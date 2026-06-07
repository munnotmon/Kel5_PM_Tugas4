import 'package:flutter/material.dart';

enum StatusKonseling { diajukan, diterima, berlangsung, selesai, dibatalkan }

class KonselingItem {
  final String id;
  final String konselor;
  final String tanggal;
  final String jam;
  final StatusKonseling status;
  final String keluhan;
  final String mode;
  final String lokasi;
  final String? catatan;
  final Map<String, dynamic>? counselorData;
  final String? catatanKonselor;
  final String? rekomendasiPemulihan;

  KonselingItem({
    required this.id,
    required this.konselor,
    required this.tanggal,
    required this.jam,
    required this.status,
    required this.keluhan,
    required this.mode,
    required this.lokasi,
    this.catatan,
    this.counselorData,
    this.catatanKonselor,
    this.rekomendasiPemulihan,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'konselor': konselor,
      'tanggal': tanggal,
      'jam': jam,
      'status': status == StatusKonseling.diajukan
          ? 'diajukan'
          : status == StatusKonseling.diterima
              ? 'diterima'
              : status == StatusKonseling.berlangsung
                  ? 'berlangsung'
                  : status == StatusKonseling.selesai
                      ? 'selesai'
                      : 'dibatalkan',
      'keluhan': keluhan,
      'mode': mode,
      'lokasi': lokasi,
      'catatan': catatan,
      'counselor': counselorData,
      'catatan_konselor': catatanKonselor,
      'rekomendasi_pemulihan': rekomendasiPemulihan,
    };
  }
}

Map<String, dynamic> getStatusInfoKonseling(StatusKonseling status) {
  switch (status) {
    case StatusKonseling.diajukan:
      return {'label': 'Diajukan', 'color': const Color(0xFFF59E0B)};
    case StatusKonseling.diterima:
      return {'label': 'Diterima', 'color': const Color(0xFF3B82F6)};
    case StatusKonseling.berlangsung:
      return {'label': 'Berlangsung', 'color': const Color(0xFF8B5CF6)}; // Elegant Purple for active sessions
    case StatusKonseling.selesai:
      return {'label': 'Selesai', 'color': const Color(0xFF10B981)};
    case StatusKonseling.dibatalkan:
      return {'label': 'Dibatalkan', 'color': const Color(0xFFEF4444)};
  }
}
