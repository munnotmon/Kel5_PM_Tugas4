import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Polinema Care+',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const PolinemaCarePage(),
    );
  }
}

class PolinemaCarePage extends StatelessWidget {
  const PolinemaCarePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF1A5D8A),
                            width: 2.0,
                          ),
                        ),
                        child: const CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.white,
                          backgroundImage: AssetImage(
                            'assets/images/logo-sementara.jpeg',
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),
                      Text(
                        'Polinema Care+',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A5D8A),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationsPage(),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF1A5D8A),
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              // Greeting Section
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

              // Gradient Button
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B79AD), Color(0xFF7CB6E1)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
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
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LaporPerundunganPage extends StatelessWidget {
  const LaporPerundunganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporkan Perundungan')),
      body: const Center(child: Text('Data Diri Pelapor')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi'), centerTitle: true),
      body: const Center(child: Text('Belum ada notifikasi baru untukmu.')),
    );
  }
}
