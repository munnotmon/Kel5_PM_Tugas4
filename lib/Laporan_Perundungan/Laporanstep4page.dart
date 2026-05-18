import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class LaporanStep4Page extends StatefulWidget {
  final Map<String, dynamic> data;

  const LaporanStep4Page({super.key, this.data = const {}});

  @override
  State<LaporanStep4Page> createState() => _LaporanStep4PageState();
}

class _LaporanStep4PageState extends State<LaporanStep4Page> {
  bool _isSending = false;

  Map<String, dynamic> get _data => widget.data;

  // =====================================================================
  // HELPERS — ambil data dengan fallback
  // =====================================================================
  String _get(String key, [String fallback = '-']) =>
      (_data[key]?.toString().isNotEmpty == true)
      ? _data[key].toString()
      : fallback;

  List<dynamic> _getList(String key) {
    final v = _data[key];
    return v is List ? v : [];
  }

  // =====================================================================
  // KIRIM LAPORAN
  // =====================================================================
  Future<void> _handleKirim() async {
    setState(() => _isSending = true);
    // Simulasi proses pengiriman
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isSending = false);

    // TODO: ganti dengan navigasi ke halaman sukses
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.all(28),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFFE0F7ED),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF1A6B8A),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Laporan Terkirim!',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Laporan Anda telah berhasil dikirimkan. Tim kami akan segera menindaklanjuti.',
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1A6B8A), Color(0xFF2AAFCF)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(
                    'Kembali ke Beranda',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        child: Column(
          children: [
            // Konten scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepIndicator(),
                    const SizedBox(height: 20),
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildDetailKejadianCard(),
                    const SizedBox(height: 16),
                    _buildPihakTerlibatCard(),
                    const SizedBox(height: 16),
                    _buildLampiranCard(),
                    const SizedBox(height: 16),
                    _buildSecurityInfo(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Tombol Kirim — sticky di atas navbar
            _buildKirimButton(),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // APPBAR
  // =====================================================================
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
        onPressed: () => context.canPop() ? context.pop() : context.go('/home'),
      ),
      title: Text(
        'Konfirmasi & Kirim',
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

  // =====================================================================
  // STEP INDICATOR
  // =====================================================================
  Widget _buildStepIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'LANGKAH 4 DARI 4',
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
              // Langkah terakhir (index 3) lebih panjang sebagai penanda selesai
              width: index == 3 ? 28 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF1A6B8A), // Semua aktif
                borderRadius: BorderRadius.circular(10),
              ),
            );
          }),
        ),
      ],
    );
  }

  // =====================================================================
  // HEADER
  // =====================================================================
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Konfirmasi & Kirim',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Silakan tinjau kembali laporan Anda sebelum\nmengirim. Kami menjamin kerahasiaan data Anda.',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // =====================================================================
  // CARD — Detail Kejadian
  // =====================================================================
  Widget _buildDetailKejadianCard() {
    final waktu = _get('waktu', '12 Okt 2026, 10:00');
    final lokasi = _get('lokasi', '');
    final jenis = _get('jenis', 'Perundungan Verbal');
    final deskripsi = _get(
      'deskripsi',
      '"Insiden terjadi saat jam istirahat..."',
    );
    final isCyber = jenis == 'Cyberbullying';

    return _buildCard(
      icon: Icons.calendar_today_rounded,
      iconBg: const Color(0xFFE8F4FD),
      iconColor: const Color(0xFF1A6B8A),
      title: 'Detail Kejadian',
      onEdit: () => context.push('/activity/laporan/step2', extra: widget.data),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Jika cyberbullying, hanya tampilkan waktu tanpa lokasi
          _buildInfoRow(
            label: isCyber ? 'WAKTU' : 'WAKTU & TEMPAT',
            value: isCyber ? waktu : '$waktu - $lokasi',
          ),
          const SizedBox(height: 14),
          _buildInfoRow(label: 'JENIS INSIDEN', value: jenis, isBold: true),
          const SizedBox(height: 14),
          _buildInfoRow(label: 'KRONOLOGI', value: deskripsi, isItalic: true),
        ],
      ),
    );
  }

  // =====================================================================
  // CARD — Pihak Terlibat
  // =====================================================================
  Widget _buildPihakTerlibatCard() {
    final korban = _get('korban', 'saya');
    final pelaku = _get('pelaku', '-');
    final saksi = _get('saksi', '-');

    final isKorbanSaya = korban == 'saya';

    return _buildCard(
      icon: Icons.people_alt_rounded,
      iconBg: const Color(0xFFE0F7ED),
      iconColor: const Color(0xFF1A6B8A),
      title: 'Pihak Terlibat',
      // Push Step3 dengan full data agar form ter-prefill
      onEdit: () => context.push('/activity/laporan/step3', extra: widget.data),
      child: Column(
        children: [
          // Korban
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Korban',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isKorbanSaya
                      ? const Color(0xFF4CAF82)
                      : const Color(0xFF1A6B8A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isKorbanSaya ? 'SAYA SENDIRI' : 'ORANG LAIN',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
          const SizedBox(height: 14),
          // Pelaku
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pelaku',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Flexible(
                child: Text(
                  pelaku,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
          const SizedBox(height: 14),
          // Saksi
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Saksi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Flexible(
                child: Text(
                  saksi.isEmpty ? '-' : saksi,
                  textAlign: TextAlign.end,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // CARD — Lampiran
  // =====================================================================
  Widget _buildLampiranCard() {
    final lampiran = _getList('lampiran');

    // Fallback tampilan jika tidak ada data lampiran
    final displayFiles = lampiran.isNotEmpty
        ? lampiran.map((f) => f.toString()).toList()
        : <String>['foto_kejadian.jpg', 'screenshot_chat.png'];

    return _buildCard(
      icon: Icons.attach_file_rounded,
      iconBg: const Color(0xFFF3F0FB),
      iconColor: const Color(0xFF7B5EA7),
      title: 'Lampiran',
      // Push Step2 dengan full data agar form ter-prefill
      onEdit: () => context.push('/activity/laporan/step2', extra: widget.data),
      child: Column(
        children: displayFiles.asMap().entries.map((entry) {
          final i = entry.key;
          final name = entry.value.split('/').last;
          final isImage =
              name.endsWith('.jpg') ||
              name.endsWith('.jpeg') ||
              name.endsWith('.png');

          return Column(
            children: [
              if (i > 0) const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      isImage
                          ? Icons.image_outlined
                          : Icons.insert_drive_file_outlined,
                      size: 20,
                      color: const Color(0xFF1A6B8A),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          color: const Color(0xFF1A2D3D),
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // =====================================================================
  // INFO KEAMANAN
  // =====================================================================
  Widget _buildSecurityInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6F9),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1A6B8A).withOpacity(0.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFF1A6B8A),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ruang Aman Terjamin',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Laporan ini akan diproses secara rahasia oleh tim respon kampus. Identitas Anda tidak akan diungkapkan tanpa persetujuan Anda.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF1A6B8A),
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

  // =====================================================================
  // TOMBOL KIRIM — sticky di atas navbar
  // =====================================================================
  Widget _buildKirimButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
      color: const Color(0xFFF5F7FA),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A4B6A), Color(0xFF1A6B8A)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A6B8A).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isSending ? null : _handleKirim,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: _isSending
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
                        'Kirim Laporan Sekarang',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  // =====================================================================
  // HELPER WIDGETS
  // =====================================================================
  Widget _buildCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required VoidCallback onEdit,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header kartu
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
              ),
              // Tombol Edit
              GestureDetector(
                onTap: onEdit,
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      size: 14,
                      color: Color(0xFF1A6B8A),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Edit',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: const Color(0xFF1A6B8A),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required String label,
    required String value,
    bool isBold = false,
    bool isItalic = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey[400],
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: const Color(0xFF1A2D3D),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
