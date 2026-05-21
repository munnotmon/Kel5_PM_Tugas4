import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'main.dart';
import 'views/beranda/home.dart';
import 'views/beranda/activity.dart';
import 'views/beranda/inbox.dart';
import 'views/inbox/inbox.dart';
import 'views/beranda/counseling.dart';
import 'views/profile/profile.dart';
import 'views/laporan_perundungan/detail_laporan.dart';
import 'views/laporan_perundungan/detail_laporan_baru.dart';
import 'views/splash_screen/splash_care.dart';
import 'views/auth/login_care.dart';
import 'views/auth/register_care.dart';
import 'views/auth/verification_care.dart';
import 'views/auth/success_verification.dart';
import 'views/auth/google_account.dart';
import 'views/laporan_perundungan/LaporPerundunganPage.dart';
import 'views/laporan_perundungan/LaporanStep2Page.dart';
import 'views/laporan_perundungan/LaporanStep3Page.dart';
import 'views/laporan_perundungan/LaporanStep4Page.dart';
import 'views/konseling/cari_konselor.dart';
import 'views/konseling/profil_konselor.dart';
import 'views/konseling/konfirmasi_konseling.dart';
import 'views/konseling/sukses_konseling.dart';
import 'views/konseling/screen1_detail_konseling.dart';
import 'views/konseling/screen3_detail_history.dart';
import 'views/konseling/screen4_reschedule.dart';
import 'views/konseling/detail_sesi.dart';
import 'views/profile/notification_settings.dart';
import 'views/profile/account_security.dart';
import 'views/profile/change_password.dart';
import 'views/profile/password_updated.dart';
import 'views/profile/pusat_bantuan.dart';
import 'views/profile/syarat_ketentuan.dart';
import 'views/profile/tentang_aplikasi.dart';

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

    // === RUTE HALAMAN KONSELING TAMBAHAN (Di luar ShellRoute agar navbar hilang) ===
    GoRoute(
      path: '/counseling/detail-sesi',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Screen1DetailKonseling(),
    ),
    GoRoute(
      path: '/counseling/detail-history',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Screen3DetailHistory(),
    ),
    GoRoute(
      path: '/counseling/reschedule',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const Screen4Reschedule(),
    ),
    GoRoute(
      path: '/counseling/cari',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FindCounselorPage(),
    ),
    GoRoute(
      path: '/counseling/profil',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return CounselorProfilePage(counselorData: data);
      },
    ),
    GoRoute(
      path: '/counseling/konfirmasi',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return ConfirmAppointmentPage(
          counselorData: extra?['counselor'],
          tanggal: extra?['tanggal'],
          waktu: extra?['waktu'],
          mode: extra?['mode'],
        );
      },
    ),

    // --- RUTE SUKSES DIPERBARUI AGAR MENANGKAP DATA ---
    GoRoute(
      path: '/counseling/sukses',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return SuccessAppointmentPage(sessionData: data);
      },
    ),

    // --- RUTE DETAIL SESI AKTIF BARU DITAMBAHKAN ---
    GoRoute(
      path: '/counseling/detail-sesi-aktif',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return DetailSesiScreen(sessionData: data);
      },
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
              // PERBAIKAN: Mengarah ke halaman utama konseling
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
              routes: [
                GoRoute(
                  path: 'notification-settings',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) =>
                      const NotificationSettingsScreen(),
                ),
                GoRoute(
                  path: 'account-security',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const AccountSecurityScreen(),
                ),
                GoRoute(
                  path: 'change-password',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const ChangePasswordScreen(),
                ),
                GoRoute(
                  path: 'password-updated',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const PasswordUpdatedScreen(),
                ),
                GoRoute(
                  path: 'pusat-bantuan',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const PusatBantuanScreen(),
                ),
                GoRoute(
                  path: 'syarat-ketentuan',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const SyaratKetentuanScreen(),
                ),
                GoRoute(
                  path: 'tentang-aplikasi',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const TentangAplikasiScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
