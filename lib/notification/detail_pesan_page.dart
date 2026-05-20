import 'package:flutter/material.dart';
import '../inbox/counseling.dart';

class DetailPesanPage extends StatelessWidget {
  const DetailPesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3FC98A),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3FC98A).withValues(alpha: 0.45),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.message_rounded, color: Colors.white, size: 24),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Pesan Baru dari Konselor',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Tadi, 09:41',
                      style: TextStyle(fontSize: 10, color: Colors.black38),
                    ),
                    const SizedBox(height: 14),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F2F5),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                              bottomRight: Radius.circular(18),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Text(
                            'Halo, saya sudah meninjau jadwal Anda. Silakan periksa kotak masuk untuk melihat saran waktu konsultasi terbaru. Jangan ragu untuk membalas jika waktu tersebut kurang sesuai.',
                            style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CounselingPage()),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4A9FD4),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 13),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                            elevation: 4,
                            shadowColor: const Color(0xFF4A9FD4).withValues(alpha: 0.4),
                            textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                          child: const Text('Buka Percakapan'),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF2563EB).withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text('SA', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Dr. Sarah Althea', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                                Text('Konselor Haven Guard', style: TextStyle(fontSize: 10, color: Colors.black38)),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                width: 7,
                                height: 7,
                                decoration: const BoxDecoration(color: Color(0xFF22C55E), shape: BoxShape.circle),
                              ),
                              const SizedBox(width: 4),
                              const Text('ONLINE', style: TextStyle(fontSize: 9, color: Color(0xFF22C55E), fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Pesan ini bersifat rahasia. Identitas Anda terlindungi dan tidak ada informasi yang dikirim ke pihak ketiga tanpa persetujuan Anda.',
                        style: TextStyle(fontSize: 9, color: Colors.black38, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: const Color(0xFFECE9E0),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, size: 14, color: Colors.black87),
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            'Detail Notifikasi',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}