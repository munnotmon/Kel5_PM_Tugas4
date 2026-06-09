import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/chat_model.dart';
import '../services/api_service.dart';
import 'auth_controller.dart';

class ChatController {
  // Hanya sesi sistem yang statis; sesi konselor diisi dinamis lewat fetchChats().
  static final List<ChatSession> _allChats = [];

  static List<ChatSession> get allChats => _allChats;

  static bool _isFetching = false;

  static Future<List<ChatSession>> fetchChats() async {
    if (_isFetching) return _allChats;
    _isFetching = true;
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
          final tipe = item['tipe'] ?? 'konseling';
          
          final label = tipe == 'laporan' ? 'Tindak Lanjut Laporan' : 'Sesi Konseling #KSL-$id';
          final specialty = '$label ($status)';
          
          final List msgList = item['pesan'] ?? [];
          
          final messages = msgList.map((m) {
            final text = m['isi_pesan'] ?? '';
            final isMe = m['sender_id'] == AuthController.currentUser?['id'];
            final createdAt = m['created_at']?.toString() ?? '';
            final timeStr = _formatTime(createdAt);
            final rawPath = m['path_gambar'] as String?;
            final imagePath = rawPath != null ? ApiService.buildImageUrl(rawPath) : null;
            final status = m['status_pesan'] ?? 'Terkirim';
            return ChatMessage(
              text: text,
              isMe: isMe,
              time: timeStr,
              imagePath: imagePath,
              status: status,
            );
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
              specialty: specialty,
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
    } finally {
      _isFetching = false;
    }
    return _allChats;
  }

  static Future<void> refreshMessagesForSession(ChatSession session) async {
    if (session.konselingId == null) return;
    try {
      final response = await ApiService.get('/chat/${session.konselingId}');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final String? status = body['status'];
        final String tipe = body['tipe'] ?? 'konseling';
        if (status != null) {
          final label = tipe == 'laporan' ? 'Tindak Lanjut Laporan' : 'Sesi Konseling #KSL-${session.konselingId}';
          session.specialty = '$label ($status)';
        }

        final List msgList = body['data'] ?? [];
        final messages = msgList.map((m) {
          final text = m['isi_pesan'] ?? '';
          final isMe = m['sender_id'] == AuthController.currentUser?['id'];
          final createdAt = m['created_at']?.toString() ?? '';
          final timeStr = _formatTime(createdAt);
          final rawPath = m['path_gambar'] as String?;
          final imagePath = rawPath != null ? ApiService.buildImageUrl(rawPath) : null;
          final status = m['status_pesan'] ?? 'Terkirim';
          return ChatMessage(
            text: text,
            isMe: isMe,
            time: timeStr,
            imagePath: imagePath,
            status: status,
          );
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

  static ChatSession? getChatByIdOrName(int? id, String name) {
    try {
      if (id != null) {
        return _allChats.firstWhere((c) => c.konselingId == id);
      }
      return _allChats.firstWhere((c) => c.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static ChatSession? getChatByName(String name) {
    try {
      return _allChats.firstWhere((c) => c.name.toLowerCase() == name.toLowerCase());
    } catch (_) {
      return null;
    }
  }

  static Future<bool> sendMessage(
    String sessionName, 
    String text, 
    {int? konselingId,
     String? imagePath, 
     Uint8List? imageBytes, 
     String? imageName}
  ) async {
    final session = getChatByIdOrName(konselingId, sessionName);
    if (session == null) return false;

    // Optimistic Update: Tambah pesan ke list lokal secara instan
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final tempMsg = ChatMessage(
      text: text,
      isMe: true,
      time: timeStr,
      imagePath: imagePath,
      imageBytes: imageBytes,
    );
    session.messages.add(tempMsg);

    if (session.konselingId != null) {
      try {
        http.Response response;
        if (imageBytes != null && imageName != null) {
          final file = http.MultipartFile.fromBytes('gambar', imageBytes, filename: imageName);
          response = await ApiService.postMultipart(
            '/chat',
            {
              'konseling_id': session.konselingId.toString(),
              'isi_pesan': text,
            },
            [file],
          );
        } else if (imagePath != null) {
          final file = await http.MultipartFile.fromPath('gambar', imagePath);
          response = await ApiService.postMultipart(
            '/chat',
            {
              'konseling_id': session.konselingId.toString(),
              'isi_pesan': text,
            },
            [file],
          );
        } else {
          response = await ApiService.post('/chat', {
            'konseling_id': session.konselingId,
            'isi_pesan': text,
          });
        }
        final body = jsonDecode(response.body);
        print('[ChatController] sendMessage response ${response.statusCode}: ${response.body}');
        if ((response.statusCode == 201 || response.statusCode == 200) && body['success'] == true) {
          final rawReturnedPath = body['data']?['path_gambar'] as String?;
          print('[ChatController] path_gambar dari server: $rawReturnedPath');
          final returnedPath = rawReturnedPath != null ? ApiService.buildImageUrl(rawReturnedPath) : null;
          if (returnedPath != null) {
            final idx = session.messages.indexOf(tempMsg);
            if (idx != -1) {
              session.messages[idx] = ChatMessage(
                text: text,
                isMe: true,
                time: timeStr,
                imagePath: returnedPath,
              );
            }
          }
          return true;
        } else {
          print('[ChatController] sendMessage failed. Status: ${response.statusCode}, Body: ${response.body}');
        }
      } catch (e) {
        print('Error sending message: $e');
      }
      // Rollback: Hapus pesan jika pengiriman gagal
      session.messages.remove(tempMsg);
      return false;
    } else {
      return true;
    }
  }

  static void markAsRead(int? id, String sessionName) {
    final session = getChatByIdOrName(id, sessionName);
    if (session != null) {
      session.unread = 0;
    }
  }

  static String _formatTime(String createdAt) {
    if (createdAt.isEmpty) return '';
    try {
      final parsedDate = DateTime.parse(createdAt).toLocal();
      return '${parsedDate.hour.toString().padLeft(2, '0')}:${parsedDate.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return createdAt.length >= 16 ? createdAt.substring(11, 16) : '';
    }
  }
}
