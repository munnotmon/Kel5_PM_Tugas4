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
  String _searchQuery = '';
  int _selectedKategori = -1; // -1 = semua

  final List<_KategoriItem> _kategori = const [
    _KategoriItem(
      icon: Icons.shield_outlined,
      iconColor: Color(0xFF1A6B8A),
      iconBg: Color(0xFFDEEFF8),
      label: 'Akun &\nKeamanan',
    ),
    _KategoriItem(
      icon: Icons.campaign_outlined,
      iconColor: Color(0xFF2A9B6E),
      iconBg: Color(0xFFDDF5EC),
      label: 'Cara Melapor',
    ),
    _KategoriItem(
      icon: Icons.spa_outlined,
      iconColor: Color(0xFF2A9B6E),
      iconBg: Color(0xFFDDF5EC),
      label: 'Tentang\nKonseling',
    ),
    _KategoriItem(
      icon: Icons.lock_outline,
      iconColor: Color(0xFF1A6B8A),
      iconBg: Color(0xFFDEEFF8),
      label: 'Privasi',
    ),
  ];

  final List<_FaqItem> _allFaqs = const [
    // Akun & Keamanan (kategori 0)
    _FaqItem(
      kategoriIndex: 0,
      question: 'Bagaimana cara mengubah kata sandi?',
      answer:
          'Buka Profil → Keamanan Akun → Ubah Kata Sandi. Masukkan kata sandi saat ini dan kata sandi baru, lalu tekan Simpan.',
    ),
    _FaqItem(
      kategoriIndex: 0,
      question: 'Apa yang harus dilakukan jika lupa kata sandi?',
      answer:
          'Saat ini fitur lupa kata sandi masih dalam pengembangan. Hubungi admin kampus melalui menu Pesan untuk mendapatkan bantuan reset akun.',
    ),
    _FaqItem(
      kategoriIndex: 0,
      question: 'Bagaimana cara memperbarui data profil saya?',
      answer:
          'Buka Profil → Edit Profil. Anda dapat mengubah nama lengkap, nomor telepon, dan foto profil. NIM dan email tidak dapat diubah.',
    ),
    _FaqItem(
      kategoriIndex: 0,
      question: 'Mengapa NIM dan email tidak bisa diubah?',
      answer:
          'NIM dan email merupakan identitas resmi akademik yang terdaftar di sistem kampus. Perubahan data tersebut hanya dapat dilakukan melalui bagian administrasi kampus.',
    ),
    _FaqItem(
      kategoriIndex: 0,
      question: 'Bagaimana cara mengganti foto profil?',
      answer:
          'Buka Profil → Edit Profil, lalu ketuk ikon kamera pada foto profil Anda. Anda dapat mengambil foto baru menggunakan kamera atau memilih dari galeri.',
    ),
    _FaqItem(
      kategoriIndex: 0,
      question: 'Apakah akun saya bisa digunakan di beberapa perangkat?',
      answer:
          'Ya, akun Anda dapat digunakan di beberapa perangkat menggunakan email dan kata sandi yang sama. Pastikan untuk logout jika menggunakan perangkat bersama.',
    ),

    // Cara Melapor (kategori 1)
    _FaqItem(
      kategoriIndex: 1,
      question: 'Bagaimana cara melaporkan perundungan?',
      answer:
          'Tekan tombol "Laporkan Perundungan" di halaman utama, isi formulir laporan secara lengkap, lalu kirimkan. Laporan Anda akan segera ditindaklanjuti oleh admin.',
    ),
    _FaqItem(
      kategoriIndex: 1,
      question: 'Berapa lama laporan saya diproses?',
      answer:
          'Laporan biasanya diproses dalam 1–3 hari kerja. Anda akan menerima notifikasi setiap ada pembaruan status laporan.',
    ),
    _FaqItem(
      kategoriIndex: 1,
      question: 'Bisakah saya melacak status laporan saya?',
      answer:
          'Ya. Buka menu Activity untuk melihat daftar laporan beserta statusnya: Menunggu, Diproses, Selesai, atau Ditolak.',
    ),
    _FaqItem(
      kategoriIndex: 1,
      question: 'Apa saja informasi yang perlu disertakan dalam laporan?',
      answer:
          'Sertakan judul laporan, jenis perundungan, kronologi kejadian, deskripsi pelaku, lokasi, dan tanggal kejadian. Anda juga dapat melampirkan bukti berupa foto atau dokumen.',
    ),
    _FaqItem(
      kategoriIndex: 1,
      question: 'Apakah laporan saya bisa dibatalkan setelah dikirim?',
      answer:
          'Laporan yang sudah dikirim tidak dapat dibatalkan secara langsung. Jika ada kesalahan informasi, segera hubungi admin melalui menu Pesan untuk koordinasi lebih lanjut.',
    ),
    _FaqItem(
      kategoriIndex: 1,
      question: 'Apa yang terjadi setelah laporan saya diterima?',
      answer:
          'Admin akan meninjau laporan Anda dan memperbarui statusnya. Jika diperlukan, admin dapat menghubungi Anda melalui fitur chat untuk informasi tambahan.',
    ),
    _FaqItem(
      kategoriIndex: 1,
      question: 'Apakah saya bisa melaporkan atas nama orang lain?',
      answer:
          'Ya, Anda dapat melaporkan kejadian perundungan yang dialami orang lain. Pastikan mencantumkan informasi korban dan kronologi kejadian sejelas mungkin pada formulir laporan.',
    ),

    // Tentang Konseling (kategori 2)
    _FaqItem(
      kategoriIndex: 2,
      question: 'Bagaimana cara memesan sesi konseling?',
      answer:
          'Buka menu Counseling, pilih konselor yang tersedia, pilih jadwal yang sesuai, lalu konfirmasi pemesanan. Anda akan mendapat notifikasi konfirmasi.',
    ),
    _FaqItem(
      kategoriIndex: 2,
      question: 'Apakah sesi konseling bersifat rahasia?',
      answer:
          'Ya. Semua percakapan dalam sesi konseling bersifat rahasia dan hanya dapat diakses oleh Anda dan konselor yang bersangkutan.',
    ),
    _FaqItem(
      kategoriIndex: 2,
      question: 'Bagaimana cara melihat riwayat konseling saya?',
      answer:
          'Buka menu Activity lalu pilih tab Konseling untuk melihat seluruh riwayat sesi konseling yang pernah Anda lakukan.',
    ),
    _FaqItem(
      kategoriIndex: 2,
      question: 'Apakah konseling di aplikasi ini gratis?',
      answer:
          'Ya, layanan konseling melalui Polinema Care+ sepenuhnya gratis untuk seluruh mahasiswa Politeknik Negeri Malang.',
    ),
    _FaqItem(
      kategoriIndex: 2,
      question: 'Bisakah saya memilih konselor sendiri?',
      answer:
          'Ya. Anda dapat melihat profil dan spesialisasi setiap konselor yang tersedia, lalu memilih konselor yang paling sesuai dengan kebutuhan Anda.',
    ),
    _FaqItem(
      kategoriIndex: 2,
      question: 'Apa yang harus dilakukan jika ingin membatalkan sesi konseling?',
      answer:
          'Hubungi admin atau konselor melalui menu Pesan untuk membatalkan atau menjadwalkan ulang sesi konseling Anda sebelum waktu yang ditentukan.',
    ),
    _FaqItem(
      kategoriIndex: 2,
      question: 'Berapa lama durasi satu sesi konseling?',
      answer:
          'Durasi sesi konseling biasanya 45–60 menit, tergantung kesepakatan antara Anda dan konselor. Jadwal dan durasi dapat dilihat pada halaman detail konselor.',
    ),

    // Privasi (kategori 3)
    _FaqItem(
      kategoriIndex: 3,
      question: 'Apakah data saya aman?',
      answer:
          'Ya. Seluruh data Anda dienkripsi dan disimpan dengan aman. Kami tidak membagikan informasi Anda kepada pihak ketiga manapun.',
    ),
    _FaqItem(
      kategoriIndex: 3,
      question: 'Siapa yang dapat melihat laporan saya?',
      answer:
          'Laporan Anda hanya dapat dilihat oleh admin kampus yang bertugas menangani kasus perundungan. Identitas pelapor dijaga kerahasiaannya.',
    ),
    _FaqItem(
      kategoriIndex: 3,
      question: 'Apakah riwayat konseling saya bisa dilihat orang lain?',
      answer:
          'Tidak. Riwayat konseling bersifat pribadi dan hanya dapat diakses oleh Anda dan konselor yang menangani sesi tersebut.',
    ),
    _FaqItem(
      kategoriIndex: 3,
      question: 'Apakah aplikasi ini mengumpulkan data lokasi saya?',
      answer:
          'Data lokasi hanya digunakan untuk keperluan pengisian laporan perundungan (lokasi kejadian) dan tidak disimpan atau dipantau secara terus-menerus.',
    ),
    _FaqItem(
      kategoriIndex: 3,
      question: 'Bagaimana cara menghapus akun saya?',
      answer:
          'Penghapusan akun dapat dilakukan dengan menghubungi admin kampus melalui menu Pesan. Seluruh data Anda akan dihapus secara permanen sesuai kebijakan privasi yang berlaku.',
    ),
    _FaqItem(
      kategoriIndex: 3,
      question: 'Apakah percakapan chat saya disimpan?',
      answer:
          'Percakapan dalam sesi konseling dan tindak lanjut laporan disimpan di server kami secara terenkripsi dan hanya dapat diakses oleh pihak yang terlibat dalam sesi tersebut.',
    ),
  ];

  List<_FaqItem> get _filteredFaqs {
    return _allFaqs.where((faq) {
      final matchKategori =
          _selectedKategori == -1 || faq.kategoriIndex == _selectedKategori;
      final matchSearch = _searchQuery.isEmpty ||
          faq.question.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          faq.answer.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchKategori && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final faqs = _filteredFaqs;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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

            _buildSearchBar(),
            const SizedBox(height: 20),

            _buildKategoriChips(),
            const SizedBox(height: 20),

            faqs.isEmpty
                ? _buildEmptyState()
                : _buildFaqList(faqs),
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
        onChanged: (val) {
          setState(() {
            _searchQuery = val;
            _expandedFaq = null;
          });
        },
        decoration: InputDecoration(
          hintText: 'Cari pertanyaan...',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: const Color(0xFF9AAAB8),
          ),
          prefixIcon: const Icon(
            Icons.search,
            color: Color(0xFF1A6B8A),
            size: 22,
          ),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF9AAAB8), size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                      _expandedFaq = null;
                    });
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Widget _buildKategoriChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('Semua', -1),
          const SizedBox(width: 8),
          ...List.generate(_kategori.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildChip(
                _kategori[i].label.replaceAll('\n', ' '),
                i,
                icon: _kategori[i].icon,
                iconColor: _kategori[i].iconColor,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildChip(String label, int index,
      {IconData? icon, Color? iconColor}) {
    final isSelected = _selectedKategori == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedKategori = index;
          _expandedFaq = null;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1A6B8A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : iconColor,
              ),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF1A2D3D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqList(List<_FaqItem> faqs) {
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
        children: faqs.asMap().entries.map((entry) {
          final i = entry.key;
          final faq = entry.value;
          final isLast = i == faqs.length - 1;
          final isExpanded = _expandedFaq == i;

          return Column(
            children: [
              InkWell(
                onTap: () => setState(() {
                  _expandedFaq = isExpanded ? null : i;
                }),
                borderRadius: BorderRadius.only(
                  topLeft: i == 0 ? const Radius.circular(20) : Radius.zero,
                  topRight: i == 0 ? const Radius.circular(20) : Radius.zero,
                  bottomLeft: isLast ? const Radius.circular(20) : Radius.zero,
                  bottomRight: isLast ? const Radius.circular(20) : Radius.zero,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 10, top: 2),
                            decoration: BoxDecoration(
                              color: _kategori[faq.kategoriIndex].iconColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              faq.question,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1A2D3D),
                                height: 1.4,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
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
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            faq.answer,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13.5,
                              color: const Color(0xFF5A7080),
                              height: 1.6,
                            ),
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

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Icon(Icons.search_off_rounded, size: 48, color: Colors.grey[300]),
            const SizedBox(height: 12),
            Text(
              'Tidak ada hasil untuk "$_searchQuery"',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                color: Colors.grey[400],
              ),
            ),
          ],
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
  final int kategoriIndex;
  final String question;
  final String answer;

  const _FaqItem({
    required this.kategoriIndex,
    required this.question,
    required this.answer,
  });
}
