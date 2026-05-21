// Lokasi: lib/controllers/splash_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashController {
  void startSplashTimer(BuildContext context) {
    Timer(const Duration(seconds: 3), () {
      if (context.mounted) {
        context.go('/login');
      }
    });
  }
}