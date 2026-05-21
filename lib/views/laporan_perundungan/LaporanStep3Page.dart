import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class LaporanStep3Page extends StatefulWidget {
  final Map<String, dynamic> prevData;

  const LaporanStep3Page({super.key, this.prevData = const {}});

  @override
  State<LaporanStep3Page> createState() => _LaporanStep3PageState();
}

class _LaporanStep3PageState extends State<LaporanStep3Page> {
  final _formKey = GlobalKey<FormState>();

  String _selectedKorban = 'saya';
  final TextEditingController _pelakuController = TextEditingController();
  final TextEditingController _saksiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final d = widget.prevData;
    // Pre-fill dari data sebelumnya (saat edit dari Step4)
    if (d['korban'] != null) _selectedKorban = d['korban'];
    _pelakuController.text = d['pelaku'] ?? '';
    _saksiController.text = d['saksi'] ?? '';
  }

  @override
  void dispose() {
    _pelakuController.dispose();
    _saksiController.dispose();
    super.dispose();
  }

  // =====================================================================
  // VALIDASI & NEXT
  // =====================================================================
  void _handleNext() {
    if (_formKey.currentState!.validate()) {
      context.push('/activity/laporan/step4', extra: {
        // Data dari step 1 & 2
        ...widget.prevData,
        // Data step 3
        'korban': _selectedKorban,
        'pelaku': _pelakuController.text,
        'saksi': _saksiController.text,
      });
    }
  }

  // =====================================================================
  // BUILD
  // =====================================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepIndicator(),
                const SizedBox(height: 20),
                _buildHeader(),
                const SizedBox(height: 28),
                _buildSiapaKorban(),
                const SizedBox(height: 20),
                _buildIdentitasPelaku(),
                const SizedBox(height: 20),
                _buildSaksi(),
                const SizedBox(height: 32),
                _buildNextButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // WIDGETS
  // =====================================================================

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Laporkan Perundungan',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: const Color(0xFFE8D5C4),
            child: ClipOval(child: Container(color: const Color(0xFFE8D5C4))),
          ),
        ),
      ],
    );
  }

  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LANGKAH 3 DARI 4',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A6B8A),
            fontWeight: FontWeight.w600,
            fontSize: 12,
            letterSpacing: 0.5,
          ),
        ),
        Row(
          children: List.generate(4, (index) {
            return Container(
              margin: const EdgeInsets.only(left: 6),
              width: index <= 2 ? 28 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: index <= 2
                    ? const Color(0xFF1A6B8A)
                    : const Color(0xFFD0D8E4),
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pihak Yang Terlibat',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Informasi ini membantu kamu memahami konteks\ndan memberikan bantuan yang tepat',
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
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.person_search_outlined,
                color: Color(0xFF1A6B8A),
                size: 22,
              ),
              const SizedBox(width: 10),
              Text(
                'Siapa Korbannya?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Tombol Saya Sendiri
          _buildKorbanOption(
            value: 'saya',
            icon: Icons.person_outline,
            label: 'Saya Sendiri',
          ),
          const SizedBox(height: 10),
          // Tombol Orang Lain
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
          color: isSelected ? const Color(0xFF4CAF82) : const Color(0xFFF0F2F5),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? Colors.white : const Color(0xFF6B7A8D),
            ),
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
    return _buildCard(
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
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFD4880C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Identitas Pelaku',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
              const SizedBox(width: 4),
              const Text(
                '*',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
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
            validator: (val) {
              if (val == null || val.isEmpty) {
                return 'Identitas pelaku wajib diisi';
              }
              return null;
            },
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF1A2D3D),
            ),
            decoration: _inputDecoration(
              'Contoh: Nama lengkap\natau ciri fisik',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaksi() {
    return _buildCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.remove_red_eye_outlined,
                  color: Color(0xFF1A6B8A),
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Saksi (Opsional)',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              'Jika ada pihak lain yang melihat\nkejadian tersebut',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[500],
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 14),
          TextFormField(
            controller: _saksiController,
            maxLines: 3,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: const Color(0xFF1A2D3D),
            ),
            decoration: _inputDecoration('Tuliskan nama saksi jika ada'),
          ),
        ],
      ),
    );
  }

  Widget _buildNextButton() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: _handleNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Lanjut Ke Langkah Berikutnya',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'KERAHASIAAN ANDA ADALAH PRIORITAS KAMI.\nDATA INI AKAN DIPROSES DENGAN PROTOKOL\nKEAMANAN TINGGI.',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10,
            color: Colors.grey[400],
            letterSpacing: 0.3,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // =====================================================================
  // HELPERS
  // =====================================================================

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.plusJakartaSans(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: const Color(0xFFF0F2F5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
        borderSide: const BorderSide(color: Color(0xFF1A6B8A), width: 1.5),
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
}
