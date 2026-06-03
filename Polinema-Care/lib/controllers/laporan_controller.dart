import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../models/laporan_model.dart';

class LaporanController {
  static LaporanModel activeReport = LaporanModel();

  static void resetActiveReport() {
    activeReport = LaporanModel();
  }

  static void updateStep1({
    required String nama,
    required String nim,
    required String telepon,
    required String prodi,
  }) {
    activeReport = activeReport.copyWith(
      nama: nama,
      nim: nim,
      telepon: telepon,
      prodi: prodi,
    );
  }

  static void updateStep2({
    required String waktu,
    required String lokasi,
    required String jenis,
    required String deskripsi,
    required List<String> lampiran,
  }) {
    activeReport = activeReport.copyWith(
      waktu: waktu,
      lokasi: lokasi,
      jenis: jenis,
      deskripsi: deskripsi,
      lampiran: lampiran,
    );
  }

  static void updateStep3({
    required String korban,
    required String pelaku,
    required String saksi,
  }) {
    activeReport = activeReport.copyWith(
      korban: korban,
      pelaku: pelaku,
      saksi: saksi,
    );
  }

  static Future<bool> submitReport(Map<String, dynamic> data) async {
    if (!ApiService.isAuthenticated) {
      print('Submit Report failed: User is not authenticated. Please log in first.');
      return false;
    }

    try {
      final Map<String, String> fields = {
        'judul_pelaporan': 'Laporan perundungan ${data['jenis'] ?? ''}',
        'jenis_perundungan': (data['jenis'] ?? 'Lainnya').toString(),
        'kronologi': (data['deskripsi'] ?? '').toString() + 
            '\n\nKorban: ' + (data['korban'] ?? '-').toString() + 
            '\nSaksi: ' + (data['saksi'] ?? '-').toString(),
        'deskripsi_pelaku': (data['pelaku'] ?? '').toString(),
        'lokasi': (data['lokasi'] ?? '').toString(),
        'tanggal_kejadian': (data['tanggal_kejadian_raw'] ?? DateTime.now().toIso8601String()).toString(),
      };

      final List<http.MultipartFile> files = [];
      final List<dynamic> lampiran = data['lampiran'] ?? [];
      
      if (!kIsWeb) {
        for (final path in lampiran) {
          if (path is String && path.isNotEmpty) {
            final file = File(path);
            if (await file.exists()) {
              final multipartFile = await http.MultipartFile.fromPath('bukti_files[]', path);
              files.add(multipartFile);
            }
          }
        }
      } else {
        if (lampiran.isNotEmpty) {
          print('File upload via path is not supported on web. Skipping file upload.');
        }
      }

      final response = await ApiService.postMultipart('/laporan', fields, files);
      print('Submit Report status code: ${response.statusCode}');
      print('Submit Report body: ${response.body}');
      final body = jsonDecode(response.body);
      return response.statusCode == 201 && body['success'] == true;
    } catch (e) {
      print('Error submitting report: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> fetchReports() async {
    try {
      final response = await ApiService.get('/laporan');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final List list = body['data'] ?? [];
        return List<Map<String, dynamic>>.from(list);
      }
    } catch (e) {
      print('Error fetching reports: $e');
    }
    return [];
  }

  static String formatDateTime(String? rawStr) {
    if (rawStr == null || rawStr == '-') return '-';
    try {
      final dt = DateTime.parse(rawStr).toLocal();
      final months = [
        'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
        'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
      ];
      final hasTime = rawStr.contains('T') || (rawStr.contains(' ') && rawStr.split(' ')[1].contains(':'));
      if (hasTime) {
        return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
            '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } else {
        return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
      }
    } catch (e) {
      return rawStr;
    }
  }
}
