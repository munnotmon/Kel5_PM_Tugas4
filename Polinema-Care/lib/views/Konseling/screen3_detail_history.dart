// Lokasi: lib/Konseling/screen3_detail_history.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart';
import '../../controllers/auth_controller.dart';

class Screen3DetailHistory extends StatefulWidget {
  final Map<String, dynamic>? sessionData;
  const Screen3DetailHistory({super.key, this.sessionData});

  @override
  State<Screen3DetailHistory> createState() => _Screen3DetailHistoryState();
}

class _Screen3DetailHistoryState extends State<Screen3DetailHistory> {


  // 1. BUAT VARIABEL STATE UNTUK MENGUNCI DATA AGAR TIDAK ILANG SAAT REBUILD
  late String _namaDokter;
  late String _spesialisasi;
  late String _tanggalSesi;
  late String _jamSesi;
  late String _mode;
  late String _lokasi;

  @override
  void initState() {
    super.initState();
    
    // 2. KUNCI DATA DARI WIDGET KE DALAM STATE LOKAL DI SINI
    _namaDokter = widget.sessionData?['konselor'] ?? 'Nama Konselor';
    _spesialisasi = widget.sessionData?['specialty'] ?? 'Spesialis Konselor';
    _tanggalSesi = widget.sessionData?['tanggal'] ?? 'Tanggal Sesi';
    _jamSesi = widget.sessionData?['jam'] ?? 'Jam Sesi';
    _mode = widget.sessionData?['mode'] ?? 'Online';
    _lokasi = widget.sessionData?['lokasi'] ?? '';


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
          title: Text(
            'Detail Riwayat Sesi',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1A2D3D),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          centerTitle: true,
        ),
        body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // --- STATUS + BAGIKAN ---
          _buildStatusBar(context),
          const SizedBox(height: 16),

          // --- JUDUL SESI ---
          _buildSessionTitle(),
          const SizedBox(height: 20),

          // --- KONSELOR CARD ---
          _buildKonselorCard(context),
          const SizedBox(height: 24),

          // --- DETAIL TRANSAKSI / STRUK BOOKING ---
          _buildReceiptCard(),
          const SizedBox(height: 24),

          // --- IDENTITAS MAHASISWA ---
          _buildStudentCard(),
          const SizedBox(height: 24),

          // --- KELUHAN CARD ---
          if (widget.sessionData?['keluhan'] != null &&
              widget.sessionData?['keluhan'].toString().isNotEmpty == true &&
              widget.sessionData?['keluhan'] != '-') ...[
            _buildKeluhanCard(),
            const SizedBox(height: 28),
          ],

          // --- TOMBOL AKSI ---
          _buildActionButtons(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF4ADE80),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withOpacity(0.28),
                blurRadius: 28,
                spreadRadius: 6,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 9, 72, 32),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Selesai',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 9, 72, 32),
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              const Icon(
                Icons.share_outlined,
                color: Color(0xFF1068A3),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Bagikan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1068A3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTitle() {
    // 3. GUNAKAN VARIABEL LOKAL YANG SUDAH AMAN DARI REBUILD
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sesi Counseling Individu',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _tanggalSesi,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              _jamSesi,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKonselorCard(BuildContext context) {
    final counselorModel = CounselingController.findKonselorByName(_namaDokter);
    final String? avatarUrl = (counselorModel.fotoProfil != null && counselorModel.fotoProfil!.isNotEmpty)
        ? counselorModel.fotoProfil
        : null;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
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
                  _namaDokter,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
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
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _spesialisasi.isNotEmpty ? _spesialisasi : 'Spesialis Profesional',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              final int? kId = int.tryParse(widget.sessionData?['id']?.toString() ?? '');
              final extraMap = {
                'name': _namaDokter,
                'specialty': _spesialisasi,
                'isSystem': false,
                'color': const Color(0xFF1068A3),
                'unread': 0,
                'messages': <Map<String, dynamic>>[],
                'konselingId': kId,
              };
              context.push('/inbox/room-chat', extra: extraMap);
            },
            child: Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xFF1068A3).withOpacity(0.12), 
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFF1068A3), 
                size: 21,
              ),
            ),
          ),
        ],
      ),
    );
  }





  Widget _buildActionButtons(BuildContext context) {
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
              final kModel = CounselingController.daftarKonselor.firstWhere(
                (k) => k.name == _namaDokter,
                orElse: () => CounselingController.placeholderKonselor,
              );
              final extraMap = Map<String, dynamic>.from(kModel.toMap());
              extraMap['old_booking_id'] = widget.sessionData?['id'];
              context.push('/counseling/reschedule', extra: extraMap);
            },
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              'Jadwalkan Ulang dengan Konselor Ini',
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
          child: OutlinedButton.icon(
            onPressed: () {
              context.push('/counseling/catatan-sesi', extra: widget.sessionData);
            },
            icon: const Icon(
              Icons.article_outlined,
              color: Color(0xFF1068A3),
              size: 20,
            ),
            label: Text(
              'Lihat Catatan Sesi',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1068A3),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1068A3)),
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
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.download_rounded,
              color: Color(0xFF1A2D3D),
              size: 20,
            ),
            label: Text(
              'Unduh Ringkasan Sesi (PDF)',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1A2D3D),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
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
        ),
      ],
    );
  }

  Widget _buildReceiptCard() {
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
              _receiptRow('Status Sesi', 'Selesai', isStatus: true, isPending: false),
              _receiptRow('Konselor', _namaDokter),
              _receiptRow('Spesialisasi', _spesialisasi),
              _receiptRow('Metode Sesi', _mode),
              _receiptRow('Hari & Tanggal', _tanggalSesi),
              _receiptRow('Waktu Sesi', _jamSesi),
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
                            : 'Tautan Google Meet expired/telah dinonaktifkan karena sesi telah selesai.',
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
              color: Color(0xFFF5F7FA), // Matches Scaffold background
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
              color: Color(0xFFF5F7FA), // Matches Scaffold background
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
                      color: const Color(0xFFE8F6EE),
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
                      ? const Color(0xFF2A9D6A)
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
}