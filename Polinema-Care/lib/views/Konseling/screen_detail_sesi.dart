// Lokasi: lib/Konseling/screen_detail_sesi.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart';
import '../../controllers/auth_controller.dart';

class ScreenDetailSesi extends StatefulWidget {
  final Map<String, dynamic>? sessionData;
  const ScreenDetailSesi({super.key, this.sessionData});

  @override
  State<ScreenDetailSesi> createState() => _ScreenDetailSesiState();
}

class _ScreenDetailSesiState extends State<ScreenDetailSesi> {
  // Variabel state untuk mengunci data sesi secara dinamis
  late Map<String, dynamic> _konselorData;
  late String _namaKonselor;
  late String _specialty;
  late String _tanggal;
  late String _waktu;
  late String _mode;
  late String _lokasi;

  @override
  void initState() {
    super.initState();
    
    // 1. Ambil nama konselor dari data parameter router
    _namaKonselor = widget.sessionData?['konselor'] ?? 
                    widget.sessionData?['counselor']?['name'] ?? 
                    'dr. Anton Wijaya';
                    
    _tanggal = widget.sessionData?['tanggal'] ?? 'Senin, 12 Okt';
    _waktu = widget.sessionData?['waktu'] ?? widget.sessionData?['jam'] ?? '10:30 WIB';
    _mode = widget.sessionData?['mode'] ?? 'Online';
    _lokasi = widget.sessionData?['lokasi'] ?? '';

    // 2. Cari data lengkap dari daftarKonselor berdasarkan nama agar singkron
    if (widget.sessionData?['counselor'] != null) {
      _konselorData = Map<String, dynamic>.from(widget.sessionData!['counselor']);
    } else {
      final kModel = CounselingController.daftarKonselor.firstWhere(
        (k) => k.name == _namaKonselor,
        orElse: () => CounselingController.placeholderKonselor,
      );
      _konselorData = kModel.toMap();
    }
    
    _specialty = _konselorData['specialty'] ?? 'Spesialis Konselor Klinis';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () {
            context.pop();
          },
        ),
        title: Text(
          'Detail Sesi',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // --- STATUS SESI ---
          _buildStatusSesi(),
          const SizedBox(height: 24),

          // --- KARTU KONSELOR ---
          _buildCounselorCard(),
          const SizedBox(height: 24),

          // --- DETAIL TRANSAKSI / STRUK BOOKING ---
          _buildReceiptCard(),
          const SizedBox(height: 24),

          // --- IDENTITAS MAHASISWA ---
          _buildStudentCard(),
          const SizedBox(height: 24),

          // --- PERSIAPAN SESI ---
          _buildPersiapanSesiList(),
          const SizedBox(height: 32),

          // --- KELUHAN SAYA ---
          _buildKeluhanCard(),
          const SizedBox(height: 40),

          // --- TOMBOL AKSI ---
          _buildActionButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildStatusSesi() {
    final statusStr = widget.sessionData?['status']?.toString().toLowerCase() ?? 'diterima';

    String largeTitle = 'Diterima';
    String pillText = 'Diterima';
    Color pillBg = const Color(0xFFEFF6FF);
    Color themeColor = const Color(0xFF3B82F6);

    if (statusStr == 'diajukan') {
      largeTitle = 'Menunggu Konfirmasi';
      pillText = 'Diajukan';
      pillBg = const Color(0xFFFFF3E0);
      themeColor = const Color(0xFFF59E0B);
    } else if (statusStr == 'berlangsung') {
      largeTitle = 'Sedang Berlangsung';
      pillText = 'Berlangsung';
      pillBg = const Color(0xFFF3E8FF);
      themeColor = const Color(0xFF8B5CF6);
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status Sesi', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text(
              largeTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A2D3D),
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: pillBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: themeColor,
              ),
              const SizedBox(width: 8),
              Text(
                pillText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: themeColor,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCounselorCard() {
    final counselorModel = CounselingController.findKonselorByName(_namaKonselor);
    final String? avatarUrl = (counselorModel.fotoProfil != null && counselorModel.fotoProfil!.isNotEmpty)
        ? counselorModel.fotoProfil
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: avatarUrl != null
                ? Image.network(
                    avatarUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 70,
                        height: 70,
                        color: const Color(0xFF1068A3).withOpacity(0.1),
                        child: const Icon(Icons.person, color: Color(0xFF1068A3), size: 35),
                      );
                    },
                  )
                : Container(
                    width: 70,
                    height: 70,
                    color: const Color(0xFF1068A3).withOpacity(0.1),
                    child: const Icon(Icons.person, color: Color(0xFF1068A3), size: 35),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE1F5FE), borderRadius: BorderRadius.circular(6)),
                  child: Text('KONSELOR SENIOR', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF0288D1), letterSpacing: 0.5)),
                ),
                const SizedBox(height: 6),
                Text(_namaKonselor, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D))),
                Text(_specialty, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500], height: 1.3)),
              ],
            ),
          ),
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
              decoration: BoxDecoration(color: const Color(0xFFF5F7FA), shape: BoxShape.circle),
              child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1068A3), size: 20),
            ),
          )
        ],
      ),
    );
  }


  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ElevatedButton.icon(
            onPressed: () {
              final extraMap = Map<String, dynamic>.from(_konselorData);
              extraMap['old_booking_id'] = widget.sessionData?['id'];
              context.push('/counseling/reschedule', extra: extraMap);
            },
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              'Ubah Jadwal Sesi',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () => _showBatalkanDialog(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFCA5A5), width: 1.5),
              backgroundColor: const Color(0xFFFFF5F5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Batalkan Sesi', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton.icon(
            onPressed: () {
              context.go('/home');
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
        )
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
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Tidak', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
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
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Ya, Batalkan', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
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
    final statusStr = widget.sessionData?['status']?.toString().toLowerCase() ?? 'diterima';

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
              const SizedBox(height: 24),
              _receiptRow(
                'Status Sesi',
                statusStr == 'diajukan'
                    ? 'Diajukan'
                    : statusStr == 'berlangsung'
                        ? 'Berlangsung'
                        : 'Diterima',
                isStatus: true,
                statusType: statusStr,
              ),
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
        Positioned(
          left: -10,
          top: 236, // matches divider position
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA), // Matches Scaffold background
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: -10,
          top: 236, // matches divider position
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFFF8F9FA), // Matches Scaffold background
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

  Widget _receiptRow(String label, String value, {bool isStatus = false, String statusType = ''}) {
    Color bg = const Color(0xFFE3F2FD);
    Color txt = const Color(0xFF1068A3);
    
    if (isStatus) {
      if (statusType == 'diajukan') {
        bg = const Color(0xFFFFF3E0);
        txt = const Color(0xFFD97706);
      } else if (statusType == 'berlangsung') {
        bg = const Color(0xFFF3E8FF);
        txt = const Color(0xFF8B5CF6);
      }
    }

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
                      color: bg,
                      borderRadius: BorderRadius.circular(10),
                    )
                  : null,
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isStatus ? txt : const Color(0xFF1A2D3D),
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
}