// lib/views/laporan/lapor_perundungan_page.dart  (Step 1 — Data Diri Pelapor)

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'laporan_widgets.dart';

class LaporanPerundunganPage extends StatefulWidget {
  /// Data dari step sebelumnya (diisi saat mode edit dari Step 4).
  final Map<String, dynamic>? prevData;

  const LaporanPerundunganPage({super.key, this.prevData});

  @override
  State<LaporanPerundunganPage> createState() => _LaporanPerundunganPageState();
}

class _LaporanPerundunganPageState extends State<LaporanPerundunganPage> {
  final _formKey = GlobalKey<FormState>();

  final _namaController = TextEditingController();
  final _nimController = TextEditingController();
  final _teleponController = TextEditingController();

  String? _selectedProdi;

  static const _prodiList = [
    'Teknologi Informasi',
    'Teknik Kimia',
    'Teknik Elektro',
    'Teknik Mesin',
    'Teknik Sipil',
    'Administrasi Niaga',
    'Akuntansi',
  ];

  // ─── Lifecycle ───────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final d = widget.prevData ?? {};
    _namaController.text = d['nama'] ?? '';
    _nimController.text = d['nim'] ?? '';
    _teleponController.text = d['telepon'] ?? '';
    _selectedProdi = d['prodi'] as String?;
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nimController.dispose();
    _teleponController.dispose();
    super.dispose();
  }

  // ─── Navigation ──────────────────────────────────────────────────────────

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;

    final safePrev = widget.prevData ?? {};
    final isEdit = safePrev['isEdit'] == true;

    final data = {
      ...safePrev,
      'nama': _namaController.text.trim(),
      'nim': _nimController.text.trim(),
      'telepon': _teleponController.text.trim(),
      'prodi': _selectedProdi,
    };

    // Saat edit dari Step 4, langsung kembali ke Step 4
    if (isEdit) {
      context.push('/activity/laporan/step4', extra: data);
    } else {
      context.push('/activity/laporan/step2', extra: data);
    }
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
                const LaporanStepIndicator(currentStep: 1),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 24),
                const LaporanSecurityBanner(),
                const SizedBox(height: 28),
                _buildFormFields(),
                const SizedBox(height: 32),
                LaporanPrimaryButton(
                  label: 'Selanjutnya',
                  onPressed: _handleNext,
                ),
                const SizedBox(height: 16),
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
          'Data Diri Pelapor',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ceritakan secara jujur. Keamanan Anda adalah\nprioritas utama kami.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('Nama Lengkap', required: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _namaController,
          textCapitalization: TextCapitalization.words,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.darkText),
          decoration: laporanInputDecoration('Masukkan nama lengkap'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Nama wajib diisi' : null,
        ),
        const SizedBox(height: 20),
        _buildLabel('NIM', required: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _nimController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.darkText),
          decoration: laporanInputDecoration('Contoh: 2241234567'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'NIM wajib diisi' : null,
        ),
        const SizedBox(height: 20),
        _buildLabel('Nomor Telepon', required: true),
        const SizedBox(height: 8),
        TextFormField(
          controller: _teleponController,
          keyboardType: TextInputType.phone,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14, color: AppColors.darkText),
          decoration: laporanInputDecoration('Contoh: 08123456789'),
          validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Nomor telepon wajib diisi' : null,
        ),
        const SizedBox(height: 20),
        _buildLabel('Program Studi', required: true),
        const SizedBox(height: 8),
        _buildProdiDropdown(),
      ],
    );
  }

  /// Label field dengan tanda bintang merah jika [required].
  Widget _buildLabel(String text, {bool required = false}) {
    return Row(
      children: [
        Text(
          text,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF4A5568),
          ),
        ),
        if (required)
          const Text(' *', style: TextStyle(color: Colors.red, fontSize: 14)),
      ],
    );
  }

  // ─── Prodi Picker ────────────────────────────────────────────────────────

  Widget _buildProdiDropdown() {
    return FormField<String>(
      validator: (_) =>
          _selectedProdi == null ? 'Program studi wajib dipilih' : null,
      builder: (state) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: _showProdiPicker,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.inputBg,
                borderRadius: BorderRadius.circular(12),
                border: state.hasError
                    ? Border.all(color: Colors.red, width: 1.5)
                    : _selectedProdi != null
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedProdi ?? 'Pilih Prodi',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: _selectedProdi != null
                            ? AppColors.darkText
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ),
          if (state.hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 12),
              child: Text(
                state.errorText!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  void _showProdiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.stepInactive,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pilih Program Studi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ..._prodiList.map((prodi) {
              final isSelected = prodi == _selectedProdi;
              return InkWell(
                onTap: () {
                  setState(() => _selectedProdi = prodi);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(12),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.inputBg,
                    borderRadius: BorderRadius.circular(12),
                    border: isSelected
                        ? Border.all(color: AppColors.primary, width: 1.5)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          prodi,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.darkText,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.primary,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}