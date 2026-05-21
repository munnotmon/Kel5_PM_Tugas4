// Lokasi: lib/views/Beranda/inbox.dart
import 'package:flutter/material.dart';

// Panggil Model yang baru dibuat
import '../../models/inbox_model.dart';
import 'counseling.dart';

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  // Untuk perpindahan Tab (Ini termasuk UI State, jadi aman tetap di View)
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabs(),
            Expanded(child: _buildChatList()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF2563EB),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Row(
        children: [
          const Icon(Icons.menu, size: 22, color: Colors.black54),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'Pesan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFFE8E4D9),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Icon(Icons.notifications_outlined, size: 18, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFECE9E0),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
        child: Row(
          children: const [
            Icon(Icons.search, size: 16, color: Colors.black38),
            SizedBox(width: 8),
            Text('Cari percakapan...', style: TextStyle(fontSize: 13, color: Colors.black38)),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Semua', 'Konseling', 'Sistem'];
    final activeColors = [const Color(0xFF2563EB), const Color(0xFF16A34A), null];

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _selectedTab == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isActive ? (activeColors[i] ?? Colors.grey) : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: isActive ? null : Border.all(color: Colors.black26, width: 0.5),
                ),
                child: Text(
                  tabs[i],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isActive ? Colors.white : Colors.black54,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChatList() {
    // Menggunakan dummyChats dari inbox_model.dart
    final filtered = dummyChats.where((chat) {
      if (_selectedTab == 0) return true;
      if (_selectedTab == 1) return chat['isDoctor'] == true;
      if (_selectedTab == 2) return chat['isSystem'] == true;
      return true;
    }).toList();

    return ListView.builder(
      itemCount: filtered.length + 1,
      itemBuilder: (context, index) {
        if (index == filtered.length) {
          return _buildEmptyBottom();
        }
        return _buildChatItem(filtered[index]);
      },
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    return GestureDetector(
      onTap: () {
        if (chat['isDoctor'] == true) {
          Navigator.push(
            context,
            // Halaman CounselingPage dari counseling.dart
            MaterialPageRoute(builder: (_) => const CounselingScreen()), 
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 12,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(chat),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(chat['name'], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(chat['preview'], style: const TextStyle(fontSize: 11, color: Colors.black45)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(chat['time'], style: const TextStyle(fontSize: 10, color: Colors.black38)),
                const SizedBox(height: 4),
                if ((chat['unread'] ?? 0) > 0)
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2563EB),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${chat['unread']}',
                        style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(Map<String, dynamic> chat) {
    final color = chat['color'] as Color;
    IconData? icon;
    if (chat['isSystem'] == true) {
      if (chat['name'] == 'Bantuan Teknis') {
        icon = Icons.support_agent;
      } else {
        icon = Icons.notifications;
      }
    }

    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: icon != null
          ? Icon(icon, color: color, size: 20)
          : Center(
              child: Text(
                chat['initials'],
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: color),
              ),
            ),
    );
  }

  Widget _buildEmptyBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        children: const [
          Icon(Icons.chat_bubble_outline, size: 40, color: Colors.black12),
          SizedBox(height: 8),
          Text('Tempat aman untuk berdiskusi', style: TextStyle(fontSize: 11, color: Colors.black26)),
        ],
      ),
    );
  }
}