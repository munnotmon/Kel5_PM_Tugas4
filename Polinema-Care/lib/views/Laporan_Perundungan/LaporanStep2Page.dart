import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import '../../controllers/laporan_controller.dart';

class LaporanStep2Page extends StatefulWidget {
  final Map<String, dynamic> prevData;

  const LaporanStep2Page({super.key, this.prevData = const {}});

  @override
  State<LaporanStep2Page> createState() => _LaporanStep2PageState();
}

class _LaporanStep2PageState extends State<LaporanStep2Page> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey _lampiranKey = GlobalKey();

  DateTime? _selectedDateTime;
  final TextEditingController _lokasiController = TextEditingController();
  String? _selectedJenis;
  final TextEditingController _deskripsiController = TextEditingController();

  static const _jenisOptions = [
    'Verbal',
    'Fisik',
    'Emosional',
    'Cyberbullying',
    'Pelecehan Seksual',
  ];
  bool get _showMap =>
      _selectedJenis != null && _selectedJenis != 'Cyberbullying';

  // Google Maps
  LatLng _selectedLatLng = const LatLng(-7.9666, 112.6326);
  Set<Marker> _markers = {};
  bool _isLoadingLocation = false;

  // Search suggestions
  Timer? _searchDebounce;
  List<Map<String, dynamic>> _searchSuggestions = [];
  bool _isSearching = false;

  // Riwayat lokasi terakhir (disimpan per sesi, maks. 5)
  static final List<Map<String, dynamic>> _recentPlaces = [];
  final FocusNode _locFocusNode = FocusNode();
  bool _locFocused = false;

  // Lampiran
  final List<XFile> _attachments = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final d = widget.prevData;
    _lokasiController.text = d['lokasi'] ?? '';
    _selectedJenis = d['jenis'] as String?;
    _deskripsiController.text = d['deskripsi'] ?? '';

    if (LaporanController.rawFiles.isNotEmpty) {
      _attachments.addAll(LaporanController.rawFiles);
    } else {
      final lampiranPaths = d['lampiran'];
      if (lampiranPaths is List) {
        for (final path in lampiranPaths) {
          _attachments.add(XFile(path.toString()));
        }
        LaporanController.rawFiles = List<XFile>.from(_attachments);
      }
    }

    final waktuStr = d['waktu'] as String?;
    if (waktuStr != null && waktuStr.isNotEmpty) {
      _selectedDateTime = _parseWaktu(waktuStr);
    }

    if (d['scrollTo'] == 'lampiran') {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_lampiranKey.currentContext != null) {
          Scrollable.ensureVisible(
            _lampiranKey.currentContext!,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    _locFocusNode.addListener(() {
      if (mounted) setState(() => _locFocused = _locFocusNode.hasFocus);
    });

    _updateMarker(_selectedLatLng);
  }

  void _updateMarker(LatLng pos) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };
    });
  }

  void _saveToRecent(Map<String, dynamic> place) {
    _recentPlaces.removeWhere((p) => p['display_name'] == place['display_name']);
    _recentPlaces.insert(0, place);
    if (_recentPlaces.length > 5) _recentPlaces.removeLast();
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _lokasiController.dispose();
    _deskripsiController.dispose();
    _locFocusNode.dispose();
    super.dispose();
  }

  // =====================================================================
  // DATE TIME PICKER
  // =====================================================================
  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? now,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 4)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A6B8A)),
        ),
        child: child!,
      ),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFF1A6B8A)),
        ),
        child: child!,
      ),
    );
    if (time == null) return;

    setState(() {
      _selectedDateTime = DateTime(
        date.year, date.month, date.day, time.hour, time.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  DateTime? _parseWaktu(String waktu) {
    try {
      const months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
      ];
      final parts = waktu.split(', ');
      final dateParts = parts[0].split(' ');
      final timeParts = parts[1].split(':');
      final day = int.parse(dateParts[0]);
      final month = months.indexOf(dateParts[1]) + 1;
      final year = int.parse(dateParts[2]);
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      return DateTime(year, month, day, hour, minute);
    } catch (_) {
      return null;
    }
  }

  // =====================================================================
  // PLACE SEARCH
  // =====================================================================
  Future<void> _searchPlaces(String query) async {
    final q = query.trim();
    if (q.length < 3) {
      if (mounted) setState(() => _searchSuggestions = []);
      return;
    }
    if (mounted) setState(() => _isSearching = true);
    try {
      final uri = Uri(
        scheme: 'https',
        host: 'nominatim.openstreetmap.org',
        path: '/search',
        queryParameters: {
          'q': q,
          'format': 'json',
          'addressdetails': '1',
          'limit': '10',
          'accept-language': 'id',
          'countrycodes': 'id',
          'lat': _selectedLatLng.latitude.toString(),
          'lon': _selectedLatLng.longitude.toString(),
        },
      );
      final response = await http.get(uri, headers: {'User-Agent': 'PolinemaCarApp/1.0'});
      if (response.statusCode == 200 && mounted) {
        final List results = jsonDecode(response.body);
        setState(() => _searchSuggestions =
            results.map((e) => Map<String, dynamic>.from(e as Map)).toList());
      }
    } catch (e) {
      if (mounted) setState(() => _searchSuggestions = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _selectSuggestion(Map<String, dynamic> suggestion) {
    final lat = double.tryParse(suggestion['lat']?.toString() ?? '') ?? 0;
    final lng = double.tryParse(suggestion['lon']?.toString() ?? '') ?? 0;
    final name = _buildDisplayName(suggestion);
    final newLatLng = LatLng(lat, lng);
    _saveToRecent({...suggestion, 'display_name': name});
    _locFocusNode.unfocus();
    setState(() {
      _selectedLatLng = newLatLng;
      _lokasiController.text = name;
      _searchSuggestions = [];
    });
    _updateMarker(newLatLng);
  }

  String _buildDisplayName(Map<String, dynamic> result) {
    final address = result['address'] as Map?;
    if (address != null) {
      final placeName = address['amenity'] ?? address['building'] ??
          address['tourism'] ?? address['shop'] ?? address['office'] ??
          address['school'] ?? address['university'] ?? address['hospital'] ??
          address['place'] ?? address['leisure'];
      final area = address['suburb'] ?? address['neighbourhood'] ??
          address['village'] ?? address['town'];
      final city = address['city'] ?? address['regency'];
      final parts = [placeName, area, city]
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) return parts.join(', ');
    }
    final display = result['display_name'] as String? ?? '';
    if (display.isNotEmpty) {
      final parts = display.split(',');
      return parts.take(3).map((s) => s.trim()).join(', ');
    }
    return display;
  }

  // =====================================================================
  // REVERSE GEOCODING
  // =====================================================================
  Future<String> _getPlaceName(LatLng latLng) async {
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}&accept-language=id',
      );
      final response = await http.get(uri, headers: {'User-Agent': 'PolinemaCarApp/1.0'});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final address = data['address'] as Map<String, dynamic>?;
        if (address != null) {
          final placeName = address['amenity'] ?? address['building'] ??
              address['tourism'] ?? address['shop'] ?? address['office'] ??
              address['school'] ?? address['university'] ?? address['hospital'] ??
              address['place'];
          final parts = [
            placeName,
            address['suburb'] ?? address['neighbourhood'],
            address['city'] ?? address['town'] ?? address['village'],
          ].whereType<String>().where((s) => s.isNotEmpty).toList();
          if (parts.isNotEmpty) return parts.join(', ');
        }
        final displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) return displayName;
      }
    } catch (_) {}
    return '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}';
  }

  // =====================================================================
  // GEOLOCATOR
  // =====================================================================
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Layanan lokasi tidak aktif. Aktifkan GPS terlebih dahulu.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Izin lokasi ditolak.'), backgroundColor: Colors.red),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(
                label: 'Pengaturan',
                textColor: Colors.white,
                onPressed: () => Geolocator.openAppSettings(),
              ),
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      final newLatLng = LatLng(position.latitude, position.longitude);
      final placeName = await _getPlaceName(newLatLng);

      if (mounted) {
        _saveToRecent({
          'display_name': placeName,
          'lat': position.latitude.toString(),
          'lon': position.longitude.toString(),
        });
        setState(() {
          _selectedLatLng = newLatLng;
          _lokasiController.text = placeName;
          _searchSuggestions = [];
        });
        _updateMarker(newLatLng);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lokasi berhasil diperbarui!'),
            backgroundColor: Color(0xFF1A6B8A),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil lokasi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  // =====================================================================
  // FULLSCREEN MAP
  // =====================================================================
  Future<void> _openFullscreenMap() async {
    final result = await Navigator.of(context, rootNavigator: true)
        .push<LatLng>(
          MaterialPageRoute(
            builder: (context) => FullscreenMapPage(initialLatLng: _selectedLatLng),
          ),
        );

    if (result != null && mounted) {
      final placeName = await _getPlaceName(result);
      if (mounted) {
        setState(() {
          _selectedLatLng = result;
          _lokasiController.text = placeName;
          _searchSuggestions = [];
        });
        _updateMarker(result);
      }
    }
  }

  // =====================================================================
  // LAMPIRAN
  // =====================================================================
  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tambah Bukti',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D),
                ),
              ),
              const SizedBox(height: 16),
              if (!kIsWeb) ...[
                _buildAttachOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Kamera',
                  subtitle: 'Ambil foto atau video langsung',
                  onTap: () { Navigator.pop(ctx); _openCameraAwesome(); },
                ),
                const SizedBox(height: 12),
              ],
              _buildAttachOption(
                icon: Icons.photo_library_outlined,
                label: 'Galeri',
                subtitle: 'Pilih dari foto atau video tersimpan',
                onTap: () { Navigator.pop(ctx); _pickFromGallery(); },
              ),
              const SizedBox(height: 12),
              _buildAttachOption(
                icon: Icons.audio_file_outlined,
                label: 'Audio / Video',
                subtitle: 'Unggah file MP3 atau MP4 dari penyimpanan',
                onTap: () { Navigator.pop(ctx); _pickAudioVideo(); },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFE0F2F8), shape: BoxShape.circle),
              child: Icon(icon, color: const Color(0xFF1A6B8A), size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF1A2D3D))),
                Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openCameraAwesome() async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => CameraAwesomePage(
          onFilesReady: (files) {
            setState(() {
              _attachments.addAll(files);
              LaporanController.rawFiles = List<XFile>.from(_attachments);
            });
          },
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final picked = await _imagePicker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() {
        _attachments.addAll(picked);
        LaporanController.rawFiles = List<XFile>.from(_attachments);
      });
    }
  }

  String _fileType(String path) {
    final ext = path.split('.').last.toLowerCase();
    if (['mp4', 'mov', 'avi', 'mkv', '3gp'].contains(ext)) return 'video';
    if (['mp3', 'm4a', 'aac', 'wav', 'ogg'].contains(ext)) return 'audio';
    return 'image';
  }

  Future<void> _pickAudioVideo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3', 'mp4', 'm4a', 'aac', 'mov', 'avi', 'mkv'],
      allowMultiple: true,
    );
    if (result != null && result.files.isNotEmpty && mounted) {
      setState(() {
        for (final f in result.files) {
          if (f.path != null) _attachments.add(XFile(f.path!));
        }
        LaporanController.rawFiles = List<XFile>.from(_attachments);
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      _attachments.removeAt(index);
      LaporanController.rawFiles = List<XFile>.from(_attachments);
    });
  }

  // =====================================================================
  // VALIDASI & NEXT
  // =====================================================================
  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waktu kejadian wajib diisi'), backgroundColor: Colors.red),
        );
        return;
      }
      if (_attachments.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lampiran bukti wajib diunggah (minimal 1 foto/video/audio)'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final isEdit = widget.prevData['isEdit'] == true;
      final currentData = {
        ...widget.prevData,
        'waktu': _formatDateTime(_selectedDateTime!),
        'tanggal_kejadian_raw': _selectedDateTime?.toIso8601String(),
        'lokasi': _lokasiController.text,
        'jenis': _selectedJenis ?? '',
        'deskripsi': _deskripsiController.text,
        'lampiran': _attachments.map((f) => f.path).toList(),
      };

      if (isEdit) {
        context.push('/activity/laporan/step4', extra: currentData);
      } else {
        context.push('/activity/laporan/step3', extra: currentData);
      }
    }
  }

  // =====================================================================
  // BUILD
  // =====================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 24),
                _buildWaktuKejadian(),
                const SizedBox(height: 20),
                _buildJenisPerundungan(),
                const SizedBox(height: 20),
                if (_showMap) ...[
                  _buildLokasiKampus(),
                  const SizedBox(height: 20),
                ],
                _buildDeskripsiKejadian(),
                const SizedBox(height: 20),
                _buildLampiranBukti(),
                const SizedBox(height: 32),
                _buildNextButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // WIDGETS
  // =====================================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Laporkan Perundungan',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A), fontWeight: FontWeight.bold, fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LANGKAH 2 DARI 4',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A6B8A), fontWeight: FontWeight.w600,
            fontSize: 12, letterSpacing: 0.5,
          ),
        ),
        Row(
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.only(left: 6),
              width: index <= 1 ? 28 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: index <= 1 ? const Color(0xFF1A6B8A) : const Color(0xFFD0D8E4),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detail Kejadian',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ceritakan secara jujur. Keamanan Anda adalah\nprioritas utama kami.',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[600], height: 1.5),
        ),
      ],
    );
  }

  Widget _buildWaktuKejadian() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('WAKTU KEJADIAN'),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: _pickDateTime,
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, color: Color(0xFF1A6B8A), size: 20),
                const SizedBox(width: 10),
                Text(
                  _selectedDateTime != null
                      ? _formatDateTime(_selectedDateTime!)
                      : 'Pilih Tanggal & Jam',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: _selectedDateTime != null ? const Color(0xFF1A2D3D) : const Color(0xFF1A6B8A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLokasiKampus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('LOKASI KAMPUS'),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
          ),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: TextFormField(
                  controller: _lokasiController,
                  focusNode: _locFocusNode,
                  validator: (val) => val == null || val.isEmpty ? 'Lokasi wajib diisi' : null,
                  onChanged: (val) {
                    _searchDebounce?.cancel();
                    if (val.trim().isEmpty) {
                      setState(() => _searchSuggestions = []);
                      return;
                    }
                    _searchDebounce = Timer(
                      const Duration(milliseconds: 500),
                      () => _searchPlaces(val),
                    );
                  },
                  style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF1A2D3D)),
                  decoration: InputDecoration(
                    hintText: 'Ketik nama tempat atau alamat...',
                    hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF1A6B8A), size: 20),
                    suffixIcon: _lokasiController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.close, size: 18, color: Colors.grey),
                            onPressed: () {
                              _lokasiController.clear();
                              setState(() => _searchSuggestions = []);
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF0F2F5),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1A6B8A), width: 1.5),
                    ),
                  ),
                ),
              ),

              // Riwayat lokasi
              if (_locFocused && _lokasiController.text.isEmpty && _recentPlaces.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
                          child: Text(
                            'Lokasi Terakhir',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11, fontWeight: FontWeight.w700,
                              color: Colors.grey[500], letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _recentPlaces.length,
                          separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey.withOpacity(0.12)),
                          itemBuilder: (_, i) {
                            final p = _recentPlaces[i];
                            final display = p['display_name'] as String? ?? '';
                            final parts = display.split(',');
                            final title = parts.first.trim();
                            final subtitle = parts.length > 1 ? parts.skip(1).take(2).map((e) => e.trim()).join(', ') : '';
                            return InkWell(
                              onTap: () => _selectSuggestion(p),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.history, size: 18, color: Color(0xFF1A6B8A)),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A2D3D))),
                                          if (subtitle.isNotEmpty)
                                            Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

              // Dropdown saran pencarian
              if (_isSearching)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 6),
                  child: Center(
                    child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A6B8A))),
                  ),
                ),
              if (_searchSuggestions.isNotEmpty)
                Container(
                  margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                  constraints: const BoxConstraints(maxHeight: 312),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _searchSuggestions.length,
                      separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
                      itemBuilder: (_, i) {
                        final s = _searchSuggestions[i];
                        final fullName = _buildDisplayName(s);
                        final nameParts = fullName.split(', ');
                        final title = nameParts.first;
                        final subtitle = nameParts.length > 1 ? nameParts.skip(1).join(', ') : '';
                        return InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () => _selectSuggestion(s),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            child: Row(
                              children: [
                                const Icon(Icons.location_on_outlined, size: 18, color: Color(0xFF1A6B8A)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A2D3D))),
                                      if (subtitle.isNotEmpty)
                                        Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              // Google Map preview — tap untuk buka fullscreen
              GestureDetector(
                onTap: _openFullscreenMap,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 180,
                        child: AbsorbPointer(
                          child: GoogleMap(
                            key: ValueKey('${_selectedLatLng.latitude},${_selectedLatLng.longitude}'),
                            initialCameraPosition: CameraPosition(
                              target: _selectedLatLng,
                              zoom: 15,
                            ),
                            markers: _markers,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                            rotateGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            tiltGesturesEnabled: false,
                            zoomGesturesEnabled: false,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.open_in_full, color: Colors.white, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                'Tap untuk perluas',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11, color: Colors.white, fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Tombol lokasi saat ini
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isLoadingLocation ? null : _getCurrentLocation,
                    icon: _isLoadingLocation
                        ? const SizedBox(
                            width: 16, height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A6B8A)),
                          )
                        : const Icon(Icons.my_location, size: 18, color: Color(0xFF1A6B8A)),
                    label: Text(
                      _isLoadingLocation ? 'Mengambil Lokasi...' : 'Gunakan Lokasi Saat Ini',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A6B8A),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1A6B8A)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showJenisPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40, height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(color: const Color(0xFFD0D8E4), borderRadius: BorderRadius.circular(10)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih Jenis Perundungan',
                  style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D)),
                ),
              ),
              const SizedBox(height: 12),
              ..._jenisOptions.map((jenis) {
                final isSelected = jenis == _selectedJenis;
                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedJenis = jenis;
                      if (jenis == 'Cyberbullying') {
                        _lokasiController.clear();
                        _selectedLatLng = const LatLng(-7.9666, 112.6326);
                        _updateMarker(_selectedLatLng);
                      }
                    });
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1A6B8A).withOpacity(0.1) : const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected ? Border.all(color: const Color(0xFF1A6B8A), width: 1.5) : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            jenis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                              color: isSelected ? const Color(0xFF1A6B8A) : const Color(0xFF1A2D3D),
                            ),
                          ),
                        ),
                        if (isSelected) const Icon(Icons.check_circle, color: Color(0xFF1A6B8A), size: 20),
                      ],
                    ),
                  ),
                );
              }),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJenisPerundungan() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('JENIS PERUNDUNGAN'),
        const SizedBox(height: 10),
        FormField<String>(
          validator: (_) => _selectedJenis == null ? 'Jenis perundungan wajib dipilih' : null,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showJenisPicker,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                      border: state.hasError
                          ? Border.all(color: Colors.red, width: 1.5)
                          : _selectedJenis != null
                              ? Border.all(color: const Color(0xFF1A6B8A), width: 1.5)
                              : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedJenis ?? 'Pilih jenis perundungan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: _selectedJenis != null ? const Color(0xFF1A2D3D) : Colors.grey[400],
                            ),
                          ),
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1A6B8A)),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Text(state.errorText!, style: const TextStyle(color: Colors.red, fontSize: 12)),
                  ),
              ],
            );
          },
        ),
        if (_selectedJenis == 'Cyberbullying') ...[
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFFFB74D)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFFE65100), size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cyberbullying terjadi secara online, sehingga lokasi kejadian tidak diperlukan.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFFE65100)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDeskripsiKejadian() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('DESKRIPSI KEJADIAN'),
        const SizedBox(height: 10),
        TextFormField(
          controller: _deskripsiController,
          maxLines: 5,
          validator: (val) => val == null || val.isEmpty ? 'Deskripsi kejadian wajib diisi' : null,
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: const Color(0xFF1A2D3D)),
          decoration: _inputDecoration('Ceritakan apa yang terjadi...'),
        ),
      ],
    );
  }

  Widget _buildLampiranBukti() {
    return Column(
      key: _lampiranKey,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('LAMPIRAN BUKTI'),
        const SizedBox(height: 10),
        if (_attachments.isNotEmpty) ...[
          SizedBox(
            height: 90,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _attachments.length,
              itemBuilder: (ctx, i) => Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Builder(builder: (_) {
                        final type = _fileType(_attachments[i].path);
                        if (type == 'video') {
                          return Container(
                            width: 80, height: 80,
                            color: const Color(0xFFE3F2FD),
                            child: const Icon(Icons.videocam, size: 36, color: Color(0xFF1A6B8A)),
                          );
                        }
                        if (type == 'audio') {
                          return Container(
                            width: 80, height: 80,
                            color: const Color(0xFFE8F5E9),
                            child: const Icon(Icons.audiotrack, size: 36, color: Color(0xFF2E7D32)),
                          );
                        }
                        return FutureBuilder<Uint8List>(
                          future: _attachments[i].readAsBytes(),
                          builder: (ctx, snap) {
                            if (snap.hasData) {
                              return Image.memory(snap.data!, width: 80, height: 80, fit: BoxFit.cover);
                            }
                            return const SizedBox(
                              width: 80, height: 80,
                              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                  Positioned(
                    top: 0, right: 10,
                    child: GestureDetector(
                      onTap: () => _removeAttachment(i),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
        GestureDetector(
          onTap: _showAttachmentOptions,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1A6B8A).withOpacity(0.3), width: 1.5),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(color: Color(0xFFE0F2F8), shape: BoxShape.circle),
                  child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFF1A6B8A), size: 30),
                ),
                const SizedBox(height: 10),
                Text(
                  _attachments.isEmpty ? 'Unggah Bukti' : 'Tambah Bukti Lagi',
                  style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D)),
                ),
                const SizedBox(height: 4),
                Text(
                  'Foto, Video, Audio, atau Tangkapan Layar (Maks. 1GB)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lanjut Ke Langkah Berikutnya',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, color: Colors.white, size: 18),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'DENGAN MELANJUTKAN, ANDA MENYETUJUI\nKEBIJAKAN PRIVASI POLINEMA CARE',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10, color: Colors.grey[400], letterSpacing: 0.3, fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: child,
    );
  }

  Widget _buildLabel(String label, {bool showAsterisk = true}) {
    return Row(
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w700, fontSize: 12, color: Colors.grey[500], letterSpacing: 0.5,
          ),
        ),
        if (showAsterisk) ...[
          const SizedBox(width: 4),
          const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
        ],
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey[400], fontSize: 14),
      filled: true,
      fillColor: const Color(0xFFF0F2F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A6B8A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1.5)),
    );
  }
}

