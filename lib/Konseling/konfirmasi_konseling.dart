import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'data_konselor.dart';

class ConfirmAppointmentPage extends StatelessWidget {
  final Map<String, dynamic>? counselorData;
  final String? tanggal;
  final String? waktu;
  final String? mode;

  const ConfirmAppointmentPage({
    super.key,
    this.counselorData,
    this.tanggal,
    this.waktu,
    this.mode,
  });

  @override
  Widget build(BuildContext context) {
    // Data fallback jika tidak ada data yang dilempar
    final data = counselorData ?? daftarKonselor[0];
    final tgl = tanggal ?? "Senin, 12 Okt";
    final wkt = waktu ?? "10:30 WIB";
    final md = mode ?? "Lokal";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Confirm Appointment",
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1068A3),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Satu langkah menuju\nkesejahteraan.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1068A3),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Silakan tinjau detail janji temu Anda sebelum melanjutkan proses konfirmasi.",
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // --- COUNSELOR CARD (Desain Baru) ---
                    _buildCounselorCard(data, md),
                    const SizedBox(height: 24),

                    // --- DETAIL ROWS ---
                    _detailRow(Icons.calendar_today_outlined, "TANGGAL", tgl),
                    const SizedBox(height: 16),
                    _detailRow(Icons.access_time, "WAKTU", wkt),
                    const SizedBox(height: 32),

                    _buildGreenBanner(),
                    const SizedBox(height: 16),
                    _buildGreyBanner(),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // --- BOTTOM ACTION ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: SizedBox(
                width: double.infinity,
                height: 55,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: ElevatedButton(
                    onPressed: () => context.push('/counseling/sukses'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Konfirmasi & Buat Janji Temu",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCounselorCard(Map<String, dynamic> data, String mode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FA),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.blueGrey[100],
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/150?u=${data['name']}",
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    color: Color(0xFF10B981),
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data['name'],
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  data['specialty'],
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF1068A3),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Text(
                        mode.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
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

  Widget _detailRow(IconData icon, String label, String val) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF1068A3), size: 20),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              val,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGreenBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F6EE),
        borderRadius: BorderRadius.circular(16),
        border: const Border(
          left: BorderSide(color: Color(0xFF2A9D6A), width: 4),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.volunteer_activism_outlined,
            color: Color(0xFF2A9D6A),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Layanan ini sepenuhnya gratis sebagai bagian dari dukungan kampus.",
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                color: const Color(0xFF1B5E20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreyBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: Colors.grey, size: 20),
          const SizedBox(width: 10),
          Text(
            "Sesi Anda bersifat rahasia dan aman.",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}
