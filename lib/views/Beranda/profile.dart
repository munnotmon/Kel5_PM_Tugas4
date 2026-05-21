import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/profile_controller.dart';
import '../../models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Inisialisasi Controller
  late final ProfileController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ProfileController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      // Gunakan ListenableBuilder untuk mendengarkan perubahan dari Controller
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, child) {
          if (_controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF1A6B8A)),
            );
          }

          final user = _controller.userData;
          if (user == null) {
            return const Center(child: Text('Gagal memuat data profil.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                _buildProfileCard(user),
                const SizedBox(height: 16),
                _buildInfoCard(user),
                const SizedBox(height: 24),
                _buildSectionLabel('PENGATURAN APLIKASI'),
                const SizedBox(height: 10),
                _buildMenuGroup([
                  _MenuItem(
                    icon: Icons.notifications_outlined,
                    iconColor: const Color(0xFF1A6B8A),
                    iconBg: const Color(0xFFE0F2F8),
                    label: 'Pengaturan Notifikasi',
                    onTap: () => context.push('/profile/notification-settings'),
                  ),
                  _MenuItem(
                    icon: Icons.shield_outlined,
                    iconColor: const Color(0xFF1A6B8A),
                    iconBg: const Color(0xFFE0F2F8),
                    label: 'Keamanan Akun',
                    onTap: () => context.push('/profile/account-security'),
                    showDivider: false,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildSectionLabel('DUKUNGAN'),
                const SizedBox(height: 10),
                _buildMenuGroup([
                  _MenuItem(
                    icon: Icons.help_outline_rounded,
                    iconColor: const Color(0xFF6B7280),
                    iconBg: const Color(0xFFF0F2F5),
                    label: 'Pusat Bantuan',
                    onTap: () => context.push('/profile/pusat-bantuan'),
                  ),
                  _MenuItem(
                    icon: Icons.description_outlined,
                    iconColor: const Color(0xFF6B7280),
                    iconBg: const Color(0xFFF0F2F5),
                    label: 'Syarat & Ketentuan',
                    onTap: () => context.push('/profile/syarat-ketentuan'),
                  ),
                  _MenuItem(
                    icon: Icons.info_outline_rounded,
                    iconColor: const Color(0xFF6B7280),
                    iconBg: const Color(0xFFF0F2F5),
                    label: 'Tentang Respon & Konseling',
                    onTap: () => context.push('/profile/tentang-aplikasi'),
                    showDivider: false,
                  ),
                ]),
                const SizedBox(height: 24),
                _buildLogoutButton(context),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF2F4F7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
        onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
      ),
      title: Text(
        'Profil Saya',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A2D3D),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  // Lempar parameter UserModel ke dalam fungsi pembuat UI
  Widget _buildProfileCard(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          // ... (bagian Stack foto tetap sama) ...
          const SizedBox(height: 14),
          Text(
            user.fullName ?? 'Nama Tidak Ada', // Menggunakan fullName
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '@${user.username ?? 'username'}', // Menggunakan username
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(UserModel user) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow('EMAIL', user.email),
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
          const SizedBox(height: 18),
          _buildInfoRow('USERNAME', user.username ?? 'Belum diatur'),
          const SizedBox(height: 18),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
          const SizedBox(height: 18),
          // Menampilkan nama lengkap sebagai informasi tambahan
          _buildInfoRow('NAMA LENGKAP', user.fullName ?? 'Belum diatur'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[400],
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A2D3D),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey[400],
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildMenuGroup(List<_MenuItem> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          return Column(
            children: [
              InkWell(
                onTap: item.onTap,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: item.iconBg,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(item.icon, color: item.iconColor, size: 20),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          item.label,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1A2D3D),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Color(0xFFB0BAC6),
                      ),
                    ],
                  ),
                ),
              ),
              if (item.showDivider)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Color(0xFFF0F2F5)),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: () => _showLogoutDialog(context),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'Keluar',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.4),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(28, 36, 28, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFFFDE8E8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.door_front_door_outlined,
                  color: Color(0xFFB94040),
                  size: 36,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Keluar dari Akun?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Apakah Anda yakin ingin keluar? Anda perlu memasukkan kata sandi kembali untuk masuk ke akun Anda.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: const Color(0xFF7A8FA0),
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    // Panggil fungsi handleLogout dari controller
                    _controller.handleLogout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1A6B8A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Ya, Keluar',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(
                  'Batal',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A6B8A),
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

class _MenuItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  const _MenuItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });
}
