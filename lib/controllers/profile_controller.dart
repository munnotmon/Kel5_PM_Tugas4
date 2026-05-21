// Lokasi: lib/controllers/profile_controller.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileController {
  // =====================================================================
  // CONTROLLERS & DATA - UBAH KATA SANDI
  // =====================================================================
  final TextEditingController currentPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  void disposeChangePassword() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
  }

  // Logika kekuatan password dipindahkan ke sini
  bool hasMinLength(String password) => password.length >= 8;
  bool hasNumber(String password) => RegExp(r'\d').hasMatch(password);
  bool hasSpecial(String password) => RegExp(r'[@#$%^&*!_]').hasMatch(password);

  int getStrengthScore(String password) {
    return (hasMinLength(password) ? 1 : 0) +
           (hasNumber(password) ? 1 : 0) +
           (hasSpecial(password) ? 1 : 0);
  }

  String getStrengthLabel(String password) {
    switch (getStrengthScore(password)) {
      case 0:
      case 1:
        return 'Lemah';
      case 2:
        return 'Sedang';
      default:
        return 'Kuat';
    }
  }

  Color getStrengthColor(String password) {
    switch (getStrengthScore(password)) {
      case 0:
      case 1:
        return const Color(0xFFE53935);
      case 2:
        return const Color(0xFF2A7B8A);
      default:
        return const Color(0xFF2A9B6E);
    }
  }

  void saveNewPassword(BuildContext context) {
    // Di sini biasanya ada validasi dengan database/API
    // Untuk saat ini, asumsikan sukses dan navigasi ke halaman password updated
    if (newPasswordController.text == confirmPasswordController.text && newPasswordController.text.isNotEmpty) {
        context.push('/profile/password-updated');
    } else {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pastikan kata sandi baru memenuhi syarat dan cocok!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // =====================================================================
  // CONTROLLERS - PUSAT BANTUAN (Pencarian)
  // =====================================================================
  final TextEditingController searchHelpController = TextEditingController();

  void disposeHelpCenter() {
      searchHelpController.dispose();
  }

  // =====================================================================
  // FUNGSI UMUM PROFILE
  // =====================================================================
  void processLogout(BuildContext context) {
    // Logika untuk membersihkan sesi (contoh: hapus token)
    context.go('/login');
  }
}