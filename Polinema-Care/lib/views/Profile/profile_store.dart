import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Shared state untuk data profil user.
/// Dipakai bersama oleh ProfileScreen dan EditProfileScreen.
class ProfileStore {
  static final ValueNotifier<String> nama = ValueNotifier('Kelompok 5');
  static final ValueNotifier<String> username = ValueNotifier('kelompok5');
  static final ValueNotifier<String> email = ValueNotifier('');
  static final ValueNotifier<String> nomorTelepon = ValueNotifier('');
  static final ValueNotifier<String> programStudi = ValueNotifier('');
  static final ValueNotifier<String> angkatan = ValueNotifier('');
  static final ValueNotifier<String> photoUrl = ValueNotifier('');
  static final ValueNotifier<Uint8List?> photo = ValueNotifier(null);

  static const String _photoKeyPrefix = 'profile_photo_';

  /// Memperbarui state profil dari data controller.
  static void update({
    required String namaVal,
    required String usernameVal,
    required String emailVal,
    required String nomorTeleponVal,
    required String programStudiVal,
    required String angkatanVal,
    required String photoUrlVal,
  }) {
    nama.value = namaVal;
    username.value = usernameVal;
    email.value = emailVal;
    nomorTelepon.value = nomorTeleponVal;
    programStudi.value = programStudiVal;
    angkatan.value = angkatanVal;
    photoUrl.value = photoUrlVal;
    photo.value = null;
  }

  /// Simpan bytes foto ke memori dan SharedPreferences (persisten lintas sesi).
  /// [userKey] biasanya email user agar tiap akun punya cache sendiri.
  static Future<void> savePhotoBytes(String userKey, Uint8List bytes) async {
    photo.value = bytes;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('$_photoKeyPrefix$userKey', base64Encode(bytes));
    } catch (_) {}
  }

  /// Muat bytes foto dari SharedPreferences ke memori.
  static Future<void> loadPhotoBytes(String userKey) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final b64 = prefs.getString('$_photoKeyPrefix$userKey');
      if (b64 != null && b64.isNotEmpty) {
        photo.value = base64Decode(b64);
      }
    } catch (_) {}
  }
}
