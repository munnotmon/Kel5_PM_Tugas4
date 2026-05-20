import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'Beranda/home.dart';
import 'Beranda/activity.dart';
import 'Beranda/inbox.dart';
import 'inbox/inbox.dart';
import 'Beranda/counseling.dart';
import 'Beranda/profile.dart';
import 'halaman_pendukung/detail_laporan.dart';
import 'halaman_pendukung/detail_laporan_baru.dart';
import 'splash_screen/splash_care.dart';
import 'login_daftar_akun/login_care.dart';
import 'login_daftar_akun/register_care.dart';
import 'login_daftar_akun/verification_care.dart';
import 'login_daftar_akun/success_verification.dart';
import 'login_daftar_akun/google_account.dart';
import 'konseling/screens/screen1_detail_konseling.dart';
import 'konseling/screens/screen2_history_konseling.dart';
import 'konseling/screens/screen3_detail_history.dart';
import 'konseling/screens/screen4_reschedule.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginCare()),
    GoRoute(path: '/register', builder: (context, state) => const RegisterCare()),
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
    GoRoute(path: '/success_verification', builder: (context, state) => const SuccessVerificationCare()),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScreen(navigationShell: navigationShell);
      },
      branches: [
        // Tab 0: Home
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
          ],
        ),
        // Tab 1: Activity
        StatefulShellBranch(
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
        // Tab 2: Inbox
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/inbox', builder: (context, state) => const InboxPage()),
          ],
        ),
        // Tab 3: Counseling
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/counseling',
              builder: (context, state) => const Screen1DetailKonseling(),
              routes: [
                GoRoute(
                  path: 'history',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Screen2HistoryKonseling(),
                ),
                GoRoute(
                  path: 'detail-history',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Screen3DetailHistory(),
                ),
                GoRoute(
                  path: 'reschedule',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const Screen4Reschedule(),
                ),
              ],
            ),
          ],
        ),
        // Tab 4: Profile
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
          ],
        ),
      ],
    ),
  ],
);