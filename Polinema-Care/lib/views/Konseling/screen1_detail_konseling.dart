import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/counseling_controller.dart';
import '../../controllers/auth_controller.dart';

class Screen1DetailKonseling extends StatefulWidget {
  final Map<String, dynamic>? sessionData;
  const Screen1DetailKonseling({super.key, this.sessionData});

  @override
  State<Screen1DetailKonseling> createState() => _Screen1DetailKonselingState();
}

class _Screen1DetailKonselingState extends State<Screen1DetailKonseling> {
  final TextEditingController _catatanController = TextEditingController();
  String _localCatatanText = '';

  late String _namaKonselor;
  late String _specialty;
  late String _tanggal;
  late String _waktu;
  late String _mode;
  late String _lokasi;

  @override
  void initState() {
    super.initState();
    _namaKonselor = widget.sessionData?['konselor'] ?? 
                    widget.sessionData?['counselor']?['name'] ?? 
                    'dr. Anton Wijaya';
    _specialty = widget.sessionData?['specialty'] ?? 
                 widget.sessionData?['counselor']?['specialty'] ??
                 CounselingController.getSpecialty(_namaKonselor);
    if (_specialty.isEmpty) {
      _specialty = 'Spesialis Trauma & Perundungan';
    }
    _tanggal = widget.sessionData?['tanggal'] ?? 'Senin, 12 Okt';
    _waktu = widget.sessionData?['waktu'] ?? widget.sessionData?['jam'] ?? '10:30 WIB';
    _mode = widget.sessionData?['mode'] ?? 'Online';
    _lokasi = widget.sessionData?['lokasi'] ?? '';
    _loadCatatan();
  }

  Future<void> _loadCatatan() async {
    final sessionId = widget.sessionData?['id']?.toString() ?? '';
    if (sessionId.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      final localText = prefs.getString('keluhan_$sessionId') ?? prefs.getString('catatan_$sessionId') ?? '';
      final serverText = widget.sessionData?['keluhan']?.toString() ?? widget.sessionData?['catatan']?.toString() ?? '';
      final noteText = serverText.isNotEmpty ? serverText : localText;
      _localCatatanText = noteText;
      if (mounted) {
        setState(() {
          _catatanController.text = noteText;
        });
        _catatanController.addListener(() {
          _localCatatanText = _catatanController.text;
          prefs.setString('keluhan_$sessionId', _localCatatanText);
          prefs.setString('catatan_$sessionId', _localCatatanText);
        });
      }
    }
  }

  Future<void> _saveCatatan() async {
    final sessionId = widget.sessionData?['id']?.toString() ?? '';
    if (sessionId.isNotEmpty) {
      await CounselingController.updateCatatan(sessionId, _localCatatanText);
    }
  }

