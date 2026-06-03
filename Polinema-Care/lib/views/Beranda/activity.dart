import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/counseling_controller.dart';
import '../../models/counseling_model.dart';
import '../../controllers/laporan_controller.dart';

// =====================================================================
// MODEL & DATA LAPORAN
// =====================================================================
enum StatusLaporan { menunggu, diproses, selesai, ditolak }

class LaporanItem {
  final String id;
  final String judul;
  final String tanggal;
  final StatusLaporan status;
  final String deskripsi;
  final String jenisPerundungan;
  final String lokasi;
  final String pelaku;
  final String saksi;
  final String korban;

  const LaporanItem({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.status,
    required this.deskripsi,
    required this.jenisPerundungan,
    required this.lokasi,
    required this.pelaku,
    required this.saksi,
    required this.korban,
  });
}

// Konversi string status dari API ke enum StatusLaporan.
StatusLaporan laporanStatusFromString(String statusStr) {
  switch (statusStr.toLowerCase()) {
    case 'menunggu':
      return StatusLaporan.menunggu;
    case 'diproses':
      return StatusLaporan.diproses;
    case 'selesai':
      return StatusLaporan.selesai;
    case 'ditolak':
      return StatusLaporan.ditolak;
    default:
      return StatusLaporan.menunggu;
  }
}

// Konversi satu map laporan dari API menjadi LaporanItem.
LaporanItem laporanItemFromMap(Map<String, dynamic> lap) {
  final String rawTanggal = lap['tanggal_kejadian'] ?? lap['created_at']?.toString() ?? '-';
  final String kronologi = lap['kronologi'] ?? '';
  
  // Extract Saksi from kronologi if present
  String saksiParsed = '-';
  final saksiReg = RegExp(r'Saksi:\s*(.*)', caseSensitive: false);
  final saksiMatch = saksiReg.firstMatch(kronologi);
  if (saksiMatch != null) {
    saksiParsed = saksiMatch.group(1)?.trim() ?? '-';
  }
  if (saksiParsed.isEmpty) {
    saksiParsed = '-';
  }

  // Extract Korban from kronologi if present
  String korbanParsed = 'saya';
  final korbanReg = RegExp(r'Korban:\s*([^\n]*)', caseSensitive: false);
  final korbanMatch = korbanReg.firstMatch(kronologi);
  if (korbanMatch != null) {
    korbanParsed = korbanMatch.group(1)?.trim() ?? 'saya';
  }

  return LaporanItem(
    id: 'RPT-${lap['id']}',
    judul: lap['judul_pelaporan'] ?? 'Laporan',
    tanggal: LaporanController.formatDateTime(rawTanggal),
    status: laporanStatusFromString(lap['status'] ?? 'Menunggu'),
    deskripsi: kronologi,
    jenisPerundungan: lap['jenis_perundungan'] ?? '-',
    lokasi: (lap['lokasi'] != null && lap['lokasi'].toString().trim().isNotEmpty) ? lap['lokasi'].toString() : '-',
    pelaku: (lap['deskripsi_pelaku'] != null && lap['deskripsi_pelaku'].toString().trim().isNotEmpty) ? lap['deskripsi_pelaku'].toString() : '-',
    saksi: saksiParsed,
    korban: korbanParsed,
  );
}

// =====================================================================
// 1. HALAMAN UTUH — ActivityScreen
// =====================================================================
class ActivityScreen extends StatefulWidget {
  final dynamic initialTab;

