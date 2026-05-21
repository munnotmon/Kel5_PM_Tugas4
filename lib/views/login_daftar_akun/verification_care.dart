import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class VerificationCare extends StatefulWidget {
  final String email; // Menerima email dari halaman pendaftaran
  const VerificationCare({super.key, required this.email});

  @override
  State<VerificationCare> createState() => _VerificationCareState();
}

class _VerificationCareState extends State<VerificationCare> {
  // Timer logic
  int _start = 59;
  Timer? _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer?.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(), // Cukup satu onPressed untuk kembali
        ),
        title: Text(
          "Konfirmasi Registrasi",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1068A3),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            // --- HEADER ---
            Text(
              "Verifikasi Email Kamu",
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF2D3142),
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF6B7280),
                  height: 1.5,
                ),
                children: [
                  const TextSpan(text: "Kami telah mengirimkan kode OTP ke "),
                  TextSpan(
                    text: widget.email,
                    style: const TextStyle(
                      color: Color(0xFF1068A3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const TextSpan(
                    text: ". Silakan masukkan kode tersebut di bawah ini.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),

            // --- OTP INPUT FIELDS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildOtpBox(index)),
            ),
            const SizedBox(height: 50),

            // --- BUTTON VERIFIKASI ---
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0F5A8F), Color(0xFF67B9ED)],
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF67B9ED).withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  context.go('/success_verification');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Verifikasi Akun',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // --- RESEND TIMER ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Belum menerima kode? ",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF6B7280),
                  ),
                ),
                Text(
                  _start == 0
                      ? "Kirim ulang"
                      : "Kirim ulang dalam 00:${_start.toString().padLeft(2, '0')}",
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1068A3),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),

            // --- INFO BOX ---
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const Icon(
                    Icons.verified_user_outlined,
                    color: Colors.green,
                    size: 30,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Email ini diperlukan untuk memastikan komunitas kampus kita tetap aman dan terverifikasi.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET UNTUK BOX OTP ---
  Widget _buildOtpBox(int index) {
    return Container(
      width: 65,
      height: 65,
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // Warna abu halus sesuai gambar
        shape: BoxShape.circle, // Bentuk lingkaran sesuai gambar
      ),
      child: Center(
        child: TextFormField(
          onChanged: (value) {
            if (value.length == 1 && index < 3) {
              FocusScope.of(
                context,
              ).nextFocus(); // Pindah otomatis ke box berikutnya
            }
          },
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1068A3),
          ),
          decoration: const InputDecoration(
            counterText: "",
            border: InputBorder.none,
            hintText: "•", // Hint titik sesuai gambar
            hintStyle: TextStyle(color: Colors.black26),
          ),
        ),
      ),
    );
  }
}
