// Lokasi: lib/views/splash_screen/splash_care.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../controllers/splash_controller.dart'; // Import controller baru

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Panggil controller
  final SplashController _splashController = SplashController();

  @override
  void initState() {
    super.initState();
    // Gunakan controller untuk menangani timer
    _splashController.startSplashTimer(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF006592),
              Color(0xFF78C6FD),
              Color.fromARGB(255, 86, 165, 229),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: const [
                  Icon(
                    Icons.shield,
                    color: Color(0xFF004D70),
                    size: 120,
                  ),
                  Icon(
                    Icons.favorite,
                    color: Color(0xFF78C6FD),
                    size: 50,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Polinema Care+",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 40),
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