class AuthController {
  static String get currentUserName => "Kelompok 5";

  static bool validateLogin(String email, String password) {
    return email == "admin@gmail.com" && password == "123456";
  }

  static bool validateRegister(String name, String nim, String email, String password) {
    return name.isNotEmpty && nim.isNotEmpty && email.isNotEmpty && password.length >= 6;
  }
}
