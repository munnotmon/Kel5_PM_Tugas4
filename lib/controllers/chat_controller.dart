import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import 'counseling_controller.dart';

class ChatController {
  static final List<ChatSession> _allChats = [
    // --- KONSELOR ---
    ChatSession(
      name: CounselingController.daftarKonselor[0].name,
      specialty: CounselingController.daftarKonselor[0].specialty,
      isSystem: false,
      color: const Color(0xFF1068A3),
      unread: 2,
      messages: [
        ChatMessage(
          text: 'Halo Kelompok 5, ada yang bisa saya bantu diskusikan hari ini?',
          isMe: false,
          time: '10:43',
        ),
        ChatMessage(
          text: 'Saya merasa sedikit stres akhir-akhir ini karena tekanan tugas kuliah, Dok.',
          isMe: true,
          time: '10:44',
        ),
        ChatMessage(
          text: 'Bagaimana perasaanmu hari ini?',
          isMe: false,
          time: '10:45',
        ),
      ],
    ),
    ChatSession(
      name: CounselingController.daftarKonselor[1].name,
      specialty: CounselingController.daftarKonselor[1].specialty,
      isSystem: false,
      color: Colors.orange,
      unread: 0,
      messages: [
        ChatMessage(
          text: 'Sesi kemarin sangat membantu, terima kasih Siska.',
          isMe: true,
          time: 'Kemarin, 14:00',
        ),
        ChatMessage(
          text: 'Terima kasih sudah berbagi cerita, Kelompok 5. Tetap semangat ya!',
          isMe: false,
          time: 'Kemarin, 14:05',
        ),
      ],
    ),
    ChatSession(
      name: CounselingController.daftarKonselor[2].name,
      specialty: CounselingController.daftarKonselor[2].specialty,
      isSystem: false,
      color: Colors.purple,
      unread: 0,
      messages: [
        ChatMessage(
          text: 'Apakah besok ada jadwal bimbingan kosong?',
          isMe: true,
          time: 'Senin, 09:00',
        ),
        ChatMessage(
          text: 'Sesi bimbingan akademismu besok ya jam 10 pagi.',
          isMe: false,
          time: 'Senin, 09:15',
        ),
      ],
    ),
    ChatSession(
      name: CounselingController.daftarKonselor[3].name,
      specialty: CounselingController.daftarKonselor[3].specialty,
      isSystem: false,
      color: Colors.teal,
      unread: 0,
      messages: [
        ChatMessage(
          text: 'Halo Kelompok 5, link meet untuk sesi kita besok sudah siap.',
          isMe: false,
          time: '12 Jan',
        ),
      ],
    ),

    // --- SISTEM ---
    ChatSession(
      name: 'Sistem Respon',
      specialty: 'Pusat Informasi Otomatis',
      isSystem: true,
      icon: Icons.campaign_outlined,
      color: const Color(0xFF1068A3),
      unread: 1,
      messages: [
        ChatMessage(
          text: 'Laporan Anda #RPT-001 telah diterima.',
          isMe: false,
          time: 'Kemarin',
        ),
        ChatMessage(
          text: 'Bukti baru telah ditambahkan ke laporan Anda. Tim sedang meninjaunya.',
          isMe: false,
          time: '2 Jam Lalu',
        ),
      ],
    ),
    ChatSession(
      name: 'Admin Kampus',
      specialty: 'Pusat Informasi Otomatis',
      isSystem: true,
      icon: Icons.admin_panel_settings_outlined,
      color: Colors.green,
      unread: 0,
      messages: [
        ChatMessage(
          text: 'Selamat datang di platform Respon & Konseling Polinema Care+.',
          isMe: false,
          time: 'Kemarin',
        ),
      ],
    ),
    ChatSession(
      name: 'Bantuan Teknis',
      specialty: 'Pusat Informasi Otomatis',
      isSystem: true,
      icon: Icons.support_agent_outlined,
      color: Colors.blueGrey,
      unread: 0,
      messages: [
        ChatMessage(
          text: 'Halo, ada yang bisa kami bantu terkait kendala sistem aplikasi?',
          isMe: false,
          time: 'Senin',
        ),
      ],
    ),
  ];

  static List<ChatSession> get allChats => _allChats;

  static List<ChatSession> getChats({int selectedTab = 0, String searchQuery = ''}) {
    List<ChatSession> list = _allChats.where((chat) {
      if (selectedTab == 1) return !chat.isSystem;
      if (selectedTab == 2) return chat.isSystem;
      return true;
    }).toList();

    if (searchQuery.isNotEmpty) {
      list = list
          .where((chat) => chat.name.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return list;
  }

  static ChatSession? getChatByName(String name) {
    try {
      return _allChats.firstWhere((c) => c.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static void sendMessage(String sessionName, String text, {String? imagePath}) {
    final session = getChatByName(sessionName);
    if (session == null) return;

    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    session.messages.add(
      ChatMessage(
        text: text,
        isMe: true,
        time: timeStr,
        imagePath: imagePath,
      ),
    );
  }

  static void markAsRead(String sessionName) {
    final session = getChatByName(sessionName);
    if (session != null) {
      session.unread = 0;
    }
  }
}
