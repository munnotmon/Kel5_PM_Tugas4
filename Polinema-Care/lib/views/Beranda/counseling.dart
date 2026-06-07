import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../controllers/counseling_controller.dart';
import '../../models/counseling_model.dart';
import '../../models/counselor_model.dart';


class CounselingScreen extends StatefulWidget {
  const CounselingScreen({super.key});

  @override
  State<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends State<CounselingScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      CounselingController.fetchKonselor(),
      CounselingController.fetchBookings(),
    ]);
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final konselorList = CounselingController.daftarKonselor;
    final riwayat = CounselingController.riwayatKonselingList;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Konseling",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        children: [
          // --- HERO HEADER CARD ---
          _buildHeroCard(context),
          const SizedBox(height: 24),

          // --- QUICK ACTIONS ---
          _buildQuickActions(context),
          const SizedBox(height: 32),

          // --- PILIH KONSELOR ---
          _sectionTitle(
            "Pilih Konselor",
            "Lihat Semua",
            onTap: () => context.push('/counseling/cari'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : konselorList.isEmpty
                    ? Center(
                        child: Text(
                          "Belum ada konselor tersedia",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView(
                        scrollDirection: Axis.horizontal,
                        children: konselorList
                            .map((k) => _KonselorGridCard(data: k))
                            .toList(),
                      ),
          ),

          const SizedBox(height: 32),

          // --- RIWAYAT KONSELING ---
          _sectionTitle(
            "Riwayat Sesi",
            "Lihat Semua",
            onTap: () => context.go('/activity', extra: 1),
          ),
          const SizedBox(height: 12),

          if (riwayat.isEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                "Belum ada riwayat konseling",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ...riwayat
              .take(3)
              .map(
                (item) => _RiwayatKonselingCard(context: context, item: item),
              ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1068A3).withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.psychology,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "Polinema Care+",
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Prioritaskan Kesehatan Mentalmu",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Konseling privat, aman, dan tanpa biaya bersama psikolog profesional pilihanmu.",
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/counseling/cari'),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE8F4FD),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search_rounded,
                      color: Color(0xFF1068A3),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Cari Konselor",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Temukan psikolog",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () => context.go('/activity', extra: 1),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.grey.shade100),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF9F1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.event_note_rounded,
                      color: Color(0xFF2A9D6A),
                      size: 20,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Riwayat Sesi",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Catatan & riwayat",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sectionTitle(String title, String action, {VoidCallback? onTap}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2F8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              action,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1A6B8A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _RiwayatKonselingCard({
    required BuildContext context,
    required KonselingItem item,
  }) {
    final statusInfo = getStatusInfoKonseling(item.status);
    final Color statusColor = statusInfo['color'];
    final String statusLabel = statusInfo['label'];

    return GestureDetector(
      // ✅ PERBAIKAN: kirim data item sebagai extra
      onTap: () {
        if (item.status == StatusKonseling.selesai) {
          GoRouter.of(context).push(
            '/counseling/detail-history',
            extra: item.toMap(),
          );
        } else if (item.status == StatusKonseling.diterima || item.status == StatusKonseling.berlangsung) {
          GoRouter.of(context).push(
            '/counseling/detail-sesi-aktif',
            extra: item.toMap(),
          );
        } else if (item.status == StatusKonseling.diajukan) {
          GoRouter.of(context).push(
            '/counseling/detail-sesi',
            extra: item.toMap(),
          );
        }
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
        child: Row(
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.3)),
              ),
              child: Text(
                statusLabel.toUpperCase(),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: statusColor,
                  fontWeight: FontWeight.w800,
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
// WIDGET CARD GRID KONSELOR
// =====================================================================
class _KonselorGridCard extends StatelessWidget {
  final Konselor data;

  const _KonselorGridCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (data.isQuotaFull) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Sesi ${data.name} hari ini sudah penuh",
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.red[700],
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return;
        }
        context.push('/counseling/profil', extra: data.toMap());
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Opacity(
          opacity: data.isQuotaFull ? 0.55 : 1.0,
          child: Column(
            children: [
              // --- BUNGKUS DENGAN STACK ---
              Stack(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: NetworkImage(
                      (data.fotoProfil != null && data.fotoProfil!.isNotEmpty)
                          ? data.fotoProfil!
                          : "https://i.pravatar.cc/150?u=${data.name}",
                    ),
                  ),
                  if (data.isOnline)
                    Positioned(
                      bottom: 2, // Sesuaikan agar pas di garis tepi bawah
                      right: 6,  // Sesuaikan agar bergeser ke kanan
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                ],
              ),
              // ----------------------------
              const SizedBox(height: 10),
              Text(
                data.name,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                data.specialty,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.chat_bubble_outline,
                    color: Colors.grey[500],
                    size: 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    " (${data.sessions})", // perbaikan spasi agar tidak nempel dengan icon
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}