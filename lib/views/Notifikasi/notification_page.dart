// Lokasi: lib/views/Notifikasi/notification_page.dart
import 'package:flutter/material.dart';

// Import model notifikasi
import '../../models/notifikasi_model.dart'; 
import 'detail_laporan_page.dart';
import 'detail_pesan_page.dart';

class NotificationsPage extends StatelessWidget { // Ganti nama class agar sesuai dengan panggilan di home.dart
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  _buildSectionLabel('Hari Ini'),
                  // Panggil data dari todayNotifs
                  ...todayNotifs.map((n) => _buildNotifItem(context, n)),
                  _buildSectionLabel('Kemarin'),
                  // Panggil data dari yesterdayNotifs
                  ...yesterdayNotifs.map((n) => _buildNotifItem(context, n)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFECE9E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.black38,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildNotifItem(BuildContext context, Map<String, dynamic> notif) {
    final color = notif['color'] as Color;
    return GestureDetector(
      onTap: () {
        if (notif['type'] == 'laporan') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailLaporanPage()));
        } else if (notif['type'] == 'pesan') {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const DetailPesanPage()));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(notif['icon'] as IconData, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notif['title'],
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notif['desc'],
                    style: const TextStyle(fontSize: 11, color: Colors.black45, height: 1.4),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    notif['time'],
                    style: const TextStyle(fontSize: 10, color: Colors.black38),
                  ),
                ],
              ),
            ),
            if (notif['unread'] == true)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
      ),
    );
  }
}