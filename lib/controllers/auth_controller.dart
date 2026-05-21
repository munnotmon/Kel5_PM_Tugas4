// Lokasi: lib/controllers/auth_controller.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';

class AuthController {
  // TextField Controllers - Login
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();

  // TextField Controllers - Register
  final TextEditingController regFullNameController = TextEditingController();
  final TextEditingController regUsernameController = TextEditingController();
  final TextEditingController regEmailController = TextEditingController();
  final TextEditingController regPasswordController = TextEditingController();

  void dispose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    regFullNameController.dispose();
    regUsernameController.dispose();
    regEmailController.dispose();
    regPasswordController.dispose();
  }

  void processLogin(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login Berhasil!',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Future.delayed(const Duration(seconds: 1), () {
        if (!context.mounted) return;
        context.go('/home');
      });
    }
  }

  void processRegister(BuildContext context, GlobalKey<FormState> formKey) {
    if (formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Data valid! Mengirim kode verifikasi.',
            style: GoogleFonts.plusJakartaSans(),
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      
      UserModel newUser = UserModel(
        fullName: regFullNameController.text,
        username: regUsernameController.text,
        email: regEmailController.text,
        password: regPasswordController.text,
      );

      context.go('/verification', extra: newUser.email);
    }
  }

  void processGoogleAccountSelection(BuildContext context, bool isLogin, String email) {
    if (isLogin) {
      context.go('/home');
    } else {
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
      context.push('/verification', extra: email);
    }
  }
}