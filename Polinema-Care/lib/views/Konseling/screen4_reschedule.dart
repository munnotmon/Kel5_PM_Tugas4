// Lokasi: lib/Konseling/screen4_reschedule.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart';
import '../../models/counselor_model.dart';

class Screen4Reschedule extends StatefulWidget {
  final Map<String, dynamic>? counselorData;
  const Screen4Reschedule({super.key, this.counselorData});

  @override
  State<Screen4Reschedule> createState() => _Screen4RescheduleState();
}

class _Screen4RescheduleState extends State<Screen4Reschedule> {
  int _selectedDateIndex = 0;
  int _selectedTimeIndex = -1;
  List<String> _availableTimes = [];
  final TextEditingController _reasonController = TextEditingController();

  List<DateTime> _availableDates = [];
  List<Map<String, dynamic>> _schedules = [];
  bool _isLoadingSchedules = true;

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  String _normalizeTime(String timeStr) {
    final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(timeStr);
    if (match != null) {
      final hour = int.parse(match.group(1)!).toString().padLeft(2, '0');
      final minute = match.group(2)!;
      return '$hour:$minute';
    }
    return timeStr.trim();
  }

  Future<void> _loadSchedules() async {
    var counselor = Konselor.fromMap(widget.counselorData ?? CounselingController.placeholderKonselor.toMap());
    if (counselor.id != null) {
      final latest = await CounselingController.fetchKonselorDetail(counselor.id!);
      if (latest != null) {
        counselor = latest;
      }
    }
    final schedules = await CounselingController.fetchSchedules();
    
    // schedules berasal langsung dari database. Karena tidak terikat admin_id di tabel jadwal_konseling,
    // kita mengambil semua jadwal dengan status 'Tersedia' seperti pada profil_konselor.dart.
    final available = schedules.where((s) => s['status'] == 'Tersedia').toList();

    // Filter available schedules based on counselor's practiceDays and availableTimes
    final filteredAvailable = available.where((s) {
      final rawDate = s['tanggal']?.toString();
      if (rawDate == null || rawDate.length < 10) return false;
      final dateStr = rawDate.substring(0, 10);
      final dt = DateTime.tryParse(dateStr);
      if (dt == null) return false;

      // Filter out past dates (keep only today or future dates)
      final todayStr = DateTime.now().toIso8601String().substring(0, 10);
      final today = DateTime.parse(todayStr);
      if (dt.isBefore(today)) return false;

      // Filter out dates where the counselor's daily session quota is full
      if (counselor.fullDates.contains(dateStr)) {
        return false;
      }

      // Filter by practice days (counselor.practiceDays contains 1..7 for Mon..Sun)
      if (!counselor.practiceDays.contains(dt.weekday)) {
        return false;
      }

      // Filter by available times
      final rawStart = s['jam_mulai']?.toString();
      if (rawStart == null) return false;
      final startNorm = _normalizeTime(rawStart);

      final hasMatchingTime = counselor.availableTimes.any((t) {
        return _normalizeTime(t) == startNorm;
      });

      return hasMatchingTime;
    }).toList();

    final uniqueDates = <String, DateTime>{};
    for (final s in filteredAvailable) {
      final rawDate = s['tanggal']?.toString();
      if (rawDate != null && rawDate.length >= 10) {
        final dateStr = rawDate.substring(0, 10);
        if (!uniqueDates.containsKey(dateStr)) {
          uniqueDates[dateStr] = DateTime.parse(dateStr);
        }
      }
    }

    _availableDates = (uniqueDates.values.toList()..sort()).take(3).toList();
    _schedules = filteredAvailable;

    if (_availableDates.isNotEmpty) {
      _selectedDateIndex = 0;
      _updateTimesForSelectedDate(0);
    } else {
      _availableTimes = [];
      _selectedTimeIndex = -1;
    }

    if (mounted) {
      setState(() {
        _isLoadingSchedules = false;
      });
    }
  }

  void _updateTimesForSelectedDate(int index) {
    if (index >= _availableDates.length) return;
    final selDateStr = _availableDates[index].toIso8601String().substring(0, 10);
    final slotsForDate = _schedules.where((s) {
      final rawDate = s['tanggal']?.toString();
      return rawDate != null && rawDate.substring(0, 10) == selDateStr;
    }).toList();

    _availableTimes = slotsForDate.map((s) {
      final start = s['jam_mulai']?.toString().substring(0, 5) ?? '';
      final end = s['jam_selesai']?.toString().substring(0, 5) ?? '';
      return '$start - $end';
    }).toList();

    if (_availableTimes.isNotEmpty) {
      _selectedTimeIndex = 0;
    } else {
      _selectedTimeIndex = -1;
    }
  }

  String _getIndonesianMonthName(int month) {
    switch (month) {
      case 1: return "Jan";
      case 2: return "Feb";
      case 3: return "Mar";
      case 4: return "Apr";
      case 5: return "Mei";
      case 6: return "Jun";
      case 7: return "Jul";
      case 8: return "Agu";
      case 9: return "Sep";
      case 10: return "Okt";
      case 11: return "Nov";
      case 12: return "Des";
      default: return "";
    }
  }

