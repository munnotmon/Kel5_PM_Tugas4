import 'package:flutter/material.dart';
import '../models/laporan_model.dart';

class LaporanController extends ChangeNotifier {
  final LaporanModel _laporanData = LaporanModel();
  bool _isSubmitting = false;

  LaporanModel get laporanData => _laporanData;
  bool get isSubmitting => _isSubmitting;

  void updateStep1({required String nama, required String nim, required String telepon, required String prodi}) {
    _laporanData.nama = nama;
    _laporanData.nim = nim;
    _laporanData.telepon = telepon;
    _laporanData.prodi = prodi;
    notifyListeners();
  }

  void updateStep2({required String jenisPerundungan, required String deskripsi}) {
    _laporanData.jenisPerundungan = jenisPerundungan;
    _laporanData.deskripsi = deskripsi;
    notifyListeners();
  }

  void updateStep3({required String lokasi, required String tanggal}) {
    _laporanData.lokasi = lokasi;
    _laporanData.tanggal = tanggal;
    notifyListeners();
  }

  void updateStep4({required String buktiPath}) {
    _laporanData.buktiPath = buktiPath;
    notifyListeners();
  }

  Future<bool> submitLaporan() async {
    _isSubmitting = true;
    notifyListeners();

    // Simulasi pengiriman ke server/database
    await Future.delayed(const Duration(seconds: 2));

    // Reset data setelah berhasil
    _laporanData.clear();
    
    _isSubmitting = false;
    notifyListeners();
    return true;
  }
}
