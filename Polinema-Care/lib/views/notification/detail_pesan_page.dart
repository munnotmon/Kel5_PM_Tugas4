import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class DetailPesanPage extends StatelessWidget {
  final Map<String, dynamic>? notifData;

  const DetailPesanPage({super.key, this.notifData});

  @override
  Widget build(BuildContext context) {
    // Fallback data aman jika extra kosong
    final String senderName = notifData?['name'] ?? "Konselor Polinema Care+";
    final String specialty = notifData?['specialty'] ?? "Spesialis Klinis";

    // PERBAIKAN LOGIKA: Mengunci sebagai List<dynamic> agar terhindar dari TypeError
    final List<dynamic> messages = notifData?['messages'] ?? [];

    // Penarikan teks secara aman untuk mencegah null/error
    String lastMsgText = "Halo, mari diskusikan jadwal konsultasimu.";
    if (messages.isNotEmpty) {
      final lastMessage = messages.last;
      if (lastMessage is Map && lastMessage.containsKey('text')) {
        lastMsgText = lastMessage['text'];
      }
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Detail Notifikasi',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              width: 70,
              height: 70,
              decoration: const BoxDecoration(
                color: Color(0xFFE0F2F1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chat_bubble_rounded,
                color: Color(0xFF1068A3),
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Pesan Baru Terdeteksi",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            const SizedBox(height: 24),

            // Tampilan balon box isi pesan sinkron dengan Inbox
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pesan Terakhir:",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '"$lastMsgText"',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      color: const Color(0xFF1A2D3D),
                      height: 1.6,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // BUTTON: Langsung masuk ke room_chat dengan membawa object data asli
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  if (notifData != null) {
                    context.push('/inbox/room-chat', extra: notifData);
                  } else {
                    context.go('/inbox');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1068A3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  "Buka Percakapan",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Detail Card Pengirim
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFF1068A3),
                    backgroundImage: NetworkImage(
                      "https://i.pravatar.cc/150?u=$senderName",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          senderName,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: const Color(0xFF1A2D3D),
                          ),
                        ),
                        Text(
                          specialty,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
