import 'package:flutter/foundation.dart';

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
  static final ValueNotifier<Uint8List?> photo = ValueNotifier(null); // Local image bytes for preview

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
    photo.value = null; // Reset local preview image bytes
  }
}