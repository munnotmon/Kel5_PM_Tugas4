import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class AccountSecurityScreen extends StatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  State<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends State<AccountSecurityScreen> {
  bool _twoFactor = true;
  bool _biometric = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildStatusBanner(),
            const SizedBox(height: 20),
            _buildPasswordTile(),
            const SizedBox(height: 12),
            _buildTwoFactorTile(),
            const SizedBox(height: 24),
            _buildSectionLabel('KEAMANAN EKSTRA'),
            const SizedBox(height: 12),
            _buildBiometricTile(),
            const SizedBox(height: 24),
            _buildDevicesHeader(),
            const SizedBox(height: 12),
            _buildDeviceCard(
              icon: Icons.phone_iphone_rounded,
              name: 'iPhone 13 (Perangkat ini)',
              location: 'Jakarta, Indonesia',
              status: 'Aktif',
              isCurrentDevice: true,
            ),
            const SizedBox(height: 10),
            _buildDeviceCard(
              icon: Icons.computer_rounded,
              name: 'Windows PC – Chrome',
              location: 'Surabaya, Indonesia',
              status: '2 jam yang lalu',
              isCurrentDevice: false,
            ),
            const SizedBox(height: 24),
            _buildPrivacyNote(),
            const SizedBox(height: 48),
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
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
        onPressed: () =>
            context.canPop() ? context.pop() : context.go('/profile'),
      ),
      title: Text(
        'Keamanan Akun',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Icon(
            Icons.verified_user_rounded,
            color: const Color(0xFF1A6B8A),
            size: 26,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF7BC8E8), Color(0xFF5AB4D9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STATUS KEAMANAN',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Colors.white.withOpacity(0.80),
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Akun Anda Terlindungi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 10),
          Divider(color: Colors.white.withOpacity(0.30), thickness: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 14,
                color: Colors.white.withOpacity(0.80),
              ),
              const SizedBox(width: 6),
              Text(
                'Terakhir diperbarui hari ini pukul 09:41 pagi.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => context.push('/profile/change-password'),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF0F3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.lock_reset_rounded,
                  color: Color(0xFF8A97A8),
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ubah Kata Sandi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Ganti sandi secara berkala',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 14,
                color: Color(0xFFB0BAC6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTwoFactorTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFDDF5EC),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.key_rounded,
                color: Color(0xFF2A9B6E),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Autentikasi Dua Faktor',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Amankan login dengan kode SMS/Email',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: _twoFactor,
                onChanged: (v) => setState(() => _twoFactor = v),
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF1A6B8A),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCDD5DE),
                trackOutlineColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.grey[500],
        letterSpacing: 1.0,
      ),
    );
  }

  Widget _buildBiometricTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFEEF0F3),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(
                Icons.face_rounded,
                color: Color(0xFF8A97A8),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Face ID / Fingerprint',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    'Akses cepat menggunakan biometrik',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 0.9,
              child: Switch(
                value: _biometric,
                onChanged: (v) => setState(() => _biometric = v),
                activeColor: Colors.white,
                activeTrackColor: const Color(0xFF1A6B8A),
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: const Color(0xFFCDD5DE),
                trackOutlineColor: const WidgetStatePropertyAll(
                  Colors.transparent,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDevicesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'PERANGKAT TERHUBUNG',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.grey[500],
            letterSpacing: 1.0,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'Keluar Semua',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A6B8A),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeviceCard({
    required IconData icon,
    required String name,
    required String location,
    required String status,
    required bool isCurrentDevice,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 28, color: const Color(0xFF8A97A8)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (isCurrentDevice) ...[
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF4CAF82),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                      ],
                      Text(
                        '$location • $status',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (isCurrentDevice)
              const Icon(
                Icons.more_vert_rounded,
                color: Color(0xFFB0BAC6),
                size: 20,
              )
            else
              _buildLogoutChip(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutChip() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFFECEC),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'LOG OUT',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.red[400],
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacyNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFF2A9B6E),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privasi Prioritas Kami',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Semua data enkripsi kami dikelola secara aman untuk memastikan percakapan konseling Anda tetap rahasia.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF3D5A50),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
