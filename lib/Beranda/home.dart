import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart'; // Wajib tambahkan ini

import 'activity.dart';
import 'counseling.dart';

import '../halaman_pendukung/notification_page.dart';
import '../halaman_pendukung/laporan_perundungan.dart';

class HomeScreen extends StatelessWidget {
  // Constructor sekarang bersih dan sederhana
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- HEADER SECTION ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(
                            Icons.shield,
                            color: Color(0xFF1068A3),
                            size: 32,
                          ),
                          Icon(Icons.favorite, color: Colors.white, size: 14),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Polinema Care+",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      // Catatan: Ini masih pakai cara lama, tidak apa-apa dibiarkan dulu
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF1068A3),
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              Text(
                'Halo, My Kisah!',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),

              Text(
                'Kamu Tidak Sendiri.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 34,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D2D2D),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 15),

              // --- BUTTON LAPOR ---
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B79AD), Color(0xFF7CB6E1)],
                  ),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Catatan: Ini juga masih pakai cara lama, tidak apa-apa dibiarkan dulu
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LaporPerundunganPage(),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.campaign,
                    color: Colors.white,
                    size: 32,
                  ),
                  label: Text(
                    'Laporkan Perundungan',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // --- SECTION AKTIVITAS ---
              // PERUBAHAN DI SINI: Langsung panggil context.go
              ActivitySection(
                onSeeAll: () => context.go('/activity'),
              ),

              const SizedBox(height: 32),

              // --- SECTION KONSELING ---
              // PERUBAHAN DI SINI: Langsung panggil context.go
              CounselingSection(
                onNavigate: () => context.go('/counseling'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}