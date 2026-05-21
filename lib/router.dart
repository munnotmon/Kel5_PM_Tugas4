import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- MAIN & NAVIGATION ---
import 'main.dart';

// --- VIEWS (Beranda) ---
import 'views/Beranda/home.dart';
import 'views/Beranda/activity.dart';
import 'views/Beranda/inbox.dart'; // class: InboxPage
import 'views/Beranda/counseling.dart';
import 'views/Beranda/profile.dart';

// --- VIEWS (Laporan & Auth) ---
import 'views/Laporan_Perundungan/detail_laporan.dart';
import 'views/Laporan_Perundungan/detail_laporan_baru.dart';
import 'views/Laporan_Perundungan/lapor_perundungan_page.dart';
import 'views/Laporan_Perundungan/laporan_step2_page.dart';
import 'views/Laporan_Perundungan/laporan_step3_page.dart';
import 'views/Laporan_Perundungan/laporan_step4_page.dart';
import 'views/login_daftar_akun/login_care.dart';
import 'views/login_daftar_akun/register_care.dart';
import 'views/login_daftar_akun/verification_care.dart';
import 'views/login_daftar_akun/success_verification.dart';
import 'views/login_daftar_akun/google_account.dart';
import 'views/splash_screen/splash_care.dart';

// --- OTHER ---
import 'tes.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> activityNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginCare()),
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
      path: '/google_account',
      builder: (context, state) {
        final bool isFromLogin = state.extra as bool? ?? true;
        return GoogleAccountSelection(isLogin: isFromLogin);
      },
    ),
    GoRoute(
      path: '/success_verification',
      builder: (context, state) => const SuccessVerificationCare(),
    ),

    // === FORM LAPORAN ===
    GoRoute(
      path: '/activity/laporan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LaporanPerundunganPage(),
    ),
    GoRoute(
      path: '/activity/laporan/step2',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return LaporanStep2Page(prevData: extra);
      },
    ),
    GoRoute(
      path: '/activity/laporan/step3',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return LaporanStep3Page(prevData: extra);
      },
    ),
    GoRoute(
      path: '/activity/laporan/step4',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>? ?? {};
        return LaporanStep4Page(data: extra);
      },
    ),
    GoRoute(
      path: '/tes-api',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DataListScreen(),
    ),

    // === RUTE MENGGUNAKAN BOTTOM NAVBAR ===
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: activityNavigatorKey,
          routes: [
            GoRoute(
              path: '/activity',
              builder: (context, state) => const ActivityScreen(),
              routes: [
                GoRoute(
                  path: 'detail-laporan',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const HalamanDetailLaporan(),
                ),
                GoRoute(
                  path: 'detail-laporan-baru',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const HalamanDetailLaporanBaru(),
                ),
              ],
            ),
          ],
        ),
        // ... (bagian atas router.dart Anda tetap sama)
        // ✅ Diperbaiki: InboxScreen → InboxPage
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const InboxPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/counseling',
              builder: (context, state) => const CounselingScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              routes: [],
            ),
          ],
        ),
      ],
    ),
  ],
);
