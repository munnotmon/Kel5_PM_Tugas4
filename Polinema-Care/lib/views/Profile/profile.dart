import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'profile_store.dart';
import '../../controllers/auth_controller.dart';
import '../../services/api_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    ProfileStore.nama.addListener(_onProfileChanged);
    ProfileStore.username.addListener(_onProfileChanged);
    ProfileStore.photo.addListener(_onProfileChanged);
    ProfileStore.email.addListener(_onProfileChanged);
    ProfileStore.nomorTelepon.addListener(_onProfileChanged);
    ProfileStore.angkatan.addListener(_onProfileChanged);
    ProfileStore.photoUrl.addListener(_onProfileChanged);
  }

  void _onProfileChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    ProfileStore.nama.removeListener(_onProfileChanged);
    ProfileStore.username.removeListener(_onProfileChanged);
    ProfileStore.photo.removeListener(_onProfileChanged);
    ProfileStore.email.removeListener(_onProfileChanged);
    ProfileStore.nomorTelepon.removeListener(_onProfileChanged);
    ProfileStore.angkatan.removeListener(_onProfileChanged);
    ProfileStore.photoUrl.removeListener(_onProfileChanged);
    super.dispose();
  }

  String _mapImageUrl(String url) {
    return ApiService.buildImageUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            _buildProfileCard(context),
            const SizedBox(height: 16),
            _buildInfoCard(),
            const SizedBox(height: 24),

            _buildSectionLabel('PENGATURAN APLIKASI'),
            const SizedBox(height: 10),

            _buildMenuGroup([
              _MenuItem(
                icon: Icons.notifications_outlined,
                iconColor: const Color(0xFF1A6B8A),
                iconBg: const Color(0xFFE0F2F8),
                label: 'Pengaturan Notifikasi',
                onTap: () =>
                    context.push('/profile/notification-settings'),
              ),
              _MenuItem(
                icon: Icons.shield_outlined,
                iconColor: const Color(0xFF1A6B8A),
                iconBg: const Color(0xFFE0F2F8),
                label: 'Keamanan Akun',
                onTap: () =>
                    context.push('/profile/account-security'),
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
                onTap: () =>
                    context.push('/profile/pusat-bantuan'),
              ),
              _MenuItem(
                icon: Icons.description_outlined,
                iconColor: const Color(0xFF6B7280),
                iconBg: const Color(0xFFF0F2F5),
                label: 'Syarat & Ketentuan',
                onTap: () =>
                    context.push('/profile/syarat-ketentuan'),
              ),
              _MenuItem(
                icon: Icons.info_outline_rounded,
                iconColor: const Color(0xFF6B7280),
                iconBg: const Color(0xFFF0F2F5),
                label: 'Tentang Respon & Konseling',
                onTap: () =>
                    context.push('/profile/tentang-aplikasi'),
                showDivider: false,
              ),
            ]),

            const SizedBox(height: 24),

            _buildLogoutButton(context),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFF2F4F7),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Color(0xFF1A6B8A),
        ),
        onPressed: () =>
            context.canPop() ? context.pop() : context.go('/home'),
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

  Widget _buildProfileCard(BuildContext context) {
    final Uint8List? photo = ProfileStore.photo.value;
    final String photoUrl = ProfileStore.photoUrl.value;
    final String nama = ProfileStore.nama.value;
    final String username = ProfileStore.username.value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1A6B8A),
            Color(0xFF2AAFCF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4,
                  ),
                  color: const Color(0xFFE8D5C4),
                ),
                child: ClipOval(
                  child: photo != null
                      ? Image.memory(
                          photo,
                          width: 110,
                          height: 110,
                          fit: BoxFit.cover,
                        )
                      : (photoUrl.isNotEmpty
                          ? Image.network(
                              _mapImageUrl(photoUrl),
                              width: 110,
                              height: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFE8D5C4),
                                child: const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white54,
                                ),
                              ),
                            )
                          : Container(
                              color: const Color(0xFFE8D5C4),
                              child: const Icon(
                                Icons.person,
                                size: 70,
                                color: Colors.white54,
                              ),
                            )),
                ),
              ),

              // ICON EDIT
              Positioned(
                bottom: -2,
                right: -2,
                child: GestureDetector(
                  onTap: () =>
                      context.push('/profile/edit-profile'),
                  child: Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6BC59A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.edit,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Text(
            nama,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            username,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              color: Colors.white.withOpacity(0.85),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    final String nama = ProfileStore.nama.value;
    final String nim = ProfileStore.username.value;
    final String email = ProfileStore.email.value;
    final String nomorTelepon = ProfileStore.nomorTelepon.value.isNotEmpty
        ? ProfileStore.nomorTelepon.value
        : '-';

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
          _buildInfoRow('NAMA LENGKAP', nama),
          _buildDivider(),
          _buildInfoRow('NIM', nim),
          _buildDivider(),
          _buildInfoRow('EMAIL', email),
          _buildDivider(),
          _buildInfoRow('NOMOR TELEPON', nomorTelepon),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 14),
      child: Divider(
        height: 1,
        color: Color(0xFFF0F2F5),
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
                        child: Icon(
                          item.icon,
                          color: item.iconColor,
                          size: 20,
                        ),
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
                  child: Divider(
                    height: 1,
                    color: Color(0xFFF0F2F5),
                  ),
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
              const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 20,
              ),

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
          padding: const EdgeInsets.fromLTRB(
            28,
            36,
            28,
            28,
          ),
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
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await AuthController.logout();
                    if (context.mounted) {
                      context.go('/login');
                    }
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