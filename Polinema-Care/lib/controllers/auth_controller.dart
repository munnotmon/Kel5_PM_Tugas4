import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';
import '../views/Profile/profile_store.dart';
import 'counseling_controller.dart';

class AuthController {
  static Map<String, dynamic>? _currentUser;

  static Map<String, dynamic>? get currentUser => _currentUser;

  static String get currentUserName => _currentUser?['nama'] ?? "User";
  static String get currentUserEmail => _currentUser?['email'] ?? "";
  static String get currentUserPhone => _currentUser?['nomor_telepon'] ?? "";
  static String get currentUserNim => _currentUser?['profil_mahasiswa']?['nim'] ?? "";
  static String get currentUserProdi => _currentUser?['profil_mahasiswa']?['program_studi'] ?? "";
  static String get currentUserAngkatan => _currentUser?['profil_mahasiswa']?['angkatan']?.toString() ?? "";
  static String get currentUserFoto => _currentUser?['foto_profil'] ?? "";

  /// Menyinkronkan data user dengan ProfileStore.
  static void _syncStore() {
    ProfileStore.update(
      namaVal: currentUserName,
      usernameVal: currentUserNim,
      emailVal: currentUserEmail,
      nomorTeleponVal: currentUserPhone,
      programStudiVal: currentUserProdi,
      angkatanVal: currentUserAngkatan,
      photoUrlVal: currentUserFoto,
    );
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiService.post('/login', {
      'email': email,
      'password': password,
    });

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      final user = body['data']['user'];
      if (user['role'] != 'mahasiswa') {
        return {
          'success': false,
          'message': 'Akses ditolak. Aplikasi ini hanya untuk Mahasiswa.'
        };
      }
      final token = body['data']['token'];
      _currentUser = user;
      ApiService.setToken(token);
      _syncStore();
      CounselingController.fetchKonselor(); // prefetch cache konselor
      return {'success': true};
    } else {
      return {
        'success': false,
        'message': body['message'] ?? 'Email atau password salah.'
      };
    }
  }

  static Future<Map<String, dynamic>> loginWithGoogle({
    required String email,
    required String name,
  }) async {
    final response = await ApiService.post('/login-google', {
      'email': email,
      'name': name,
    });

    final body = jsonDecode(response.body);
    if (response.statusCode == 200 && body['success'] == true) {
      final user = body['data']['user'];
      if (user['role'] != 'mahasiswa') {
        return {
          'success': false,
          'message': 'Akses ditolak. Aplikasi ini hanya untuk Mahasiswa.'
        };
      }
      final token = body['data']['token'];
      _currentUser = user;
      ApiService.setToken(token);
      _syncStore();
      CounselingController.fetchKonselor(); // prefetch cache konselor
      return {'success': true};
    } else {
      return {
        'success': false,
        'message': body['message'] ?? 'Login dengan Google gagal.'
      };
    }
  }

  static Future<Map<String, dynamic>> register({
    required String nama,
    required String nim,
    required String email,
    required String password,
    String? nomorTelepon,
    String? programStudi,
    int? angkatan,
  }) async {
    final response = await ApiService.post('/register', {
      'nama': nama,
      'nim': nim,
      'email': email,
      'password': password,
      'nomor_telepon': nomorTelepon,
      'program_studi': programStudi ?? 'Teknologi Informasi',
      'angkatan': angkatan ?? 2026,
    });

    final body = jsonDecode(response.body);
    if (response.statusCode == 201 && body['success'] == true) {
      final token = body['data']['token'];
      _currentUser = body['data']['user'];
      ApiService.setToken(token);
      _syncStore();
      CounselingController.fetchKonselor(); // prefetch cache konselor
      return {'success': true};
    } else {
      return {
        'success': false,
        'message': body['message'] ?? 'Registrasi gagal. NIM atau Email sudah terdaftar.'
      };
    }
  }

  static Future<Map<String, dynamic>> updateProfile({
    required String nama,
    required String nomorTelepon,
    required String programStudi,
    required int angkatan,
    XFile? photoFile,
  }) async {
    try {
      final fields = {
        'nama': nama,
        'nomor_telepon': nomorTelepon,
        'program_studi': programStudi,
        'angkatan': angkatan.toString(),
      };

      final List<http.MultipartFile> files = [];
      if (photoFile != null) {
        final bytes = await photoFile.readAsBytes();
        final multipartFile = http.MultipartFile.fromBytes(
          'foto_profil',
          bytes,
          filename: photoFile.name,
        );
        files.add(multipartFile);
      }

      final response = await ApiService.postMultipart('/profile/update', fields, files);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body['success'] == true) {
        _currentUser = body['data'];
        _syncStore();
        return {'success': true, 'message': body['message'] ?? 'Profil berhasil diperbarui'};
      } else {
        return {
          'success': false,
          'message': body['message'] ?? 'Gagal memperbarui profil.'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Gagal memperbarui profil: $e'
      };
    }
  }

  static Future<void> logout() async {
    _currentUser = null;
    ApiService.setToken(null);
    try {
      // Fire-and-forget backend token deletion
      ApiService.post('/logout', {});
    } catch (e) {
      print('Background logout failed: $e');
    }
  }
}
