// Lokasi: lib/register_care.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'input_decoration_helper.dart';
import 'package:go_router/go_router.dart';

class RegisterCare extends StatefulWidget {
  const RegisterCare({super.key});

  @override
  State<RegisterCare> createState() => _RegisterCareState();
}

class _RegisterCareState extends State<RegisterCare> {
  final _formKey = GlobalKey<FormState>();

  // Controller untuk setiap field sesuai image_1.png
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isSubmitted =
      false; // Status untuk memicu error spesifik setelah tombol ditekan

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    setState(() {
      _isSubmitted = true;
    });

    if (_formKey.currentState!.validate()) {
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
      context.go('/verification', extra: _emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan background gradient yang sama
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
                  const SizedBox(height: 10), // Sedikit penyesuaian jarak atas
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
                            size: 28, // Ukuran ikon sedikit diperkecil
                          ),
                          Icon(Icons.favorite, color: Colors.white, size: 12),
                        ],
                      ),
                      const SizedBox(width: 10),
                      Text(
                        "Polinema Care+",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 20, // Ukuran font sedikit diperkecil
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF2D3142),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Menyesuaikan teks "Daftar Akun Baru" dengan gradient warna sesuai image_1.png
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 30, // Sedikit lebih kecil agar rapi
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3142),
                      ),
                      children: const [
                        TextSpan(text: "Daftar "),
                        TextSpan(
                          text: "Akun Baru",
                          style: TextStyle(
                            color: Color(0xFF1068A3), // Warna utama
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Mari bergabung dalam komunitas kampus yang aman dan saling mendukung. Langkah awal menuju kenyamanan bersama.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 30),

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
                      autovalidateMode: AutovalidateMode
                          .onUserInteraction, // Error hilang saat user mulai mengetik
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 1. Nama Lengkap Field
                          _buildFieldLabel("Nama Lengkap"),
                          TextFormField(
                            controller: _fullNameController,
                            onChanged: (value) => _resetSubmittedState(),
                            style: GoogleFonts.plusJakartaSans(),
                            decoration: PolinemaCareInputDecoration.get(
                              hint: 'Masukkan nama lengkap Anda',
                              icon: Icons.person_outline,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Nama lengkap wajib diisi';
                              if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value))
                                return 'Nama hanya boleh berisi huruf';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 2. Username Field
                          _buildFieldLabel("Username"),
                          TextFormField(
                            controller: _usernameController,
                            onChanged: (value) => _resetSubmittedState(),
                            style: GoogleFonts.plusJakartaSans(),
                            decoration: PolinemaCareInputDecoration.get(
                              hint: 'Masukkan username',
                              icon: Icons.badge_outlined, // Ikon ID card
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Username wajib diisi';
                              if (value.length < 8)
                                return 'Username minimal 8 karakter';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 3. Email Field
                          _buildFieldLabel("Email"),
                          TextFormField(
                            controller: _emailController,
                            onChanged: (value) => _resetSubmittedState(),
                            style: GoogleFonts.plusJakartaSans(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: PolinemaCareInputDecoration.get(
                              hint: 'Masukkan Email',
                              icon: Icons.mail_outline,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Email wajib diisi';
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value))
                                return 'Format email tidak valid';
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 4. Kata Sandi Field
                          _buildFieldLabel("Kata Sandi"),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _isObscure,
                            onChanged: (value) => _resetSubmittedState(),
                            style: GoogleFonts.plusJakartaSans(),
                            decoration: PolinemaCareInputDecoration.get(
                              hint: 'Buat kata sandi yang kuat',
                              icon: Icons.lock_outline,
                              // See/Unsee logic
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.black38,
                                ),
                                onPressed: () =>
                                    setState(() => _isObscure = !_isObscure),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                return 'Password wajib diisi';
                              if (value.length < 6)
                                return 'Password minimal harus 6 karakter';
                              return null;
                            },
                          ),

                          const SizedBox(
                            height: 24,
                          ), // Tambahan jarak sebelum tombol
                          // --- REGISTER BUTTON (Daftar Sekarang) ---
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
                              onPressed: _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Text(
                                'Daftar Sekarang',
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // --- SEPARATOR ---
                          _buildSeparator(),
                          const SizedBox(height: 20),

                          // --- GOOGLE REGISTER (Daftar dengan Google) ---
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              onPressed: () {
                                context.push('/google_account');
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Google Icon (G warna-warni)
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
                                    'Daftar dengan Google',
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
                  const SizedBox(height: 24),

                  // --- FOOTER LINKS ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sudah punya akun? ",
                        style: GoogleFonts.plusJakartaSans(
                          color: const Color(0xFF6B7280),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          context.go('/login'); // Kembali ke halaman Login
                        },
                        child: Text(
                          "Masuk di sini",
                          style: GoogleFonts.plusJakartaSans(
                            color: const Color(0xFF1068A3),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xFF1068A3),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  _buildFooterLinks(),
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

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13, // Sedikit lebih kecil agar presisi
          fontWeight: FontWeight.w600,
          color: const Color(0xFF4B5563),
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    return Row(
      children: [
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            "ATAU",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF9CA3AF),
            ),
          ),
        ),
        const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
      ],
    );
  }

  Widget _buildFooterLinks() {
    return Row(
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
    );
  }

  // Fungsi untuk reset status submit agar error hilang saat mengetik kembali
  void _resetSubmittedState() {
    if (_isSubmitted) {
      setState(() {
        _isSubmitted = false;
      });
    }
  }
}
