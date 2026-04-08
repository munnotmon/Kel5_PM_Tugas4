import 'package:flutter/material.dart';
import 'login_care.dart';
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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A6B7A)),
        useMaterial3: true,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: LoginCare(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ActivityScreen(),
    InboxScreen(),
    CounselingScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Bungkus IndexedStack dengan Container untuk menerapkan gradasi
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(179, 247, 250, 249),
              Color.fromARGB(255, 245, 249, 255),
            ],
          ),
        ),
        child: IndexedStack(index: _currentIndex, children: _pages),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// --- HALAMAN HOME (GABUNGAN DESAIN MUNA + AYU + WILDAN) ---
class HomeScreen extends StatelessWidget {
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
              // Header Section (Muna)
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
              // Button Lapor (Muna)
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

              // --- SECTION AKTIVITAS (Ayu) ---
              const ActivitySection(),

              const SizedBox(height: 32),

              // --- SECTION KONSELING (Wildan) ---
              const WildanCounselingSection(),
            ],
          ),
        ),
      ),
    );
  }
}

// Widget untuk isi Aktivitas (Ayu's UI - UPDATED)
class ActivitySection extends StatelessWidget {
  const ActivitySection({super.key});

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
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HalamanLihatSemua(),
                ),
              ),
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

        // --- CARD 1: Insiden Kantin (Bisa Dipencet) ---
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HalamanDetailLaporan(),
              ),
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
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Color(0xFF1D9E75),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // --- CARD 2: Laporan Baru (Bisa Dipencet) ---
        Material(
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
        ),
      ],
    );
  }
}

// --- WIDGET KONSELING (Diadaptasi dari Wildan) ---
class WildanCounselingSection extends StatelessWidget {
  const WildanCounselingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Konseling",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            // MODIFIKASI: Menambahkan Material & InkWell untuk efek tap premium
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HalamanRiwayat(),
                  ),
                ),
                borderRadius: BorderRadius.circular(
                  8,
                ), // Agar efek klik kotak melengkung
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
        // Card Atas Wildan
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
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HalamanJadwal(),
                  ),
                ),
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
        // Card Jadwal Wildan
        Material(
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
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.blueGrey,
                  ),
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
        ),
      ],
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _bgLightGrey = Color.fromARGB(
    255,
    240,
    244,
    247,
  ); // Sedikit lebih gelap agar terlihat kontras
  static const _iconGrey = Color(0xFF8A97A8);
  static const _activeGreen = Color(0xFFD6F5E3);
  static const _darkGreen = Color(0xFF004D40);
  static const _defaultBlue = Color(0xFF00668F);

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Activity'),
    _NavItem(icon: Icons.send_rounded, label: 'Inbox', isCenterFab: true),
    _NavItem(icon: Icons.psychology_rounded, label: 'Counseling'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Stack(
        // Gunakan Stack paling luar
        clipBehavior: Clip.none, // Biarkan konten meluap ke atas
        alignment: Alignment.center,
        children: [
          // 1. BACKGROUND NAVBAR (Yang melengkung)
          Container(
            height: 85,
            decoration: const BoxDecoration(
              color: _bgLightGrey,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(45),
                topRight: Radius.circular(45),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            // Di sini TIDAK boleh pakai Clip.antiAlias agar FAB tidak terpotong
            child: Row(
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                if (item.isCenterFab) return const Expanded(child: SizedBox());
                final isActive = currentIndex == i;

                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? _activeGreen : Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            item.icon,
                            size: 26,
                            color: isActive ? _darkGreen : _iconGrey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: isActive ? _darkGreen : _iconGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),

          // 2. TOMBOL INBOX (Diletakkan di luar Container background agar tidak terpotong)
          Positioned(
            top: -30, // Melayang keluar dari batas Container bawah
            child: GestureDetector(
              onTap: () => onTap(2),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: currentIndex == 2 ? _activeGreen : _defaultBlue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -0.5,
                    child: Icon(
                      Icons.send_rounded,
                      color: currentIndex == 2 ? _darkGreen : Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // 3. LABEL INBOX
          Positioned(
            bottom: 10,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Text(
                'Inbox',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: currentIndex == 2
                      ? FontWeight.bold
                      : FontWeight.w500,
                  color: currentIndex == 2 ? _darkGreen : _iconGrey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final bool isCenterFab;
  const _NavItem({
    required this.icon,
    required this.label,
    this.isCenterFab = false,
  });
}

// --- SEMUA HALAMAN PENDUKUNG ---
class ActivityScreen extends StatelessWidget {
  const ActivityScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Activity Screen')));
}

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Inbox Screen')));
}

class CounselingScreen extends StatelessWidget {
  const CounselingScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Counseling Screen')));
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Profile Screen')));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Notifikasi")),
    body: const Center(child: Text("Belum ada notifikasi")),
  );
}

class LaporPerundunganPage extends StatelessWidget {
  const LaporPerundunganPage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Form Laporan")),
    body: const Center(child: Text("Isi laporan di sini")),
  );
}

class HalamanJadwal extends StatelessWidget {
  const HalamanJadwal({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Pilih Jadwal")),
    body: const Center(child: Text("Halaman Jadwal")),
  );
}

class HalamanRiwayat extends StatelessWidget {
  const HalamanRiwayat({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Riwayat Konseling")),
    body: const Center(child: Text("Belum ada riwayat")),
  );
}

class DetailSesi extends StatelessWidget {
  const DetailSesi({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Detail Sesi")),
    body: const Center(child: Text("Detail sesi tersedia di sini")),
  );
}

class HalamanLihatSemua extends StatelessWidget {
  const HalamanLihatSemua({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Semua Aktivitas"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(
        child: Text("Daftar seluruh aktivitas laporan Anda ada di sini."),
      ),
    );
  }
}

class HalamanDetailLaporan extends StatelessWidget {
  const HalamanDetailLaporan({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text("Detail Laporan Kantin")));
}

class HalamanDetailLaporanBaru extends StatelessWidget {
  const HalamanDetailLaporanBaru({super.key});
  @override
  Widget build(BuildContext context) =>
      Scaffold(appBar: AppBar(title: const Text("Detail Laporan Baru")));
}
