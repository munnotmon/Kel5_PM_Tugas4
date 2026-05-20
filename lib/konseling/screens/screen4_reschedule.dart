import 'package:flutter/material.dart';
import '../constants.dart';
import '../widgets/shared_widgets.dart';

class Screen4Reschedule extends StatefulWidget {
  const Screen4Reschedule({super.key});

  @override
  State<Screen4Reschedule> createState() => _Screen4RescheduleState();
}

class _Screen4RescheduleState extends State<Screen4Reschedule> {
  int _selectedDate = 1;
  int _selectedTime = 1;

  final List<Map<String, String>> _dates = [
    {'day': 'Mon', 'num': '16'},
    {'day': 'Tue', 'num': '17'},
    {'day': 'Wed', 'num': '18'},
    {'day': 'Thu', 'num': '19'},
    {'day': 'Fri', 'num': '20'},
  ];

  final List<String> _times = ['09:00 AM', '10:30 AM', '01:00 PM', '03:00 PM'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          const PhoneStatusBar(),
          const PhoneNavTop(title: 'Reschedule Session'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
              children: [
                // Konselor
                KonselorCard(
                  initials: 'AW',
                  name: 'dr. Anton Wijaya',
                  specialist: 'Spesialis Psikologi',
                  trailing: const Text('★★★★☆  4.9',
                      style: TextStyle(
                          fontSize: 11, color: Color(0xFFF59E0B))),
                ),

                const SectionTitle(
                    icon: Icons.calendar_today_outlined,
                    title: 'Select New Date'),

                // Month Header
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.chevron_left, size: 16, color: kTextPrimary),
                    Text('October 2023',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: kTextPrimary)),
                    Icon(Icons.chevron_right, size: 16, color: kTextPrimary),
                  ],
                ),

                const SizedBox(height: 8),

                // Date Strip
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_dates.length, (i) {
                      final active = i == _selectedDate;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedDate = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: active ? kTeal : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: active ? kTeal : kBorder, width: 1.5),
                          ),
                          child: Column(
                            children: [
                              Text(_dates[i]['day']!,
                                  style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                      color: active
                                          ? Colors.white
                                          : kTextMuted)),
                              Text(_dates[i]['num']!,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: active
                                          ? Colors.white
                                          : kTextPrimary)),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ),

                const SectionTitle(
                    icon: Icons.access_time_outlined,
                    title: 'Available Time'),

                // Time Grid
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 3.5,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(_times.length, (i) {
                    final active = i == _selectedTime;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedTime = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: active ? kTeal : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              color: active ? kTeal : kBorder, width: 1.5),
                        ),
                        child: Center(
                          child: Text(_times[i],
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: active
                                      ? Colors.white
                                      : const Color(0xFF475569))),
                        ),
                      ),
                    );
                  }),
                ),

                const SectionTitle(
                    icon: Icons.chat_bubble_outline,
                    title: 'Reason for Rescheduling'),

                // Reason Input
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: kBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: kBorder, width: 1.5),
                  ),
                  child: const TextField(
                    maxLines: 3,
                    style: TextStyle(fontSize: 11, color: kTextPrimary),
                    decoration: InputDecoration.collapsed(
                      hintText:
                          'Tell us why you need to move this session (optional)...',
                      hintStyle: TextStyle(fontSize: 11, color: kTextMuted),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                const Text(
                  'By confirming, your old slot at 2:00 PM today will be made available for others.',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 10, color: kTextMuted, height: 1.5),
                ),
                const SizedBox(height: 8),

                TealButton(label: 'Confirm New Schedule'),
                const SizedBox(height: 8),
              ],
            ),
          ),
        
        ],
      ),
    );
  }
}