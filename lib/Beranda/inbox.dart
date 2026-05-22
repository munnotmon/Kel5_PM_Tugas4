import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../Konseling/data_konselor.dart'; // Sesuaikan path jika berbeda

class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  int _selectedTab = 0;
  String _searchQuery = "";

  // List utama yang menyimpan seluruh data chat dan riwayat obrolannya
  late List<Map<String, dynamic>> _allChats;

  @override
  void initState() {
    super.initState();
    _allChats = [
      // --- KONSELOR ---
      {
        ...daftarKonselor[0], // dr. Anton
        'isSystem': false,
        'color': const Color(0xFF1068A3),
        'unread': 2,
        'messages': [
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
      },
      {
        ...daftarKonselor[1], // Siska
        'isSystem': false,
        'color': Colors.orange,
        'unread': 0,
        'messages': [
          {
            'text': 'Sesi kemarin sangat membantu, terima kasih Siska.',
            'isMe': true,
            'time': 'Kemarin, 14:00',
          },
          {
            'text':
                'Terima kasih sudah berbagi cerita, Kelompok 5. Tetap semangat ya!',
            'isMe': false,
            'time': 'Kemarin, 14:05',
          },
        ],
      },
      {
        ...daftarKonselor[2], // Budi Hartono
        'isSystem': false,
        'color': Colors.purple,
        'unread': 0,
        'messages': [
          {
            'text': 'Apakah besok ada jadwal bimbingan kosong?',
            'isMe': true,
            'time': 'Senin, 09:00',
          },
          {
            'text': 'Sesi bimbingan akademismu besok ya jam 10 pagi.',
            'isMe': false,
            'time': 'Senin, 09:15',
          },
        ],
      },
      {
        ...daftarKonselor[3], // dr. Sarah
        'isSystem': false,
        'color': Colors.teal,
        'unread': 0,
        'messages': [
          {
            'text':
                'Halo Kelompok 5, link meet untuk sesi kita besok sudah siap.',
            'isMe': false,
            'time': '12 Jan',
          },
        ],
      },

      // --- SISTEM ---
      {
        'name': 'Sistem Respon',
        'isSystem': true,
        'icon': Icons.campaign_outlined,
        'color': const Color(0xFF1068A3),
        'unread': 1,
        'messages': [
          {
            'text': 'Laporan Anda #HGN-20261012 telah diterima.',
            'isMe': false,
            'time': 'Kemarin',
          },
          {
            'text':
                'Bukti baru telah ditambahkan ke laporan Anda. Tim sedang meninjaunya.',
            'isMe': false,
            'time': '2 Jam Lalu',
          },
        ],
      },
      {
        'name': 'Admin Kampus',
        'isSystem': true,
        'icon': Icons.admin_panel_settings_outlined,
        'color': Colors.green,
        'unread': 0,
        'messages': [
          {
            'text':
                'Selamat datang di platform Respon & Konseling Polinema Care+.',
            'isMe': false,
            'time': 'Kemarin',
          },
        ],
      },
      {
        'name': 'Bantuan Teknis',
        'isSystem': true,
        'icon': Icons.support_agent_outlined,
        'color': Colors.blueGrey,
        'unread': 0,
        'messages': [
          {
            'text':
                'Halo, ada yang bisa kami bantu terkait kendala sistem aplikasi?',
            'isMe': false,
            'time': 'Senin',
          },
        ],
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Logika Filter Tab
    List<Map<String, dynamic>> displayedChats = _allChats.where((chat) {
      if (_selectedTab == 1) return chat['isSystem'] == false;
      if (_selectedTab == 2) return chat['isSystem'] == true;
      return true; // Tab 'Semua'
    }).toList();

    // Logika Pencarian
    if (_searchQuery.isNotEmpty) {
      displayedChats = displayedChats
          .where(
            (chat) => chat['name'].toString().toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildTabs(),
            Expanded(
              child: displayedChats.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      itemCount: displayedChats.length,
                      itemBuilder: (context, index) {
                        return _buildChatItem(displayedChats[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Pesan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1A2D3D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: TextField(
        onChanged: (val) => setState(() => _searchQuery = val),
        decoration: InputDecoration(
          hintText: 'Cari percakapan...',
          hintStyle: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey[400],
          ),
          prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildTabs() {
    final tabs = ['Semua', 'Konseling', 'Sistem'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(tabs.length, (i) {
          final isActive = _selectedTab == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isActive ? const Color(0xFF1068A3) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive
                        ? const Color(0xFF1068A3)
                        : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  tabs[i],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : Colors.grey[600],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildChatItem(Map<String, dynamic> chat) {
    final isSystem = chat['isSystem'] == true;
    final color = chat['color'] as Color;

    // Ambil pesan terakhir untuk preview
    final List<Map<String, dynamic>> messages = chat['messages'];
    final lastMessage = messages.isNotEmpty ? messages.last : null;
    final previewText = lastMessage != null
        ? lastMessage['text']
        : 'Tidak ada pesan';
    final timeText = lastMessage != null ? lastMessage['time'] : '';

    return GestureDetector(
      onTap: () {
        setState(() => chat['unread'] = 0); // Hilangkan badge merah saat diklik

        // Lempar data ke ruang chat dan tunggu user kembali
        context.push('/inbox/room-chat', extra: chat).then((_) {
          // Refresh list inbox agar preview memuat pesan terakhir yang baru dikirim
          setState(() {});
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.1),
              backgroundImage: isSystem
                  ? null
                  : NetworkImage("https://i.pravatar.cc/150?u=${chat['name']}"),
              child: isSystem
                  ? Icon(chat['icon'] as IconData, color: color, size: 22)
                  : null,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    chat['name'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    previewText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  timeText,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    color: Colors.grey[400],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                if ((chat['unread'] ?? 0) > 0)
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFF1068A3),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${chat['unread']}',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.chat_bubble_outline, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Tidak ada percakapan ditemukan',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
