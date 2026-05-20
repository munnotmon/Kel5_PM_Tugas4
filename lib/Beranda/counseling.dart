import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../halaman_pendukung/riwayat.dart';

class CounselingScreen extends StatelessWidget {
  const CounselingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: CounselingSection(), // <-- pakai CounselingSection yang sudah lengkap
        ),
      ),
    );
  }
}

// =====================================================================
// SECTION UNTUK HOME SCREEN (CounselingSection)
// =====================================================================
class CounselingSection extends StatelessWidget {
  final VoidCallback? onNavigate;

  const CounselingSection({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                onTap: () => context.go('/activity'),
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
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2ED),
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
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jadwalkan sesi privat dengan konselor kami.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1068A3),
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
        _buildJadwalCardHome(context),
      ],
    );
  }
}

Widget _buildJadwalCardHome(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
   onTap: () => context.push('/counseling/detail'),
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
                      color: const Color(0xFF1068A3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Sesi dengan dr. Anton Wijaya",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
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
