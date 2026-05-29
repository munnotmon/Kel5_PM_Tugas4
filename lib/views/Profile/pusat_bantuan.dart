import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PusatBantuanScreen extends StatefulWidget {
  const PusatBantuanScreen({super.key});

  @override
  State<PusatBantuanScreen> createState() => _PusatBantuanScreenState();
}

class _PusatBantuanScreenState extends State<PusatBantuanScreen> {
  final TextEditingController _searchController = TextEditingController();
  int? _expandedFaq;

  final List<_FaqItem> _faqs = const [
    _FaqItem(
      question: 'Bagaimana cara melapor secara anonim?',
      answer:
          'Anda dapat melapor secara anonim dengan memilih opsi "Anonim" saat mengisi formulir laporan. Data identitas Anda tidak akan disimpan atau ditampilkan kepada pihak manapun.',
    ),
    _FaqItem(
      question: 'Berapa lama laporan saya diproses?',
      answer:
          'Laporan biasanya diproses dalam 1–3 hari kerja. Anda akan menerima notifikasi setiap ada pembaruan status laporan Anda.',
    ),
    _FaqItem(
      question: 'Apakah data saya aman?',
      answer:
          'Ya, seluruh data Anda dienkripsi dan disimpan dengan aman. Kami mematuhi standar keamanan data yang ketat dan tidak membagikan informasi Anda kepada pihak ketiga.',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Headline
            Text(
              'Ada yang bisa kami\nbantu?',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2D3D),
                height: 1.25,
              ),
            ),
            const SizedBox(height: 20),

            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 32),

            // Kategori Populer
            Text(
              'Kategori Populer',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            const SizedBox(height: 16),
            _buildKategoriGrid(),
            const SizedBox(height: 32),

            // FAQ
            Text(
              'FAQ Terpopuler',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            const SizedBox(height: 12),
            _buildFaqList(),
            const SizedBox(height: 28),

            // CTA Card
            _buildCtaCard(),
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
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(
        'Pusat Bantuan',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          color: const Color(0xFF1A2D3D),
        ),
        decoration: InputDecoration(
          hintText: 'Cari bantuan...',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: const Color(0xFF9AAAB8),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF1A6B8A),
            size: 22,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildKategoriGrid() {
    final List<_KategoriItem> items = [
      _KategoriItem(
        icon: Icons.shield_outlined,
        iconColor: const Color(0xFF1A6B8A),
        iconBg: const Color(0xFFDEEFF8),
        label: 'Akun &\nKeamanan',
      ),
      _KategoriItem(
        icon: Icons.campaign_outlined,
        iconColor: const Color(0xFF2A9B6E),
        iconBg: const Color(0xFFDDF5EC),
        label: 'Cara Melapor',
      ),
      _KategoriItem(
        icon: Icons.spa_outlined,
        iconColor: const Color(0xFF2A9B6E),
        iconBg: const Color(0xFFDDF5EC),
        label: 'Tentang\nKonseling',
      ),
      _KategoriItem(
        icon: Icons.lock_outline,
        iconColor: const Color(0xFF1A6B8A),
        iconBg: const Color(0xFFDEEFF8),
        label: 'Privasi',
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.95,
      children: items.map((item) => _buildKategoriCard(item)).toList(),
    );
  }

  Widget _buildKategoriCard(_KategoriItem item) {
    return Container(
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
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: item.iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.iconColor, size: 22),
              ),
              const SizedBox(height: 12),
              Text(
                item.label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A2D3D),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqList() {
    return Container(
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
        children: _faqs.asMap().entries.map((entry) {
          final i = entry.key;
          final faq = entry.value;
          final isLast = i == _faqs.length - 1;
          final isExpanded = _expandedFaq == i;

          return Column(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    _expandedFaq = isExpanded ? null : i;
                  });
                },
                borderRadius: BorderRadius.only(
                  topLeft: i == 0 ? const Radius.circular(20) : Radius.zero,
                  topRight: i == 0 ? const Radius.circular(20) : Radius.zero,
                  bottomLeft: isLast ? const Radius.circular(20) : Radius.zero,
                  bottomRight: isLast ? const Radius.circular(20) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq.question,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF1A2D3D),
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            color: const Color(0xFF9AAAB8),
                            size: 22,
                          ),
                        ],
                      ),
                      if (isExpanded) ...[
                        const SizedBox(height: 12),
                        Text(
                          faq.answer,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13.5,
                            color: const Color(0xFF5A7080),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (!isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Divider(height: 1, color: Color(0xFFF0F2F5)),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCtaCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFF1A6B8A), Color(0xFF155C78)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circle
          Positioned(
            right: -20,
            bottom: -30,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: -10,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Butuh Bantuan Lebih Lanjut?',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Tim dukungan kami siap\nmendengarkan 24/7.',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.75),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              // Chat dengan Admin button
              _buildCtaButton(
                icon: Icons.chat_bubble_outline_rounded,
                label: 'Chat dengan Admin',
                onTap: () {},
              ),
              const SizedBox(height: 10),

              // Kirim Email button
              _buildCtaButton(
                icon: Icons.mail_outline_rounded,
                label: 'Kirim Email',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCtaButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 18, color: const Color(0xFF1A6B8A)),
        label: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1A6B8A),
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}

class _KategoriItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;

  const _KategoriItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
  });
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}
