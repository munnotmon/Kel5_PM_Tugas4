// lib/views/laporan/laporan_step3_page.dart  (Step 3 — Pihak Yang Terlibat)

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'laporan_widgets.dart';

class LaporanStep3Page extends StatefulWidget {
  final Map<String, dynamic> prevData;

  const LaporanStep3Page({super.key, this.prevData = const {}});

  @override
  State<LaporanStep3Page> createState() => _LaporanStep3PageState();
}

class _LaporanStep3PageState extends State<LaporanStep3Page> {
  final _formKey = GlobalKey<FormState>();

  String _selectedKorban = 'saya';
  final _pelakuController = TextEditingController();
  final _saksiController = TextEditingController();

  // ─── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final d = widget.prevData;
    if (d['korban'] != null) _selectedKorban = d['korban'] as String;
    _pelakuController.text = d['pelaku'] ?? '';
    _saksiController.text = d['saksi'] ?? '';
  }

  @override
  void dispose() {
    _pelakuController.dispose();
    _saksiController.dispose();
    super.dispose();
  }

  // ─── Navigation ──────────────────────────────────────────────────────────

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    context.push('/activity/laporan/step4', extra: {
      ...widget.prevData,
      'korban': _selectedKorban,
      'pelaku': _pelakuController.text.trim(),
      'saksi': _saksiController.text.trim(),
    });
  }

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: const LaporanAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const LaporanStepIndicator(currentStep: 3),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 28),
                _buildSiapaKorban(),
                const SizedBox(height: 20),
                _buildIdentitasPelaku(),
                const SizedBox(height: 20),
                _buildSaksi(),
                const SizedBox(height: 32),
                LaporanPrimaryButton(
                  label: 'Lanjut Ke Langkah Berikutnya',
                  onPressed: _handleNext,
                ),
                const SizedBox(height: 10),
                const LaporanPrivacyFooter(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ─── Widgets ─────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pihak Yang Terlibat',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Informasi ini membantu kami memahami konteks\ndan memberikan bantuan yang tepat.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildSiapaKorban() {
    return LaporanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.person_search_outlined,
                  color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Siapa Korbannya?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          _buildKorbanOption(
            value: 'saya',
            icon: Icons.person_outline,
            label: 'Saya Sendiri',
          ),
          const SizedBox(height: 10),
          _buildKorbanOption(
            value: 'orang_lain',
            icon: Icons.people_outline,
            label: 'Orang Lain',
          ),
        ],
      ),
    );
  }

  Widget _buildKorbanOption({
    required String value,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedKorban == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedKorban = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4CAF82)
              : AppColors.inputBg,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: isSelected ? Colors.white : const Color(0xFF6B7A8D)),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF6B7A8D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentitasPelaku() {
    return LaporanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFD4880C), size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Identitas Pelaku',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
              const SizedBox(width: 4),
              const Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Nama atau Deskripsi Pelaku',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4A5568),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _pelakuController,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, color: AppColors.darkText),
            decoration:
                laporanInputDecoration('Contoh: Nama lengkap\natau ciri fisik'),
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Identitas pelaku wajib diisi'
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildSaksi() {
    return LaporanCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.remove_red_eye_outlined,
                    color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Text(
                'Saksi (Opsional)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              'Jika ada pihak lain yang melihat kejadian tersebut',
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 13, color: Colors.grey[500], height: 1.5),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _saksiController,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(
                fontSize: 14, color: AppColors.darkText),
            decoration:
                laporanInputDecoration('Tuliskan nama saksi jika ada'),
          ),
        ],
      ),
    );
  }
}