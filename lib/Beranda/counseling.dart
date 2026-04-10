import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../halaman_pendukung/riwayat.dart';
import '../halaman_pendukung/jadwal.dart';
import '../halaman_pendukung/detail_sesi.dart';

// --- 1. HALAMAN UTUH (Gunakan kode yang sudah kamu buat) ---
class CounselingScreen extends StatelessWidget {
  const CounselingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildJadwalCard(context),
            ),
          ],
        ),
      ),
    );
  }
}

// --- 2. POTONGAN UI (Untuk ditampilkan di HOME) ---
class CounselingSection extends StatelessWidget {
  // Callback untuk pindah tab dari Home ke fitur Counseling
  final VoidCallback? onNavigate;

  const CounselingSection({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul Section & Tombol Riwayat
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Jadwal Konseling",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HalamanRiwayat(),
                  ),
                ),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    "Riwayat",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D9BFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Card Banner: Butuh teman bicara?
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 219, 237, 219),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Butuh teman bicara?",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jadwalkan sesi privat dengan konselor kami.",
                      style: GoogleFonts.plusJakartaSans(fontSize: 11),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                // Jika ditekan di Home, akan menjalankan onNavigate (pindah tab)
                onPressed: onNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 43, 103, 47),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Jadwalkan"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // Menampilkan ringkasan jadwal yang sama dengan di fitur utama
        _buildJadwalCard(context),
      ],
    );
  }
}

// Widget pembantu agar desain kartu jadwal konsisten
Widget _buildJadwalCard(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const DetailSesi()),
      ),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 22, backgroundColor: Colors.blueGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BESOK, 10:00",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Sesi dengan dr. WILDAN",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    ),
  );
}
