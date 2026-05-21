import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  bool get _hasMinLength => _newPasswordController.text.length >= 8;
  bool get _hasNumber =>
      RegExp(r'\d').hasMatch(_newPasswordController.text);
  bool get _hasSpecial =>
      RegExp(r'[@#$%^&*!]_').hasMatch(_newPasswordController.text);

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

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 28),
            _buildHeader(),
            const SizedBox(height: 32),
            _buildCurrentPasswordField(),
            const SizedBox(height: 20),
            _buildNewPasswordSection(),
            const SizedBox(height: 36),
            _buildSaveButton(),
            const SizedBox(height: 16),
            _buildCancelButton(context),
            const SizedBox(height: 32),
            _buildHelpCard(),
            const SizedBox(height: 48),
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
        'Ubah Kata Sandi',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F8),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFB8DFF0), width: 1.5),
          ),
          child: const Icon(
            Icons.lock_reset_rounded,
            color: Color(0xFF1A6B8A),
            size: 26,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Keamanan Akun',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Gunakan kata sandi yang kuat untuk menjaga keamanan akun Anda. Kami menyarankan kombinasi huruf, angka, dan simbol.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.6,
          ),
        ),
      ],
    );
  }

  Widget _buildCurrentPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Kata Sandi Saat Ini',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 10),
        _buildTextField(
          controller: _currentPasswordController,
          hint: '••••••••',
          obscure: !_showCurrent,
          onToggle: () => setState(() => _showCurrent = !_showCurrent),
          showToggle: true,
        ),
      ],
    );
  }

  Widget _buildNewPasswordSection() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Kata Sandi Baru',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
              const SizedBox(width: 4),
              const Text('*',
                  style: TextStyle(color: Colors.red, fontSize: 14)),
            ],
          ),
          const SizedBox(height: 10),
          _buildTextField(
            controller: _newPasswordController,
            hint: 'Minimal 8 karakter',
            obscure: !_showNew,
            onToggle: () => setState(() => _showNew = !_showNew),
            showToggle: true,
            onChanged: (_) => setState(() {}),
            filled: false,
          ),
          const SizedBox(height: 14),
          // Strength bar
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
                    color: active ? _strengthColor : const Color(0xFFDDE2E8),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 14),
          // Validation checklist
          _buildCheckItem('Minimal 8 karakter', _hasMinLength),
          const SizedBox(height: 8),
          _buildCheckItem('Mengandung setidaknya satu angka', _hasNumber),
          const SizedBox(height: 8),
          _buildCheckItem(
              r'Mengandung karakter khusus (@, #, $)', _hasSpecial),
          const SizedBox(height: 20),
          const Divider(color: Color(0xFFF0F2F5), thickness: 1),
          const SizedBox(height: 16),
          _buildConfirmInline(),
        ],
      ),
    );
  }

  Widget _buildConfirmInline() {
    final isMatch = _confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text == _newPasswordController.text;
    final isMismatch = _confirmPasswordController.text.isNotEmpty &&
        _confirmPasswordController.text != _newPasswordController.text;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Konfirmasi Kata Sandi Baru',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            const SizedBox(width: 4),
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 14)),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: isMatch
                ? const Color(0xFFDDF5EC)
                : isMismatch
                    ? const Color(0xFFFFECEC)
                    : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isMatch
                  ? const Color(0xFF2A9B6E)
                  : isMismatch
                      ? Colors.red.shade300
                      : Colors.transparent,
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: _confirmPasswordController,
            obscureText: !_showConfirm,
            onChanged: (_) => setState(() {}),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              color: const Color(0xFF1A2D3D),
              letterSpacing: _showConfirm ? 0 : 2,
            ),
            decoration: InputDecoration(
              hintText: 'Ulangi kata sandi baru',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.grey[400],
                letterSpacing: 0,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16),
              suffixIcon: IconButton(
                icon: Icon(
                  _showConfirm
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: Colors.grey[400],
                  size: 22,
                ),
                onPressed: () =>
                    setState(() => _showConfirm = !_showConfirm),
              ),
            ),
          ),
        ),
        if (isMatch) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF2A9B6E), size: 16),
              const SizedBox(width: 6),
              Text(
                'Kata sandi cocok',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2A9B6E),
                ),
              ),
            ],
          ),
        ] else if (isMismatch) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.cancel_rounded, color: Colors.red[400], size: 16),
              const SizedBox(width: 6),
              Text(
                'Kata sandi tidak cocok',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.red[400],
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCheckItem(String label, bool checked) {
    return Row(
      children: [
        checked
            ? const Icon(Icons.check_circle_rounded,
                color: Color(0xFF2A9B6E), size: 20)
            : const Icon(Icons.radio_button_unchecked_rounded,
                color: Color(0xFFB0BAC6), size: 20),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: checked ? FontWeight.w600 : FontWeight.w400,
            color: checked
                ? const Color(0xFF2A9B6E)
                : const Color(0xFF8A97A8),
          ),
        ),
      ],
    );
  }


  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required bool obscure,
    VoidCallback? onToggle,
    bool showToggle = false,
    ValueChanged<String>? onChanged,
    bool filled = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: filled ? const Color(0xFFEEF1F5) : const Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        onChanged: onChanged,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 15,
          color: const Color(0xFF1A2D3D),
          letterSpacing: obscure ? 2 : 0,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[400],
            letterSpacing: 0,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: showToggle
              ? IconButton(
                  icon: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey[400],
                    size: 22,
                  ),
                  onPressed: onToggle,
                )
              : null,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A6B8A).withOpacity(0.35),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ElevatedButton.icon(
          onPressed: () => context.push('/profile/password-updated'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          icon: const Icon(Icons.save_rounded, color: Colors.white, size: 20),
          label: Text(
            'Simpan Kata Sandi',
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

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextButton(
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/profile'),
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            'Batalkan Perubahan',
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

  Widget _buildHelpCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F8F0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.shield_outlined,
            color: Color(0xFF2A9B6E),
            size: 22,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Butuh bantuan?',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Jika Anda merasa akun Anda telah disusupi, segera hubungi tim dukungan kami untuk tindakan pencegahan.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF3D5A50),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}