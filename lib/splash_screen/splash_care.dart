import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';
import '../login_daftar_akun/login_care.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Berpindah ke halaman LoginCare setelah 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginCare()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Implementasi gradasi 3 warna sesuai permintaan
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF006592), // Biru Tua
              Color(0xFF78C6FD), // Biru Muda
              Color.fromARGB(255, 86, 165, 229), // Putih
            ],
            // Mengatur distribusi warna agar transisi Biru Muda berada di tengah
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo Perisai dengan Heart
              Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(
                    Icons.shield,
                    color: Color(
                      0xFF004D70,
                    ), // Warna perisai lebih gelap agar terlihat
                    size: 120,
                  ),
                  Icon(
                    Icons.favorite,
                    color: Color(
                      0xFF78C6FD,
                    ), // Warna hati mengikuti biru muda gradasi
                    size: 50,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Nama Aplikasi
              Text(
                "Polinema Care+",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 40),
              // Loading Indicator berwarna Biru Tua
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006592)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
