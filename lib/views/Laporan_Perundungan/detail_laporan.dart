// lib/views/laporan/detail_laporan.dart
//
// Halaman detail untuk laporan yang sudah ada di tab Activity.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import 'laporan_widgets.dart';

class HalamanDetailLaporan extends StatelessWidget {
  const HalamanDetailLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () =>
              context.canPop() ? context.pop() : context.go('/activity'),
        ),
        title: Text(
          'Detail Laporan',
          style: GoogleFonts.plusJakartaSans(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      // TODO: Ganti dengan data nyata dari API / argument routing
      body: const Center(
        child: Text('Halaman Detail Laporan — coming soon'),
      ),
    );
  }
}