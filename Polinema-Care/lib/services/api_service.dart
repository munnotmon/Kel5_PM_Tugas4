import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  // Gunakan 127.0.0.1 agar mendukung perintah `adb reverse tcp:8000 tcp:8000` baik untuk HP fisik maupun emulator.
  static const String baseUrl = kIsWeb ? 'http://localhost:8000/api' : 'http://127.0.0.1:8000/api';

  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static bool get isAuthenticated => _token != null;

  static Map<String, String> _getHeaders() {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      return await http.get(url, headers: _getHeaders());
    } catch (e) {
      return http.Response(jsonEncode({'success': false, 'message': 'Koneksi ke server gagal: $e'}), 500);
    }
  }

  static Future<http.Response> post(String endpoint, Map<String, dynamic> body) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      return await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode(body),
      );
    } catch (e) {
      return http.Response(jsonEncode({'success': false, 'message': 'Koneksi ke server gagal: $e'}), 500);
    }
  }

  static Future<http.Response> postMultipart(
    String endpoint, 
    Map<String, String> fields, 
    List<http.MultipartFile> files
  ) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final request = http.MultipartRequest('POST', url);
      
      if (_token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      request.headers['Accept'] = 'application/json';

      request.fields.addAll(fields);
      request.files.addAll(files);

      final streamedResponse = await request.send();
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      return http.Response(jsonEncode({'success': false, 'message': 'Upload file gagal: $e'}), 500);
    }
  }
}
