import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/api_service.dart';

/// Widget untuk menampilkan gambar dari URL yang membutuhkan header khusus
/// (misalnya ngrok-skip-browser-warning). Menggunakan http package agar
/// header pasti terkirim, lalu menampilkan dengan Image.memory.
class ApiImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget Function(BuildContext)? errorWidget;
  final Widget Function(BuildContext)? loadingWidget;

  const ApiImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.errorWidget,
    this.loadingWidget,
  });

  @override
  State<ApiImage> createState() => _ApiImageState();
}

class _ApiImageState extends State<ApiImage> {
  late Future<Uint8List?> _future;

  @override
  void initState() {
    super.initState();
    _future = _fetchImage();
  }

  @override
  void didUpdateWidget(ApiImage old) {
    super.didUpdateWidget(old);
    if (old.url != widget.url) {
      _future = _fetchImage();
    }
  }

  Future<Uint8List?> _fetchImage() async {
    try {
      final headers = {
        ...ApiService.imageHeaders,
        if (ApiService.isAuthenticated)
          'Authorization': 'Bearer ${ApiService.token}',
      };
      final response = await http
          .get(Uri.parse(widget.url), headers: headers)
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) return response.bodyBytes;
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: widget.loadingWidget?.call(context) ??
                const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
          );
        }
        if (snap.data == null) {
          return SizedBox(
            width: widget.width,
            height: widget.height,
            child: widget.errorWidget?.call(context) ??
                Container(
                  color: const Color(0xFFF1F5F9),
                  child: const Center(
                    child: Icon(Icons.broken_image_rounded,
                        color: Color(0xFF94A3B8), size: 36),
                  ),
                ),
          );
        }
        return Image.memory(
          snap.data!,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
        );
      },
    );
  }
}
