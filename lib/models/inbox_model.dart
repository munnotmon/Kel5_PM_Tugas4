// Lokasi: lib/models/inbox_model.dart
import 'package:flutter/material.dart';

// Data list percakapan dipindah ke Model
final List<Map<String, dynamic>> dummyChats = [
  {
    'name': 'Dr. Anton Wijaya',
    'preview': 'Bagaimana perasaa...',
    'time': '10:45',
    'unread': 2,
    'initials': 'AW',
    'color': Colors.blue,
    'isDoctor': true,
  },
  {
    'name': 'Update Keamanan',
    'preview': 'Laporan anonim Anda telah dit...',
    'time': '09:12',
    'unread': 0,
    'initials': '',
    'color': Colors.green,
    'isSystem': true,
  },
  {
    'name': 'Siska Pratama, ...',
    'preview': 'Terima kasih sudah berb...',
    'time': 'Kemarin',
    'unread': 0,
    'initials': 'SP',
    'color': Colors.orange,
    'isDoctor': true,
  },
  {
    'name': 'Bantuan Teknis',
    'preview': 'Halo, ada yang bisa kami bant...',
    'time': 'Senin',
    'unread': 0,
    'initials': '',
    'color': Colors.blueGrey,
    'isSystem': true,
  },
  {
    'name': 'Budi Santoso',
    'preview': 'Sesi konsultasi telah selesai. T...',
    'time': '12 Jan',
    'unread': 0,
    'initials': 'BS',
    'color': Colors.purple,
    'isDoctor': true,
  },
];