  const ActivityScreen({super.key, this.initialTab});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    // Tentukan posisi tab saat halaman pertama kali di-build
    int initialIndex = 0;
    if (widget.initialTab == 1 || widget.initialTab == 'konseling') {
      initialIndex = 1;
    }

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: initialIndex,
    );
  }

  // ✅ Mendeteksi data `extra` baru saat halaman sudah aktif di memori
  @override
  void didUpdateWidget(covariant ActivityScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialTab != oldWidget.initialTab) {
      if (widget.initialTab == 1 || widget.initialTab == 'konseling') {
        _tabController.animateTo(1); // Geser otomatis ke tab Konseling
      } else if (widget.initialTab == 0 || widget.initialTab == 'laporan') {
        _tabController.animateTo(0); // Geser otomatis ke tab Laporan
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Aktivitas Saya',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A6B8A),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1A6B8A),
          unselectedLabelColor: Colors.grey,
          indicatorColor: const Color(0xFF1A6B8A),
          indicatorWeight: 3,
          labelStyle: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          unselectedLabelStyle: GoogleFonts.plusJakartaSans(fontSize: 14),
          tabs: const [
            Tab(text: 'Status Laporan'),
            Tab(text: 'Konseling'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [_TabLaporan(), _TabKonseling()],
      ),
    );
  }
}

// =====================================================================
// TAB 1 — STATUS LAPORAN
// =====================================================================
class _TabLaporan extends StatefulWidget {
  const _TabLaporan();

  @override
  State<_TabLaporan> createState() => _TabLaporanState();
}

class _TabLaporanState extends State<_TabLaporan> {
  List<Map<String, dynamic>> _reports = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  Future<void> _loadReports() async {
    setState(() => _isLoading = true);
    final reports = await LaporanController.fetchReports();
    if (mounted) {
      setState(() {
        _reports = reports;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadReports,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          _BuatLaporanButton(),
          const SizedBox(height: 20),
          Text(
            'Riwayat Laporan',
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
          else if (_reports.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Belum ada laporan diajukan.',
                  style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                ),
              ),
            )
          else
            ..._reports.map((lap) {
              return _LaporanCard(item: laporanItemFromMap(lap));
            }),
        ],
      ),
    );
  }
}

class _BuatLaporanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/activity/laporan'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFC7E6F0),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC7E6F0).withOpacity(0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.campaign,
                color: Color(0xFF1A6B8A),
                size: 26,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Buat Laporan Baru",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF124C63),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Laporkan kejadian perundungan sekarang",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF124C63).withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF124C63),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _LaporanCard extends StatelessWidget {
  final LaporanItem item;
  const _LaporanCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final statusInfo = _statusInfo(item.status);

    return GestureDetector(
      onTap: () {
        context.push(
          '/activity/detail-laporan',
          extra: {
            'id': item.id,
            'judul': item.judul,
            'tanggal': item.tanggal,
            'deskripsi': item.deskripsi,
            'statusLabel': statusInfo['label'],
            'statusColor': statusInfo['color'],
            'jenis_perundungan': item.jenisPerundungan,
            'lokasi': item.lokasi,
            'pelaku': item.pelaku,
            'saksi': item.saksi,
            'korban': item.korban,
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.judul,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _StatusChip(
                  label: statusInfo['label']!,
                  color: statusInfo['color']! as Color,
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF0F2F5)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 12,
                  color: Colors.grey,
                ),
                const SizedBox(width: 4),
                Text(
                  item.tanggal,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _StatusProgress(status: item.status),
          ],
        ),
      ),
    );
  }

  Map<String, dynamic> _statusInfo(StatusLaporan status) {
    switch (status) {
      case StatusLaporan.menunggu:
        return {'label': 'Menunggu', 'color': const Color(0xFFF59E0B)};
      case StatusLaporan.diproses:
        return {'label': 'Diproses', 'color': const Color(0xFF3B82F6)};
      case StatusLaporan.selesai:
        return {'label': 'Selesai', 'color': const Color(0xFF10B981)};
      case StatusLaporan.ditolak:
        return {'label': 'Ditolak', 'color': const Color(0xFFEF4444)};
    }
  }
}

