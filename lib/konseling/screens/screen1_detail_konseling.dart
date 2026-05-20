import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart';

class Screen1DetailKonseling extends StatelessWidget {
  const Screen1DetailKonseling({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          const PhoneStatusBar(),
          const PhoneNavTop(title: 'Detail Sesi'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Status Sesi', style: TextStyle(fontSize: 10, color: kTextMuted)),
                          SizedBox(height: 4),
                          Text('Terjadwal', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kTextPrimary)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(color: const Color(0xFFD1FAE5), borderRadius: BorderRadius.circular(20)),
                        child: const Text('● Aktif', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Color(0xFF065F46))),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBorder)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(10, 8, 10, 2),
                        child: Text('KONSELOR SENIOR', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: kTeal, letterSpacing: 0.5)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const CircleAvatar(radius: 24, backgroundColor: kTeal, child: Text('AW', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white))),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text('dr. Anton Wijaya', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: kTextPrimary)),
                                Text('Spesialis Psikologi Klinis &', style: TextStyle(fontSize: 11, color: kTextSecondary)),
                                Text('Konseling Remaja', style: TextStyle(fontSize: 11, color: kTextSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBorder)),
                  child: const Column(
                    children: [
                      InfoRow(icon: Icons.calendar_today_outlined, label: 'Hari & Tanggal', value: 'Senin, 12 Okt'),
                      Divider(height: 16, color: Color(0xFFF1F5F9)),
                      InfoRow(icon: Icons.access_time_outlined, label: 'Waktu', value: '10:30 WIB'),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [kTeal, kTealDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Taulan Virtual', style: TextStyle(fontSize: 11, color: Color(0xCCFFFFFF))),
                      const SizedBox(height: 4),
                      const Text('🎥 Google Meet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.videocam_outlined, color: kTeal, size: 14),
                            SizedBox(width: 5),
                            Text('Join Meet', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: kTeal)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SectionTitle(icon: Icons.check_box_outlined, title: 'Persiapan Sesi'),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), border: Border.all(color: kBorder)),
                  child: const Column(
                    children: [
                      CheckItem(text: 'Cari tempat tenang dan minim gangguan', done: true),
                      SizedBox(height: 8),
                      CheckItem(text: 'Siapkan air minum di dekat Anda', done: true),
                      SizedBox(height: 8),
                      CheckItem(text: 'Pastikan koneksi internet stabil', done: false),
                    ],
                  ),
                ),
                const SectionTitle(icon: Icons.edit_outlined, title: 'Catatan Saya'),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  constraints: const BoxConstraints(minHeight: 60),
                  decoration: BoxDecoration(
                    color: kBg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
                  ),
                  child: const Text(
                    'Tuliskan hal-hal yang ingin kamu diskusikan dengan Dr. Anton di sini...',
                    style: TextStyle(fontSize: 11, color: kTextMuted),
                  ),
                ),
                const SizedBox(height: 16),
                // UBAH JADWAL → ke Screen4Reschedule
                GestureDetector(
                  onTap: () => context.push('/counseling/reschedule'),
                  child: OutlineButton(label: 'Ubah Jadwal', icon: Icons.calendar_today_outlined),
                ),
                const SizedBox(height: 8),
                // RIWAYAT → ke Screen2History
                GestureDetector(
                  onTap: () => context.push('/counseling/history'),
                  child: OutlineButton(label: 'Lihat Riwayat', icon: Icons.history_outlined),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}