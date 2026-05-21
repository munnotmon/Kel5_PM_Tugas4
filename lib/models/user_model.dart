// Lokasi: lib/models/user_model.dart
class UserModel {
  final String? fullName;
  final String? username;
  final String email;
  final String? password;

  UserModel({
    this.fullName,
    this.username,
    required this.email,
    this.password,
  });
}