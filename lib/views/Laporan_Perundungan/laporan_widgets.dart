// lib/views/laporan/widgets/laporan_widgets.dart
//
// Shared widgets yang dipakai oleh semua LaporanStepPage.
// Isi file ini:
//   - AppColors         → konstanta warna
//   - LaporanAppBar     → AppBar seragam
//   - LaporanStepIndicator → progress bar 4 langkah
//   - LaporanNextButton → tombol "Selanjutnya" bergradien
//   - LaporanCard       → wrapper card putih berbordir shadow
//   - LaporanInputDecoration → InputDecoration seragam
//   - LaporanSecurityBanner  → card "Aman & Terlindung"

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────
// KONSTANTA WARNA
// ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  static const primary = Color(0xFF1A6B8A);
  static const primaryLight = Color(0xFF2AAFCF);
  static const primaryBg = Color(0xFFE8F6F9);
  static const darkText = Color(0xFF1A2D3D);
  static const bodyBg = Color(0xFFF5F7FA);
  static const inputBg = Color(0xFFF0F2F5);
  static const stepInactive = Color(0xFFD0D8E4);
  static const avatarBg = Color(0xFFE8D5C4);
}

// ─────────────────────────────────────────────
// APPBAR SERAGAM
// ─────────────────────────────────────────────

/// AppBar yang digunakan di semua halaman form laporan.
///
/// [title] — judul yang ditampilkan (default: 'Laporkan Perundungan')
/// [onBack] — override aksi tombol back; jika null maka `context.pop()`,
///            atau `context.go('/home')` jika tidak bisa pop
class LaporanAppBar extends StatelessWidget implements PreferredSizeWidget {
  const LaporanAppBar({
    super.key,
    this.title = 'Laporkan Perundungan',
    this.onBack,
  });

  final String title;
  final VoidCallback? onBack;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.primary),
        onPressed: onBack ??
            () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go('/home');
              }
            },
      ),
      title: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          color: AppColors.primary,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.avatarBg,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// STEP INDICATOR
// ─────────────────────────────────────────────

/// Progress bar 4-langkah.
///
/// [currentStep] → 1-based (1 s.d. 4)
class LaporanStepIndicator extends StatelessWidget {
  const LaporanStepIndicator({super.key, required this.currentStep});

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LANGKAH $currentStep DARI 4',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        Row(
          children: List.generate(4, (index) {
            final isActive = index < currentStep;
            final isCurrentLast = index == currentStep - 1;
            return Container(
              margin: const EdgeInsets.only(left: 6),
              // Langkah aktif terakhir sedikit lebih lebar sebagai aksen
              width: isCurrentLast ? 28 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.stepInactive,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// TOMBOL SELANJUTNYA / KIRIM (bergradien)
// ─────────────────────────────────────────────

/// Tombol lebar penuh dengan gradien biru.
///
/// [label]    — teks tombol
/// [onPressed] — callback; set null untuk disable (misal saat loading)
/// [isLoading] — tampilkan CircularProgressIndicator di dalam tombol
/// [icon]     — ikon di sebelah kanan teks (default: arrow_forward)
class LaporanPrimaryButton extends StatelessWidget {
  const LaporanPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon = Icons.arrow_forward,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(icon, color: Colors.white, size: 18),
                  ],
                ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// CARD WRAPPER
// ─────────────────────────────────────────────

/// Card putih dengan rounded corners & shadow halus.
class LaporanCard extends StatelessWidget {
  const LaporanCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ─────────────────────────────────────────────
// INPUT DECORATION SERAGAM
// ─────────────────────────────────────────────

/// InputDecoration seragam untuk semua TextFormField laporan.
InputDecoration laporanInputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.plusJakartaSans(
      color: Colors.grey[400],
      fontSize: 14,
    ),
    filled: true,
    fillColor: AppColors.inputBg,
    contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
  );
}

// ─────────────────────────────────────────────
// SECURITY BANNER
// ─────────────────────────────────────────────

/// Banner "Aman & Terlindung" yang muncul di Step 1.
class LaporanSecurityBanner extends StatelessWidget {
  const LaporanSecurityBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return LaporanCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2ED),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.shield_outlined,
              color: AppColors.primary,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Aman & Terlindung',
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Informasi identitas Anda akan dijaga kerahasiaannya '
                  'dan hanya digunakan untuk keperluan verifikasi '
                  'serta bantuan profesional.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[600],
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

// ─────────────────────────────────────────────
// FOOTER PRIVASI (Step 3 & 4)
// ─────────────────────────────────────────────

/// Teks kecil di bawah tombol: "KERAHASIAAN ANDA ADALAH PRIORITAS KAMI…"
class LaporanPrivacyFooter extends StatelessWidget {
  const LaporanPrivacyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'KERAHASIAAN ANDA ADALAH PRIORITAS KAMI.\n'
      'DATA INI AKAN DIPROSES DENGAN PROTOKOL KEAMANAN TINGGI.',
      textAlign: TextAlign.center,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 10,
        color: Colors.grey[400],
        letterSpacing: 0.3,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}