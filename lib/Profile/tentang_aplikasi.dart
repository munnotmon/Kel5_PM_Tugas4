import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroBanner(),
            const SizedBox(height: 24),
            _buildVisiMisi(),
            const SizedBox(height: 32),
            _buildKomitmenSection(),
            const SizedBox(height: 32),
            _buildCaraKerjaSection(),
            const SizedBox(height: 32),
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
        'Tentang Aplikasi',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  // ── HERO BANNER ──────────────────────────────────────────────
  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -18,
            top: -18,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 30,
            bottom: -10,
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tempat Aman Digital\nbagi Setiap Mahasiswa.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Respon & Konseling hadir sebagai ruang aman di mana suara Anda didengar, keamanan Anda diprioritaskan, dan kesejahteraan mental Anda adalah fokus utama kami.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  color: Colors.white.withOpacity(0.85),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── VISI & MISI ───────────────────────────────────────────────
  Widget _buildVisiMisi() {
    return Column(
      children: [
        _buildVisiMisiCard(
          icon: Icons.remove_red_eye_outlined,
          iconColor: const Color(0xFF2A9B6E),
          iconBg: const Color(0xFFDDF5EC),
          label: 'Visi',
          body:
              'Menciptakan ekosistem kampus yang bebas dari perundungan dan kekerasan, di mana setiap individu merasa dihargai.',
        ),
        const SizedBox(height: 16),
        _buildVisiMisiCard(
          icon: Icons.flag_outlined,
          iconColor: const Color(0xFF2A9B6E),
          iconBg: const Color(0xFFDDF5EC),
          label: 'Misi',
          body:
              'Memberikan akses instan ke bantuan profesional dan menyediakan kanal pelaporan yang aman dan terpercaya.',
        ),
      ],
    );
  }

  Widget _buildVisiMisiCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String body,
  }) {
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
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A6B8A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: const Color(0xFF5A7080),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── KOMITMEN KAMI ─────────────────────────────────────────────
  Widget _buildKomitmenSection() {
    final items = [
      _KomitmenItem(
        icon: Icons.lock_rounded,
        iconColor: const Color(0xFF1A6B8A),
        iconBg: const Color(0xFFDEEFF8),
        title: '100% Kerahasiaan',
        subtitle: 'Data dan identitas Anda tersimpan dengan enkripsi tingkat tinggi.',
      ),
      _KomitmenItem(
        icon: Icons.medical_services_outlined,
        iconColor: const Color(0xFF1A6B8A),
        iconBg: const Color(0xFFDEEFF8),
        title: 'Konselor Profesional',
        subtitle:
            'Tim psikolog dan konselor terlatih siap mendampingi setiap langkah Anda.',
      ),
      _KomitmenItem(
        icon: Icons.visibility_off_outlined,
        iconColor: const Color(0xFF7B4FBF),
        iconBg: const Color(0xFFF0E8FA),
        title: 'Pelaporan Anonim',
        subtitle:
            'Laporkan insiden tanpa rasa takut melalui sistem anonimitas total.',
        isLast: true,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Komitmen Kami',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 14),
        Container(
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
            children: items.map((item) {
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 16,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: item.iconBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon, color: item.iconColor, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 14.5,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF1A2D3D),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.subtitle,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: const Color(0xFF7A8FA0),
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!item.isLast)
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: Divider(height: 1, color: Color(0xFFF0F2F5)),
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  // ── CARA KERJA ────────────────────────────────────────────────
  Widget _buildCaraKerjaSection() {
    final steps = [
      _StepItem(
        number: '1',
        title: 'Laporkan (Report)',
        body:
            'Ceritakan kejadian atau kendala yang Anda hadapi melalui formulir yang tersedia.',
      ),
      _StepItem(
        number: '2',
        title: 'Terhubung (Connect)',
        body:
            'Sistem kami akan mencocokkan laporan Anda dengan konselor yang paling tepat.',
      ),
      _StepItem(
        number: '3',
        title: 'Dukungan (Support)',
        body:
            'Dapatkan bimbingan, mediasi, atau tindak lanjut yang Anda perlukan untuk merasa aman kembali.',
      ),
    ];

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
        children: [
          Text(
            'Cara Kerja',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 24),
          ...List.generate(steps.length, (i) {
            final step = steps[i];
            final isLast = i == steps.length - 1;
            return _buildStep(step, isLast: isLast);
          }),
        ],
      ),
    );
  }

  Widget _buildStep(_StepItem step, {bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Number + vertical line
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Text(
                    step.number,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A6B8A).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    step.title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    step.body,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: const Color(0xFF7A8FA0),
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── FOOTER ────────────────────────────────────────────────────
  Widget _buildFooter() {
    return Column(
      children: [
        // Quote icon
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFFDEEFF8),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.volunteer_activism_rounded,
            color: Color(0xFF1A6B8A),
            size: 24,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '"Setiap laporan adalah langkah menuju kampus yang lebih baik. Kami di sini untuk menjamin tidak ada seorang pun yang harus berjuang sendirian."',
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            color: const Color(0xFF5A7080),
            fontStyle: FontStyle.italic,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          '© 2026 Respon & Konseling. All Rights Reserved.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            color: const Color(0xFFAABBC8),
          ),
        ),
      ],
    );
  }
}

// ── DATA CLASSES ──────────────────────────────────────────────
class _KomitmenItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool isLast;

  const _KomitmenItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });
}

class _StepItem {
  final String number;
  final String title;
  final String body;

  const _StepItem({
    required this.number,
    required this.title,
    required this.body,
  });
}