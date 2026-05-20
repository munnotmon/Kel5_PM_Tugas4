import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'data_konselor.dart'; // Pastikan import ini sesuai

class FindCounselorPage extends StatefulWidget {
  const FindCounselorPage({super.key});

  @override
  State<FindCounselorPage> createState() => _FindCounselorPageState();
}

class _FindCounselorPageState extends State<FindCounselorPage> {
  // Variabel State untuk pencarian & filter
  String _searchQuery = '';
  String _selectedFilter = 'Semua';

  // Daftar kategori filter
  final List<String> _filters = [
    'Semua',
    'Perundungan',
    'Trauma',
    'Depresi',
    'Kecemasan',
    'Karir',
  ];

  @override
  Widget build(BuildContext context) {
    // === LOGIKA PENYARINGAN (FILTER & SEARCH) ===
    List<Map<String, dynamic>> filteredKonselor = daftarKonselor.where((
      konselor,
    ) {
      // 1. Cek Pencarian Text
      final String name = (konselor['name'] ?? '').toLowerCase();
      final String specialty = (konselor['specialty'] ?? '').toLowerCase();
      final bool matchesSearch =
          name.contains(_searchQuery.toLowerCase()) ||
          specialty.contains(_searchQuery.toLowerCase());

      // 2. Cek Filter Kategori (Chips)
      bool matchesFilter = true;
      if (_selectedFilter != 'Semua') {
        final List<String> specialties = (konselor['specialties'] as List)
            .map((e) => e.toString().toLowerCase())
            .toList();
        matchesFilter = specialties.contains(_selectedFilter.toLowerCase());
      }

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F7FA),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A6B8A)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Find Support",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A6B8A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- SEARCH BAR ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Cari nama atau spesialisasi...",
                hintStyle: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // --- CHIPS FILTER ---
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              children: _filters.map((filter) {
                return _buildChip(filter, _selectedFilter == filter);
              }).toList(),
            ),
          ),

          const SizedBox(height: 10),

          // --- HEADER: KONSELOR TERSEDIA ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Konselor Tersedia",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                    Text(
                      "24 ONLINE",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF10B981),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "Pilih teman bicara yang tepat untukmu",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // --- LIST DATA KONSELOR ---
          Expanded(
            child: filteredKonselor.isEmpty
                ? _buildEmptyState()
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      ...filteredKonselor.map((konselor) {
                        return _buildCounselorTile(context, konselor);
                      }),

                      // Menambahkan section rekomendasi assessment di bagian bawah list
                      const SizedBox(height: 20),
                      _buildAssessmentPrompt(),
                      const SizedBox(height: 40),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET CHIPS ---
  Widget _buildChip(String label, bool active) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1A6B8A) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFF1A6B8A) : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: active ? Colors.white : Colors.grey[600],
            fontWeight: active ? FontWeight.bold : FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  // --- WIDGET CARD KONSELOR ---
  Widget _buildCounselorTile(BuildContext context, Map<String, dynamic> data) {
    return GestureDetector(
      onTap: () => context.push('/counseling/profil', extra: data),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FOTO PROFIL & STATUS ONLINE ---
            Stack(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundColor: Colors.blueGrey[100],
                  // Placeholder foto agar ada gambar (bisa diganti sesuai desain)
                  backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/150?u=${data['name']}",
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: Container(
                    width: 14,
                    height: 14,
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981), // Hijau Online
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // --- INFO KONSELOR ---
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Baris Nama & Rating
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          data['name'],
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: const Color(0xFF1A2D3D),
                            height: 1.2,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.star,
                              color: Color(0xFF059669),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              data['rating'],
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF059669),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Spesialisasi (Warna Biru)
                  Text(
                    data['specialty'],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: const Color(0xFF1A6B8A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Baris Bawah (Sesi, Verified, Lihat Profil)
                  Row(
                    children: [
                      Icon(
                        Icons.chat_bubble_outline,
                        color: Colors.grey[500],
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        data['sessions']?.replaceAll(' Sesi', '') ??
                            '', // Mengambil angka saja
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        " Sesi",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),

                      const SizedBox(width: 12),

                      const Icon(
                        Icons.verified,
                        color: Color(0xFF10B981),
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "Verified",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const Spacer(),

                      Text(
                        "Lihat Profil",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A6B8A),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF1A6B8A),
                        size: 16,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- WIDGET ASSESSMENT BOTTOM ---
  Widget _buildAssessmentPrompt() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2F8),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.support_agent,
            color: Color(0xFF1A6B8A),
            size: 28,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Belum menemukan yang cocok? Kami\nbisa rekomendasikan konselor sesuai\nmasalahmu.",
          textAlign: TextAlign.center,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "Coba Assessment Cepat",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A6B8A),
          ),
        ),
      ],
    );
  }

  // --- WIDGET KETIKA PENCARIAN KOSONG ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            "Konselor tidak ditemukan",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Coba ubah kata kunci pencarian atau filter",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
