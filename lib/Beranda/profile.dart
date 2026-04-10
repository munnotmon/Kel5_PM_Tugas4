import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login_daftar_akun/login_care.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Fungsi untuk menampilkan pop-up konfirmasi logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "Konfirmasi Keluar",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          content: Text(
            "Apakah kamu yakin ingin keluar dari sesi ini?",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog jika batal
              },
              child: Text(
                "Batal",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Tutup dialog dan arahkan kembali ke halaman Login.
                // Menggunakan pushAndRemoveUntil agar semua riwayat halaman dihapus (tidak bisa di-back)
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginCare()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                "Keluar",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

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
              "My Kisah",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ListTile(
              onTap: () => _showLogoutDialog(context),
              leading: const Icon(
                Icons.logout_rounded,
                color: Colors.redAccent,
              ),
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
