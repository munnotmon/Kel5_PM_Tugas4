import 'package:flutter/material.dart';

class DetailSesi extends StatelessWidget {
  const DetailSesi({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text("Detail Sesi")),
    body: const Center(child: Text("Detail sesi tersedia di sini")),
  );
}