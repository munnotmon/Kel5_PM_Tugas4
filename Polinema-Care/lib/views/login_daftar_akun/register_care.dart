import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'input_decoration_helper.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/auth_controller.dart';

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
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedProdi;
  final List<String> _prodiList = [
    'Teknologi Informasi',
    'Teknik Kimia',
    'Teknik Elektro',
    'Teknik Mesin',
    'Teknik Sipil',
    'Administrasi Niaga',
    'Akuntansi',
  ];

  bool _isObscure = true;
  bool _isSubmitted =
      false; // Status untuk memicu error spesifik setelah tombol ditekan

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoading = false;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasNumber => RegExp(r'\d').hasMatch(_passwordController.text);
  bool get _hasSpecial => RegExp(r'[@#$%^&*!_]').hasMatch(_passwordController.text);

  int get _strengthScore =>
      (_hasMinLength ? 1 : 0) + (_hasNumber ? 1 : 0) + (_hasSpecial ? 1 : 0);

  String get _strengthLabel {
    switch (_strengthScore) {
      case 0:
      case 1:
        return 'Lemah';
      case 2:
        return 'Sedang';
      default:
        return 'Kuat';
    }
  }

  Color get _strengthColor {
    switch (_strengthScore) {
      case 0:
      case 1:
        return const Color(0xFFE53935);
      case 2:
        return const Color(0xFF2A7B8A);
      default:
        return const Color(0xFF2A9B6E);
    }
  }

  void _register() async {
    setState(() {
      _isSubmitted = true;
    });

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final result = await AuthController.register(
        nama: _fullNameController.text.trim(),
        nim: _usernameController.text.trim(),
        email: _emailController.text.trim(),
        nomorTelepon: _phoneController.text.trim(),
        password: _passwordController.text,
        programStudi: _selectedProdi,
      );

      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Registrasi Berhasil!',
              style: GoogleFonts.plusJakartaSans(),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );
        context.go('/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              result['message'] ?? 'Registrasi gagal. NIM atau Email sudah digunakan.',
              style: GoogleFonts.plusJakartaSans(),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
                              if (value == null || value.isEmpty) {
                                return 'Nama lengkap wajib diisi';
                              }
                              if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
                                return 'Nama hanya boleh berisi huruf';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 2. NIM Field
                          _buildFieldLabel("NIM (Nomor Induk Mahasiswa)"),
                          TextFormField(
                            controller: _usernameController,
                            onChanged: (value) => _resetSubmittedState(),
                            style: GoogleFonts.plusJakartaSans(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: PolinemaCareInputDecoration.get(
                              hint: 'Masukkan NIM Anda',
                              icon: Icons.badge_outlined, // Ikon ID card
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'NIM wajib diisi';
                              }
                              if (value.length < 8) {
                                return 'NIM minimal 8 karakter';
                              }
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
                              if (value == null || value.isEmpty) {
                                return 'Email wajib diisi';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Format email tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 4. Nomor Telepon Field
                          _buildFieldLabel("Nomor Telepon"),
                          TextFormField(
                            controller: _phoneController,
                            onChanged: (value) => _resetSubmittedState(),
                            style: GoogleFonts.plusJakartaSans(),
                            keyboardType: TextInputType.phone,
                            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9+]'))],
                            decoration: PolinemaCareInputDecoration.get(
                              hint: 'Contoh: 08123456789',
                              icon: Icons.phone_outlined,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nomor telepon wajib diisi';
                              }
                              if (!RegExp(r'^(\+62|08)[0-9]{8,12}$').hasMatch(value)) {
                                return 'Format nomor tidak valid (contoh: 08123456789)';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // 5. Program Studi Field
                          _buildFieldLabel("Program Studi"),
                          DropdownButtonFormField<String>(
                            value: _selectedProdi,
                            isExpanded: true,
                            menuMaxHeight: 280,
                            borderRadius: BorderRadius.circular(16),
                            decoration: PolinemaCareInputDecoration.get(
                              hint: 'Pilih program studi',
                              icon: Icons.school_outlined,
                            ),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14,
                              color: const Color(0xFF2D3142),
                            ),
                            items: _prodiList
                                .map((prodi) => DropdownMenuItem(
                                      value: prodi,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 4),
                                        child: Text(prodi),
                                      ),
                                    ))
                                .toList(),
                            onChanged: (val) =>
                                setState(() => _selectedProdi = val),
                            validator: (_) => _selectedProdi == null
                                ? 'Program studi wajib dipilih'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // 6. Kata Sandi Field
                          _buildFieldLabel("Kata Sandi"),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: _passwordController,
                                  obscureText: _isObscure,
                                  onChanged: (value) {
                                    _resetSubmittedState();
                                    setState(() {});
                                  },
                                  style: GoogleFonts.plusJakartaSans(),
                                  decoration: PolinemaCareInputDecoration.get(
                                    hint: 'Buat kata sandi yang kuat',
                                    icon: Icons.lock_outline,
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
                                    if (value == null || value.isEmpty) {
                                      return 'Kata sandi wajib diisi';
                                    }
                                    if (value.length < 8) {
                                      return 'Kata sandi minimal 8 karakter';
                                    }
                                    if (!RegExp(r'\d').hasMatch(value)) {
                                      return 'Kata sandi harus mengandung setidaknya satu angka';
                                    }
                                    if (!RegExp(r'[@#$%^&*!_]').hasMatch(value)) {
                                      return r'Kata sandi harus mengandung karakter khusus (@, #, $, _)';
                                    }
                                    return null;
                                  },
                                ),
                                if (_passwordController.text.isNotEmpty) ...[
                                  const SizedBox(height: 14),
                                  Row(
                                    children: [
                                      Text(
                                        'Kekuatan: ',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF1A2D3D),
                                        ),
                                      ),
                                      Text(
                                        _strengthLabel,
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.bold,
                                          color: _strengthColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: List.generate(3, (i) {
                                      final active = i < _strengthScore;
                                      return Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                                          height: 5,
                                          decoration: BoxDecoration(
                                            color: active
                                                ? _strengthColor
                                                : const Color(0xFFDDE2E8),
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                        ),
                                      );
                                    }),
                                  ),
                                  const SizedBox(height: 12),
                                  _buildCheckItem('Minimal 8 karakter', _hasMinLength),
                                  const SizedBox(height: 6),
                                  _buildCheckItem('Mengandung setidaknya satu angka', _hasNumber),
                                  const SizedBox(height: 6),
                                  _buildCheckItem(r'Mengandung karakter khusus (@, #, $, _)', _hasSpecial),
                                ],
                              ],
                            ),

                          const SizedBox(height: 16),
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
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                    )
                                  : Text(
                                      'Daftar Sekarang',
                                      style: GoogleFonts.plusJakartaSans(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
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

  Widget _buildCheckItem(String label, bool checked) {
    return Row(
      children: [
        checked
            ? const Icon(Icons.check_circle_rounded, color: Color(0xFF2A9B6E), size: 18)
            : const Icon(Icons.radio_button_unchecked_rounded, color: Color(0xFFB0BAC6), size: 18),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: checked ? FontWeight.w600 : FontWeight.w400,
            color: checked ? const Color(0xFF2A9B6E) : const Color(0xFF8A97A8),
          ),
        ),
      ],
    );
  }

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
