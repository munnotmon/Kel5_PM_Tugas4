import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'Beranda/home.dart';
import 'Beranda/activity.dart';
import 'Beranda/inbox.dart';
import 'inbox/inbox.dart';
import 'Beranda/counseling.dart';
import 'Beranda/profile.dart';
import 'Laporan_Perundungan/detail_laporan.dart';
import 'Laporan_Perundungan/detail_laporan_baru.dart';
import 'splash_screen/splash_care.dart';
import 'login_daftar_akun/login_care.dart';
import 'login_daftar_akun/register_care.dart';
import 'login_daftar_akun/verification_care.dart';
import 'login_daftar_akun/success_verification.dart';
import 'login_daftar_akun/google_account.dart';
import 'Laporan_Perundungan/LaporPerundunganPage.dart';
import 'Laporan_Perundungan/LaporanStep2Page.dart';
import 'Laporan_Perundungan/LaporanStep3Page.dart';
import 'Laporan_Perundungan/LaporanStep4Page.dart';
import 'Konseling/cari_konselor.dart';
import 'Konseling/profil_konselor.dart';
import 'Konseling/konfirmasi_konseling.dart';
import 'Konseling/sukses_konseling.dart';
import 'Konseling/screens/screen1_detail_konseling.dart';
import 'Konseling/screens/screen2_history_konseling.dart';
import 'Konseling/screens/screen3_detail_history.dart';
import 'Konseling/screens/screen4_reschedule.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> activityNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
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

    // === FORM LAPORAN — di luar ShellRoute agar navbar hilang ===
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
      path: '/counseling/cari',
      parentNavigatorKey: _rootNavigatorKey, // Menyembunyikan Bottom Navbar
      builder: (context, state) => const FindCounselorPage(),
    ),
    GoRoute(
      path: '/counseling/profil',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        // Tangkap data yang dikirim melalui extra
        final data = state.extra as Map<String, dynamic>?;
        return CounselorProfilePage(counselorData: data);
      },
    ),
    GoRoute(
      path: '/counseling/konfirmasi',
      builder: (context, state) {
        // Ambil extra data. Biarkan null jika tidak ada (nanti ditangani di ConfirmAppointmentPage)
        final extra = state.extra as Map<String, dynamic>?;

        return ConfirmAppointmentPage(
          counselorData: extra?['counselor'],
          tanggal: extra?['tanggal'],
          waktu: extra?['waktu'],
          mode: extra?['mode'],
        );
      },
    ),
    GoRoute(
      path: '/counseling/sukses',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SuccessAppointmentPage(),
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
        // Tab 2: Inbox
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/inbox',
              builder: (context, state) => const InboxPage(),
            ),
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
