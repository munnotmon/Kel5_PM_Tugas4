import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- IMPORT SEMUA FILE ---
import 'main.dart';
import 'splash_screen/splash_care.dart';
import 'Beranda/home.dart';
import 'Beranda/activity.dart';
import 'Beranda/inbox.dart';
import 'Beranda/counseling.dart';
import 'Profile/profile.dart';
import 'Laporan_Perundungan/detail_laporan.dart';
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
import 'Konseling/screen1_detail_konseling.dart';
import 'Konseling/screen3_detail_history.dart';
import 'Konseling/screen4_reschedule.dart';
import 'Profile/notification_settings.dart';
import 'Profile/account_security.dart';
import 'Profile/change_password.dart';
import 'Profile/password_updated.dart';
import 'Profile/pusat_bantuan.dart';
import 'Profile/syarat_ketentuan.dart';
import 'Profile/tentang_aplikasi.dart';
import 'inbox/room_chat.dart';
import 'notification/notification_page.dart';
import 'notification/detail_laporan_page.dart';
import 'notification/detail_pesan_page.dart';
import 'Konseling/screen_detail_sesi.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> activityNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
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
      builder: (context, state) => const Screen1DetailKonseling(),
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