import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'data_konselor.dart';

class DetailSesiScreen extends StatelessWidget {
  final Map<String, dynamic>? sessionData; // Variabel penangkap data

  const DetailSesiScreen({super.key, this.sessionData});

  @override
  Widget build(BuildContext context) {
    // 1. Ekstrak data yang dilempar, dengan fallback default
    final data = sessionData?['counselor'] ?? daftarKonselor[0];
    final tgl = sessionData?['tanggal'] ?? "Senin, 12 Okt 2026";
    final wkt = sessionData?['waktu'] ?? "10:30 WIB";
    final mode = sessionData?['mode'] ?? "Offline";

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
          'Detail Sesi',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusBadge(),
            const SizedBox(height: 16),

            // Memasukkan variabel ke UI
            _buildSessionHeader(tgl, wkt),
            const SizedBox(height: 20),

            _buildCounselorCard(data),
            const SizedBox(height: 16),

            _buildPersiapanSesiCard(),
            const SizedBox(height: 16),

            // LOGIKA MODE: Tampil Google Meet / Lokasi Offline
            if (mode.toString().toLowerCase() == 'online' ||
                mode.toString().toLowerCase() == 'virtual')
              _buildGabungSesiCard()
            else
              _buildLokasiOfflineCard(),

            const SizedBox(height: 24),
            _buildAturJadwalSection(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF4CAF50),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Mendatang',
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF2E7D32),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Menangkap tanggal dan waktu dinamis
  Widget _buildSessionHeader(String tanggal, String waktu) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sesi Konseling',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(
              Icons.calendar_today_outlined,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              tanggal,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(width: 12),
            const Icon(
              Icons.access_time_outlined,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              waktu,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Menangkap data konselor dinamis
  Widget _buildCounselorCard(Map<String, dynamic> data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF1068A3),
            backgroundImage: NetworkImage(
              "https://i.pravatar.cc/150?u=${data['name']}",
            ), // Foto Dinamis
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  data['specialty'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2ED),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              size: 18,
              color: Color(0xFF1068A3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersiapanSesiCard() {
    final List<String> tips = [
      'Cari tempat tenang dan privat untuk berbicara.',
      'Siapkan catatan jika ada poin yang ingin didiskusikan.',
      'Pastikan Anda merasa nyaman dan rileks sebelum sesi.',
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                color: Color(0xFF1068A3),
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Persiapan Sesi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (tip) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 16,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      tip,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGabungSesiCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.video_call_outlined,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesi Online (Virtual)',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Google Meet (Aktif 5 Menit Sebelum)',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white70,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Buka',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1068A3),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLokasiOfflineCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.location_on_outlined,
              color: Color(0xFF1068A3),
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sesi Offline (Tatap Muka)',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1A2D3D),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Ruang Konseling Kampus, Gedung Kemahasiswaan Lt. 2',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.grey[700],
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAturJadwalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ATUR JADWAL',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildJadwalButton(
                icon: Icons.calendar_month_outlined,
                label: 'Jadwalkan Ulang',
                backgroundColor: const Color(0xFFE0F2ED),
                iconColor: const Color(0xFF1068A3),
                textColor: const Color(0xFF1068A3),
                onTap: () => context.push('/counseling/reschedule'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildJadwalButton(
                icon: Icons.cancel_outlined,
                label: 'Batalkan Sesi',
                backgroundColor: const Color(0xFFFFEBEE),
                iconColor: const Color(0xFFE53935),
                textColor: const Color(0xFFE53935),
                onTap: () => _showBatalkanDialog(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildJadwalButton({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                color: textColor,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showBatalkanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Batalkan Sesi?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin membatalkan sesi ini?',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey[700],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(
              'Tidak',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              context.pop();
              context.go('/counseling');
            },
            child: Text(
              'Ya, Batalkan',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFFE53935),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
