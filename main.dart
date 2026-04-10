import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_care.dart'; // Pastikan file ini ada

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

// --- FUNGSI LOGOUT (Diletakkan di luar agar bisa dipanggil mana saja) ---
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.door_back_door_outlined,
                  color: Colors.redAccent,
                  size: 32,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                "Keluar dari Akun?",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Apakah Anda yakin ingin keluar? Anda perlu memasukkan kata sandi kembali untuk masuk ke akun Anda.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginCare()),
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9BFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Ya, Keluar",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Batal",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D9BFF),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

// --- HALAMAN PROFILE ---
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Sarah Johnson",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ListTile(
              onTap: () => _showLogoutDialog(context), // Sekarang bisa dipanggil
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: Text(
                "Keluar dari Akun",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: const Icon(Icons.chevron_right, color: Colors.grey),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: BorderSide(color: Colors.grey.withOpacity(0.1)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- WIDGET NAVBAR ---
class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xFF1A6B7A),
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Activity'),
        BottomNavigationBarItem(icon: Icon(Icons.send), label: 'Inbox'),
        BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'Counseling'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}

// Dummy Screens agar tidak error saat di-run
class HomeScreen extends StatelessWidget { const HomeScreen({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Home")); }
class ActivityScreen extends StatelessWidget { const ActivityScreen({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Activity")); }
class InboxScreen extends StatelessWidget { const InboxScreen({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Inbox")); }
class CounselingScreen extends StatelessWidget { const CounselingScreen({super.key}); @override Widget build(BuildContext context) => const Center(child: Text("Counseling")); }
class NotificationsPage extends StatelessWidget { const NotificationsPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar()); }
class LaporPerundunganPage extends StatelessWidget { const LaporPerundunganPage({super.key}); @override Widget build(BuildContext context) => Scaffold(appBar: AppBar()); }
class ActivitySection extends StatelessWidget { const ActivitySection({super.key}); @override Widget build(BuildContext context) => Container(); }
class WildanCounselingSection extends StatelessWidget { const WildanCounselingSection({super.key}); @override Widget build(BuildContext context) => Container(); }
