// Lokasi: lib/halaman_pendukung/laporan_step2.dart
import 'dart:io' show Directory, File;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:image_picker/image_picker.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:geolocator/geolocator.dart';

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

  // Jenis perundungan yang butuh map (terjadi secara fisik/tatap muka)
  static const _jenisOptions = [
    'Verbal',
    'Fisik',
    'Emosional',
    'Cyberbullying',
    'Pelecehan Seksual',
  ];
  bool get _showMap =>
      _selectedJenis != null && _selectedJenis != 'Cyberbullying';

  // Map
  final MapController _mapController = MapController();
  LatLng _selectedLatLng = const LatLng(-7.9666, 112.6326); // Default: Malang
  bool _isLoadingLocation = false;

  // Lampiran
  final List<XFile> _attachments = [];
  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final d = widget.prevData;
    // Pre-fill field dari data sebelumnya (saat edit dari Step4)
    _lokasiController.text = d['lokasi'] ?? '';
    _selectedJenis = d['jenis'] as String?;
    _deskripsiController.text = d['deskripsi'] ?? '';
    // Restore lampiran path jika ada
    final lampiranPaths = d['lampiran'];
    if (lampiranPaths is List) {
      for (final path in lampiranPaths) {
        _attachments.add(XFile(path.toString()));
      }
    }
    // Restore DateTime dari string 'waktu' format: "9 Mei 2026, 15:17"
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
  }

  DateTime? _parseWaktu(String waktu) {
    try {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ];
      // Format: "9 Mei 2026, 15:17"
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

  @override
  void dispose() {
    _lokasiController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  // =====================================================================
  // DATE TIME PICKER
  // =====================================================================
  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
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
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String _formatDateTime(DateTime dt) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  // =====================================================================
  // GEOLOCATOR — lokasi saat ini
  // =====================================================================
  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);

    try {
      // Cek apakah location service aktif
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Layanan lokasi tidak aktif. Aktifkan GPS terlebih dahulu.',
              ),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      // Cek & minta izin
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Izin lokasi ditolak.'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                'Izin lokasi ditolak permanen. Buka pengaturan untuk mengaktifkan.',
              ),
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

      // Ambil posisi
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final newLatLng = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          _selectedLatLng = newLatLng;
          _lokasiController.text =
              '${position.latitude.toStringAsFixed(5)}, '
              '${position.longitude.toStringAsFixed(5)}';
        });

        // Animasikan kamera map ke posisi baru
        _mapController.move(newLatLng, 17);

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
          SnackBar(
            content: Text('Gagal mengambil lokasi: $e'),
            backgroundColor: Colors.red,
          ),
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
            builder: (context) =>
                FullscreenMapPage(initialLatLng: _selectedLatLng),
          ),
        );

    if (result != null && mounted) {
      setState(() {
        _selectedLatLng = result;
        _lokasiController.text =
            '${result.latitude.toStringAsFixed(5)}, '
            '${result.longitude.toStringAsFixed(5)}';
      });
      _mapController.move(result, 15);
    }
  }

  // =====================================================================
  // LAMPIRAN — pilih sumber: kamera atau galeri
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
              const SizedBox(height: 16),
              if (!kIsWeb) ...[
                _buildAttachOption(
                  icon: Icons.camera_alt_outlined,
                  label: 'Kamera',
                  subtitle: 'Ambil foto atau video langsung',
                  onTap: () {
                    Navigator.pop(ctx);
                    _openCameraAwesome();
                  },
                ),
                const SizedBox(height: 12),
              ],
              _buildAttachOption(
                icon: Icons.photo_library_outlined,
                label: 'Galeri',
                subtitle: 'Pilih dari foto atau video tersimpan',
                onTap: () {
                  Navigator.pop(ctx);
                  _pickFromGallery();
                },
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
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2F8),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFF1A6B8A), size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
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
            setState(() => _attachments.addAll(files));
          },
        ),
      ),
    );
  }

  Future<void> _pickFromGallery() async {
    final picked = await _imagePicker.pickMultiImage(imageQuality: 80);
    if (picked.isNotEmpty) {
      setState(() {
        for (final xfile in picked) {
          _attachments.add(xfile);
        }
      });
    }
  }

  void _removeAttachment(int index) {
    setState(() => _attachments.removeAt(index));
  }

  // =====================================================================
  // VALIDASI & NEXT
  // =====================================================================
  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waktu kejadian wajib diisi'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      final isEdit = widget.prevData['isEdit'] == true;

      // Siapkan data yang akan dibawa
      final currentData = {
        ...widget.prevData,
        'waktu': _formatDateTime(_selectedDateTime!),
        'lokasi': _lokasiController.text,
        'jenis': _selectedJenis ?? '',
        'deskripsi': _deskripsiController.text,
        'lampiran': _attachments.map((f) => f.path).toList(),
      };

      if (isEdit) {
        // Jika dari Step 4, langsung kembalikan ke Step 4
        context.push('/activity/laporan/step4', extra: currentData);
      } else {
        // Jika alur normal, lanjut ke Step 3
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
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE8D5C4),
            child: ClipOval(child: Container(color: const Color(0xFFE8D5C4))),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LANGKAH 2 DARI 4',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A6B8A),
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        Row(
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.only(left: 6),
              width: index <= 1 ? 28 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: index <= 1
                    ? const Color(0xFF1A6B8A)
                    : const Color(0xFFD0D8E4),
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
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ceritakan secara jujur. Keamanan Anda adalah\nprioritas utama kami.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
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
                const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF1A6B8A),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  _selectedDateTime != null
                      ? _formatDateTime(_selectedDateTime!)
                      : 'Pilih Tanggal & Jam',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: _selectedDateTime != null
                        ? const Color(0xFF1A2D3D)
                        : const Color(0xFF1A6B8A),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: TextFormField(
                  controller: _lokasiController,
                  validator: (val) =>
                      val == null || val.isEmpty ? 'Lokasi wajib diisi' : null,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: const Color(0xFF1A2D3D),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Cari atau pilih lokasi...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFF1A6B8A),
                      size: 20,
                    ),
                    filled: true,
                    fillColor: const Color(0xFFF0F2F5),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Color(0xFF1A6B8A),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),

              // Flutter Map — tap untuk buka fullscreen
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
                        child: IgnorePointer(
                          // Map preview tidak interaktif, tap seluruh area buka fullscreen
                          child: FlutterMap(
                            mapController: _mapController,
                            options: MapOptions(
                              initialCenter: _selectedLatLng,
                              initialZoom: 15,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName:
                                    'com.example.polinema_care',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: _selectedLatLng,
                                    width: 40,
                                    height: 40,
                                    child: const Icon(
                                      Icons.location_pin,
                                      color: Color(0xFF1A6B8A),
                                      size: 40,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Overlay hint "Tap untuk perluas"
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.open_in_full,
                                color: Colors.white,
                                size: 12,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Tap untuk perluas',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
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
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF1A6B8A),
                            ),
                          )
                        : const Icon(
                            Icons.my_location,
                            size: 18,
                            color: Color(0xFF1A6B8A),
                          ),
                    label: Text(
                      _isLoadingLocation
                          ? 'Mengambil Lokasi...'
                          : 'Gunakan Lokasi Saat Ini',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1A6B8A),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF1A6B8A)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
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
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFD0D8E4),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pilih Jenis Perundungan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
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
                      }
                    });
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF1A6B8A).withOpacity(0.1)
                          : const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(
                              color: const Color(0xFF1A6B8A),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            jenis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                              color: isSelected
                                  ? const Color(0xFF1A6B8A)
                                  : const Color(0xFF1A2D3D),
                            ),
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: Color(0xFF1A6B8A),
                            size: 20,
                          ),
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
          validator: (val) =>
              _selectedJenis == null ? 'Jenis perundungan wajib dipilih' : null,
          builder: (state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: _showJenisPicker,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                      border: state.hasError
                          ? Border.all(color: Colors.red, width: 1.5)
                          : _selectedJenis != null
                          ? Border.all(
                              color: const Color(0xFF1A6B8A),
                              width: 1.5,
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            _selectedJenis ?? 'Pilih jenis perundungan',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: _selectedJenis != null
                                  ? const Color(0xFF1A2D3D)
                                  : Colors.grey[400],
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.keyboard_arrow_down,
                          color: Color(0xFF1A6B8A),
                        ),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 6, left: 12),
                    child: Text(
                      state.errorText!,
                      style: const TextStyle(color: Colors.red, fontSize: 12),
                    ),
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
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFFE65100),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cyberbullying terjadi secara online, sehingga lokasi kejadian tidak diperlukan.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFFE65100),
                    ),
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
        _buildLabel('DESKRIPSI KEJADIAN', showAsterisk: false),
        const SizedBox(height: 10),
        TextFormField(
          controller: _deskripsiController,
          maxLines: 5,
          validator: (null),
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: const Color(0xFF1A2D3D),
          ),
          decoration: _inputDecoration(
            'Ceritakan apa yang terjadi...',
          ).copyWith(),
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
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FutureBuilder<Uint8List>(
                        future: _attachments[i].readAsBytes(),
                        builder: (ctx, snap) {
                          if (snap.hasData) {
                            return Image.memory(
                              snap.data!,
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            );
                          }
                          return const SizedBox(
                            width: 80,
                            height: 80,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 10,
                    child: GestureDetector(
                      onTap: () => _removeAttachment(i),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
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
              border: Border.all(
                color: const Color(0xFF1A6B8A).withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2F8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.cloud_upload_outlined,
                    color: Color(0xFF1A6B8A),
                    size: 30,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _attachments.isEmpty ? 'Unggah Bukti' : 'Tambah Bukti Lagi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Foto, Video, atau Tangkapan Layar (Maks. 10MB)',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lanjut Ke Langkah Berikutnya',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
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
            fontSize: 10,
            color: Colors.grey[400],
            letterSpacing: 0.3,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Helper
  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
            fontWeight: FontWeight.w700,
            fontSize: 12,
            color: Colors.grey[500],
            letterSpacing: 0.5,
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
      hintStyle: GoogleFonts.plusJakartaSans(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFF0F2F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF1A6B8A), width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.5),
      ),
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
  final MapController _mapController = MapController();
  bool _isLoadingLocation = false;

  @override
  void initState() {
    super.initState();
    _selectedLatLng = widget.initialLatLng;
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoadingLocation = true);
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Aktifkan GPS terlebih dahulu.'),
              backgroundColor: Colors.orange,
            ),
          );
        }
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return;
      }
      if (permission == LocationPermission.deniedForever) return;

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        final newLatLng = LatLng(position.latitude, position.longitude);
        setState(() => _selectedLatLng = newLatLng);
        _mapController.move(newLatLng, 17);
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
          // Fullscreen Map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLatLng,
              initialZoom: 16,
              onTap: (tapPosition, point) {
                setState(() => _selectedLatLng = point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.polinema_care',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLatLng,
                    width: 48,
                    height: 48,
                    child: const Icon(
                      Icons.location_pin,
                      color: Color(0xFF1A6B8A),
                      size: 48,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // AppBar area (safe area + back button)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  // Tombol kembali
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1A6B8A),
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Judul
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Text(
                        'Tap pada peta untuk pilih lokasi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF1A2D3D),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Tombol lokasi saat ini (kanan bawah)
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: _isLoadingLocation
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Color(0xFF1A6B8A),
                        ),
                      )
                    : const Icon(
                        Icons.my_location,
                        color: Color(0xFF1A6B8A),
                        size: 22,
                      ),
              ),
            ),
          ),

          // Koordinat yang dipilih
          Positioned(
            left: 16,
            right: 16,
            bottom: 120,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.92),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Text(
                  '${_selectedLatLng.latitude.toStringAsFixed(5)}, '
                  '${_selectedLatLng.longitude.toStringAsFixed(5)}',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF1A2D3D),
                    fontWeight: FontWeight.w500,
                  ),
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
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A6B8A).withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, _selectedLatLng),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                label: Text(
                  'Konfirmasi Lokasi Ini',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
// HALAMAN KAMERA (CameraAwesome) — multi-capture dengan seleksi
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
          MaterialPageRoute(
            builder: (_) => PhotoSelectionPage(paths: allPaths),
          ),
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
                final path =
                    '${dir.path}/bukti_${DateTime.now().millisecondsSinceEpoch}.jpg';
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
                        setState(() {
                          _capturedPaths.add(path);
                        });
                      }
                    }
                  },
                );
              }
            },
            onMediaTap: (MediaCapture media) {
              _openSelection();
            },
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
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
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
    _selected = List.from(widget.paths); // default semua terpilih
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
        title: Text(
          '${_selected.length} foto dipilih',
          style: GoogleFonts.plusJakartaSans(color: Colors.white),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
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
                    child: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 22,
                    ),
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
              gradient: const LinearGradient(
                colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: _selected.isEmpty
                  ? null
                  : () => Navigator.pop(context, _selected),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Gunakan ${_selected.length} Foto',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// HALAMAN PREVIEW FOTO
// =====================================================================
class PhotoPreviewPage extends StatelessWidget {
  final String filePath;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  const PhotoPreviewPage({
    super.key,
    required this.filePath,
    required this.onConfirm,
    required this.onRetake,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(File(filePath), fit: BoxFit.contain),

          // Tombol Ambil Ulang (kiri atas)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                  onTap: onRetake,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 6),
                        Text(
                          'Ambil Ulang',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Tombol Gunakan Foto (bawah)
          Positioned(
            left: 20,
            right: 20,
            bottom: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A6B8A).withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton.icon(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 20,
                ),
                label: const Text(
                  'Gunakan Foto Ini',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
