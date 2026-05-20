import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

// Pastikan path import ini sesuai dengan struktur folder kamu
import '../Konseling/data_konselor.dart';
import '../Konseling/data_riwayat_konseling.dart';

class CounselingScreen extends StatelessWidget {
  const CounselingScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(20),
        children: [
          // --- SESI MENDATANG ---
          _sectionTitle("Sesi Mendatang", "1 Aktif"),
          const SizedBox(height: 12),
          _buildSesiMendatangCard(context),

          const SizedBox(height: 24),

          // --- BANNER JADWALKAN ---
          _buildJadwalkanBanner(context),

          const SizedBox(height: 24),

          // --- PILIH KONSELOR ---
          _sectionTitle(
            "Pilih Konselor",
            "Lihat Semua",
            onTap: () => context.push('/counseling/cari'),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 230,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _KonselorGridCard(data: daftarKonselor[0]), // dr. Anton
                _KonselorGridCard(data: daftarKonselor[1]), // Siska, M.Psi
                _KonselorGridCard(data: daftarKonselor[2]), // Budi Hartono
                _KonselorGridCard(data: daftarKonselor[3]), // dr. Sarah Johnson
              ],
            ),
          ),

          const SizedBox(height: 24),

          // --- RIWAYAT KONSELING ---
          _sectionTitle(
            "Riwayat Konseling",
            "Lihat Semua",
            onTap: () => context.go('/activity'),
          ),
          const SizedBox(height: 12),

          // Looping otomatis membaca 2 data terakhir dari riwayatKonselingList
          ...riwayatKonselingList
              .take(2)
              .map((item) => _RiwayatKonselingCard(item: item)),
        ],
      ),
    );
  }

  // =====================================================================
  // WIDGET HELPERS
  // =====================================================================

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
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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

  Widget _buildSesiMendatangCard(BuildContext context) {
    return GestureDetector(
      // KETIKA DIKLIK, BUKA SCREEN 1 DETAIL KONSELING
      onTap: () => context.push('/counseling/detail-sesi'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF1A6B8A).withOpacity(0.1)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(radius: 28, backgroundColor: Colors.grey),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "dr. Sarah Johnson",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        "Konselor Psikologi Klinis",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                _timeInfo(Icons.calendar_today, "Besok, 12 Okt"),
                const SizedBox(width: 10),
                _timeInfo(Icons.access_time, "14:00 - 15:00"),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF2D81B4), Color(0xFF5AB6E5)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.push('/counseling/detail-sesi'), // Arahkan juga
                icon: const Icon(Icons.videocam, color: Colors.white, size: 20),
                label: Text(
                  "Gabung Sesi",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeInfo(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF1A6B8A)),
            const SizedBox(width: 6),
            Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJadwalkanBanner(BuildContext context) {
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

  // --- RIWAYAT CARD (Terhubung dengan database list) ---
  Widget _RiwayatKonselingCard({required KonselingItem item}) {
    // Ambil warna dan label otomatis dari fungsi helper di data_riwayat_konseling.dart
    final statusInfo = getStatusInfoKonseling(item.status);
    final Color statusColor = statusInfo['color'];
    final String statusLabel = statusInfo['label'];

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
    );
  }
}

// =====================================================================
// WIDGET CARD GRID KONSELOR
// =====================================================================
class _KonselorGridCard extends StatelessWidget {
  final Map<String, dynamic> data;

  const _KonselorGridCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/counseling/profil', extra: data),
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const CircleAvatar(radius: 40, backgroundColor: Colors.grey),
            const SizedBox(height: 10),
            Text(
              data['name'],
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              data['specialty'],
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
                const Icon(Icons.star, color: Colors.amber, size: 12),
                const SizedBox(width: 4),
                Text(
                  data['rating'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " (${data['sessions']})",
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
    );
  }
}

// =====================================================================
// SECTION UNTUK HOME SCREEN (CounselingSection)
// =====================================================================
class CounselingSection extends StatelessWidget {
  final VoidCallback? onNavigate;

  const CounselingSection({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Jadwal Konseling",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => context.go('/activity'),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Text(
                    "Riwayat",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1D9BFF),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFE0F2ED),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Butuh teman bicara?",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jadwalkan sesi privat dengan konselor kami.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onNavigate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1068A3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text("Jadwalkan"),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        _buildJadwalCardHome(context),
      ],
    );
  }
}

Widget _buildJadwalCardHome(BuildContext context) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FA),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const CircleAvatar(radius: 22, backgroundColor: Colors.blueGrey),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BESOK, 10:00",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 10,
                      color: const Color(0xFF1068A3),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Sesi dengan dr. Anton Wijaya",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    ),
  );
}