// =====================================================================
// HALAMAN MAP FULLSCREEN
// =====================================================================
class FullscreenMapPage extends StatefulWidget {
  final LatLng initialLatLng;

  const FullscreenMapPage({super.key, required this.initialLatLng});

  @override
  State<FullscreenMapPage> createState() => _FullscreenMapPageState();
}

class _FullscreenMapPageState extends State<FullscreenMapPage> {

  late LatLng _selectedLatLng;
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  bool _isLoadingLocation = false;
  bool _isReverseGeocoding = false;
  String _placeName = '';

  // Search
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  Timer? _searchDebounce;
  List<Map<String, dynamic>> _suggestions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _selectedLatLng = widget.initialLatLng;
    _updateMarker(_selectedLatLng);
    _reverseGeocode(_selectedLatLng, updateField: false);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchDebounce?.cancel();
    _mapController?.dispose();
    super.dispose();
  }

  void _updateMarker(LatLng pos) {
    setState(() {
      _markers = {
        Marker(
          markerId: const MarkerId('selected'),
          position: pos,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        ),
      };
    });
  }

  Future<void> _reverseGeocode(LatLng latLng, {bool updateField = true}) async {
    if (mounted) setState(() => _isReverseGeocoding = true);
    try {
      final uri = Uri.parse(
        'https://nominatim.openstreetmap.org/reverse'
        '?format=json&lat=${latLng.latitude}&lon=${latLng.longitude}&accept-language=id',
      );
      final response = await http.get(uri, headers: {'User-Agent': 'PolinemaCarApp/1.0'});
      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body);
        final address = data['address'] as Map<String, dynamic>?;
        String name = '';
        if (address != null) {
          final placeName = address['amenity'] ?? address['building'] ??
              address['tourism'] ?? address['shop'] ?? address['office'] ??
              address['school'] ?? address['university'] ?? address['hospital'] ??
              address['place'];
          final parts = [
            placeName,
            address['suburb'] ?? address['neighbourhood'],
            address['city'] ?? address['town'] ?? address['village'],
          ].whereType<String>().where((s) => s.isNotEmpty).toList();
          if (parts.isNotEmpty) name = parts.join(', ');
        }
        if (name.isEmpty) name = data['display_name'] as String? ?? '';
        if (mounted) {
          setState(() => _placeName = name);
          if (updateField) _searchController.text = name;
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() => _placeName =
            '${latLng.latitude.toStringAsFixed(5)}, ${latLng.longitude.toStringAsFixed(5)}');
      }
    } finally {
      if (mounted) setState(() => _isReverseGeocoding = false);
    }
  }

  Future<void> _searchPlaces(String query) async {
    final q = query.trim();
    if (q.length < 3) {
      if (mounted) setState(() => _suggestions = []);
      return;
    }
    if (mounted) setState(() => _isSearching = true);
    try {
      final uri = Uri(
        scheme: 'https',
        host: 'nominatim.openstreetmap.org',
        path: '/search',
        queryParameters: {
          'q': q,
          'format': 'json',
          'addressdetails': '1',
          'limit': '10',
          'accept-language': 'id',
          'countrycodes': 'id',
          'lat': _selectedLatLng.latitude.toString(),
          'lon': _selectedLatLng.longitude.toString(),
        },
      );
      final response = await http.get(uri, headers: {'User-Agent': 'PolinemaCarApp/1.0'});
      if (response.statusCode == 200 && mounted) {
        final List results = jsonDecode(response.body);
        setState(() => _suggestions =
            results.map((e) => Map<String, dynamic>.from(e as Map)).toList());
      }
    } catch (e) {
      if (mounted) setState(() => _suggestions = []);
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _selectSuggestion(Map<String, dynamic> s) {
    final lat = double.tryParse(s['lat']?.toString() ?? '') ?? 0;
    final lng = double.tryParse(s['lon']?.toString() ?? '') ?? 0;
    final name = _buildDisplayName(s);
    final newLatLng = LatLng(lat, lng);
    _searchFocusNode.unfocus();
    setState(() {
      _selectedLatLng = newLatLng;
      _placeName = name;
      _searchController.text = name;
      _suggestions = [];
    });
    _updateMarker(newLatLng);
    _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 17));
  }

  String _buildDisplayName(Map<String, dynamic> result) {
    final address = result['address'] as Map?;
    if (address != null) {
      final placeName = address['amenity'] ?? address['building'] ??
          address['tourism'] ?? address['shop'] ?? address['office'] ??
          address['school'] ?? address['university'] ?? address['hospital'] ??
          address['place'] ?? address['leisure'];
      final area = address['suburb'] ?? address['neighbourhood'] ??
          address['village'] ?? address['town'];
      final city = address['city'] ?? address['regency'];
      final parts = [placeName, area, city]
          .whereType<String>()
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) return parts.join(', ');
    }
    final display = result['display_name'] as String? ?? '';
    if (display.isNotEmpty) {
      final parts = display.split(',');
      return parts.take(3).map((s) => s.trim()).join(', ');
    }
    return display;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Layanan lokasi tidak aktif. Aktifkan GPS terlebih dahulu.'), backgroundColor: Colors.orange),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Izin lokasi ditolak.'), backgroundColor: Colors.red),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.'),
              backgroundColor: Colors.red,
              action: SnackBarAction(label: 'Pengaturan', textColor: Colors.white, onPressed: () => Geolocator.openAppSettings()),
            ),
          );
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (mounted) {
        final newLatLng = LatLng(position.latitude, position.longitude);
        setState(() => _selectedLatLng = newLatLng);
        _updateMarker(newLatLng);
        _mapController?.animateCamera(CameraUpdate.newLatLngZoom(newLatLng, 17));
        await _reverseGeocode(newLatLng);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Lokasi berhasil diperbarui!'), backgroundColor: Color(0xFF1A6B8A), duration: Duration(seconds: 2)),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengambil lokasi: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoadingLocation = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fullscreen Google Map
          GoogleMap(
            initialCameraPosition: CameraPosition(target: _selectedLatLng, zoom: 16),
            onMapCreated: (controller) => _mapController = controller,
            markers: _markers,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            onTap: (point) {
              _searchFocusNode.unfocus();
              setState(() {
                _selectedLatLng = point;
                _suggestions = [];
                _searchController.clear();
              });
              _updateMarker(point);
              _reverseGeocode(point);
            },
          ),

          // Top bar: back + search
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
                          ),
                          child: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A), size: 20),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8)],
                          ),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _searchFocusNode,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF1A2D3D)),
                            decoration: InputDecoration(
                              hintText: 'Cari tempat...',
                              hintStyle: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.grey[400]),
                              prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF1A6B8A)),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                                      onPressed: () {
                                        _searchController.clear();
                                        setState(() => _suggestions = []);
                                      },
                                    )
                                  : null,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: InputBorder.none,
                            ),
                            onChanged: (val) {
                              _searchDebounce?.cancel();
                              if (val.trim().isEmpty) {
                                setState(() => _suggestions = []);
                                return;
                              }
                              _searchDebounce = Timer(
                                const Duration(milliseconds: 500),
                                () => _searchPlaces(val),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Dropdown saran
                  if (_isSearching)
                    Container(
                      margin: const EdgeInsets.only(top: 4, left: 52),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8)],
                      ),
                      child: const Center(
                        child: SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A6B8A))),
                      ),
                    ),
                  if (_suggestions.isNotEmpty)
                    Container(
                      margin: const EdgeInsets.only(top: 4, left: 52),
                      constraints: const BoxConstraints(maxHeight: 260),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10)],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const ClampingScrollPhysics(),
                          itemCount: _suggestions.length,
                          separatorBuilder: (_, _) => Divider(height: 1, color: Colors.grey.withOpacity(0.15)),
                          itemBuilder: (_, i) {
                            final s = _suggestions[i];
                            final fullName = _buildDisplayName(s);
                            final nameParts = fullName.split(', ');
                            final title = nameParts.first;
                            final subtitle = nameParts.length > 1 ? nameParts.skip(1).join(', ') : '';
                            return InkWell(
                              onTap: () => _selectSuggestion(s),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                child: Row(
                                  children: [
                                    const Icon(Icons.location_on_outlined, size: 16, color: Color(0xFF1A6B8A)),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600, color: const Color(0xFF1A2D3D))),
                                          if (subtitle.isNotEmpty)
                                            Text(subtitle, style: GoogleFonts.plusJakartaSans(fontSize: 11, color: Colors.grey[500]), maxLines: 1, overflow: TextOverflow.ellipsis),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Tombol lokasi saat ini
          Positioned(
            right: 16,
            bottom: 120,
            child: GestureDetector(
              onTap: _isLoadingLocation ? null : _getCurrentLocation,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 8)],
                ),
                child: _isLoadingLocation
                    ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.5, color: Color(0xFF1A6B8A)))
                    : const Icon(Icons.my_location, color: Color(0xFF1A6B8A), size: 22),
              ),
            ),
          ),

          // Nama tempat yang dipilih
          Positioned(
            left: 20,
            right: 70,
            bottom: 106,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _isReverseGeocoding
                  ? Container(
                      key: const ValueKey('loading'),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.93),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF1A6B8A))),
                          const SizedBox(width: 8),
                          Text('Memuat nama tempat...', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[600])),
                        ],
                      ),
                    )
                  : _placeName.isEmpty
                      ? const SizedBox.shrink(key: ValueKey('empty'))
                      : Container(
                          key: ValueKey(_placeName),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.93),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6)],
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF1A6B8A)),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  _placeName,
                                  style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF1A2D3D), fontWeight: FontWeight.w500),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
            ),
          ),

          // Tombol Konfirmasi Lokasi
          Positioned(
            left: 20,
            right: 20,
            bottom: 40,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: const Color(0xFF1A6B8A).withOpacity(0.35), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, _selectedLatLng),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
                label: Text(
                  'Konfirmasi Lokasi Ini',
                  style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// HALAMAN KAMERA (CameraAwesome)
// =====================================================================
class CameraAwesomePage extends StatefulWidget {
  final Function(List<XFile> files) onFilesReady;

  const CameraAwesomePage({super.key, required this.onFilesReady});

  @override
  State<CameraAwesomePage> createState() => _CameraAwesomePageState();
}

class _CameraAwesomePageState extends State<CameraAwesomePage> {
  final List<String> _capturedPaths = [];

  void _openSelection() async {
    if (_capturedPaths.isEmpty) return;
    final allPaths = List<String>.from(_capturedPaths);
    final selected = await Navigator.of(context, rootNavigator: true)
        .push<List<String>>(
          MaterialPageRoute(builder: (_) => PhotoSelectionPage(paths: allPaths)),
        );
    if (selected != null && selected.isNotEmpty && mounted) {
      widget.onFilesReady(selected.map((p) => XFile(p)).toList());
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CameraAwesomeBuilder.awesome(
            saveConfig: SaveConfig.photo(
              pathBuilder: (sensors) async {
                final dir = Directory.systemTemp;
                final path = '${dir.path}/bukti_${DateTime.now().millisecondsSinceEpoch}.jpg';
                return SingleCaptureRequest(path, sensors.first);
              },
            ),
            onMediaCaptureEvent: (MediaCapture media) {
              if (media.status == MediaCaptureStatus.success) {
                media.captureRequest.when(
                  single: (single) {
                    if (single.file != null) {
                      final path = single.file!.path;
                      if (!_capturedPaths.contains(path)) {
                        setState(() => _capturedPaths.add(path));
                      }
                    }
                  },
                );
              }
            },
            onMediaTap: (MediaCapture media) => _openSelection(),
            topActionsBuilder: (state) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// HALAMAN SELEKSI FOTO
// =====================================================================
class PhotoSelectionPage extends StatefulWidget {
  final List<String> paths;
  const PhotoSelectionPage({super.key, required this.paths});

  @override
  State<PhotoSelectionPage> createState() => _PhotoSelectionPageState();
}

class _PhotoSelectionPageState extends State<PhotoSelectionPage> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.paths);
  }

  void _toggle(String path) {
    setState(() {
      _selected.contains(path) ? _selected.remove(path) : _selected.add(path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('${_selected.length} foto dipilih', style: GoogleFonts.plusJakartaSans(color: Colors.white)),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4,
        ),
        itemCount: widget.paths.length,
        itemBuilder: (_, i) {
          final path = widget.paths[i];
          final isSelected = _selected.contains(path);
          return GestureDetector(
            onTap: () => _toggle(path),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(File(path), fit: BoxFit.cover),
                if (isSelected)
                  Container(
                    color: const Color(0xFF1A6B8A).withOpacity(0.4),
                    alignment: Alignment.topRight,
                    padding: const EdgeInsets.all(6),
                    child: const Icon(Icons.check_circle, color: Colors.white, size: 22),
                  ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)]),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: _selected.isEmpty ? null : () => Navigator.pop(context, _selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Gunakan ${_selected.length} Foto',
                style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
