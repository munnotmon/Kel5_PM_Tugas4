import 'dart:async';
import 'dart:convert';
import 'dart:typed_data' show Uint8List;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/laporan_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/counseling_controller.dart';
import '../../models/counseling_model.dart';
import '../../services/api_service.dart';
import '../Profile/profile_store.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _unreadCount = 0;
  Timer? _timer;
  Future<List<Map<String, dynamic>>>? _reportsFuture;
  Future<List<KonselingItem>>? _counselingFuture;

  @override
  void initState() {
    super.initState();
    _reportsFuture = LaporanController.ambilDaftarLaporan();
    _counselingFuture = CounselingController.fetchBookings();
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
        _reportsFuture = LaporanController.ambilDaftarLaporan();
        _counselingFuture = CounselingController.fetchBookings();
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

  String _mapImageUrl(String url) {
    if (url.isEmpty) return '';
    if (kIsWeb) return url;
    if (ApiService.baseUrl.contains('127.0.0.1')) {
      return url.replaceAll('localhost', '127.0.0.1');
    }
    return url.replaceAll('localhost', '10.0.2.2').replaceAll('127.0.0.1', '10.0.2.2');
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

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 11) return 'Selamat Pagi';
    if (hour < 15) return 'Selamat Siang';
    if (hour < 18) return 'Selamat Sore';
    return 'Selamat Malam';
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: color.withOpacity(0.12), width: 1.5),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A2D3D),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = AuthController.currentUserName;
    final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- PROFILE & NOTIFICATION HEADER ---
                Row(
                  children: [
                    ValueListenableBuilder<Uint8List?>(
                      valueListenable: ProfileStore.photo,
                      builder: (ctx, localBytes, _) {
                        if (localBytes != null) {
                          return CircleAvatar(
                            radius: 20,
                            backgroundImage: MemoryImage(localBytes),
                          );
                        }
                        return ValueListenableBuilder<String>(
                          valueListenable: ProfileStore.photoUrl,
                          builder: (ctx2, url, _) {
                            if (url.isNotEmpty) {
                              return CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(_mapImageUrl(url)),
                                onBackgroundImageError: (_, __) {},
                                backgroundColor: const Color(0xFF1068A3).withOpacity(0.1),
                              );
                            }
                            return CircleAvatar(
                              radius: 20,
                              backgroundColor: const Color(0xFF1068A3).withOpacity(0.1),
                              child: Text(
                                initial,
                                style: GoogleFonts.plusJakartaSans(
                                  color: const Color(0xFF1068A3),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getGreeting(),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              color: const Color(0xFF94A3B8),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              color: const Color(0xFF1E293B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildNotificationBell(context),
                  ],
                ),
                const SizedBox(height: 24),

                // --- HERO CARD BANNER ---
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1068A3), Color(0xFF1E3A8A)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF1068A3).withOpacity(0.25),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(28),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.white.withOpacity(0.2)),
                                ),
                                child: Text(
                                  "POLINEMA CARE+",
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              Text(
                                "Kamu Tidak Sendiri.",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  height: 1.2,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Kami hadir untuk mendengarkan, melindungi, dan mendampingi langkahmu secara aman dan rahasia.",
                                style: GoogleFonts.plusJakartaSans(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                  height: 1.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () => context.push('/activity/laporan'),
                                icon: const Icon(Icons.campaign_rounded, color: Color(0xFF1068A3), size: 18),
                                label: Text(
                                  "Laporkan Perundungan",
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: const Color(0xFF1068A3),
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF1068A3),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          right: -20,
                          bottom: -20,
                          child: Icon(
                            Icons.shield_outlined,
                            size: 140,
                            color: Colors.white.withOpacity(0.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // --- LAYANAN KAMI SECTION ---
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Layanan Kami",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildQuickActionItem(
                          context,
                          icon: Icons.campaign_rounded,
                          label: "Buat Laporan",
                          color: const Color(0xFFEF4444),
                          onTap: () => context.push('/activity/laporan'),
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.calendar_month_rounded,
                          label: "Cari Konselor",
                          color: const Color(0xFF3B82F6),
                          onTap: () => context.push('/counseling/cari'),
                        ),
                        _buildQuickActionItem(
                          context,
                          icon: Icons.help_center_rounded,
                          label: "Pusat Bantuan",
                          color: const Color(0xFF8B5CF6),
                          onTap: () => context.push('/profile/pusat-bantuan'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // --- SECTION AKTIVITAS ---
                ActivitySection(
                  onSeeAll: () => context.go('/activity', extra: 0),
                  future: _reportsFuture,
                ),
                const SizedBox(height: 28),

                // --- SECTION SESI MENDATANG ---
                UpcomingSessionSection(
                  future: _counselingFuture,
                  onNavigate: () => context.push('/counseling/cari'),
                ),
                const SizedBox(height: 24),
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
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            GestureDetector(
              onTap: onSeeAll,
              child: Text(
                "Lihat Semua",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1068A3),
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
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Text(
                  "Belum ada laporan diajukan.",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: const Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
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
                statusColor = const Color(0xFFF59E0B);
                break;
              case 'diterima':
                statusColor = const Color(0xFF0284C7);
                break;
              case 'diproses':
                statusColor = const Color(0xFF3B82F6);
                break;
              case 'selesai':
                statusColor = const Color(0xFF10B981);
                break;
              case 'ditolak':
                statusColor = const Color(0xFFEF4444);
                break;
              default:
                statusColor = const Color(0xFFF59E0B);
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
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                  border: Border.all(color: const Color(0xFFF1F5F9)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.description_outlined,
                        color: statusColor,
                        size: 24,
                      ),
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
                              fontWeight: FontWeight.w800,
                              fontSize: 15,
                              color: const Color(0xFF1A2D3D),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                statusStr.toUpperCase(),
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: statusColor,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Color(0xFF94A3B8),
                      size: 16,
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

class UpcomingSessionSection extends StatelessWidget {
  final Future<List<KonselingItem>>? future;
  final VoidCallback? onNavigate;

  const UpcomingSessionSection({super.key, this.future, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sesi Mendatang",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF1E293B),
              ),
            ),
            GestureDetector(
              onTap: () {
                context.go('/activity', extra: 1);
              },
              child: Text(
                "Lihat Semua",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1068A3),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        FutureBuilder<List<KonselingItem>>(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()));
            }
            final list = snapshot.data ?? [];
            final upcomingList = list.where((item) =>
                item.status == StatusKonseling.diajukan ||
                item.status == StatusKonseling.diterima ||
                item.status == StatusKonseling.berlangsung).toList();

            if (upcomingList.isEmpty) {
              return _buildEmptyUpcomingCard(context);
            }

            final item = upcomingList.first;
            return _buildUpcomingCard(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildEmptyUpcomingCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFF1F5F9)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Color(0xFFEFF6FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.calendar_today_rounded,
              size: 32,
              color: Color(0xFF1068A3),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Belum Ada Sesi Terjadwal",
            style: GoogleFonts.plusJakartaSans(
              fontWeight: FontWeight.w800,
              fontSize: 16,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Jadwalkan sesi privat dengan konselor pilihanmu untuk bimbingan lebih lanjut.",
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: const Color(0xFF94A3B8),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            height: 44,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1068A3), Color(0xFF2563EB)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1068A3).withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: onNavigate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                "Jadwalkan Sekarang",
                style: GoogleFonts.plusJakartaSans(
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

  Widget _buildUpcomingCard(BuildContext context, KonselingItem item) {
    final specialty = CounselingController.getSpecialty(item.konselor);
    final isConfirmed = item.status == StatusKonseling.diterima || item.status == StatusKonseling.berlangsung;

    return GestureDetector(
      onTap: () {
        if (isConfirmed) {
          context.push(
            '/counseling/detail-sesi-aktif',
            extra: item.toMap(),
          );
        } else {
          context.push(
            '/counseling/detail-sesi',
            extra: item.toMap(),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF1068A3).withOpacity(0.1), width: 2),
                  ),
                  child: CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey.shade100,
                    backgroundImage: NetworkImage(
                      'https://i.pravatar.cc/150?u=${item.konselor.replaceAll(' ', '')}',
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         item.konselor,
                         style: GoogleFonts.plusJakartaSans(
                           fontWeight: FontWeight.bold,
                           fontSize: 15,
                           color: const Color(0xFF1A2D3D),
                         ),
                       ),
                       const SizedBox(height: 3),
                       Text(
                         specialty.isNotEmpty ? specialty : 'Konselor Profesional',
                         style: GoogleFonts.plusJakartaSans(
                           fontSize: 12,
                           color: const Color(0xFF94A3B8),
                           fontWeight: FontWeight.w500,
                         ),
                       ),
                     ],
                   ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: isConfirmed
                        ? const Color(0xFFEFF6FF)
                        : const Color(0xFFFFF7ED),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isConfirmed ? const Color(0xFFBFDBFE) : const Color(0xFFFED7AA),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    isConfirmed ? "DIKONFIRMASI" : "MENUNGGU",
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: isConfirmed ? const Color(0xFF2563EB) : const Color(0xFFEA580C),
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _timeInfo(Icons.calendar_today_rounded, item.tanggal),
                const SizedBox(width: 12),
                _timeInfo(Icons.access_time_filled_rounded, item.jam),
              ],
            ),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1068A3), Color(0xFF2563EB)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF1068A3).withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  if (isConfirmed) {
                    context.push(
                      '/counseling/detail-sesi-aktif',
                      extra: item.toMap(),
                    );
                  } else {
                    context.push(
                      '/counseling/detail-sesi',
                      extra: item.toMap(),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Lihat Detail Sesi",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white,
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
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF1068A3)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A2D3D),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
