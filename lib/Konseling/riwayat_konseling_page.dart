// Lokasi: lib/Konseling/riwayat_konseling_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'data_riwayat_konseling.dart';
import 'data_konselor.dart';

class RiwayatKonselingPage extends StatefulWidget {
  const RiwayatKonselingPage({super.key});

  @override
  State<RiwayatKonselingPage> createState() => _RiwayatKonselingPageState();
}

class _RiwayatKonselingPageState extends State<RiwayatKonselingPage> {
  int _selectedFilter = 0; // 0=Semua, 1=Bulan Ini, 2=Selesai
  final List<String> _filters = ['Semua', 'Bulan Ini', 'Selesai'];

  List<KonselingItem> get _allSessions => riwayatKonselingList;

  List<KonselingItem> get _filteredSessions {
    if (_selectedFilter == 0) return _allSessions;
    if (_selectedFilter == 1) {
      return _allSessions.where((s) => s.tanggal.contains('Okt')).toList();
    }
    if (_selectedFilter == 2) {
      return _allSessions
          .where((s) => s.status == StatusKonseling.selesai)
          .toList();
    }
    return _allSessions;
  }

  /// Cari specialty dari daftarKonselor berdasarkan nama konselor.
  /// Jika tidak ketemu, kembalikan string kosong.
  String _getSpecialty(String namaKonselor) {
    try {
      final found = daftarKonselor.firstWhere(
        (k) =>
            (k['name'] as String).toLowerCase() ==
            namaKonselor.toLowerCase(),
        orElse: () => {},
      );
      return found['specialty'] as String? ?? '';
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
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
          'Counseling History',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1068A3),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- HEADER ---
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Sesi',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                Text(
                  'Counseling Kamu.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1068A3),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Kelola dan tinjau kembali percakapan berharga dengan konselor profesional kami.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),

                // --- FILTER CHIPS ---
                Row(
                  children: List.generate(_filters.length, (i) {
                    final isSelected = _selectedFilter == i;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedFilter = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1068A3)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF1068A3)
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Text(
                            _filters[i],
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),

          // --- LIST SESI ---
          Expanded(
            child: _filteredSessions.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _filteredSessions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _filteredSessions.length) {
                        return _buildBottomBanner(context);
                      }
                      return _buildSessionCard(
                          context, _filteredSessions[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, KonselingItem session) {
    final statusInfo = getStatusInfoKonseling(session.status);
    final Color statusColor = statusInfo['color'];
    final String statusLabel = statusInfo['label'].toUpperCase();

    final isSelesai = session.status == StatusKonseling.selesai;
    final isDibatalkan = session.status == StatusKonseling.dibatalkan;

    // Ambil specialty dari daftarKonselor, tanpa mengubah data_riwayat_konseling.dart
    final String specialty = _getSpecialty(session.konselor);
    final String avatarUrl = 'https://i.pravatar.cc/150?u=${session.konselor}';

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BARIS ATAS: FOTO + NAMA + SPECIALTY + STATUS BADGE ---
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.blueGrey[100],
                backgroundImage: NetworkImage(avatarUrl),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.konselor,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A2D3D),
                        height: 1.3,
                      ),
                    ),
                    if (specialty.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        specialty,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              // Status badge di pojok kanan atas
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.4)),
                ),
                child: Text(
                  statusLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // --- TANGGAL & JAM ---
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: Color(0xFF1068A3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      session.tanggal,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: Color(0xFF1068A3),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      session.jam,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // --- ACTION BUTTONS ---
          if (isSelesai)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        context.push('/counseling/detail-history'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1068A3),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Lihat Detail',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Catatan Sesi',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF1A2D3D),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            )
          else if (isDibatalkan)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => context.push('/counseling/cari'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Reschedule Tersedia',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1A2D3D),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBanner(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 100),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.psychology_outlined,
                color: Color(0xFF1068A3),
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Butuh Teman Cerita Lagi?',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Konselor kami selalu siap mendengarkan tanpa menghakimi.',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.settings, color: Colors.grey[300], size: 40),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.push('/counseling/cari'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1068A3),
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Buat Jadwal Baru',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            'Belum ada sesi konseling',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}