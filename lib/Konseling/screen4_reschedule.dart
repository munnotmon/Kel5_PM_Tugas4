import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class Screen4Reschedule extends StatefulWidget {
  const Screen4Reschedule({super.key});

  @override
  State<Screen4Reschedule> createState() => _Screen4RescheduleState();
}

class _Screen4RescheduleState extends State<Screen4Reschedule> {
  int _selectedDate = 1;
  int _selectedTime = 1;

  final List<Map<String, String>> _dates = [
    {'day': 'Sen', 'num': '12'},
    {'day': 'Sel', 'num': '13'},
    {'day': 'Rab', 'num': '14'},
    {'day': 'Kam', 'num': '15'},
    {'day': 'Jum', 'num': '16'},
  ];

  final List<String> _times = [
    '09:00 WIB',
    '10:30 WIB',
    '13:00 WIB',
    '15:00 WIB',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reschedule Sesi',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Konselor Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Color(0xFF1068A3),
                  child: Text(
                    'AW',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'dr. Anton Wijaya',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A2D3D),
                      ),
                    ),
                    Text(
                      'Spesialis Psikologi Klinis',
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
          const SizedBox(height: 24),

          // Select New Date
          Text(
            'Pilih Tanggal Baru',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(_dates.length, (i) {
                final active = i == _selectedDate;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDate = i),
                  child: Container(
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: active ? const Color(0xFF1068A3) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: active
                            ? const Color(0xFF1068A3)
                            : Colors.grey.shade300,
                        width: 1.5,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          _dates[i]['day']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: active ? Colors.white : Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _dates[i]['num']!,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: active
                                ? Colors.white
                                : const Color(0xFF1A2D3D),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 24),

          // Select New Time
          Text(
            'Waktu Tersedia',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: List.generate(_times.length, (i) {
              final active = i == _selectedTime;
              return GestureDetector(
                onTap: () => setState(() => _selectedTime = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF1068A3) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: active
                          ? const Color(0xFF1068A3)
                          : Colors.grey.shade300,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    _times[i],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: active ? Colors.white : Colors.grey[700],
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Reason for Rescheduling
          Text(
            'Alasan Reschedule (Opsional)',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A2D3D),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300, width: 1.5),
            ),
            child: TextField(
              maxLines: 3,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: const Color(0xFF1A2D3D),
              ),
              decoration: InputDecoration.collapsed(
                hintText:
                    'Tuliskan alasan mengapa kamu memindahkan sesi ini...',
                hintStyle: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Dengan konfirmasi, jadwal kamu sebelumnya akan dibatalkan.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),

          // Button Confirm
          GestureDetector(
            onTap: () => context.push(
              '/counseling/sukses',
            ), // Redirect ke sukses jika diklik
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Text(
                'Konfirmasi Jadwal Baru',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
