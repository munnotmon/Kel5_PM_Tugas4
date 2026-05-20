import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'data_konselor.dart';

class CounselorProfilePage extends StatefulWidget {
  final Map<String, dynamic>? counselorData;

  const CounselorProfilePage({super.key, this.counselorData});

  @override
  State<CounselorProfilePage> createState() => _CounselorProfilePageState();
}

class _CounselorProfilePageState extends State<CounselorProfilePage> {
  int selectedDate = 0;
  String selectedTime = "10:30 WIB";
  String selectedMode = "Lokal"; // Variabel untuk mode konseling

  late final Map<String, dynamic> data;

  @override
  void initState() {
    super.initState();
    data = widget.counselorData ?? daftarKonselor[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Counselor Profile",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1068A3),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildPillStat(
                      Icons.work_outline,
                      data['experience_years'],
                    ),
                    const SizedBox(width: 12),
                    _buildPillStat(Icons.chat_bubble_outline, data['sessions']),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  "Tentang Saya",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  data['about'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[600],
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  "Spesialisasi",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: (data['specialties'] as List)
                      .map((spec) => _specChip(spec.toString()))
                      .toList(),
                ),
                const SizedBox(height: 24),
                Text(
                  "Pengalaman & Pendidikan",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ...((data['educations'] as List).map(
                  (edu) => _buildEduExpItem(
                    Icons.school_outlined,
                    edu['title'].toString(),
                    edu['subtitle'].toString(),
                  ),
                )),
                ...((data['experiences'] as List).map(
                  (exp) => _buildEduExpItem(
                    Icons.business_center_outlined,
                    exp['title'].toString(),
                    exp['subtitle'].toString(),
                  ),
                )),

                const SizedBox(height: 24),
                Text(
                  "Metode Konseling",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildModeSelector(), // Widget Selector Mode

                const SizedBox(height: 24),
                Text(
                  "Jadwal Tersedia",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildTimeGrid(),
                const SizedBox(height: 100),
              ],
            ),
          ),

          // Tombol Jadwalkan
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
                ),
                borderRadius: BorderRadius.circular(30),
              ),
              child: ElevatedButton.icon(
                onPressed: () {
                  // Validasi sederhana: pastikan data ada
                  if (data == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Data konselor tidak ditemukan!"),
                      ),
                    );
                    return;
                  }

                  // Navigasi dengan data yang sudah pasti
                  context.push(
                    '/counseling/konfirmasi',
                    extra: {
                      'counselor': data,
                      'tanggal': "Senin, 12 Okt", // Sesuai pilihanmu
                      'waktu': selectedTime,
                      'mode': selectedMode,
                    },
                  );
                },
                icon: const Icon(
                  Icons.calendar_today,
                  color: Colors.white,
                  size: 18,
                ),
                label: Text(
                  "Jadwalkan Sesi",
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- UI WIDGETS ---

  Widget _buildHeader() {
    return Center(
      child: Column(
        children: [
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.blueGrey[200],
              image: const DecorationImage(
                image: NetworkImage("https://i.pravatar.cc/150?img=11"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data['name'],
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            data['specialty'],
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1068A3),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Row(
      children: [
        _modeButton("Offline", Icons.location_on_outlined),
        const SizedBox(width: 12),
        _modeButton("Online", Icons.videocam_outlined),
      ],
    );
  }

  Widget _modeButton(String mode, IconData icon) {
    bool active = selectedMode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedMode = mode),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1068A3) : Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: active ? const Color(0xFF1068A3) : Colors.grey.shade300,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: active ? Colors.white : Colors.grey),
              const SizedBox(width: 8),
              Text(
                mode,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: active ? Colors.white : Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillStat(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1068A3)),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _specChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F2ED),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 11,
          color: const Color(0xFF165C3B),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildEduExpItem(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F4FD),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: const Color(0xFF1068A3), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    List<Map<String, String>> dates = [
      {"day": "SEN", "date": "12"},
      {"day": "SEL", "date": "13"},
      {"day": "RAB", "date": "14"},
    ];
    return Row(
      children: List.generate(dates.length, (index) {
        bool active = selectedDate == index;
        return GestureDetector(
          onTap: () => setState(() => selectedDate = index),
          child: Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: active ? const Color(0xFF1068A3) : Colors.grey.shade200,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Text(
                  dates[index]["day"]!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: active ? const Color(0xFF1068A3) : Colors.grey,
                  ),
                ),
                Text(
                  dates[index]["date"]!,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: active
                        ? const Color(0xFF1068A3)
                        : const Color(0xFF1A2D3D),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTimeGrid() {
    List<String> times = ["09:00 WIB", "10:30 WIB", "13:00 WIB", "15:30 WIB"];
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: times.map((t) {
        bool active = selectedTime == t;
        return GestureDetector(
          onTap: () => setState(() => selectedTime = t),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF1068A3) : const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              t,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: active ? Colors.white : Colors.grey[700],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
