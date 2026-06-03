import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart'; // Import database konselor

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ SINKRONISASI TIPE DATA DENGAN INBOX & ROOM CHAT (ANTI-CRASH TYPE)
    final Map<String, dynamic> chatAnton = {
      'name': CounselingController.konselorAt(0).name,
      'specialty': CounselingController.konselorAt(0).specialty,
      'color': const Color(0xFF1068A3),
      'isSystem': false,
      'messages': <Map<String, dynamic>>[
        {
          'text':
              'Halo Kelompok 5, ada yang bisa saya bantu diskusikan hari ini?',
          'isMe': false,
          'time': '10:43',
        },
        {
          'text':
              'Saya merasa sedikit stres akhir-akhir ini karena tekanan tugas kuliah, Dok.',
          'isMe': true,
          'time': '10:44',
        },
        {
          'text': 'Bagaimana perasaanmu hari ini?',
          'isMe': false,
          'time': '10:45',
        },
      ],
    };

    final Map<String, dynamic> chatSarah = {
      'name': CounselingController.konselorAt(3).name,
      'specialty': CounselingController.konselorAt(3).specialty,
      'color': Colors.teal,
      'isSystem': false,
      'messages': <Map<String, dynamic>>[
        {
          'text':
              'Halo Kelompok 5, link meet untuk sesi kita besok sudah siap.',
          'isMe': false,
          'time': '12 Jan',
        },
      ],
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Notifikasi',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        children: [
          _buildSectionLabel('HARI INI'),
          _buildNotifItem(
            context,
            type: 'pesan',
            title: 'Pesan dari dr. Anton Wijaya',
            desc: '“Bagaimana perasaanmu hari ini?”',
            time: '10:45',
            icon: Icons.chat_bubble_outline_rounded,
            color: const Color(0xFF1068A3),
            extraData: chatAnton,
          ),
          _buildNotifItem(
            context,
            type: 'laporan',
            title: 'Laporan Diproses (#RPT-001)',
            desc:
                'Bukti baru telah ditambahkan ke laporan Anda. Tim sedang meninjaunya.',
            time: '2 Jam Lalu',
            icon: Icons.description_outlined,
            color: const Color(0xFF3B82F6),
            extraData: null,
          ),

          _buildSectionLabel('MINGGU INI'),
          _buildNotifItem(
            context,
            type: 'pesan',
            title: 'Pesan dari dr. Sarah Johnson',
            desc:
                '“Halo Kelompok 5, link meet untuk sesi kita besok sudah siap.”',
            time: '12 Jan',
            icon: Icons.chat_bubble_outline_rounded,
            color: Colors.teal,
            extraData: chatSarah,
          ),
          _buildNotifItem(
            context,
            type: 'sistem',
            title: 'Welcome to Polinema Care+',
            desc:
                'Selamat datang di platform Respon & Konseling Polinema Care+.',
            time: 'Kemarin',
            icon: Icons.admin_panel_settings_outlined,
            color: Colors.green,
            extraData: null,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: Colors.grey[400],
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildNotifItem(
    BuildContext context, {
    required String type,
    required String title,
    required String desc,
    required String time,
    required IconData icon,
    required Color color,
    required Map<String, dynamic>? extraData,
  }) {
    return GestureDetector(
      onTap: () {
        if (type == 'laporan') {
          context.push('/notifications/detail-laporan');
        } else if (type == 'pesan') {
          context.push('/notifications/detail-pesan', extra: extraData);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: const Color(0xFF1A2D3D),
                          ),
                        ),
                      ),
                      Text(
                        time,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.4,
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
