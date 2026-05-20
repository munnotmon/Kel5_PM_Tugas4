import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart';
import 'package:go_router/go_router.dart'; // tambah di atas

class Screen3DetailHistory extends StatelessWidget {
  const Screen3DetailHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          const PhoneStatusBar(),
          PhoneNavTop(
            title: 'Detail Riwayat Sesi',
            trailing: Row(
              children: const [
                Icon(Icons.upload_outlined, size: 14, color: kTeal),
                SizedBox(width: 4),
                Text('Bagikan',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: kTeal)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 80),
              children: [
                // Status Badge
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE0F2FE),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text('✓ Selesai',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0369A1))),
                  ),
                ),

                const SizedBox(height: 8),
                const Text('Sesi Konseling Individu.',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: kTextPrimary)),
                const SizedBox(height: 4),
                const Text('Senin, 12 Okt 2023',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kTextSecondary)),
                const SizedBox(height: 10),

                // Konselor Card
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundColor: kTeal,
                        child: Text('AW',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('dr. Anton Wijaya',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: kTextPrimary)),
                            Text('Penasehat',
                                style: TextStyle(
                                    fontSize: 11, color: kTextSecondary)),
                            Text('★★★★☆  4.9 (124 reviews)',
                                style: TextStyle(
                                    fontSize: 11, color: Color(0xFFF59E0B))),
                          ],
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: kTealLight,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.chat_bubble_outline,
                            size: 14, color: kTeal),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Ringkasan Sesi
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.description_outlined,
                              size: 14, color: kTeal),
                          SizedBox(width: 6),
                          Text('Ringkasan Sesi',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: kTeal)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _SummaryPoint(text:
                          'Membahas strategi koping untuk menghadapi tekanan tugas kuliah yang menumpuk.'),
                      _SummaryPoint(text:
                          'Identifikasi pemicu kecemasan saat berada di lingkungan sosial yang ramai.'),
                      _SummaryPoint(text:
                          'Refleksi mengenai pola komunikasi dengan teman sebaya.'),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Rekomendasi Konselor
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFFF0FFFE), Color(0xFFE6FFFD)]),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFB2F5EA)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.star_outline, size: 14, color: kTeal),
                          SizedBox(width: 6),
                          Text('Rekomendasi Konselor',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: kTeal)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _RekomItem(
                        color: kTeal,
                        icon: Icons.headphones_outlined,
                        title: 'Latihan Pernapasan',
                        subtitle: 'Lakukan 5 menit setiap pagi setelah bangun tidur',
                      ),
                      const SizedBox(height: 8),
                      _RekomItem(
                        color: kTealDark,
                        icon: Icons.edit_outlined,
                        title: 'Jurnal Harian',
                        subtitle: 'Tuliskan 3 hal positif yang terjadi setiap hari',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Catatan Pribadi
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorder),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('📝 Catatan Pribadi',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: kTextPrimary)),
                          Text('Edit',
                              style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: kTeal)),
                        ],
                      ),
                      SizedBox(height: 8),
                      Text(
                        '"Hari ini merasa lebih tenang setelah bercerita dengan dr. Anton. Ternyata selama ini aku terlalu keras pada diri sendiri. Besok harus mulai coba latihan napasnya."',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF475569),
                            fontStyle: FontStyle.italic,
                            height: 1.6),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Action Buttons
                GestureDetector(
  onTap: () => context.push('/counseling/reschedule'),
  child: Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(vertical: 11),
    decoration: BoxDecoration(
      color: kTealLight,
      border: Border.all(color: kTeal, width: 1.5),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Icon(Icons.calendar_today_outlined, color: kTeal, size: 14),
        SizedBox(width: 6),
        Text('Jadwalkan Ulang dengan Konselor Ini',),
      ],
    ),
  ),
),

                const SizedBox(height: 8),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: kBorder, width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.download_outlined,
                          color: kTextSecondary, size: 14),
                      SizedBox(width: 6),
                      Text('Unduh Ringkasan Sesi (PDF)',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kTextSecondary)),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
          const BottomNav(activeIndex: 3),
        ],
      ),
    );
  }
}

// ─── Local Sub-widgets ───────────────────────────────────────────────────────

class _SummaryPoint extends StatelessWidget {
  final String text;
  const _SummaryPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 5,
            margin: const EdgeInsets.only(top: 5),
            decoration:
                const BoxDecoration(color: kTeal, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF475569),
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}

class _RekomItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String subtitle;

  const _RekomItem({
    required this.color,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: Colors.white, size: 16),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: kTextPrimary)),
            Text(subtitle,
                style:
                    const TextStyle(fontSize: 10, color: kTextSecondary)),
          ],
        ),
      ],
    );
  }
}