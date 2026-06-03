import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class ChatController {
  // Hanya sesi sistem yang statis; sesi konselor diisi dinamis lewat fetchChats().
  static final List<ChatSession> _allChats = [];

  static List<ChatSession> get allChats => _allChats;

  static Future<List<ChatSession>> fetchChats() async {
    try {
      final response = await ApiService.get('/konseling');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final List list = body['data'] ?? [];
        
        final realChats = <ChatSession>[];
        for (final item in list) {
          final id = item['id'] as int;
          final adminName = item['admin']?['nama'] ?? 'Admin Kampus';
          final status = item['status'] ?? 'Diajukan';
          
          final msgResponse = await ApiService.get('/chat/$id');
          final msgBody = jsonDecode(msgResponse.body);
          final List msgList = (msgResponse.statusCode == 200 && msgBody['success'] == true)
              ? msgBody['data'] ?? []
              : [];
          
          final messages = msgList.map((m) {
            final text = m['isi_pesan'] ?? '';
            final isMe = m['sender_id'] == AuthController.currentUser?['id'];
            final createdAt = m['created_at']?.toString() ?? '';
            final timeStr = createdAt.length >= 16 ? createdAt.substring(11, 16) : '';
            return ChatMessage(text: text, isMe: isMe, time: timeStr);
          }).toList();

          int unreadCount = 0;
          for (final m in msgList) {
            if (m['sender_id'] != AuthController.currentUser?['id'] && m['status_pesan'] == 'Terkirim') {
              unreadCount++;
            }
          }

          realChats.add(
            ChatSession(
              name: adminName,
              specialty: 'Sesi Konseling #KSL-$id ($status)',
              isSystem: false,
              color: Colors.blueAccent,
              unread: unreadCount,
              messages: messages,
              konselingId: id,
            ),
          );
        }

        final systemSessions = _allChats.where((c) => c.isSystem).toList();
        _allChats.clear();
        _allChats.addAll(systemSessions);
        _allChats.addAll(realChats);
      }
    } catch (e) {
      print('Error fetching chats: $e');
    }
    return _allChats;
  }

  static Future<void> refreshMessagesForSession(ChatSession session) async {
    if (session.konselingId == null) return;
    try {
      final response = await ApiService.get('/chat/${session.konselingId}');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final List msgList = body['data'] ?? [];
        final messages = msgList.map((m) {
          final text = m['isi_pesan'] ?? '';
          final isMe = m['sender_id'] == AuthController.currentUser?['id'];
          final createdAt = m['created_at']?.toString() ?? '';
          final timeStr = createdAt.length >= 16 ? createdAt.substring(11, 16) : '';
          return ChatMessage(text: text, isMe: isMe, time: timeStr);
        }).toList();

        session.messages.clear();
        session.messages.addAll(messages);
      }
    } catch (e) {
      print('Error refreshing messages: $e');
    }
  }

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

  static Future<bool> sendMessage(String sessionName, String text, {String? imagePath}) async {
    final session = getChatByName(sessionName);
    if (session == null) return false;

    if (session.konselingId != null) {
      try {
        final response = await ApiService.post('/chat', {
          'konseling_id': session.konselingId,
          'isi_pesan': text,
        });
        final body = jsonDecode(response.body);
        if (response.statusCode == 201 && body['success'] == true) {
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
          return true;
        }
      } catch (e) {
        print('Error sending message: $e');
      }
      return false;
    } else {
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
      return true;
    }
  }

  static void markAsRead(String sessionName) {
    final session = getChatByName(sessionName);
    if (session != null) {
      session.unread = 0;
    }
  }
}
