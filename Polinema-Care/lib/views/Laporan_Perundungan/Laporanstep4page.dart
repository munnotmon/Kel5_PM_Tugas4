import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../controllers/laporan_controller.dart';

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
    final success = await LaporanController.kirimLaporan(_data);
    if (!mounted) return;
    setState(() => _isSending = false);

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal mengirim laporan. Silakan coba lagi.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

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
              width: index == 3 ? 28 : 10,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF1A6B8A),
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
    final deskripsi = _get('deskripsi', 'Tidak ada deskripsi kejadian.');
    final isCyber = jenis == 'Cyberbullying';

    return _buildCard(
      icon: Icons.calendar_today_rounded,
      iconBg: const Color(0xFFE8F4FD),
      iconColor: const Color(0xFF1A6B8A),
      title: 'Detail Kejadian',
      onEdit: () => context.push(
        '/activity/laporan/step2',
        extra: {
          ...widget.data,
          'isEdit': true,
          'scrollTo': null, // BACA INI: Tambahkan ini untuk mereset scroll!
        },
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow(
            label: isCyber ? 'WAKTU' : 'WAKTU & TEMPAT',
            value: isCyber ? waktu : '$waktu - $lokasi',
          ),
          const SizedBox(height: 14),
          _buildInfoRow(label: 'JENIS INSIDEN', value: jenis, isBold: true),
          const SizedBox(height: 14),
          // KRONOLOGI — tampilkan sebagai paragraf penuh agar teks dari Step 2 terbaca
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KRONOLOGI',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                  letterSpacing: 0.8,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(
                  deskripsi,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: const Color(0xFF1A2D3D),
                    height: 1.6,
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
      onEdit: () => context.push(
        '/activity/laporan/step3',
        extra: {...widget.data, 'isEdit': true},
      ),
      child: Column(
        children: [
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

    return _buildCard(
      icon: Icons.attach_file_rounded,
      iconBg: const Color(0xFFF3F0FB),
      iconColor: const Color(0xFF7B5EA7),
      title: 'Lampiran',
      onEdit: () => context.push(
        '/activity/laporan/step2',
        extra: {
          ...widget.data,
          'isEdit': true,
          'scrollTo': 'lampiran', // Tambahkan penanda ini
        },
      ),
      child: lampiran.isEmpty
          ? Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              alignment: Alignment.center,
              child: Text(
                'Tidak ada lampiran bukti yang ditambahkan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[500],
                ),
              ),
            )
          : Column(
              children: lampiran.map((f) => f.toString()).toList().asMap().entries.map((entry) {
                final i = entry.key;
                final name = entry.value.split('/').last;
                final ext = name.split('.').last.toLowerCase();
                final isImage = ['jpg', 'jpeg', 'png', 'gif', 'webp'].contains(ext);
                final isVideo = ['mp4', 'mov', 'avi', 'mkv', '3gp'].contains(ext);
                final isAudio = ['mp3', 'm4a', 'aac', 'wav', 'ogg'].contains(ext);

                final IconData fileIcon = isImage
                    ? Icons.image_outlined
                    : isVideo
                        ? Icons.videocam_outlined
                        : isAudio
                            ? Icons.audiotrack_outlined
                            : Icons.insert_drive_file_outlined;
                final Color fileIconColor = isVideo
                    ? const Color(0xFF1565C0)
                    : isAudio
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFF1A6B8A);

                return Column(
                  children: [
                    if (i > 0) const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        if (isImage) {
                          showDialog(
                            context: context,
                            builder: (_) => Dialog(
                              backgroundColor: Colors.transparent,
                              insetPadding: const EdgeInsets.all(16),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      File(entry.value),
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, _, _) => Container(
                                        padding: const EdgeInsets.all(32),
                                        color: Colors.black87,
                                        child: const Icon(Icons.broken_image, color: Colors.white, size: 64),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, color: Colors.white, size: 20),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else if (isVideo) {
                          showDialog(
                            context: context,
                            builder: (_) => _VideoPreviewDialog(filePath: entry.value, fileName: name),
                          );
                        } else if (isAudio) {
                          showDialog(
                            context: context,
                            builder: (_) => _AudioPreviewDialog(filePath: entry.value, fileName: name),
                          );
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              title: Row(
                                children: [
                                  Icon(fileIcon, color: fileIconColor, size: 22),
                                  const SizedBox(width: 10),
                                  const Text('Lampiran'),
                                ],
                              ),
                              content: Text(
                                name,
                                style: GoogleFonts.plusJakartaSans(fontSize: 13),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Container(
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
                              fileIcon,
                              size: 20,
                              color: fileIconColor,
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
                            const Icon(Icons.chevron_right, size: 16, color: Colors.grey),
                          ],
                        ),
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
  // TOMBOL KIRIM
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

// =====================================================================
// VIDEO PREVIEW DIALOG
// =====================================================================
class _VideoPreviewDialog extends StatefulWidget {
  final String filePath;
  final String fileName;
  const _VideoPreviewDialog({required this.filePath, required this.fileName});

  @override
  State<_VideoPreviewDialog> createState() => _VideoPreviewDialogState();
}

class _VideoPreviewDialogState extends State<_VideoPreviewDialog> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final screen = MediaQuery.of(context).size;
    final maxVideoH = screen.height * 0.45;

    return Dialog(
      backgroundColor: Colors.black,
      insetPadding: EdgeInsets.symmetric(
        horizontal: screen.width * 0.04,
        vertical: screen.height * 0.06,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                _initialized
                    ? ConstrainedBox(
                        constraints: BoxConstraints(maxHeight: maxVideoH),
                        child: AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        ),
                      )
                    : SizedBox(
                        height: maxVideoH.clamp(150.0, 220.0),
                        width: double.infinity,
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: Colors.black54, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_initialized)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Column(
                children: [
                  ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (_, VideoPlayerValue val, _) => Column(
                      children: [
                        Slider(
                          value: val.position.inSeconds.toDouble(),
                          min: 0,
                          max: val.duration.inSeconds.toDouble().clamp(1, double.infinity),
                          activeColor: const Color(0xFF1068A3),
                          onChanged: (v) => _controller.seekTo(Duration(seconds: v.toInt())),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(val.position),
                                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                              Text(_formatDuration(val.duration),
                                  style: const TextStyle(color: Colors.white70, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.replay_10, color: Colors.white),
                        onPressed: () async {
                          final pos = await _controller.position ?? Duration.zero;
                          _controller.seekTo(pos - const Duration(seconds: 10));
                        },
                      ),
                      IconButton(
                        iconSize: 48,
                        icon: Icon(
                          _controller.value.isPlaying ? Icons.pause_circle : Icons.play_circle,
                          color: Colors.white,
                        ),
                        onPressed: () => setState(() {
                          _controller.value.isPlaying ? _controller.pause() : _controller.play();
                        }),
                      ),
                      IconButton(
                        icon: const Icon(Icons.forward_10, color: Colors.white),
                        onPressed: () async {
                          final pos = await _controller.position ?? Duration.zero;
                          _controller.seekTo(pos + const Duration(seconds: 10));
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
            child: Text(
              widget.fileName,
              style: const TextStyle(color: Colors.white60, fontSize: 11),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

// =====================================================================
// AUDIO PREVIEW DIALOG
// =====================================================================
class _AudioPreviewDialog extends StatefulWidget {
  final String filePath;
  final String fileName;
  const _AudioPreviewDialog({required this.filePath, required this.fileName});

  @override
  State<_AudioPreviewDialog> createState() => _AudioPreviewDialogState();
}

class _AudioPreviewDialogState extends State<_AudioPreviewDialog> {
  final AudioPlayer _player = AudioPlayer();
  PlayerState _playerState = PlayerState.stopped;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player.onPlayerStateChanged.listen((s) {
      if (mounted) setState(() => _playerState = s);
    });
    _player.onPositionChanged.listen((p) {
      if (mounted) setState(() => _position = p);
    });
    _player.onDurationChanged.listen((d) {
      if (mounted) setState(() => _duration = d);
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _fmt(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isPlaying = _playerState == PlayerState.playing;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: const Color(0xFF1A2D3D),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1068A3).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.audiotrack_rounded, color: Color(0xFF5AB6E5), size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            widget.fileName,
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 16),
          Slider(
            value: _position.inSeconds.toDouble(),
            min: 0,
            max: _duration.inSeconds.toDouble().clamp(1, double.infinity),
            activeColor: const Color(0xFF5AB6E5),
            inactiveColor: Colors.white24,
            onChanged: (v) => _player.seek(Duration(seconds: v.toInt())),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_fmt(_position), style: const TextStyle(color: Colors.white54, fontSize: 11)),
                Text(_fmt(_duration), style: const TextStyle(color: Colors.white54, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, color: Colors.white70),
                onPressed: () => _player.seek(_position - const Duration(seconds: 10)),
              ),
              IconButton(
                iconSize: 56,
                icon: Icon(
                  isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                  color: const Color(0xFF5AB6E5),
                ),
                onPressed: () async {
                  if (isPlaying) {
                    await _player.pause();
                  } else {
                    if (_playerState == PlayerState.stopped || _playerState == PlayerState.completed) {
                      await _player.play(DeviceFileSource(widget.filePath));
                    } else {
                      await _player.resume();
                    }
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.forward_10, color: Colors.white70),
                onPressed: () => _player.seek(_position + const Duration(seconds: 10)),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            _player.stop();
            Navigator.pop(context);
          },
          child: const Text('Tutup', style: TextStyle(color: Color(0xFF5AB6E5))),
        ),
      ],
    );
  }
}
