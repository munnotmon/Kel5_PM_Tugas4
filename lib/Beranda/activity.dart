import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../halaman_pendukung/detail_laporan.dart';
import '../halaman_pendukung/detail_laporan_baru.dart';

// =====================================================================
// 1. HALAMAN UTUH (Ditampilkan saat Tab Activity di Bottom Navbar ditekan)
// =====================================================================
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Wajib pakai SafeArea agar tidak tertutup jam/sinyal HP
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Semua Aktivitas",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Pantau perkembangan laporan dan aktivitasmu.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 24),

              // Memanggil komponen kartu agar tidak perlu menulis kode panjang berulang-ulang
              _buildCardInsidenKantin(context),
              const SizedBox(height: 16),
              _buildCardLaporanBaru(context),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// 2. POTONGAN UI (Ditampilkan di dalam HomeScreen)
// =====================================================================
class ActivitySection extends StatelessWidget {
  // Fungsi yang dipanggil saat tulisan "Lihat Semua" ditekan
  final VoidCallback onSeeAll;

  const ActivitySection({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Aktivitas Saya",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            InkWell(
              // DISINI PERUBAHANNYA: Eksekusi pindah tab!
              onTap: onSeeAll,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "Lihat Semua",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D9BFF),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildCardInsidenKantin(context),
        const SizedBox(height: 16),
        _buildCardLaporanBaru(context),
      ],
    );
  }
}

// =====================================================================
// WIDGET BANTUAN (Agar desain kartu bisa dipakai di Home & Activity)
// =====================================================================

Widget _buildCardInsidenKantin(BuildContext context) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HalamanDetailLaporan()),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2ECC71).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "DIPROSES",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF27AE60),
                    ),
                  ),
                ),
                Text(
                  "12 Okt",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "ID Laporan: #29482",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Insiden Kantin",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 0.75,
                minHeight: 5,
                backgroundColor: Color(0xFFE0E0E0),
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1D9E75)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _buildCardLaporanBaru(BuildContext context) {
  return Material(
    color: const Color(0xFFF8FBFB),
    borderRadius: BorderRadius.circular(25),
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HalamanDetailLaporanBaru(),
        ),
      ),
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD6EAF8),
                    shape: BoxShape.circle,
                  ),
                  child: Transform.rotate(
                    angle: -0.5,
                    child: const Icon(
                      Icons.send_rounded,
                      color: Color(0xFF2E86C1),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Laporan Baru",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                    Text(
                      "Status: Dikirim",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              "Tim audit sedang meninjau dokumen awal Anda.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
