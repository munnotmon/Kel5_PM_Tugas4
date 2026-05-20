import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart';
import 'package:go_router/go_router.dart'; // tambah di atas

class Screen2HistoryKonseling extends StatelessWidget {
  const Screen2HistoryKonseling({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          const PhoneStatusBar(),
          const PhoneNavTop(title: 'Counseling History'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
              children: [
                const SizedBox(height: 12),
                const Text('Riwayat Sesi\nCounseling Kamu.',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: kTextPrimary,
                        height: 1.2)),
                const SizedBox(height: 4),
                const Text(
                    'Kelola dan tinjau kembali percakapan berharga dengan konselor profesional kamu.',
                    style: TextStyle(fontSize: 12, color: kTextSecondary)),
                const SizedBox(height: 12),

                // Filter Tabs
                Row(
                  children: [
                    _FilterTab(label: 'Semua', active: true),
                    const SizedBox(width: 8),
                    _FilterTab(label: 'Bulan Ini', active: false),
                    const SizedBox(width: 8),
                    _FilterTab(label: 'Selesai', active: false),
                  ],
                ),

                const SizedBox(height: 12),

                _HistoryItem(
                  initials: 'AW',
                  avatarColor: kTeal,
                  name: 'dr. Anton Wijaya',
                  role: 'Konselor Psikologi',
                  status: 'SELESAI',
                  statusColor: const Color(0xFF166534),
                  statusBg: const Color(0xFFDCFCE7),
                  date: 'Senin, 12 Okt 2023',
                  time: '10:30 - 11:30 WIB',
                  showChat: true,
                ),

                _HistoryItem(
                  initials: 'SM',
                  avatarColor: const Color(0xFF8B5CF6),
                  name: 'Sarah Melinda, M.Psi',
                  role: 'Penanganan Bullying',
                  status: 'SELESAI',
                  statusColor: const Color(0xFF166534),
                  statusBg: const Color(0xFFDCFCE7),
                  date: 'Kamis, 05 Okt 2023',
                  time: '14:00 - 15:00 WIB',
                ),

                _HistoryItem(
                  initials: 'BS',
                  avatarColor: const Color(0xFFEF4444),
                  name: 'dr. Budi Santoso',
                  role: 'Konselor Trauma',
                  status: 'DIBATALKAN',
                  statusColor: const Color(0xFF991B1B),
                  statusBg: const Color(0xFFFEE2E2),
                  date: 'Selasa, 26 Sep 2023',
                  time: '09:00 - 10:00 WIB',
                  cancelled: true,
                ),
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}

// ─── Local sub-widgets ───────────────────────────────────────────────────────

class _FilterTab extends StatelessWidget {
  final String label;
  final bool active;

  const _FilterTab({required this.label, required this.active});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: active ? kTeal : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: active ? Colors.white : kTextSecondary)),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final String initials;
  final Color avatarColor;
  final String name;
  final String role;
  final String status;
  final Color statusColor;
  final Color statusBg;
  final String date;
  final String time;
  final bool showChat;
  final bool cancelled;

  const _HistoryItem({
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.role,
    required this.status,
    required this.statusColor,
    required this.statusBg,
    required this.date,
    required this.time,
    this.showChat = false,
    this.cancelled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: avatarColor,
                child: Text(initials,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(name,
                              style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: kTextPrimary)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(status,
                              style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  color: statusColor)),
                        ),
                      ],
                    ),
                    Text(role,
                        style: const TextStyle(
                            fontSize: 11, color: kTextSecondary)),
                  ],
                ),
              ),
              if (showChat)
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
          const SizedBox(height: 10),
          Row(children: [
            const Icon(Icons.calendar_today_outlined, size: 14, color: kTeal),
            const SizedBox(width: 6),
            Text(date,
                style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
          ]),
          const SizedBox(height: 6),
          Row(children: [
            const Icon(Icons.access_time_outlined, size: 14, color: kTeal),
            const SizedBox(width: 6),
            Text(time,
                style: const TextStyle(fontSize: 11, color: Color(0xFF475569))),
          ]),
          const SizedBox(height: 10),
          if (!cancelled)
            Row(
              children: [
                Expanded(
  child: GestureDetector(
    onTap: () => context.push('/counseling/detail-history'),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: kTeal, width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text('Lihat Detail',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: kTeal)),
    ),
  ),
),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 7),
                    decoration: BoxDecoration(
                      color: kTeal,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text('Catatan Sesi',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                  ),
                ),
              ],
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text('Reschedule Tersedia',
                  style: TextStyle(
                      fontSize: 11,
                      color: kTextMuted,
                      fontStyle: FontStyle.italic)),
            
            ),
        ],
      ),
    );
  }
}