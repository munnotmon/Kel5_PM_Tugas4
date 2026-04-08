import 'package:flutter/material.dart';
import 'main.dart'; // Pastikan file main.dart berisi class MainScreen
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == "admin@gmail.com" &&
          _passwordController.text == "123456") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login Polinema care Berhasil!',
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
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Email atau Password Salah',
              style: GoogleFonts.plusJakartaSans(),
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
                            style: GoogleFonts.plusJakartaSans(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(
                              hint: 'Masukkan Email',
                              icon: Icons.person_outline,
                            ),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Email wajib diisi'
                                : null,
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
                            obscureText: _isObscure,
                            style: GoogleFonts.plusJakartaSans(),
                            decoration:
                                _inputDecoration(
                                  hint: 'Masukkan Kata Sandi',
                                  icon: Icons.lock_outline,
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isObscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: Colors.black38,
                                    ),
                                    onPressed: () => setState(
                                      () => _isObscure = !_isObscure,
                                    ),
                                  ),
                                ),
                            validator: (value) =>
                                (value == null || value.isEmpty)
                                ? 'Password wajib diisi'
                                : null,
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
                      GestureDetector(
                        onTap: () {},
                        child: Text(
                          "Daftar Akun Baru",
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF1068A3),
                            fontWeight: FontWeight.bold,
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
      hintStyle: GoogleFonts.plusJakartaSans(color: Colors.black38),
      prefixIcon: Icon(icon, color: Colors.black38),
      filled: true,
      fillColor: const Color(0xFFF5F7F9),
      contentPadding: const EdgeInsets.symmetric(vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15.0),
        borderSide: const BorderSide(color: Color(0xFF67B9ED), width: 1.5),
      ),
    );
  }
}