  String _formatFullDate(DateTime dt) {
    final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
    return '${days[dt.weekday % 7]}, ${dt.day} ${_getIndonesianMonthName(dt.month)}';
  }

  String _getDayName(DateTime date) {
    const days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    return days[date.weekday - 1];
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final konselor = widget.counselorData ?? CounselingController.placeholderKonselor.toMap();

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
          'Penjadwalan Ulang Sesi',
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
    final name = konselor['name'] ?? konselor['konselor'] ?? 'Konselor';
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
              (konselor['foto_profil'] != null && konselor['foto_profil'].toString().isNotEmpty)
                  ? konselor['foto_profil']
                  : 'https://i.pravatar.cc/150?u=${name.replaceAll(' ', '')}',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                Text(
                  konselor['specialty'] ?? 'Konselor Polinema Care',
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
                      '${konselor['rating'] ?? '5.0'} (${konselor['sessions'] ?? '0'} sesi)',
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
              'Pilih Tanggal Baru',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF1A2D3D),
              ),
            ),
            Text(
              _availableDates.isNotEmpty
                  ? '${_getIndonesianMonthName(_availableDates[_selectedDateIndex].month)} ${_availableDates[_selectedDateIndex].year}'
                  : '',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1068A3),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _isLoadingSchedules
            ? const Center(child: CircularProgressIndicator())
            : _availableDates.isEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      'Tidak ada jadwal tersedia.',
                      style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 13),
                    ),
                  )
                : SizedBox(
                    height: 95,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _availableDates.length,
                      itemBuilder: (context, index) {
                        final date = _availableDates[index];
                        final isSelected = _selectedDateIndex == index;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDateIndex = index;
                              _updateTimesForSelectedDate(index);
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 10),
                            width: 70,
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
          'Waktu Tersedia',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 16),
        _isLoadingSchedules
            ? const Center(child: CircularProgressIndicator())
            : _availableTimes.isEmpty
                ? Text(
                    'Pilih tanggal terlebih dahulu.',
                    style: GoogleFonts.plusJakartaSans(color: Colors.grey, fontSize: 13),
                  )
                : GridView.builder(
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
                            shape: const StadiumBorder(),
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
          'Alasan Penjadwalan Ulang',
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
              hintText: 'Tuliskan alasan Anda menjadwalkan ulang sesi ini (opsional)',
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
    bool canConfirm = !_isLoadingSchedules && _availableDates.isNotEmpty && _selectedTimeIndex >= 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: canConfirm
                  ? const LinearGradient(
                      colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    )
                  : null,
              color: canConfirm ? null : Colors.grey.shade300,
              borderRadius: BorderRadius.circular(30),
            ),
            child: ElevatedButton(
              onPressed: !canConfirm
                  ? null
                  : () async {
                      final selectedDate = _availableDates[_selectedDateIndex];
                      final selectedTime = _availableTimes[_selectedTimeIndex];

                      final selDateStr = selectedDate.toIso8601String().substring(0, 10);
                      final activeSchedule = _schedules.firstWhere((s) {
                        final dateStr = s['tanggal']?.toString().substring(0, 10);
                        final start = s['jam_mulai']?.toString().substring(0, 5) ?? '';
                        final end = s['jam_selesai']?.toString().substring(0, 5) ?? '';
                        final timeStr = '$start - $end';
                        return dateStr == selDateStr && timeStr == selectedTime;
                      }, orElse: () => <String, dynamic>{});

                      final scheduleId = activeSchedule['id'];
                      if (scheduleId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Slot jadwal tidak ditemukan!")),
                        );
                        return;
                      }

                      // Tampilkan spinner loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (loadingCtx) => const Center(child: CircularProgressIndicator()),
                      );

                      // Batalkan slot lama jika dikirim
                      final oldBookingId = widget.counselorData?['old_booking_id']?.toString() ?? '';
                      if (oldBookingId.isNotEmpty) {
                        await CounselingController.cancelBooking(oldBookingId);
                      }

                      final errorMessage = await CounselingController.createBooking(
                        scheduleId,
                        _reasonController.text.trim().isNotEmpty
                            ? 'Penjadwalan Ulang: ${_reasonController.text}'
                            : 'Penjadwalan Ulang',
                        adminId: konselor['id'],
                      );

                      if (context.mounted) {
                        Navigator.pop(context); // Tutup spinner loading
                      }

                      if (errorMessage != null) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(errorMessage)),
                          );
                        }
                        return;
                      }

                      if (context.mounted) {
                        context.push(
                          '/counseling/sukses',
                          extra: {
                            'counselor': konselor,
                            'tanggal': _formatFullDate(selectedDate),
                            'waktu': selectedTime,
                            'mode': widget.counselorData?['mode'] ?? 'Online',
                          },
                        );
                      }
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
                'Konfirmasi Jadwal Baru',
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Dengan konfirmasi, slot jadwal Anda yang lama akan dilepaskan.',
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