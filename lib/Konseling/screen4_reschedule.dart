// Lokasi: lib/Konseling/screen4_reschedule.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'data_konselor.dart';

class Screen4Reschedule extends StatefulWidget {
  final Map<String, dynamic>? counselorData;
  const Screen4Reschedule({super.key, this.counselorData});

  @override
  State<Screen4Reschedule> createState() => _Screen4RescheduleState();
}

class _Screen4RescheduleState extends State<Screen4Reschedule> {
  int _selectedDateIndex = 16; // Default: tanggal 17 Oktober = index ke-16
  int _selectedTimeIndex = 1; // Default: 10:30 AM

  final List<String> _availableTimes = [
    '09:00 AM',
    '10:30 AM',
    '01:00 PM',
    '03:30 PM',
  ];

  final TextEditingController _reasonController = TextEditingController();

  // Semua tanggal di bulan Oktober 2023 (1–31)
  List<DateTime> get _displayDates {
    return List.generate(31, (i) => DateTime(2023, 10, 1).add(Duration(days: i)));
  }

  String _getDayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final konselor = widget.counselorData ?? daftarKonselor[0];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reschedule Session',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1068A3),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              children: [
                // --- KONSELOR CARD ---
                _buildKonselorCard(konselor),
                const SizedBox(height: 28),

                // --- SELECT NEW DATE ---
                _buildDateSection(),
                const SizedBox(height: 28),

                // --- AVAILABLE TIME ---
                _buildTimeSection(),
                const SizedBox(height: 28),

                // --- REASON ---
                _buildReasonSection(),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // --- BOTTOM BUTTON ---
          _buildBottomSection(context, konselor),
        ],
      ),
    );
  }

  Widget _buildKonselorCard(Map<String, dynamic> konselor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=${konselor['name']}',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  konselor['name'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                Text(
                  konselor['specialty'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[500],
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Color(0xFF16A34A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.star, color: Colors.amber, size: 13),
                    const SizedBox(width: 4),
                    Text(
                      '${konselor['rating']} (124 reviews)',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select New Date',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            Text(
              'October 2023',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1068A3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 95, // ← naikan dari 80 agar tidak terpotong
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.only(right: 16), // ← agar tanggal terakhir tidak terpotong
            itemCount: _displayDates.length,
            itemBuilder: (context, index) {
              final date = _displayDates[index];
              final isSelected = _selectedDateIndex == index;

              return GestureDetector(
                onTap: () => setState(() => _selectedDateIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 10),
                  width: 70, // ← naikan dari 65 agar tidak sempit
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF1068A3)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF1068A3)
                          : Colors.grey.shade200,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _getDayName(date),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? Colors.white70
                              : Colors.grey[500],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${date.day}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.white : const Color(0xFF1A2D3D),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Time',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3.2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: _availableTimes.length,
          itemBuilder: (context, index) {
            final isSelected = _selectedTimeIndex == index;
            return GestureDetector(
              onTap: () => setState(() => _selectedTimeIndex = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: ShapeDecoration(
                  color: isSelected
                      ? const Color(0xFF1068A3)
                      : const Color(0xFFF0F4F8),
                  shape: const StadiumBorder(), // ← pill shape sempurna
                ),
                child: Center(
                  child: Text(
                    _availableTimes[index],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? Colors.white : const Color(0xFF1A2D3D),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildReasonSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Rescheduling',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            controller: _reasonController,
            maxLines: 4,
            style: GoogleFonts.plusJakartaSans(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Tell us why you need to move the session (optional)',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[400],
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(18),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomSection(BuildContext context, Map<String, dynamic> konselor) {
    final selectedDate = _displayDates[_selectedDateIndex];
    final selectedTime = _availableTimes[_selectedTimeIndex];

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          // Tombol Konfirmasi
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  '/counseling/sukses',
                  extra: {
                    'counselor': konselor,
                    'tanggal':
                        '${_getDayName(selectedDate)}, ${selectedDate.day} Okt',
                    'waktu': selectedTime,
                    'mode': 'Online',
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Confirm New Schedule',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Info teks di bawah tombol
          Text(
            'By confirming, your old slot at 2:00 PM today will\nbe released for others.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}