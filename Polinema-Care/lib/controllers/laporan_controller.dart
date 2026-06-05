import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import '../services/api_service.dart';
import '../models/laporan_model.dart';

import 'package:image_picker/image_picker.dart' show XFile;

class LaporanController {
  static LaporanModel activeReport = LaporanModel();
  static List<XFile> rawFiles = [];

  static void resetDraftLaporan() {
    activeReport = LaporanModel();
    rawFiles.clear();
  }

  static void simpanTahap1({
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

  static void simpanTahap2({
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

  static void simpanTahap3({
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

  static Future<bool> kirimLaporan(Map<String, dynamic> data) async {
    if (!ApiService.isAuthenticated) {
      print('Submit Report failed: User is not authenticated. Please log in first.');
      return false;
    }

    try {
      final Map<String, String> fields = {
        'judul_pelaporan': 'Laporan perundungan ${data['jenis'] ?? ''}',
        'jenis_perundungan': (data['jenis'] ?? 'Lainnya').toString(),
        'kronologi': '${data['deskripsi'] ?? ''}\n\nKorban: ${data['korban'] ?? '-'}\nSaksi: ${data['saksi'] ?? '-'}',
        'deskripsi_pelaku': (data['pelaku'] ?? '').toString(),
        'lokasi': (data['lokasi'] ?? '').toString(),
        'tanggal_kejadian': (data['tanggal_kejadian_raw'] ?? DateTime.now().toIso8601String()).toString(),
        'program_studi': (data['prodi'] ?? '').toString(),
      };

      final List<http.MultipartFile> files = [];

      for (final xfile in rawFiles) {
        if (kIsWeb) {
          final bytes = await xfile.readAsBytes();
          final multipartFile = http.MultipartFile.fromBytes(
            'bukti_files[]',
            bytes,
            filename: xfile.name,
          );
          files.add(multipartFile);
        } else {
          final file = File(xfile.path);
          if (await file.exists()) {
            final multipartFile = await http.MultipartFile.fromPath(
              'bukti_files[]',
              xfile.path,
            );
            files.add(multipartFile);
          }
        }
      }

      final response = await ApiService.postMultipart('/laporan', fields, files);
      print('Submit Report status code: ${response.statusCode}');
      print('Submit Report body: ${response.body}');
      
      if (response.statusCode == 201) {
        rawFiles.clear();
      }

      final body = jsonDecode(response.body);
      return response.statusCode == 201 && body['success'] == true;
    } catch (e) {
      print('Error submitting report: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> ambilDaftarLaporan() async {
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

  static String formatWaktu(String? rawStr) {
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
