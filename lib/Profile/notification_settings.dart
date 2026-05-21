import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Push notification toggles
  bool _laporanBaru = true;
  bool _pesanBaru = true;
  bool _pengingatSesi = true;

  // Email notification toggles
  bool _updateSistem = false;
  bool _salinanLaporan = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            _buildHeroBanner(),
            const SizedBox(height: 28),
            _buildSectionHeader(
              label: 'Notifikasi Aplikasi',
              sublabel: 'PUSH NOTIFICATIONS',
              icon: Icons.phone_android_rounded,
            ),
            const SizedBox(height: 12),
            _buildNotifCard([
              _NotifItem(
                icon: Icons.description_rounded,
                iconColor: const Color(0xFF2A9B6E),
                iconBg: const Color(0xFFDDF5EC),
                title: 'Laporan Baru',
                subtitle: 'Update tentang status laporan Anda',
                value: _laporanBaru,
                onChanged: (v) => setState(() => _laporanBaru = v),
              ),
              _NotifItem(
                icon: Icons.chat_bubble_outline_rounded,
                iconColor: const Color(0xFF1A6B8A),
                iconBg: const Color(0xFFDEF0F8),
                title: 'Pesan Baru',
                subtitle: 'Notifikasi obrolan dari konselor',
                value: _pesanBaru,
                onChanged: (v) => setState(() => _pesanBaru = v),
              ),
              _NotifItem(
                icon: Icons.event_repeat_rounded,
                iconColor: const Color(0xFF2A7B8A),
                iconBg: const Color(0xFFDEF0F8),
                title: 'Pengingat Sesi Konseling',
                subtitle: '15 menit sebelum sesi dimulai',
                value: _pengingatSesi,
                onChanged: (v) => setState(() => _pengingatSesi = v),
                isLast: true,
              ),
            ]),
            const SizedBox(height: 28),
            _buildSectionHeader(
              label: 'Notifikasi Email',
              sublabel: 'EMAIL DELIVERY',
              icon: Icons.mail_outline_rounded,
            ),
            const SizedBox(height: 12),
            _buildNotifCard([
              _NotifItem(
                icon: Icons.update_rounded,
                iconColor: const Color(0xFF8A97A8),
                iconBg: const Color(0xFFF0F2F5),
                title: 'Update Sistem',
                subtitle: 'Info fitur baru dan kebijakan',
                value: _updateSistem,
                onChanged: (v) => setState(() => _updateSistem = v),
              ),
              _NotifItem(
                icon: Icons.task_alt_rounded,
                iconColor: const Color(0xFF8A97A8),
                iconBg: const Color(0xFFF0F2F5),
                title: 'Salinan Laporan',
                subtitle: 'Kirim salinan laporan ke email',
                value: _salinanLaporan,
                onChanged: (v) => setState(() => _salinanLaporan = v),
                isLast: true,
              ),
            ]),
            const SizedBox(height: 28),
            _buildSecurityNote(),
            const SizedBox(height: 48),
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
        'Pengaturan Notifikasi',
        style: GoogleFonts.plusJakartaSans(
          color: const Color(0xFF1A6B8A),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildHeroBanner() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFD6EEF8), Color(0xFFB8DFF0)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Text content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Pilih yang Penting',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: 190,
                  child: Text(
                    'Atur bagaimana Haven Guard memberi tahu Anda tentang pembaruan keamanan dan sesi.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: const Color(0xFF3D5A70),
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Bell illustration on the right — tanpa gradient gelap
          Positioned(
            right: 16,
            top: 0,
            bottom: 0,
            child: Center(
              child: Icon(
                Icons.notifications_rounded,
                size: 80,
                color: const Color(0xFFD4A017).withOpacity(0.75),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required String label,
    required String sublabel,
    required IconData icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A6B8A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                sublabel,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[400],
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
        Icon(icon, color: Colors.grey[400], size: 22),
      ],
    );
  }

  Widget _buildNotifCard(List<_NotifItem> items) {
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
        children: items.map((item) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    // Icon
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: item.iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(item.icon, color: item.iconColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    // Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF1A2D3D),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            item.subtitle,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Toggle
                    Transform.scale(
                      scale: 0.9,
                      child: Switch(
                        value: item.value,
                        onChanged: item.onChanged,
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF1A6B8A),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFFCDD5DE),
                        trackOutlineColor:
                            const WidgetStatePropertyAll(Colors.transparent),
                      ),
                    ),
                  ],
                ),
              ),
              if (!item.isLast)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1, color: Color(0xFFF0F2F5)),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0xFFCDD5DE),
          style: BorderStyle.solid,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.5),
      ),
      child: Text(
        '"Keamanan Anda adalah prioritas kami. Beberapa notifikasi sistem mendesak akan tetap dikirimkan meskipun pengaturan di atas dinonaktifkan."',
        textAlign: TextAlign.center,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13,
          color: const Color(0xFF5A7080),
          fontStyle: FontStyle.italic,
          height: 1.6,
        ),
      ),
    );
  }
}

class _NotifItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  const _NotifItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });
}