import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class SyaratKetentuanScreen extends StatefulWidget {
  const SyaratKetentuanScreen({super.key});

  @override
  State<SyaratKetentuanScreen> createState() => _SyaratKetentuanScreenState();
}

class _SyaratKetentuanScreenState extends State<SyaratKetentuanScreen> {
  final List<_SectionItem> _sections = const [
    _SectionItem(
      number: '1',
      icon: Icons.menu_book_rounded,
      iconColor: Color(0xFF1A6B8A),
      iconBg: Color(0xFFDEEFF8),
      title: 'Pendahuluan',
      body:
          'Selamat datang di platform Respon & Konseling. Platform ini dirancang sebagai ruang aman bagi mahasiswa untuk melaporkan insiden perundungan dan mendapatkan dukungan psikologis yang diperlukan.\n\nKetentuan ini mengatur akses dan penggunaan layanan kami di dalam lingkungan kampus. Dengan mengakses aplikasi, Anda menyatakan bahwa Anda telah berusia dewasa menurut hukum atau mendapatkan izin orang tua/wali.',
      highlight: null,
    ),
    _SectionItem(
      number: '2',
      icon: Icons.settings_outlined,
      iconColor: Color(0xFF1A6B8A),
      iconBg: Color(0xFFDEEFF8),
      title: 'Penggunaan\nLayanan',
      body:
          'Layanan ini hanya ditujukan untuk tujuan pelaporan yang sah dan konsultasi kesehatan mental. Pengguna dilarang:\n\n• Memberikan laporan palsu atau fitnah terhadap individu lain.\n\n• Menggunakan platform untuk tujuan perundungan atau pelecehan balik.\n\n• Membagikan konten yang mengandung kebencian, diskriminasi, atau pornografi.',
      highlight: null,
    ),
    _SectionItem(
      number: '3',
      icon: Icons.lock_outline_rounded,
      iconColor: Color(0xFF1A6B8A),
      iconBg: Color(0xFFDEEFF8),
      title: 'Anonimitas',
      body:
          'Kami menjamin kerahasiaan identitas pelapor melalui enkripsi tingkat tinggi. Identitas Anda tidak akan diungkapkan kepada pihak terlapor tanpa persetujuan tertulis kecuali diwajibkan oleh hukum.',
      highlight: null,
    ),
    _SectionItem(
      number: '4',
      icon: Icons.storage_rounded,
      iconColor: Color(0xFF1A6B8A),
      iconBg: Color(0xFFDEEFF8),
      title: 'Pengelolaan Data',
      body:
          'Semua data percakapan konseling bersifat rahasia antara konselor dan pengguna. Data statistik anonim mungkin digunakan untuk evaluasi program kesejahteraan kampus.',
      highlight: null,
    ),
    _SectionItem(
      number: '5',
      icon: Icons.warning_amber_rounded,
      iconColor: Color(0xFFE07B3A),
      iconBg: Color(0xFFFFF0E6),
      title: 'Batasan\nTanggung Jawab',
      body:
          'Meskipun kami berusaha memberikan respons cepat, layanan ini bukan pengganti layanan darurat medis atau kepolisian segera. Jika Anda berada dalam situasi bahaya yang mengancam nyawa, segera hubungi nomor darurat lokal.',
      highlight:
          'PENTING: Respon & Konseling tidak bertanggung jawab atas tindakan pihak ketiga yang di luar kendali platform kami.',
    ),
    _SectionItem(
      number: '6',
      icon: Icons.edit_document,
      iconColor: Color(0xFF1A6B8A),
      iconBg: Color(0xFFDEEFF8),
      title: 'Perubahan\nKetentuan',
      body:
          'Kami berhak memperbarui syarat dan ketentuan ini sewaktu-waktu. Perubahan akan dikonfirmasikan melalui notifikasi aplikasi. Penggunaan berkelanjutan setelah perubahan berarti Anda menerima syarat yang baru.',
      highlight: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),

            // Last updated badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFDEEFF8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'PEMBARUAN TERAKHIR: 24 MEI 2024',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A6B8A),
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Headline
            RichText(
              text: TextSpan(
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                  height: 1.2,
                ),
                children: const [
                  TextSpan(text: 'Komitmen Kami\nuntuk\n'),
                  TextSpan(
                    text: 'Keamanan Anda.',
                    style: TextStyle(color: Color(0xFF1A6B8A)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            Text(
              'Harap baca dokumen ini dengan seksama. Dengan menggunakan aplikasi Respon & Konseling, Anda setuju untuk terikat oleh ketentuan di bawah ini.',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: const Color(0xFF5A7080),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),

            // Sections
            ...List.generate(_sections.length, (i) {
              final section = _sections[i];
              final isLast = i == _sections.length - 1;
              return Column(
                children: [
                  _buildSection(section),
                  if (!isLast) const SizedBox(height: 16),
                ],
              );
            }),

            const SizedBox(height: 28),

            // Agreement card + button (mengikuti scroll)
            _buildBottomBar(context),

            const SizedBox(height: 20),

            // Footer copyright
            _buildFooter(),

            const SizedBox(height: 60),
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
        'Syarat & Ketentuan',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSection(_SectionItem section) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
          // Number + icon + title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: section.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(section.icon, color: section.iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 2),
                    Text(
                      '${section.number}. ${section.title}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A2D3D),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Body text
          Text(
            section.body,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: const Color(0xFF5A7080),
              height: 1.65,
            ),
          ),

          // Highlight box (for section 5)
          if (section.highlight != null) ...[
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFFE07B3A).withOpacity(0.4),
                  width: 1,
                ),
              ),
              child: Text(
                section.highlight!,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: const Color(0xFFB85A00),
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Shield icon
          Container(
            width: 48,
            height: 48,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFDEEFF8),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.shield_rounded,
              color: Color(0xFF1A6B8A),
              size: 24,
            ),
          ),

          Text(
            'Dengan mengeklik tombol di bawah, Anda mengkonfirmasi telah membaca dan memahami seluruh Syarat & Ketentuan di atas.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12.5,
              color: const Color(0xFF7A8FA0),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),

          // CTA button
          SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1A6B8A).withOpacity(0.30),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () => context.canPop() ? context.pop() : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Saya Setuju & Lanjutkan',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Text(
      'Hak Cipta © 2024 Respon & Konseling - Bagian dari Program Kesejahteraan Mahasiswa.',
      textAlign: TextAlign.center,
      style: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        color: const Color(0xFF9AAAB8),
        height: 1.6,
      ),
    );
  }
}

class _SectionItem {
  final String number;
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String body;
  final String? highlight;

  const _SectionItem({
    required this.number,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
    required this.highlight,
  });
}
