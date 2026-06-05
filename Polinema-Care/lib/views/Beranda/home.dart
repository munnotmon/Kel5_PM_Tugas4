import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'counseling.dart';
import '../../controllers/laporan_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _unreadCount = 0;
  Timer? _timer;
  Future<List<Map<String, dynamic>>>? _reportsFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = LaporanController.fetchReports();
    _fetchUnreadCount();
    _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
      _fetchUnreadCount();
      _refreshData();
    });
  }

  void _refreshData() {
    if (!ApiService.isAuthenticated) return;
    if (mounted) {
      setState(() {

        _reportsFuture = LaporanController.fetchReports();
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchUnreadCount() async {
    if (!ApiService.isAuthenticated) return;
    try {
      final response = await ApiService.get('/notifikasi');
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        if (body['success'] == true) {
          final List list = body['data'] ?? [];
          final count = list.where((item) => item['sudah_dibaca'] == false || item['sudah_dibaca'] == 0 || item['sudah_dibaca'] == '0').length;
          if (mounted) {
            setState(() {
              _unreadCount = count;
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching unread notification count: $e');
    }
  }

  Widget _buildNotificationBell(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        GestureDetector(
          onTap: () async {
            await context.push('/notifications');
            _fetchUnreadCount();
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withOpacity(0.15)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: Color(0xFF1068A3),
              size: 22,
            ),
          ),
        ),
        if (_unreadCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.redAccent,
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                '$_unreadCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
      ],
    );
  }

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
                    _buildNotificationBell(context),
                  ],
                ),
                const SizedBox(height: 22),

                Text(
                  'Halo, ${AuthController.currentUserName}',
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
                      'Menu Laporkan Perundungan',
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
                  onSeeAll: () =>
                      context.go('/activity', extra: 0), // ← fix: push → go
                  future: _reportsFuture,
                ),

                const SizedBox(height: 32),

                // --- SECTION KONSELING ---
                CounselingSection(
                  onNavigate: () => context.push('/counseling/cari'),
                  onSeeHistory: () =>
                      context.go('/activity', extra: 1), // ← fix: push → go
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActivitySection extends StatelessWidget {
  final VoidCallback? onSeeAll;
  final Future<List<Map<String, dynamic>>>? future;

  const ActivitySection({super.key, this.onSeeAll, this.future});

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
        FutureBuilder<List<Map<String, dynamic>>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
            }
            final reports = snapshot.data ?? [];
            if (reports.isEmpty) {
              return Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.2)),
                ),
                child: Text(
                  "Belum ada laporan diajukan.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }

            final latest = reports.first;
            final statusStr = latest['status'] ?? 'Menunggu';
            final id = latest['id']?.toString() ?? '';
            final title = latest['judul_pelaporan'] ?? 'Laporan Perundungan';
            final kronologi = latest['kronologi'] ?? '';

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

            Color statusColor;
            switch (statusStr.toLowerCase()) {
              case 'menunggu':
                statusColor = Colors.orange;
                break;
              case 'diterima':
                statusColor = Colors.lightBlue;
                break;
              case 'diproses':
                statusColor = Colors.blue;
                break;
              case 'selesai':
                statusColor = Colors.green;
                break;
              case 'ditolak':
                statusColor = Colors.red;
                break;
              default:
                statusColor = Colors.orange;
            }

            return GestureDetector(
              onTap: () {
                context.push(
                  '/activity/detail-laporan',
                  extra: {
                    'id': 'RPT-$id',
                    'judul': title,
                    'tanggal': LaporanController.formatWaktu(latest['tanggal_kejadian'] ?? latest['created_at']?.toString()),
                    'deskripsi': kronologi,
                    'statusLabel': statusStr,
                    'statusColor': statusColor,
                    'jenis_perundungan': latest['jenis_perundungan'] ?? '-',
                    'lokasi': (latest['lokasi'] != null && latest['lokasi'].toString().trim().isNotEmpty) ? latest['lokasi'].toString() : '-',
                    'pelaku': (latest['deskripsi_pelaku'] != null && latest['deskripsi_pelaku'].toString().trim().isNotEmpty) ? latest['deskripsi_pelaku'].toString() : '-',
                    'saksi': saksiParsed,
                    'korban': korbanParsed,
                  },
                );
              },
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
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Status: $statusStr",
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        statusStr.toLowerCase() == 'selesai'
                            ? Icons.check_circle
                            : statusStr.toLowerCase() == 'ditolak'
                                ? Icons.cancel
                                : Icons.check_circle_outline,
                        color: statusColor,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
