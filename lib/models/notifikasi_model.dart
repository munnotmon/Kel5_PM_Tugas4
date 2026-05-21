// Lokasi: lib/models/notifikasi_model.dart
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> todayNotifs = const [
  {
    'title': 'Pesan dari Konselor',
    'desc': 'Halo, silakan periksa jadwal konsultasi Anda yang baru saja diperbarui.',
    'time': '09:41',
    'icon': Icons.message_rounded,
    'color': Color(0xFF2563EB),
    'unread': true,
    'type': 'pesan',
  },
  {
    'title': 'Laporan Diproses',
    'desc': 'Laporan anonim Anda sedang ditinjau oleh tim keamanan kampus.',
    'time': '08:15',
    'icon': Icons.description_rounded,
    'color': Color(0xFFF59E0B),
    'unread': true,
    'type': 'laporan',
  },
  {
    'title': 'Pesan dari Konselor',
    'desc': 'Halo, silakan periksa jadwal konsultasi Anda yang baru saja diperbarui.',
    'time': '09:41',
    'icon': Icons.message_rounded,
    'color': Color(0xFF2563EB),
    'unread': false,
    'type': 'pesan',
  },
  {
    'title': 'Laporan Diproses',
    'desc': 'Laporan anonim Anda sedang ditinjau oleh tim keamanan kampus.',
    'time': '08:15',
    'icon': Icons.description_rounded,
    'color': Color(0xFFF59E0B),
    'unread': false,
    'type': 'laporan',
  },
];

final List<Map<String, dynamic>> yesterdayNotifs = const [
  {
    'title': 'Peringatan Keamanan',
    'desc': 'Seseorang mencoba masuk ke akun Anda dari perangkat yang tidak dikenal.',
    'time': '14:28',
    'icon': Icons.warning_rounded,
    'color': Color(0xFFEF4444),
    'unread': false,
    'type': 'keamanan',
  },
  {
    'title': 'Tips Kesehatan Mental',
    'desc': 'Temukan cara mengelola stres akademik melalui artikel terbaru kami.',
    'time': '10:00',
    'icon': Icons.lightbulb_rounded,
    'color': Color(0xFF22C55E),
    'unread': false,
    'type': 'tips',
  },
];