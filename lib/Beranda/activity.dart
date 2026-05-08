import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

// Pastikan import path ini sesuai dengan lokasi file LaporanPerundunganPage yang baru diperbaiki
import '../Laporan_Perundungan/LaporPerundunganPage.dart';

// =====================================================================
// 1. HALAMAN UTUH (Ditampilkan saat Tab Activity di Bottom Navbar ditekan)
// =====================================================================
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Menampilkan halaman laporan. Karena LaporanPerundunganPage sudah
    // menghapus Navbar-nya sendiri, maka Navbar dari MainScreen akan tetap terlihat.
    return const LaporanPerundunganPage();
  }
}

// =====================================================================
// 2. POTONGAN UI (Ditampilkan di dalam HomeScreen)
// =====================================================================
class ActivitySection extends StatelessWidget {
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
        // Gunakan fungsi builder yang sudah diperbaiki di bawah
        _buildCardPreviewLapor(context, onSeeAll),
      ],
    );
  }
}

Widget _buildCardPreviewLapor(BuildContext context, VoidCallback onTap) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.campaign,
                color: Color(0xFF1A6B8A),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Laporkan Perundungan",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Buat laporan baru sekarang",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF1A6B8A),
            ),
          ],
        ),
      ),
    ),
  );
}
