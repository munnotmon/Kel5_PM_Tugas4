// Lokasi: lib/login_daftar_akun/google_account.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class GoogleAccountSelection extends StatelessWidget {
  // Tambahkan variabel ini untuk mengecek apakah user sedang login atau register
  final bool isLogin;

  // Jadikan parameter isLogin wajib diisi saat halaman ini dipanggil
  const GoogleAccountSelection({super.key, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              // --- HEADER APP NAME ---
              Text(
                "Polinema Care+",
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF1068A3),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 40),

              // --- GOOGLE LOGO ---
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    Color(0xFF4285F4),
                    Color(0xFFDB4437),
                    Color(0xFFF4B400),
                    Color(0xFF0F9D58),
                  ],
                ).createShader(bounds),
                child: Text(
                  'G',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // --- TITLE & SUBTITLE ---
              Text(
                "Pilih akun",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3142),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Lanjutkan ke Polinema Care+",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 40),

              // --- ACCOUNT LIST ---
              _buildAccountCard(
                context: context,
                name: "Aris Setiawan",
                email: "aris.setiawan@gmail.com",
                avatarColor: const Color(0xFF8D6E63),
                avatarIcon: Icons.person,
              ),
              const SizedBox(height: 12),
              _buildAccountCard(
                context: context,
                name: "Siska Permata",
                email: "siska.permata@gmail.com",
                avatarColor: const Color(0xFF26A69A),
                avatarIcon: Icons.person_3,
              ),
              const SizedBox(height: 12),
              _buildAddAccountCard(),

              const Spacer(),

              // --- DISCLAIMER TEXT ---
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                    height: 1.5,
                  ),
                  children: [
                    const TextSpan(
                      text:
                          "Untuk melanjutkan, Google akan membagikan nama, alamat email, preferensi bahasa, dan foto profil Anda dengan ",
                    ),
                    TextSpan(
                      text: "Polinema Care+",
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF1068A3),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // --- FOOTER LINKS ---
              Text(
                "KEBIJAKAN PRIVASI • PERSYARATAN LAYANAN",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B7280),
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 30),

              // --- BUTTON BATAL ---
              InkWell(
                onTap: () {
                  // Perbaikan navigasi Batal yang tadi error merah
                  if (context.canPop()) {
                    context.pop();
                  } else {
                    context.go(isLogin ? '/login' : '/register');
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1068A3),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountCard({
    required BuildContext context,
    required String name,
    required String email,
    required Color avatarColor,
    required IconData avatarIcon,
  }) {
    return InkWell(
      onTap: () {
        if (!context.mounted) return; // Pengecekan aman

        // LOGIKA PENGECEKAN:
        if (isLogin) {
          // JIKA LOGIN: Langsung masuk ke Home tanpa verifikasi
          context.go('/home');
        } else {
          // JIKA REGISTER: Harus verifikasi dulu
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Mengirim kode verifikasi ke $email...',
                style: GoogleFonts.plusJakartaSans(),
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          );
          // Gunakan push agar tombol panah kembali bisa dipakai
          context.push('/verification', extra: email);
        }
      },
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: avatarColor,
              child: Icon(avatarIcon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                  Text(
                    email,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
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

  Widget _buildAddAccountCard() {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(40),
      child: Container(
        // ... (Kode UI Tambah Akun tetap sama persis) ...
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(40),
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFE5E7EB),
              child: Icon(
                Icons.person_add_alt_1_outlined,
                color: Color(0xFF4B5563),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Text(
              "Gunakan akun lain",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF2D3142),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
