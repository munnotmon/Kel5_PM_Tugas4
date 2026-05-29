// Lokasi: lib/views/Profile/profile_store.dart
import 'dart:typed_data';
import 'package:flutter/foundation.dart';

/// Shared state untuk data profil user.
/// Dipakai bersama oleh ProfileScreen dan EditProfileScreen.
class ProfileStore {
  static final ValueNotifier<String> nama = ValueNotifier('Kelompok 5');
  static final ValueNotifier<String> username = ValueNotifier('kelompok5');
  static final ValueNotifier<Uint8List?> photo = ValueNotifier(null);
}