  // Default: tampilkan mode Mendatang (Gambar 5)
  // Pass sessionData dengan 'status': 'aktif' untuk Gambar 1
  bool get isMendatang => widget.sessionData?['status'] != 'aktif';

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          await _saveCatatan();
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
            onPressed: () async {
              await _saveCatatan();
              if (context.mounted) {
                context.pop();
              }
            },
          ),
          title: Text(
            'Detail Sesi',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1068A3),
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
        body: isMendatang
            ? _buildMendatangBody(context)
            : _buildAktifBody(context),
      ),
    );
  }

  // =====================================================================
  // BODY MODE MENDATANG (Gambar 5)
  // =====================================================================
  Widget _buildMendatangBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Badge Mendatang
        Align(
          alignment: Alignment.centerLeft,
          child: _buildStatusBadge('Mendatang'),
        ),
        const SizedBox(height: 20),

        // Judul
        Text(
          'Sesi Konseling',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 24),

        // Konselor Card
        _buildKonselorCardMendatang(),
        const SizedBox(height: 24),

        // Detail Booking Sesi (Receipt Struk)
        _buildReceiptCard(),
        const SizedBox(height: 24),

        // Identitas Mahasiswa
        _buildStudentCard(),
        const SizedBox(height: 24),

        // Persiapan Sesi (list style)
        _buildPersiapanSesiList(),
        const SizedBox(height: 28),

        // Atur Jadwal
        _buildAturJadwalMendatang(context),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () async {
              await _saveCatatan();
              if (context.mounted) {
                context.go('/home');
              }
            },
            icon: const Icon(Icons.home_outlined, color: Color(0xFF1068A3)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1068A3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            label: Text(
              'Kembali ke Beranda',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1068A3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // =====================================================================
  // BODY MODE AKTIF/TERJADWAL (Gambar 1)
  // =====================================================================
  Widget _buildAktifBody(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      children: [
        // Status Sesi Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Status Sesi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Terjadwal',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
              ],
            ),
            _buildStatusBadge('Aktif'),
          ],
        ),
        const SizedBox(height: 20),

        // Konselor Card Aktif
        _buildKonselorCardAktif(),
        const SizedBox(height: 14),

        // Detail Booking Sesi (Receipt Struk)
        _buildReceiptCard(),
        const SizedBox(height: 24),

        // Identitas Mahasiswa
        _buildStudentCard(),
        const SizedBox(height: 24),

        // Persiapan Sesi (list style)
        _buildPersiapanSesiList(),
        const SizedBox(height: 28),

        // Keluhan
        _buildKeluhanInput(),
        const SizedBox(height: 28),

        // Ubah Jadwal + Batalkan
        _buildAturJadwalAktif(context),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () async {
              await _saveCatatan();
              if (context.mounted) {
                context.go('/home');
              }
            },
            icon: const Icon(Icons.home_outlined, color: Color(0xFF1068A3)),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1068A3)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            label: Text(
              'Kembali ke Beranda',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1068A3),
              ),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  // =====================================================================
  // SHARED WIDGETS
  // =====================================================================

  Widget _buildStatusBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFDCFCE7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF16A34A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF16A34A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[500], size: 20),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // MENDATANG WIDGETS
  // =====================================================================

  Widget _buildKonselorCardMendatang() {
    final counselorModel = CounselingController.findKonselorByName(_namaKonselor);
    final String? avatarUrl = (counselorModel.fotoProfil != null && counselorModel.fotoProfil!.isNotEmpty)
        ? counselorModel.fotoProfil
        : null;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // PENINGKATAN SHADOW
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey[200],
            backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
            child: avatarUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _namaKonselor,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _specialty,
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
          // BUBBLE HIJAU
          GestureDetector(
            onTap: () {
              final int? kId = int.tryParse(widget.sessionData?['id']?.toString() ?? '');
              final extraMap = {
                'name': _namaKonselor,
                'specialty': _specialty,
                'isSystem': false,
                'color': const Color(0xFF1068A3),
                'unread': 0,
                'messages': <Map<String, dynamic>>[],
                'konselingId': kId,
              };
              context.push('/inbox/room-chat', extra: extraMap);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7), // Warna background hijau muda
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chat_bubble_outline, // Menggunakan icon solid agar lebih nyata
                color: Color(0xFF1068A3), // Warna icon hijau gelap
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildGabungSesiCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1068A3).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.videocam_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pertemuan Virtual (Online)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      'Google Meet',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Tautan Google Meet akan dikirimkan oleh konselor ke email Anda sebelum sesi dimulai.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAturJadwalMendatang(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.settings_outlined, color: Colors.grey, size: 16),
            const SizedBox(width: 6),
            Text(
              'ATUR JADWAL',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.grey[500],
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
                Expanded(
              child: GestureDetector(
                onTap: () {
                  final kModel = CounselingController.daftarKonselor.firstWhere(
                    (k) => k.name == _namaKonselor,
                    orElse: () => CounselingController.placeholderKonselor,
                  );
                  final extraMap = Map<String, dynamic>.from(kModel.toMap());
                  extraMap['old_booking_id'] = widget.sessionData?['id'];
                  context.push('/counseling/reschedule', extra: extraMap);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F4F8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      // PENINGKATAN SHADOW
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.event_repeat,
                        color: Color(0xFF1068A3),
                        size: 26,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jadwalkan Ulang',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A2D3D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: GestureDetector(
                onTap: () => _showBatalkanDialog(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF0F0),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFFCA5A5), width: 1.5),
                    boxShadow: [
                      // PENINGKATAN SHADOW
                      BoxShadow(
                        color: Colors.red.withOpacity(0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.cancel_outlined,
                        color: Colors.redAccent,
                        size: 26,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Batalkan Sesi',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // =====================================================================
  // AKTIF WIDGETS
  // =====================================================================

  Widget _buildKonselorCardAktif() {
    final counselorModel = CounselingController.findKonselorByName(_namaKonselor);
    final String? avatarUrl = (counselorModel.fotoProfil != null && counselorModel.fotoProfil!.isNotEmpty)
        ? counselorModel.fotoProfil
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          // PENINGKATAN SHADOW
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl,
                    width: 70,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Container(
                      width: 70,
                      height: 80,
                      color: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 70,
                    height: 80,
                    color: Colors.grey[200],
                    child: const Icon(Icons.person, color: Colors.grey),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'KONSELOR SENIOR',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF16A34A),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _namaKonselor,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _specialty,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              final int? kId = int.tryParse(widget.sessionData?['id']?.toString() ?? '');
              final extraMap = {
                'name': _namaKonselor,
                'specialty': _specialty,
                'isSystem': false,
                'color': const Color(0xFF1068A3),
                'unread': 0,
                'messages': <Map<String, dynamic>>[],
                'konselingId': kId,
              };
              context.push('/inbox/room-chat', extra: extraMap);
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFDCFCE7), // Warna background hijau muda
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF1068A3),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleMeetCard() {
    return _buildGabungSesiCard();
  }

  Widget _buildOfflineLocationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16A34A), Color(0xFF4ADE80)], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF16A34A).withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pertemuan Tatap Muka (Offline)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                    Text(
                      _lokasi.isNotEmpty && _lokasi != '-' ? _lokasi : 'Ruang Konseling Kampus (Gedung AA, Lantai 1)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              'Silakan hadir langsung di lokasi di atas tepat waktu.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersiapanSesiList() {
    final isOffline = _mode.toLowerCase() == 'offline';
    final tips = isOffline
        ? [
            'Hadir di lokasi 10 menit sebelum sesi dimulai',
            'Siapkan catatan poin penting yang ingin dibahas',
            'Heningkan ponsel agar sesi berlangsung fokus',
          ]
        : [
            'Cari tempat tenang dan minim gangguan',
            'Siapkan air minum di dekat Anda',
            'Pastikan koneksi internet stabil',
          ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.checklist, color: Color(0xFF1068A3), size: 22),
            const SizedBox(width: 8),
            Text(
              'Persiapan Sesi',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2D3D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        ...tips.map(
          (tip) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  // PENINGKATAN SHADOW
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline,
                    color: Color(0xFF1068A3),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKeluhanInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF1068A3), size: 22),
            const SizedBox(width: 8),
            Text(
              'Tuliskan Keluhanmu',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2D3D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _catatanController,
            maxLines: 4,
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
            decoration: InputDecoration(
              hintText:
                  'Tuliskan keluhan yang ingin kamu diskusikan dengan $_namaKonselor di sini...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[400],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAturJadwalAktif(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            final kModel = CounselingController.daftarKonselor.firstWhere(
              (k) => k.name == _namaKonselor,
              orElse: () => CounselingController.placeholderKonselor,
            );
            final extraMap = Map<String, dynamic>.from(kModel.toMap());
            extraMap['old_booking_id'] = widget.sessionData?['id'];
            context.push('/counseling/reschedule', extra: extraMap);
          },
          child: Text(
            'Ubah Jadwal',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1068A3),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _showBatalkanDialog(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.5),
              backgroundColor: const Color(0xFFFFF5F5),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Batalkan Sesi',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showBatalkanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Batalkan Sesi?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin membatalkan sesi konseling ini?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'Tidak',
              style: GoogleFonts.plusJakartaSans(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (loadingCtx) => const Center(child: CircularProgressIndicator()),
              );

              final bookingId = widget.sessionData?['id']?.toString() ?? '';
              final success = await CounselingController.cancelBooking(bookingId);

              if (context.mounted) {
                Navigator.pop(context); // pop loading
              }
              Navigator.pop(ctx); // pop confirmation alert

              if (success) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sesi konseling berhasil dibatalkan.')),
                  );
                  context.go('/activity', extra: 'konseling');
                }
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal membatalkan sesi konseling.')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Ya, Batalkan',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentCard() {
    final name = AuthController.currentUserName;
    final nim = AuthController.currentUserNim;
    final prodi = AuthController.currentUserProdi;
    final angkatan = AuthController.currentUserAngkatan;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.badge_outlined, color: Color(0xFF1068A3), size: 20),
              const SizedBox(width: 8),
              Text(
                'Identitas Mahasiswa',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F4F8)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nama',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500]),
              ),
              Text(
                name,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'NIM',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500]),
              ),
              Text(
                nim,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Program Studi',
                style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500]),
              ),
              Text(
                prodi.isNotEmpty ? '$prodi (Angkatan $angkatan)' : '-',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeluhanCard() {
    final keluhan = widget.sessionData?['keluhan']?.toString() ?? '-';
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.chat_bubble_outline_rounded, color: Color(0xFF1068A3), size: 20),
              const SizedBox(width: 8),
              Text(
                'Keluhan / Deskripsi Masalah',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1, color: Color(0xFFF1F4F8)),
          Text(
            keluhan.isNotEmpty && keluhan != '-' ? keluhan : 'Tidak ada deskripsi keluhan.',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.grey[800],
              height: 1.5,
              fontStyle: (keluhan.isEmpty || keluhan == '-') ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildReceiptCard() {
    final statusStr = widget.sessionData?['status']?.toString() ?? 'aktif';
    final isPending = statusStr == 'menunggu' || statusStr == 'Diajukan';

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'POLINEMA CARE+',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      color: const Color(0xFF1068A3),
                      letterSpacing: 1,
                    ),
                  ),
                  Text(
                    widget.sessionData?['id']?.toString() ?? 'KSL-00',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              
              // Barcode sudah dihapus total, diganti dengan jarak antar elemen
              const SizedBox(height: 24),

              _receiptRow('Status Sesi', isPending ? 'Menunggu' : 'Dikonfirmasi', isStatus: true, isPending: isPending),
              _receiptRow('Konselor', _namaKonselor),
              _receiptRow('Spesialisasi', _specialty),
              _receiptRow('Metode Sesi', _mode),
              _receiptRow('Hari & Tanggal', _tanggal),
              _receiptRow('Waktu Sesi', _waktu),
              
              const SizedBox(height: 16),
              _buildDashedDivider(),
              const SizedBox(height: 16),
              
              Text(
                _mode.toLowerCase() == 'offline' ? 'Lokasi Pertemuan:' : 'Tautan Sesi:',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade100),
                ),
                child: Row(
                  children: [
                    Icon(
                      _mode.toLowerCase() == 'offline' ? Icons.location_on_outlined : Icons.videocam_outlined,
                      color: const Color(0xFF1068A3),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _mode.toLowerCase() == 'offline'
                            ? (_lokasi.isNotEmpty && _lokasi != '-' && _lokasi.toLowerCase().contains('gedung aa') ? _lokasi : 'Ruang Konseling Kampus (Gedung AA, Lantai 1)')
                            : 'Tautan Google Meet akan dikirimkan oleh konselor ke email Anda sebelum sesi dimulai.',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A2D3D),
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Lingkaran potong kiri
        Positioned(
          left: -10,
          top: 204, // <-- Angka ini sudah dikurangi dari 236. Sesuaikan sedikit jika masih kurang pas dengan garis putus-putus
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA), // Warna background halaman agar terlihat transparan
              shape: BoxShape.circle,
            ),
          ),
        ),
        
        // Lingkaran potong kanan
        Positioned(
          right: -10,
          top: 204, // <-- Pastikan angka ini sama dengan top yang ada di left
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFF5F7FA), 
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDashedDivider() {
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            color: index % 2 == 0 ? Colors.transparent : Colors.grey.shade300,
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(String label, String value, {bool isStatus = false, bool isPending = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
          Flexible(
            child: Container(
              padding: isStatus ? const EdgeInsets.symmetric(horizontal: 10, vertical: 4) : null,
              decoration: isStatus
                  ? BoxDecoration(
                      color: isPending ? const Color(0xFFFFF3E0) : const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isStatus
                      ? (isPending ? Colors.orange[800] : Colors.blue[800])
                      : const Color(0xFF1A2D3D),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
