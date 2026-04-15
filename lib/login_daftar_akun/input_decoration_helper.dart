// Lokasi: lib/login_daftar_akun/input_decoration_helper.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PolinemaCareInputDecoration {
  static InputDecoration get({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: Colors.black38,
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: Colors.black38),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: const Color(0xFFF5F7F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      errorStyle: GoogleFonts.plusJakartaSans(
        color: const Color(0xFFB71C1C),
        fontSize: 12,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 2.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Color(0xFF67B9ED), width: 1.5),
      ),
    );
  }
}
