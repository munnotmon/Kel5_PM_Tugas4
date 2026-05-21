import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class PasswordUpdatedScreen extends StatelessWidget {
  const PasswordUpdatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
        child: Column(
          children: [
            const Spacer(flex: 2),
            _buildSuccessIcon(),
            const SizedBox(height: 36),
            Text(
              'Kata Sandi Diperbarui',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2D3D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              'Akun Anda kini lebih aman. Silakan gunakan kata sandi baru Anda untuk masuk di masa mendatang.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                color: Colors.grey[500],
                height: 1.6,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(flex: 2),
            _buildPrimaryButton(
              label: 'Kembali ke Keamanan',
              onTap: () => context.go('/profile/account-security'),
            ),
            const SizedBox(height: 12),
            _buildSecondaryButton(
              label: 'Kembali ke Beranda',
              onTap: () => context.go('/home'),
            ),
            const SizedBox(height: 32),
            _buildInfoCard(),
            const Spacer(flex: 1),
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
        'Keamanan',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2AAFCF).withOpacity(0.12),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Color(0xFF2AAFCF), Color(0xFF1A6B8A)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(
            Icons.check_rounded,
            color: Colors.white,
            size: 52,
          ),
        ),
      ),
    );
  }

  Widget _buildPrimaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A6B8A).withOpacity(0.30),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton({
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF1A6B8A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFDDF5EC),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFF2A9B6E),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Pembaruan keamanan membantu melindungi data pribadi Anda dari akses yang tidak sah.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13.5,
                color: const Color(0xFF2D5A45),
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}