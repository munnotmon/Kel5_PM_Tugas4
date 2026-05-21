import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/user_model.dart';

class ProfileController extends ChangeNotifier {
  UserModel? userData;
  bool isLoading = true;

  ProfileController() {
    fetchUserProfile();
  }

  // Simulasi pemanggilan API / Database
  Future<void> fetchUserProfile() async {
    isLoading = true;
    notifyListeners();

    // Simulasi delay jaringan
    await Future.delayed(const Duration(seconds: 1));

    // Data di-set ke model
    userData = UserModel(
      fullName: 'Kelompok 5',
      username: 'klp5_keren',
      email: 'Kelompok5Mantap@campus.edu',
      // password tidak perlu dimasukkan ke profil (biasanya disembunyikan dari UI)
    );

    isLoading = false;
    notifyListeners();
  }

  void handleLogout(BuildContext context) {
    // Tambahkan logika untuk menghapus token/session/cache di sini

    // Navigasi setelah logout
    context.go('/login');
  }
}
