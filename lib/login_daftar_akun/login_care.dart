import 'package:flutter/material.dart';
import 'main.dart';
import 'register_care.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginCare extends StatefulWidget {
  const LoginCare({super.key});

  @override
  State<LoginCare> createState() => _LoginCareState();
}

class _LoginCareState extends State<LoginCare> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    setState(() {
      _isSubmitted = true; // Set ke true saat tombol ditekan
    });

    // Panggil validate untuk memicu visual error
    if (_formKey.currentState!.validate()) {
      // Jika semua validator return null (Kredensial Benar)
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
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(179, 247, 250, 249),
              Color.fromARGB(255, 245, 249, 255),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // --- HEADER ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: const [
                          Icon(
                            Icons.shield,
                            color: Color(0xFF1068A3),
                            size: 32,
                          ),
                          Icon(Icons.favorite, color: Colors.white, size: 14),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Polinema Care+",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Selamat Datang",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3142),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Masuk untuk kembali ke ruang amanmu.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- FORM CONTAINER ---
                  Container(
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                    ),
                    child: Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _emailController,
                            onChanged: (value) {
                              if (_isSubmitted) {
                                setState(() {
                                  _isSubmitted =
                                      false; // Reset status agar error hilang saat user mengetik kembali
                                });
                              }
                            },
                            style: GoogleFonts.plusJakartaSans(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(
                              hint: 'Masukkan Email',
                              icon: Icons.person_outline,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email wajib diisi';
                              }

                              // Regex untuk validasi format email
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Format email tidak valid (contoh: user@gmail.com)';
                              }

                              if (_isSubmitted && value != "admin@gmail.com") {
                                return 'Email salah. Silakan coba lagi.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Kata Sandi",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF4B5563),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordController,
                            obscureText:
                                _isObscure, // Mengontrol sembunyi/lihat teks
                            onChanged: (value) {
                              if (_isSubmitted) {
                                setState(() => _isSubmitted = false);
                              }
                            },
                            style: GoogleFonts.plusJakartaSans(),
                            decoration:
                                _inputDecoration(
                                  hint: 'Masukkan Kata Sandi',
                                  icon: Icons.lock_outline,
                                ).copyWith(
                                  suffixIcon: Padding(
                                    padding: const EdgeInsets.only(right: 8.0),
                                    child: IconButton(
                                      icon: Icon(
                                        _isObscure
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: Colors.black38,
                                        size: 22,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isObscure =
                                              !_isObscure; // Toggle state
                                        });
                                      },
                                    ),
                                  ),
                                ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password wajib diisi';
                              }
                              if (value.length < 6) {
                                return 'Password minimal harus 6 karakter';
                              }
                              if (_isSubmitted && value != "123456") {
                                return 'kata sandi salah. Silakan coba lagi.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 12),

                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              "Lupa Kata Sandi?",
                              style: GoogleFonts.plusJakartaSans(
                                color: const Color(0xFF1068A3),
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),

                          // --- LOGIN BUTTON ---
                          Container(
                            width: double.infinity,
                            height: 55,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF0F5A8F), Color(0xFF67B9ED)],
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF67B9ED,
                                  ).withOpacity(0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Masuk',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // --- GOOGLE LOGIN ---
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (bounds) =>
                                        const LinearGradient(
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
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Masuk dengan Google',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16,
                                      color: const Color(0xFF2D3142),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- FOOTER LINKS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Belum punya akun? ",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      // Menggunakan InkWell untuk efek interaktif
                      InkWell(
                        borderRadius: BorderRadius.circular(
                          4,
                        ), // Agar efek highlight rapi
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterCare(),
                            ),
                          );
                        },
                        // Warna saat ditekan (opsional)
                        highlightColor: const Color(
                          0xFF1068A3,
                        ).withOpacity(0.1),
                        splashColor: const Color(0xFF1068A3).withOpacity(0.2),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          child: Text(
                            "Daftar Akun Baru",
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF1068A3),
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: const Color(0xFF1068A3),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PRIVACY POLICY",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Text(
                        "TERMS OF SERVICE",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF9CA3AF),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: Colors.black38,
        fontSize: 14,
      ),
      prefixIcon: Icon(icon, color: Colors.black38),
      filled: true,
      fillColor: const Color(0xFFF5F7F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),

      // Teks Error di bawah field
      errorStyle: GoogleFonts.plusJakartaSans(
        color: const Color(0xFFB71C1C), // Merah gelap sesuai gambar
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
