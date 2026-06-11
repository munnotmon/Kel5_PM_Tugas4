import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;

class ApiService {
  // Set true jika ingin memakai ngrok, set false jika memakai local
  static const bool useNgrok = true;

  static const String baseUrl = useNgrok
      ? 'https://engraver-stride-chatter.ngrok-free.dev/api'
      : (kIsWeb ? 'http://localhost:8000/api' : 'http://127.0.0.1:8000/api');

  static String buildImageUrl(String path) {
    if (path.isEmpty) return '';
    
    String resolvedPath = path;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      final uri = Uri.tryParse(path);
      if (uri != null) {
        final host = uri.host.toLowerCase();
        if (host == 'localhost' || host == '127.0.0.1' || host == '10.0.2.2') {
          final baseUri = Uri.parse(baseUrl);
          resolvedPath = uri.replace(
            scheme: baseUri.scheme,
            host: baseUri.host,
            port: baseUri.hasPort ? baseUri.port : null,
          ).toString();
        }
      }
      return resolvedPath;
    }
    
    final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    final serverRoot = baseUrl.endsWith('/api') 
        ? baseUrl.substring(0, baseUrl.length - 4) 
        : baseUrl;
    return '$serverRoot/storage/$cleanPath';
  }

  // Header wajib untuk Image.network() agar ngrok tidak redirect ke halaman warning
  static Map<String, String> get imageHeaders => useNgrok
      ? {'ngrok-skip-browser-warning': 'true'}
      : {};

  static String? _token;

  static void setToken(String? token) {
    _token = token;
  }

  static bool get isAuthenticated => _token != null;
  static String? get token => _token;

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

  static const _timeout = Duration(seconds: 15);
  static const _uploadTimeout = Duration(seconds: 60);

  static Future<http.Response> get(String endpoint) async {
    final url = Uri.parse('$baseUrl$endpoint');
    try {
      return await http.get(url, headers: _getHeaders()).timeout(_timeout);
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
      ).timeout(_timeout);
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
      if (useNgrok) {
        request.headers['ngrok-skip-browser-warning'] = 'true';
      }

      request.fields.addAll(fields);
      request.files.addAll(files);

      final streamedResponse = await request.send().timeout(_uploadTimeout);
      return await http.Response.fromStream(streamedResponse);
    } catch (e) {
      return http.Response(jsonEncode({'success': false, 'message': 'Upload file gagal: $e'}), 500);
    }
  }
}