import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HalamanDetailLaporan extends StatelessWidget {
  final Map<String, dynamic>? laporanData; // Menangkap data dinamis

  const HalamanDetailLaporan({super.key, this.laporanData});

  @override
  Widget build(BuildContext context) {
    // Fallback data jika ternyata data kosong (safety)
    final id = laporanData?['id'] ?? 'RPT-00';
    final judul = laporanData?['judul'] ?? 'Detail Laporan';
    final tanggal = laporanData?['tanggal'] ?? 'Tanggal tidak diketahui';
    final deskripsi = laporanData?['deskripsi'] ?? 'Tidak ada deskripsi.';
    final statusLabel = laporanData?['statusLabel'] ?? 'Menunggu';
    final Color statusColor = laporanData?['statusColor'] ?? Colors.orange;

    // Ambil data dinamis dari map parameter
    final jenis = (laporanData?['jenis_perundungan'] != null && laporanData!['jenis_perundungan'].toString().trim().isNotEmpty)
        ? laporanData!['jenis_perundungan'].toString()
        : '-';
    final lokasi = (laporanData?['lokasi'] != null && laporanData!['lokasi'].toString().trim().isNotEmpty)
        ? laporanData!['lokasi'].toString()
        : '-';
    final pelaku = (laporanData?['pelaku'] != null && laporanData!['pelaku'].toString().trim().isNotEmpty)
        ? laporanData!['pelaku'].toString()
        : '-';
    final saksi = (laporanData?['saksi'] != null && laporanData!['saksi'].toString().trim().isNotEmpty)
        ? laporanData!['saksi'].toString()
        : '-';
    final korban = laporanData?['korban']?.toString() ?? 'saya';
    final statusPelapor = (korban.toLowerCase() == 'saya') ? 'Korban (Melaporkan Sendiri)' : 'Saksi / Kerabat Korban';

    // Ekstrak deskripsi asli tanpa tambahan info korban/saksi
    String deskripsiClean = deskripsi;
    final indexKorban = deskripsi.indexOf('\n\nKorban:');
    if (indexKorban != -1) {
      deskripsiClean = deskripsi.substring(0, indexKorban).trim();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF1E3A8A), size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Detail Laporan Kasus',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // --- KARTU UTAMA STATUS ---
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1E3A8A).withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white.withOpacity(0.25)),
                      ),
                      child: Text(
                        id.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.circle, size: 8, color: statusColor),
                          const SizedBox(width: 6),
                          Text(
                            statusLabel.toUpperCase(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: statusColor,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  judul,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today_rounded, size: 14, color: Colors.white.withOpacity(0.8)),
                    const SizedBox(width: 8),
                    Text(
                      'Dilaporkan pada $tanggal',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.85),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- RINCIAN INFORMASI KORBAN & PELAKU ---
          _buildSectionHeader(Icons.info_outline_rounded, 'Informasi Insiden'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoTile(Icons.gavel_rounded, 'Jenis Perundungan', jenis),
                const Divider(height: 20, thickness: 1, color: Color(0xFFF1F5F9)),
                _buildInfoTile(Icons.location_on_rounded, 'Lokasi Kejadian', lokasi),
                const Divider(height: 20, thickness: 1, color: Color(0xFFF1F5F9)),
                _buildInfoTile(Icons.assignment_ind_rounded, 'Status Pelapor', statusPelapor),
                const Divider(height: 20, thickness: 1, color: Color(0xFFF1F5F9)),
                _buildInfoTile(Icons.person_search_rounded, 'Terduga Pelaku', pelaku),
                const Divider(height: 20, thickness: 1, color: Color(0xFFF1F5F9)),
                _buildInfoTile(Icons.remove_red_eye_rounded, 'Saksi Mata', saksi),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- KRONOLOGI / DESKRIPSI ---
          _buildSectionHeader(Icons.description_rounded, 'Kronologi / Deskripsi'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.format_quote_rounded,
                    color: Color(0xFF1E3A8A),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        deskripsiClean,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: const Color(0xFF475569),
                          height: 1.7,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- LINI MASA INVESTIGASI ---
          _buildSectionHeader(Icons.analytics_rounded, 'Perkembangan Penanganan'),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF1F5F9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildTimelineItem(
                  'Laporan Diterima Sistem',
                  'Laporan Anda telah berhasil terkirim ke sistem kami pada $tanggal.',
                  true,
                  isLast: false,
                ),
                _buildTimelineItem(
                  'Verifikasi Berkas & Bukti',
                  statusLabel.toLowerCase() == 'menunggu'
                      ? 'Menunggu tim admin melakukan verifikasi berkas dan bukti pelaporan.'
                      : (statusLabel.toLowerCase() == 'ditolak'
                          ? 'Verifikasi berkas ditolak/tidak dapat ditindaklanjuti.'
                          : 'Berkas dan bukti pelaporan telah diverifikasi oleh tim admin.'),
                  statusLabel.toLowerCase() != 'menunggu',
                  isLast: false,
                ),
                _buildTimelineItem(
                  'Tindakan & Investigasi',
                  (statusLabel.toLowerCase() == 'diproses' || statusLabel.toLowerCase() == 'selesai')
                      ? 'Kasus sedang ditindaklanjuti dengan investigasi lapangan, pemanggilan saksi, dan mediasi.'
                      : 'Menunggu proses verifikasi selesai untuk memulai investigasi.',
                  statusLabel.toLowerCase() == 'diproses' || statusLabel.toLowerCase() == 'selesai',
                  isLast: false,
                ),
                _buildTimelineItem(
                  'Kasus Selesai / Ditutup',
                  statusLabel.toLowerCase() == 'selesai'
                      ? 'Kasus perundungan ini telah dinyatakan selesai dan ditutup secara resmi oleh pihak kampus.'
                      : 'Kasus akan ditutup secara resmi setelah seluruh proses penanganan dan mediasi selesai.',
                  statusLabel.toLowerCase() == 'selesai',
                  isLast: true,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // --- TOMBOL AKSI ---
          _buildActionButtons(context, id),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF1E3A8A), size: 18),
          ),
          const SizedBox(width: 10),
          Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFF1F5F9)),
          ),
          child: Icon(icon, color: const Color(0xFF475569), size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isDone, {bool isLast = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFF1E3A8A) : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDone ? const Color(0xFF1E3A8A) : const Color(0xFFCBD5E1),
                  width: 2,
                ),
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 11, color: Colors.white)
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 48,
                color: isDone ? const Color(0xFF1E3A8A) : const Color(0xFFE2E8F0),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDone ? const Color(0xFF1E293B) : const Color(0xFF94A3B8),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: isDone ? const Color(0xFF475569) : const Color(0xFF94A3B8),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context, String reportId) {
    return Column(
      children: [
        // Premium Download Mockup Button
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: const Color(0xFF1E3A8A),
                  content: Text(
                    'Bukti Laporan ${reportId.toUpperCase()} berhasil diunduh dalam format PDF.',
                    style: GoogleFonts.plusJakartaSans(fontSize: 13, color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.picture_as_pdf_rounded, color: Color(0xFF1E3A8A), size: 18),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF1E3A8A), width: 1.5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            label: Text(
              'Unduh Bukti Laporan (PDF)',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E3A8A),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Home Button
        Container(
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E3A8A).withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
            label: Text(
              'Kembali ke Beranda',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
