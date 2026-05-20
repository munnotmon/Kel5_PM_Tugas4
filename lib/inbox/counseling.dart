import 'package:flutter/material.dart';

class CounselingPage extends StatefulWidget {
  const CounselingPage({super.key});

  @override
  State<CounselingPage> createState() => _CounselingPageState();
}

class _CounselingPageState extends State<CounselingPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Halo Ahmad, bagaimana perasaanmu hari ini? Apakah ada yang ingin kamu ceritakan mengenai sesi kita sebelumnya?',
      'isMe': false,
      'time': '10:45',
    },
    {
      'text': 'Halo Dok, saya merasa sedikit lebih tenang sekarang setelah mencoba teknik pernapasan yang Dokter ajarkan.',
      'isMe': true,
      'time': '10:47',
    },
    {
      'text': 'Bagus sekali! Senang mendengarnya. Teruskan latihan itu ya.',
      'isMe': false,
      'time': '10:49',
    },
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'text': text,
        'isMe': true,
        'time': TimeOfDay.now().format(context),
      });
    });
    _controller.clear();
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildEncryptNote(),
            Expanded(child: _buildMessages()),
            _buildInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F0),
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios, size: 18, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 8),
          Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFDBEAFE),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('AW', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8))),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('dr. Anton Wijaya', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                Text('ONLINE', style: TextStyle(fontSize: 10, color: Color(0xFF16A34A), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          const Icon(Icons.videocam_outlined, size: 22, color: Colors.black54),
          const SizedBox(width: 12),
          const Icon(Icons.phone_outlined, size: 20, color: Colors.black54),
        ],
      ),
    );
  }

  Widget _buildEncryptNote() {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFECE9E0),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Row(
        children: [
          Icon(Icons.lock_outline, size: 12, color: Colors.black45),
          SizedBox(width: 5),
          Expanded(
            child: Text(
              'End-to-end Encrypted. Percakapan ini bersifat rahasia dan terenkripsi.',
              style: TextStyle(fontSize: 10, color: Colors.black45),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessages() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      itemCount: _messages.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Text('HARI INI', style: TextStyle(fontSize: 10, color: Colors.black38, letterSpacing: 0.5)),
            ),
          );
        }
        final msg = _messages[index - 1];
        return _buildBubble(msg);
      },
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg) {
    final isMe = msg['isMe'] as bool;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(
              width: 24, height: 24,
              decoration: const BoxDecoration(color: Color(0xFFDBEAFE), shape: BoxShape.circle),
              child: const Center(
                child: Text('AW', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w600, color: Color(0xFF1D4ED8))),
              ),
            ),
            const SizedBox(width: 6),
          ],
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.65),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                decoration: BoxDecoration(
                  color: isMe ? const Color(0xFF2563EB) : Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(16),
                    topRight: const Radius.circular(16),
                    bottomLeft: Radius.circular(isMe ? 16 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 16),
                  ),
                  boxShadow: isMe ? [] : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  msg['text'],
                  style: TextStyle(
                    fontSize: 12,
                    color: isMe ? Colors.white : Colors.black87,
                    height: 1.45,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Text(msg['time'], style: const TextStyle(fontSize: 9, color: Colors.black38)),
                  if (isMe) ...[
                    const SizedBox(width: 3),
                    const Text('✓', style: TextStyle(fontSize: 9, color: Color(0xFF93C5FD))),
                  ],
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 10),
      decoration: const BoxDecoration(
        color: Color(0xFFF5F5F0),
        border: Border(top: BorderSide(color: Color(0xFFE0DDD4), width: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.add, size: 24, color: Colors.black38),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFECE9E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _controller,
                style: const TextStyle(fontSize: 13),
                decoration: const InputDecoration(
                  hintText: 'Tulis pesan...',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.black38),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.sentiment_satisfied_alt_outlined, size: 22, color: Colors.black38),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 34, height: 34,
              decoration: const BoxDecoration(color: Color(0xFF2563EB), shape: BoxShape.circle),
              child: const Icon(Icons.send, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}