import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- IMPORT SEMUA FILE ---
import 'main.dart';
import 'views/splash_screen/splash_care.dart';
import 'views/Beranda/home.dart';
import 'views/Beranda/activity.dart';
import 'views/Beranda/inbox.dart';
import 'views/Beranda/counseling.dart';
import 'views/Profile/profile.dart';
import 'views/Laporan_Perundungan/detail_laporan.dart';
import 'views/login_daftar_akun/login_care.dart';
import 'views/login_daftar_akun/register_care.dart';
import 'views/login_daftar_akun/verification_care.dart';
import 'views/login_daftar_akun/success_verification.dart';
import 'views/login_daftar_akun/google_account.dart';
import 'views/Laporan_Perundungan/LaporPerundunganPage.dart';
import 'views/Laporan_Perundungan/LaporanStep2Page.dart';
import 'views/Laporan_Perundungan/LaporanStep3Page.dart';
import 'views/Laporan_Perundungan/Laporanstep4page.dart';
import 'views/Konseling/cari_konselor.dart';
import 'views/Konseling/profil_konselor.dart';
import 'views/Konseling/konfirmasi_konseling.dart';
import 'views/Konseling/sukses_konseling.dart';
import 'views/Konseling/screen1_detail_konseling.dart';
import 'views/Konseling/screen3_detail_history.dart';
import 'views/Konseling/screen4_reschedule.dart';
import 'views/Konseling/screen_detail_sesi.dart';
import 'views/Profile/notification_settings.dart';
import 'views/Profile/account_security.dart';
import 'views/Profile/change_password.dart';
import 'views/Profile/password_updated.dart';
import 'views/Profile/edit_profile.dart';
import 'views/Profile/pusat_bantuan.dart';
import 'views/Profile/syarat_ketentuan.dart';
import 'views/Profile/tentang_aplikasi.dart';
import 'views/inbox/room_chat.dart';
import 'views/notification/notification_page.dart';
import 'views/notification/detail_laporan_page.dart';
import 'views/notification/detail_pesan_page.dart';
import 'services/api_service.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> activityNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  redirect: (context, state) {
    final publicRoutes = [
      '/login', 
      '/register', 
      '/splash', 
      '/verification', 
      '/success_verification', 
      '/google_account'
    ];
    final location = state.matchedLocation;
    final isPublic = publicRoutes.contains(location);
    final loggedIn = ApiService.isAuthenticated;

    debugPrint('GoRouter Guard: location=$location, isPublic=$isPublic, loggedIn=$loggedIn');

    if (!loggedIn && !isPublic) {
      debugPrint('GoRouter Guard: Redirecting to /login');
      return '/login';
    }
    if (loggedIn && isPublic && location != '/splash') {
      debugPrint('GoRouter Guard: Redirecting to /home');
      return '/home';
    }
    debugPrint('GoRouter Guard: Allowing navigation');
    return null;
  },
  routes: [
    // === AUTH & SPLASH ===
    GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginCare()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterCare(),
    ),
    GoRoute(
      path: '/verification',
      builder: (context, state) =>
          VerificationCare(email: state.extra as String? ?? ''),
    ),
    GoRoute(
      path: '/google_account',
      builder: (context, state) =>
          GoogleAccountSelection(isLogin: state.extra as bool? ?? true),
    ),
    GoRoute(
      path: '/success_verification',
      builder: (context, state) => const SuccessVerificationCare(),
    ),

    // === LAPORAN (Tanpa Navbar) ===
    GoRoute(
      path: '/activity/laporan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LaporanPerundunganPage(),
    ),
    GoRoute(
      path: '/activity/laporan/step2',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => LaporanStep2Page(
        prevData: state.extra as Map<String, dynamic>? ?? {},
      ),
    ),
    GoRoute(
      path: '/activity/laporan/step3',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => LaporanStep3Page(
        prevData: state.extra as Map<String, dynamic>? ?? {},
      ),
    ),
    GoRoute(
      path: '/activity/laporan/step4',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          LaporanStep4Page(data: state.extra as Map<String, dynamic>? ?? {}),
    ),

    // === KONSELING & INBOX (Tanpa Navbar) ===
    GoRoute(
      path: '/counseling/detail-sesi',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => Screen1DetailKonseling(
        sessionData: state.extra as Map<String, dynamic>?,
      ),
    ),
    GoRoute(
      path: '/counseling/detail-sesi-aktif',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        // Menangkap data map yang dikirim lewat context.push
        final data = state.extra as Map<String, dynamic>?;

        // Kembalikan ke ScreenDetailSesi dan oper datanya
        return ScreenDetailSesi(sessionData: data);
      },
    ),

    // ✅ PERBAIKAN: state.extra diteruskan ke Screen3DetailHistory
    GoRoute(
      path: '/counseling/detail-history',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => Screen3DetailHistory(
        sessionData: state.extra as Map<String, dynamic>?,
      ),
    ),

    GoRoute(
      path: '/counseling/reschedule',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => Screen4Reschedule(
        counselorData: state.extra as Map<String, dynamic>?,
      ),
    ),
    GoRoute(
      path: '/counseling/cari',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const FindCounselorPage(),
    ),
    GoRoute(
      path: '/counseling/profil',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => CounselorProfilePage(
        counselorData: state.extra as Map<String, dynamic>?,
      ),
    ),
    GoRoute(
      path: '/counseling/konfirmasi',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final e = state.extra as Map<String, dynamic>?;
        return ConfirmAppointmentPage(
          counselorData: e?['counselor'],
          tanggal: e?['tanggal'],
          waktu: e?['waktu'],
          mode: e?['mode'],
        );
      },
    ),
    GoRoute(
      path: '/counseling/sukses',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => SuccessAppointmentPage(
        sessionData: state.extra as Map<String, dynamic>?,
      ),
    ),
    GoRoute(
      path: '/inbox/room-chat',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) =>
          RoomChatPage(counselorData: state.extra as Map<String, dynamic>),
    ),

    // === NOTIFIKASI ===
    GoRoute(
      path: '/notifications',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const NotificationPage(),
    ),
    GoRoute(
      path: '/notifications/detail-laporan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const DetailLaporanPage(),
    ),
    GoRoute(
      path: '/notifications/detail-pesan',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final data = state.extra as Map<String, dynamic>?;
        return DetailPesanPage(notifData: data);
      },
    ),

    // === BOTTOM NAVBAR ===
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainScreen(navigationShell: navigationShell),
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
              builder: (context, state) =>
                  ActivityScreen(initialTab: state.extra),
              routes: [
                GoRoute(
                  path: 'detail-laporan',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final data = state.extra as Map<String, dynamic>?;
                    return HalamanDetailLaporan(laporanData: data);
                  },
                ),
              ],
            ),
          ],
        ),
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
              routes: [
                GoRoute(
                  path: 'edit-profile',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => const EditProfileScreen(),
                ),
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