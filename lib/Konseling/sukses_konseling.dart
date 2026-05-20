import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SuccessAppointmentPage extends StatelessWidget {
  const SuccessAppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Color(0xFFE0F2ED),
                child: Icon(Icons.check, size: 60, color: Colors.green),
              ),
              const SizedBox(height: 24),
              Text(
                "Janji Temu Berhasil!",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Sesi Anda telah dijadwalkan. Kami di sini untuk mendengarkan.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(color: Colors.grey),
              ),
              const SizedBox(height: 40),
              _buildSummaryCard(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () => context.go('/home'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1068A3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Kembali ke Beranda",
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: Text(
                  "Lihat Detail Sesi",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(radius: 20, backgroundColor: Colors.grey),
              const SizedBox(width: 12),
              Text(
                "dr. Anton Wijaya",
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 30),
          _rowInfo(Icons.calendar_today, "Senin, 12 Okt"),
          const SizedBox(height: 10),
          _rowInfo(Icons.access_time, "10:30 WIB"),
        ],
      ),
    );
  }

  Widget _rowInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
