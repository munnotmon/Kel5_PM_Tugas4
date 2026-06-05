import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/chat_controller.dart';
import '../../models/chat_model.dart';

class RoomChatPage extends StatefulWidget {
  final Map<String, dynamic> counselorData;

  const RoomChatPage({super.key, required this.counselorData});

  @override
  State<RoomChatPage> createState() => _RoomChatPageState();
}

class _RoomChatPageState extends State<RoomChatPage> {
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();

  late ChatSession _session;
  Timer? _pollTimer;

  @override
  void initState() {
    super.initState();
    final name = widget.counselorData['name'] ?? 'Konselor';
    
    // Temukan session dari ChatController, jika belum ada buat session baru
    ChatSession? found = ChatController.getChatByName(name);
    if (found == null) {
      found = ChatSession.fromMap(widget.counselorData);
      ChatController.allChats.add(found);
    }
    _session = found;
    _startPolling();
  }

  void _startPolling() {
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_session.konselingId != null) {
        await ChatController.refreshMessagesForSession(_session);
        if (mounted) {
          setState(() {
            widget.counselorData['messages'] = _session.messages.map((m) => m.toMap()).toList();
          });
        }
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _msgController.text.trim();
    if (text.isEmpty) return;
    _msgController.clear();

    final success = await ChatController.sendMessage(_session.name, text);
    if (success) {
      if (mounted) {
        setState(() {
          widget.counselorData['messages'] = _session.messages.map((m) => m.toMap()).toList();
        });
        _scrollToBottom();
      }
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (image != null) {
        if (!mounted) return;
        final TextEditingController captionController = TextEditingController();
        
        final bool? confirmSend = await showDialog<bool>(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Dialog(
              backgroundColor: const Color(0xFF1E272C),
              insetPadding: const EdgeInsets.all(0),
              child: Scaffold(
                backgroundColor: const Color(0xFF1E272C),
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context, false),
                  ),
                  title: Text(
                    'Kirim Gambar',
                    style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: kIsWeb
                              ? Image.network(
                                  image.path,
                                  fit: BoxFit.contain,
                                )
                              : Image.file(
                                  File(image.path),
                                  fit: BoxFit.contain,
                                ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      color: const Color(0xFF131C21),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: captionController,
                              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 14),
                              decoration: InputDecoration(
                                hintText: 'Tambahkan keterangan...',
                                hintStyle: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 14),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CircleAvatar(
                            backgroundColor: const Color(0xFF1068A3),
                            child: IconButton(
                              icon: const Icon(Icons.send, color: Colors.white, size: 20),
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
        );

        if (confirmSend == true) {
          final caption = captionController.text.trim();
          final textToSend = caption.isNotEmpty ? caption : 'Lampiran Gambar';
          
          bool success;
          if (kIsWeb) {
            final bytes = await image.readAsBytes();
            success = await ChatController.sendMessage(
              _session.name,
              textToSend,
              imageBytes: bytes,
              imageName: image.name,
              imagePath: image.path,
            );
          } else {
            success = await ChatController.sendMessage(
              _session.name,
              textToSend,
              imagePath: image.path,
            );
          }
          
          if (success) {
            if (mounted) {
              setState(() {
                widget.counselorData['messages'] = _session.messages.map((m) => m.toMap()).toList();
              });
              _scrollToBottom();
            }
          }
        }
        captionController.dispose();
      }
    } catch (e) {
      debugPrint("Gagal mengambil gambar: $e");
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Wrap(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2F8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color(0xFF1068A3),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Ambil Foto (Kamera)',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2F8),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_library,
                      color: Color(0xFF1068A3),
                      size: 22,
                    ),
                  ),
                  title: Text(
                    'Pilih dari Galeri',
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _msgController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSystem = _session.isSystem;
    final messages = _session.messages;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
        title: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: isSystem
                      ? _session.color.withOpacity(0.2)
                      : Colors.grey[200],
                  backgroundImage: isSystem
                      ? null
                      : NetworkImage(
                          "https://i.pravatar.cc/150?u=${_session.name}",
                        ),
                  child: isSystem && _session.icon != null
                      ? Icon(
                          _session.icon,
                          color: _session.color,
                          size: 20,
                        )
                      : null,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _session.name,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  Text(
                    isSystem
                        ? 'Pusat Informasi Otomatis'
                        : _session.specialty,
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.isMe;
                final hasImage = msg.imagePath != null;

                return Align(
                  alignment: isMe
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF1068A3) : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (hasImage)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: (msg.imagePath!.startsWith('http://') || msg.imagePath!.startsWith('https://') || kIsWeb)
                                  ? Image.network(
                                      msg.imagePath!,
                                      width: 220,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.file(
                                      File(msg.imagePath!),
                                      width: 220,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        Text(
                          msg.text,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            color: isMe
                                ? Colors.white
                                : const Color(0xFF1A2D3D),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          msg.time,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            color: isMe ? Colors.white70 : Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _session.specialty.toLowerCase().contains('(selesai)') ||
                  _session.specialty.toLowerCase().contains('(dibatalkan)')
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      top: BorderSide(color: Colors.grey.withOpacity(0.15)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock_outline, color: Colors.grey, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Sesi konseling telah selesai.',
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.grey[500],
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFF5F7FA),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Color(0xFF1068A3)),
                          onPressed: _showAttachmentOptions,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: TextField(
                            controller: _msgController,
                            style: GoogleFonts.plusJakartaSans(fontSize: 13),
                            decoration: InputDecoration(
                              hintText: 'Tulis pesan Anda...',
                              hintStyle: TextStyle(color: Colors.grey[400]),
                              border: InputBorder.none,
                            ),
                            onSubmitted: (_) => _sendMessage(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      CircleAvatar(
                        backgroundColor: const Color(0xFF1068A3),
                        child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white, size: 18),
                          onPressed: _sendMessage,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
