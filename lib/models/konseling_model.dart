// lib/models/konseling_model.dart
import 'package:flutter/material.dart';

enum StatusKonseling { menunggu, dikonfirmasi, selesai, dibatalkan }

class KonselingItem {
  final String id;
  final String konselor;
  final String tanggal;
  final String jam;
  final StatusKonseling status;

  KonselingItem({
    required this.id,
    required this.konselor,
    required this.tanggal,
    required this.jam,
    required this.status,
  });
}

List<KonselingItem> riwayatKonselingList = [
  KonselingItem(
    id: 'KSL-001',
    konselor: 'dr. Sarah Johnson',
    tanggal: '12 Okt 2026',
    jam: '14:00 - 15:00',
    status: StatusKonseling.dikonfirmasi,
  ),
  KonselingItem(
    id: 'KSL-002',
    konselor: 'dr. Anton Wijaya',
    tanggal: '28 Sep 2026',
    jam: '13:00 - 14:00',
    status: StatusKonseling.selesai,
  ),
];

Map<String, dynamic> getStatusInfoKonseling(StatusKonseling status) {
  switch (status) {
    case StatusKonseling.menunggu:
      return {'label': 'Menunggu', 'color': const Color(0xFFF59E0B)};
    case StatusKonseling.dikonfirmasi:
      return {'label': 'Dikonfirmasi', 'color': const Color(0xFF3B82F6)};
    case StatusKonseling.selesai:
      return {'label': 'Selesai', 'color': const Color(0xFF10B981)};
    case StatusKonseling.dibatalkan:
      return {'label': 'Dibatalkan', 'color': const Color(0xFFEF4444)};
  }
}