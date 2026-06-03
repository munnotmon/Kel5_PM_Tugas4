import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class HalamanDetailLaporan extends StatelessWidget {
  final Map<String, dynamic>? laporanData; // Menangkap data dinamis

  const HalamanDetailLaporan({super.key, this.laporanData});

  @override
  Widget build(BuildContext context) {
    // Fallback data jika ternyata data kosong (safety)
    final id = laporanData?['id'] ?? '#RPT-000';
    final judul = laporanData?['judul'] ?? 'Detail Laporan';
    final tanggal = laporanData?['tanggal'] ?? 'Tanggal tidak diketahui';
    final deskripsi = laporanData?['deskripsi'] ?? 'Tidak ada deskripsi.';
    final statusLabel = laporanData?['statusLabel'] ?? 'DIPROSES';
    final Color statusColor = laporanData?['statusColor'] ?? Colors.orange;

    // Ambil data dinamis dari map parameter
    final jenis = (laporanData?['jenis_perundungan'] != null && laporanData!['jenis_perundungan'].toString().trim().isNotEmpty) ? laporanData!['jenis_perundungan'].toString() : '-';
    final lokasi = (laporanData?['lokasi'] != null && laporanData!['lokasi'].toString().trim().isNotEmpty) ? laporanData!['lokasi'].toString() : '-';
    final pelaku = (laporanData?['pelaku'] != null && laporanData!['pelaku'].toString().trim().isNotEmpty) ? laporanData!['pelaku'].toString() : '-';
    final saksi = (laporanData?['saksi'] != null && laporanData!['saksi'].toString().trim().isNotEmpty) ? laporanData!['saksi'].toString() : '-';
    final korban = laporanData?['korban']?.toString() ?? 'saya';
    final statusPelapor = (korban.toLowerCase() == 'saya') ? 'Korban (Melaporkan Sendiri)' : 'Saksi / Kerabat Korban';

    // Ekstrak deskripsi asli tanpa tambahan info korban/saksi
    String deskripsiClean = deskripsi;
    final indexKorban = deskripsi.indexOf('\n\nKorban:');
    if (indexKorban != -1) {
      deskripsiClean = deskripsi.substring(0, indexKorban).trim();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
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
        padding: const EdgeInsets.all(24),
        children: [
          // --- KARTU UTAMA STATUS ---
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: statusColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        statusLabel.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  judul,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Dilaporkan pada $tanggal',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- RINCIAN INFORMASI KORBAN & PELAKU ---
          Text(
            'Informasi Insiden',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                _buildInfoRow('Jenis Perundungan', jenis),
                const Divider(height: 24),
                _buildInfoRow('Lokasi Kejadian', lokasi),
                const Divider(height: 24),
                _buildInfoRow(
                  'Status Pelapor',
                  statusPelapor,
                ),
                const Divider(height: 24),
                _buildInfoRow('Terduga Pelaku', pelaku),
                const Divider(height: 24),
                _buildInfoRow('Saksi Mata', saksi),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // --- KRONOLOGI / DESKRIPSI ---
          Text(
            'Kronologi / Deskripsi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              deskripsiClean,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.6,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // --- LINI MASA INVESTIGASI ---
          Text(
            'Perkembangan Penanganan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 16),
          _buildTimelineItem(
            'Laporan Diterima Sistem',
            tanggal,
            true,
          ),
          _buildTimelineItem(
            'Verifikasi Berkas & Bukti',
            statusLabel != 'Menunggu'
                ? tanggal
                : 'Menunggu verifikasi admin',
            statusLabel != 'Menunggu',
          ),
          _buildTimelineItem(
            'Tindakan & Investigasi',
            statusLabel == 'Selesai'
                ? 'Kasus telah ditutup/diselesaikan'
                : 'Sedang dalam proses',
            statusLabel == 'Selesai',
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineItem(String title, String subtitle, bool isDone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: isDone ? const Color(0xFF1068A3) : Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: isDone
                  ? const Icon(Icons.check, size: 10, color: Colors.white)
                  : null,
            ),
            Container(
              width: 2,
              height: 45,
              color: isDone ? const Color(0xFF1068A3) : Colors.grey[300],
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
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isDone ? const Color(0xFF1A2D3D) : Colors.grey[500],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
