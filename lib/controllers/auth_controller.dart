import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulasi delay API
    await Future.delayed(const Duration(seconds: 1));

    bool success = false;
    
    // Mock validasi
    if (email == 'admin@gmail.com' && password == '123456') {
      _currentUser = UserModel(
        uid: 'admin_1', 
        email: email, 
        name: 'Administrator', 
        role: 'admin'
      );
      success = true;
    } else if (email == 'user@gmail.com' && password == '123456') {
      _currentUser = UserModel(
        uid: 'user_1', 
        email: email, 
        name: 'Mahasiswa', 
        role: 'user'
      );
      success = true;
    }

    _isLoading = false;
    notifyListeners();
    return success;
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
