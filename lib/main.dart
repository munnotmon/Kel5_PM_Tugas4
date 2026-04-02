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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A6B7A)),
        useMaterial3: true,
        textTheme: GoogleFonts.plusJakartaSansTextTheme(),
      ),
      home: const MainScreen(),
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

  // Daftar halaman untuk navigasi
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
      backgroundColor: Colors.white,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// --- HALAMAN HOME (Gabungan UI Header kamu) ---
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                icon: const Icon(Icons.campaign, color: Colors.white, size: 32),
                label: Text(
                  'Laporkan Perundungan',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 19, // Ukuran disesuaikan agar pas
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
    );
  }
}

// --- CUSTOM NAVIGATION BAR ---
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const _teal = Color(0xFF1A6B7A);
  static const _lightMint = Color(0xFFD6F5E3);
  static const _bgGrey = Color(0xFFDDE2E8);
  static const _iconGrey = Color(0xFF8A97A8);

  static const List<_NavItem> _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Activity'),
    _NavItem(icon: Icons.send_rounded, label: 'Inbox', isCenterFab: true),
    _NavItem(icon: Icons.psychology_rounded, label: 'Counseling'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 16),
        height: 72,
        decoration: BoxDecoration(
          color: _bgGrey,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Row(
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
                          curve: Curves.easeOut,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isActive ? _lightMint : Colors.transparent,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            item.icon,
                            size: 24,
                            color: isActive ? _teal : _iconGrey,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: isActive
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: isActive ? _teal : _iconGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Positioned(
              top: -22,
              child: GestureDetector(
                onTap: () => onTap(2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: currentIndex == 2 ? const Color(0xFF0D4F5C) : _teal,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _teal.withOpacity(0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 6,
              child: IgnorePointer(
                child: Text(
                  'Inbox',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: currentIndex == 2
                        ? FontWeight.w700
                        : FontWeight.w400,
                    color: currentIndex == 2 ? _teal : _iconGrey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- KOMPONEN PENDUKUNG ---

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

class LaporPerundunganPage extends StatelessWidget {
  const LaporPerundunganPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laporkan Perundungan')),
      body: const Center(child: Text('Form Pelaporan')),
    );
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi'), centerTitle: true),
      body: const Center(child: Text('Belum ada notifikasi baru.')),
    );
  }
}
