import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HalamanRiwayat extends StatelessWidget {
  const HalamanRiwayat({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Riwayat Konseling")),
    body: const Center(child: Text("Belum ada riwayat")),
  );
}