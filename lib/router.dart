import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import semua halaman yang dibutuhkan
import 'main.dart';
import 'Beranda/home.dart';
import 'Beranda/activity.dart';
import 'Beranda/inbox.dart';
import 'Beranda/counseling.dart';
import 'Beranda/profile.dart';
import 'halaman_pendukung/detail_laporan.dart';
import 'halaman_pendukung/detail_laporan_baru.dart';
import 'splash_screen/splash_care.dart';
import 'login_daftar_akun/login_care.dart';
import 'login_daftar_akun/register_care.dart';
import 'login_daftar_akun/verification_care.dart';
import 'login_daftar_akun/success_verification.dart';

// Kunci navigasi global (penting agar halaman detail bisa menutupi navbar)
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login', // Halaman pertama kali dibuka
  routes: [
    // --- PASTIKAN KEDUA RUTE INI ADA DI SINI ---
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(
      path: '/login', // <--- INI ADALAH RUTE YANG DICARI OLEH SISTEM
      builder: (context, state) => const LoginCare(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterCare(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) {
        final email = state.extra as String? ?? '';
        return VerificationCare(email: email);
      },
    ),
    GoRoute(
      path: '/success_verification',
      builder: (context, state) => const SuccessVerificationCare(),
    ),

    // === RUTE MENGGUNAKAN BOTTOM NAVBAR ===
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        // Tab 1: Activity
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/activity',
              builder: (context, state) => const ActivityScreen(),
              routes: [
                // Sub-rute: Detail Laporan Lama
                GoRoute(
                  path: 'detail-laporan',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const HalamanDetailLaporan(),
                ),
                // Sub-rute: Detail Laporan Baru
                GoRoute(
                  path: 'detail-laporan-baru',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const HalamanDetailLaporanBaru(),
                ),
              ],
            ),
          ],
        ),
        // Tab 2: Inbox
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const InboxScreen(),
            ),
          ],
        ),
        // Tab 3: Counseling
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/counseling',
              builder: (context, state) => const CounselingScreen(),
            ),
          ],
        ),
        // Tab 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
