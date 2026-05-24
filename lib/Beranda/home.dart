import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'activity.dart';
import 'counseling.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- HEADER SECTION ---
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: const [
                            Icon(
                              Icons.shield,
                              color: Color(0xFF1068A3),
                              size: 32,
                            ),
                            Icon(Icons.favorite, color: Colors.white, size: 14),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Text(
                          "Polinema Care+",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF2D3142),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => context.push('/notifications'),
                      icon: const Icon(
                        Icons.notifications_none,
                        color: Color(0xFF1068A3),
                        size: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),

                Text(
                  'Halo, Kelompok 5',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  'Kamu Tidak Sendiri.',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF2D2D2D),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 15),

                // --- BUTTON LAPOR ---
                Container(
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3B79AD), Color(0xFF7CB6E1)],
                    ),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      context.push('/activity/laporan');
                    },
                    icon: const Icon(
                      Icons.campaign,
                      color: Colors.white,
                      size: 32,
                    ),
                    label: Text(
                      'Laporkan Perundungan',
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // --- SECTION AKTIVITAS ---
                ActivitySection(
                  onSeeAll: () => context.go('/activity', extra: 0), // ← fix: push → go
                ),

                const SizedBox(height: 32),

                // --- SECTION KONSELING ---
                CounselingSection(
                  onNavigate: () => context.push('/counseling/cari'),
                  onSeeHistory: () => context.go('/activity', extra: 1), // ← fix: push → go
                ),

                const SizedBox(height: 32),

                // --- SECTION INBOX ---
                InboxSection(onNavigate: () => context.go('/inbox')),

                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =====================================================================
// WIDGET COMPONENT: ACTIVITY SECTION
// =====================================================================
class ActivitySection extends StatelessWidget {
  final VoidCallback? onSeeAll;

  const ActivitySection({super.key, this.onSeeAll});

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
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                "Lihat Semua",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1D9BFF),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: () => context.push('/activity/detail-laporan'),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2F8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.campaign, color: Color(0xFF1A6B8A)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Laporan Perundungan",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Status: Diproses (#RPT-001)",
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.orange,
                          fontWeight: FontWeight.w600,
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
      ],
    );
  }
}

// =====================================================================
// WIDGET COMPONENT: INBOX SECTION
// =====================================================================
class InboxSection extends StatelessWidget {
  final VoidCallback? onNavigate;

  const InboxSection({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Inbox",
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF1A1A1A),
          ),
        ),
        const SizedBox(height: 16),

        _buildInboxCard(
          title: "Sistem Respon",
          time: "2 JAM LALU",
          message: "Bukti baru telah ditambahkan ke lapora...",
          isUnread: true,
          onTap: onNavigate,
        ),
        const SizedBox(height: 12),

        _buildInboxCard(
          title: "Admin Kampus",
          time: "KEMARIN",
          message: "Selamat datang di platform Respon &...",
          isUnread: false,
          onTap: onNavigate,
        ),
      ],
    );
  }

  Widget _buildInboxCard({
    required String title,
    required String time,
    required String message,
    required bool isUnread,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FBFB),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.grey.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    if (isUnread) ...[
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1068A3),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3142),
                      ),
                    ),
                  ],
                ),
                Text(
                  time,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: isUnread ? 16.0 : 0),
              child: Text(
                message,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}