class _StatusProgress extends StatelessWidget {
  final StatusLaporan status;
  const _StatusProgress({required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = ['Terkirim', 'Diterima', 'Diproses', 'Selesai'];
    int activeIndex;
    switch (status) {
      case StatusLaporan.menunggu:
        activeIndex = 0;
        break;
      case StatusLaporan.diproses:
        activeIndex = 2;
        break;
      case StatusLaporan.selesai:
        activeIndex = 3;
        break;
      case StatusLaporan.ditolak:
        activeIndex = -1;
        break;
    }

    if (status == StatusLaporan.ditolak) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.cancel_outlined,
              size: 14,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(width: 6),
            Text(
              'Laporan ditolak oleh admin',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: const Color(0xFFEF4444),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Row(
      children: List.generate(steps.length, (i) {
        final isDone = i <= activeIndex;
        final isLast = i == steps.length - 1;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDone
                          ? const Color(0xFF1A6B8A)
                          : Colors.grey[200],
                      border: Border.all(
                        color: isDone
                            ? const Color(0xFF1A6B8A)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: isDone
                        ? const Icon(Icons.check, size: 11, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      color: isDone
                          ? const Color(0xFF1A6B8A)
                          : Colors.grey[400],
                      fontWeight: isDone ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 14),
                    color: i < activeIndex
                        ? const Color(0xFF1A6B8A)
                        : Colors.grey[200],
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }
}

// =====================================================================
// TAB 2 — KONSELING
// =====================================================================
class _TabKonseling extends StatefulWidget {
  const _TabKonseling();

  @override
  State<_TabKonseling> createState() => _TabKonselingState();
}

class _TabKonselingState extends State<_TabKonseling> {
  int _selectedFilter = 0;
  final List<String> _filters = ['Semua', 'Bulan Ini', 'Selesai'];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    setState(() => _isLoading = true);
    await CounselingController.fetchBookings();
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<KonselingItem> get _filteredList {
    return CounselingController.getFilteredSessions(_selectedFilter);
  }

  String _getSpecialty(String namaKonselor) {
    return CounselingController.getSpecialty(namaKonselor);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _loadSessions,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        children: [
          // --- BANNER ---
          _buildBottomBanner(context),
          const SizedBox(height: 24),

          // --- FILTER CHIPS DIPINDAH KE BAWAH BANNER ---
          Row(
            children: List.generate(_filters.length, (i) {
              final isActive = _selectedFilter == i;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => setState(() => _selectedFilter = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: isActive ? const Color(0xFF4CAF50) : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFF4CAF50)
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      _filters[i],
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive ? Colors.white : Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // --- LIST CARD ---
          if (_isLoading)
            const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
          else if (_filteredList.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'Belum ada jadwal konseling.',
                  style: GoogleFonts.plusJakartaSans(color: Colors.grey),
                ),
              ),
            )
          else
            ..._filteredList.map(
              (item) => _KonselingCard(
                item: item,
                specialty: _getSpecialty(item.konselor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBanner(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFE8F4FD),
        borderRadius: BorderRadius.circular(24),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 120, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Butuh Teman Cerita Lagi?',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Konselor kami selalu siap\nmendengarkan tanpa menghakimi.',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.push('/counseling/cari'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1068A3),
                      elevation: 3,
                      shadowColor: const Color(0xFF1068A3).withOpacity(0.4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 22,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Buat Jadwal Baru',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -15,
              bottom: -20,
              child: Container(
                width: 105,
                height: 105,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey.shade300.withOpacity(0.7),
                    width: 7,
                  ),
                ),
                child: Icon(
                  Icons.psychology_outlined,
                  color: Colors.grey.shade400,
                  size: 56,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// WIDGET CARD KONSELING
// =====================================================================
class _KonselingCard extends StatelessWidget {
  final KonselingItem item;
  final String specialty;

  const _KonselingCard({required this.item, required this.specialty});

  @override
  Widget build(BuildContext context) {
    final statusInfo = getStatusInfoKonseling(item.status);
    final Color statusColor = statusInfo['color'] as Color;
    final String statusLabel = (statusInfo['label'] as String).toUpperCase();
    final bool isSelesai = item.status == StatusKonseling.selesai;
    final bool isDikonfirmasi = item.status == StatusKonseling.dikonfirmasi;
    final bool isDibatalkan = item.status == StatusKonseling.dibatalkan;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: isDibatalkan
                    ? Colors.grey[300]
                    : Colors.blueGrey[100],
                backgroundImage: isDibatalkan
                    ? null
                    : NetworkImage(
                        'https://i.pravatar.cc/150?u=${item.konselor}',
                      ),
                child: isDibatalkan
                    ? Icon(Icons.person, color: Colors.grey[400], size: 26)
                    : null,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.konselor,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDibatalkan
                            ? Colors.grey[400]
                            : const Color(0xFF1A2D3D),
                        height: 1.3,
                      ),
                    ),
                    if (specialty.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        specialty,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: isDibatalkan
                              ? Colors.grey[400]
                              : Colors.grey[500],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
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

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 14,
                      color: isDibatalkan
                          ? Colors.grey[400]
                          : const Color(0xFF1068A3),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.tanggal,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: isDibatalkan
                            ? Colors.grey[400]
                            : const Color(0xFF1A2D3D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time_outlined,
                      size: 14,
                      color: isDibatalkan
                          ? Colors.grey[400]
                          : const Color(0xFF1068A3),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item.jam,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: isDibatalkan
                            ? Colors.grey[400]
                            : const Color(0xFF1A2D3D),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          if (isSelesai || isDikonfirmasi)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.push(
                        '/counseling/detail-history',
                        extra: {
                          'konselor': item.konselor,
                          'specialty': specialty,
                          'tanggal': item.tanggal,
                          'jam': item.jam,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1068A3),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Lihat Detail',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Catatan Sesi',
                      style: GoogleFonts.plusJakartaSans(
                        color: const Color(0xFF1A2D3D),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
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
                onPressed: () => context.push('/counseling/reschedule'),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Reschedule Tersedia',
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1A2D3D),
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
}

// =====================================================================
// SHARED WIDGET
// =====================================================================
class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label.toUpperCase(),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10,
          color: color,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// =====================================================================
// 2. POTONGAN UI — ActivitySection (untuk HomeScreen)
// =====================================================================
class ActivitySection extends StatelessWidget {
  final VoidCallback onSeeAll;

  const ActivitySection({super.key, required this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Aktivitas Saya",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            InkWell(
              onTap: onSeeAll,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "Lihat Semua",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1D9BFF),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Ambil laporan terbaru langsung dari API.
        FutureBuilder<List<Map<String, dynamic>>>(
          future: LaporanController.fetchReports(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final reports = snapshot.data ?? [];
            if (reports.isEmpty) {
              return Text(
                "Belum ada laporan diajukan.",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.grey,
                ),
              );
            }
            final latestLaporan = laporanItemFromMap(reports.first);
            return _buildLaporanPreview(context, latestLaporan);
          },
        ),
      ],
    );
  }

  Widget _buildLaporanPreview(BuildContext context, LaporanItem item) {
    final statusColors = {
      StatusLaporan.menunggu: const Color(0xFFF59E0B),
      StatusLaporan.diproses: const Color(0xFF3B82F6),
      StatusLaporan.selesai: const Color(0xFF10B981),
      StatusLaporan.ditolak: const Color(0xFFEF4444),
    };
    final statusLabels = {
      StatusLaporan.menunggu: 'Menunggu',
      StatusLaporan.diproses: 'Diproses',
      StatusLaporan.selesai: 'Selesai',
      StatusLaporan.ditolak: 'Ditolak',
    };
    final color = statusColors[item.status]!;
    final label = statusLabels[item.status]!;

    return GestureDetector(
      onTap: () {
        context.push(
          '/activity/detail-laporan',
          extra: {
            'id': item.id,
            'judul': item.judul,
            'tanggal': item.tanggal,
            'deskripsi': item.deskripsi,
            'statusLabel': label,
            'statusColor': color,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.description_outlined, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.judul,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  Text(
                    item.tanggal,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            _StatusChip(label: label, color: color),
          ],
        ),
      ),
    );
  }
}
