// Lokasi: lib/input_decoration_helper.dart
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
      suffixIcon: suffixIcon, // Menambahkan parameter suffixIcon
      filled: true,
      fillColor: const Color(0xFFF5F7F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),

      // Teks Error di bawah field
      errorStyle: GoogleFonts.plusJakartaSans(
        color: const Color(0xFFB71C1C), // Merah gelap
        fontSize: 12,
      ),

      // Border kondisi Normal
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),

      // Border saat Error
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Color(0xFFB71C1C), width: 1.5),
      ),

      // Border saat Error dan sedang di-klik
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
