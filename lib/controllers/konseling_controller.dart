import 'package:flutter/material.dart';
import '../models/konselor_model.dart';
import '../views/konseling/data_konselor.dart'; // Hanya untuk ambil mock data saat inisialisasi

class KonselingController extends ChangeNotifier {
  List<KonselorModel> _konselorList = [];
  bool _isLoading = false;

  List<KonselorModel> get konselorList => _konselorList;
  bool get isLoading => _isLoading;

  KonselingController() {
    _loadMockData();
  }

  void _loadMockData() {
    // Mengubah map dari data_konselor menjadi object KonselorModel
    _konselorList = daftarKonselor.map((json) => KonselorModel.fromJson(json)).toList();
    notifyListeners();
  }

  List<KonselorModel> searchKonselor(String query) {
    if (query.isEmpty) return _konselorList;
    
    return _konselorList.where((k) {
      return k.name.toLowerCase().contains(query.toLowerCase()) || 
             k.specialty.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}
