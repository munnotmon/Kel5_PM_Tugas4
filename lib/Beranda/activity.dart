import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../Konseling/data_riwayat_konseling.dart'; // Import data riwayat konseling terpusat

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

  const LaporanItem({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.status,
    required this.deskripsi,
  });
}

final List<LaporanItem> dummyLaporan = [
  LaporanItem(
    id: 'RPT-001',
    judul: 'Perundungan Verbal di Kelas',
    tanggal: '12 Mei 2026',
    status: StatusLaporan.diproses,
    deskripsi: 'Laporan mengenai tindakan verbal oleh senior kepada junior.',
  ),
  LaporanItem(
    id: 'RPT-002',
    judul: 'Intimidasi di Kantin',
    tanggal: '8 Mei 2026',
    status: StatusLaporan.selesai,
    deskripsi: 'Laporan intimidasi yang terjadi di area kantin kampus.',
  ),
  LaporanItem(
    id: 'RPT-003',
    judul: 'Cyberbullying Media Sosial',
    tanggal: '1 Mei 2026',
    status: StatusLaporan.menunggu,
    deskripsi: 'Penyebaran konten negatif di grup WhatsApp.',
  ),
];

// =====================================================================
// 1. HALAMAN UTUH — ActivityScreen
// =====================================================================
class ActivityScreen extends StatefulWidget {
  const ActivityScreen({super.key});

  @override
  State<ActivityScreen> createState() => _ActivityScreenState();
}

class _ActivityScreenState extends State<ActivityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
class _TabLaporan extends StatelessWidget {
  const _TabLaporan();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
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
        ...dummyLaporan.map((lap) => _LaporanCard(item: lap)),
      ],
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
          color: const Color(0xFFC7E6F0), // Warna biru pastel yang senada
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

    return Container(
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
          const SizedBox(height: 8),
          Text(
            item.deskripsi,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.4,
            ),
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
              const Spacer(),
              Text(
                item.id,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: const Color(0xFF1A6B8A),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _StatusProgress(status: item.status),
        ],
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
class _TabKonseling extends StatelessWidget {
  const _TabKonseling();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _AjukanKonselingButton(),
        const SizedBox(height: 20),
        Text(
          'Riwayat Konseling',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 12),
        // Memanggil List Global dari data_riwayat_konseling.dart
        ...riwayatKonselingList.map((k) => _KonselingCard(item: k)),
      ],
    );
  }
}

class _AjukanKonselingButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/counseling/cari'),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF9FF5C0),
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF9FF5C0).withOpacity(0.5),
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
                Icons.psychology,
                color: Color(0xFF2A9D6A),
                size: 26,
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jadwalkan Sesi Baru",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF165C3B),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    "Temukan waktu yang tepat untukmu",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF165C3B).withOpacity(0.8),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF165C3B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _KonselingCard extends StatelessWidget {
  final KonselingItem item;
  const _KonselingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    // Ambil data status terpusat
    final statusInfo = getStatusInfoKonseling(item.status);

    return Container(
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
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFE0F2ED),
                child: Text(
                  item.konselor.split(' ').take(2).map((w) => w[0]).join(),
                  style: GoogleFonts.plusJakartaSans(
                    color: const Color(0xFF1A6B8A),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.konselor,
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 11,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '${item.tanggal} · ${item.jam}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Memanggil Widget Status (Warnanya otomatis ngikut)
              _StatusChip(
                label: statusInfo['label']!,
                color: statusInfo['color']! as Color,
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF0F2F5)),
          const SizedBox(height: 10),
          Text(
            item.id,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: const Color(0xFF1A6B8A),
              fontWeight: FontWeight.w600,
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
    final latestLaporan = dummyLaporan.isNotEmpty ? dummyLaporan.first : null;

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
        // Preview laporan terbaru
        if (latestLaporan != null) _buildLaporanPreview(context, latestLaporan),
        const SizedBox(height: 10),
        // Tombol laporan baru
        _buildCardPreviewLapor(context, onSeeAll),
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

    return Container(
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
    );
  }
}

Widget _buildCardPreviewLapor(BuildContext context, VoidCallback onTap) {
  return Material(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE0F2ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.campaign,
                color: Color(0xFF1A6B8A),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Laporkan Perundungan",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Buat laporan baru sekarang",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Color(0xFF1A6B8A),
            ),
          ],
        ),
      ),
    ),
  );
}
