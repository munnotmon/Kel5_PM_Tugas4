import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'data_konselor.dart';

class SuccessAppointmentPage extends StatelessWidget {
  final Map<String, dynamic>?
  sessionData; // Penangkap data dari halaman Konfirmasi

  const SuccessAppointmentPage({super.key, this.sessionData});

  @override
  Widget build(BuildContext context) {
    // Mengekstrak data yang dilempar dari halaman Konfirmasi
    final data = sessionData?['counselor'] ?? daftarKonselor[0];
    final tgl = sessionData?['tanggal'] ?? "Senin, 12 Okt";
    final wkt = sessionData?['waktu'] ?? "10:30 WIB";
    final md = sessionData?['mode'] ?? "Virtual";

    // Menentukan teks lokasi berdasarkan mode yang dipilih
    final isOnline =
        md.toString().toLowerCase() == 'online' ||
        md.toString().toLowerCase() == 'virtual';
    final locationText = isOnline
        ? "Sesi Online (Link akan dikirim ke Email)"
        : "Sesi Offline (Ruang Konseling Kampus (Gedung AA, Lantai 1))";

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- ICON CENTANG GLOWING ---
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF69F0AE).withOpacity(0.2), // Outer glow
                ),
                child: Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Color(0xFF86EFAC), // Inner circle
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 40,
                      color: Color(0xFF064E3B), // Dark green check
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // --- HEADER TEXT ---
              Text(
                "Janji Temu Berhasil!",
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A2D3D),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Sesi Anda dengan ${data['name']} telah dijadwalkan. Kami di sini untuk mendengarkan.",
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  color: Colors.grey[600],
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),

              // --- SUMMARY CARD ---
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Konselor Info
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: const Color(0xFF1068A3),
                          backgroundImage: NetworkImage(
                            "https://i.pravatar.cc/150?u=${data['name']}",
                          ),
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
                                  color: const Color(0xFF1A2D3D),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Konselor Senior",
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Detail Rows
                    _buildDetailRow(
                      Icons.calendar_today_outlined,
                      "Tanggal",
                      tgl,
                    ),
                    const SizedBox(height: 20),
                    _buildDetailRow(Icons.access_time_outlined, "Waktu", wkt),
                    const SizedBox(height: 20),
                    _buildDetailRow(
                      isOnline
                          ? Icons.videocam_outlined
                          : Icons.location_on_outlined,
                      "Lokasi",
                      locationText,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // --- PERSIAPAN SECTION ---
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Apa yang perlu disiapkan?",
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildPrepItem(
                Icons.self_improvement_outlined,
                "Cari tempat yang tenang dan privat agar Anda merasa nyaman bercerita.",
              ),
              _buildPrepItem(
                Icons.edit_note_outlined,
                "Siapkan catatan jika ada poin-poin penting yang ingin Anda sampaikan.",
              ),
              const SizedBox(height: 32),

              // --- BUTTONS ---
              SizedBox(
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
                    onPressed: () => context.go('/home'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      "Kembali ke Beranda",
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  // MELEMPAR DATA KE HALAMAN DETAIL SESI AKTIF
                  onPressed: () => context.push(
                    '/counseling/detail-sesi-aktif',
                    extra: sessionData,
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Lihat Detail Sesi",
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF1068A3),
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200, width: 1.5),
          ),
          child: Icon(icon, color: const Color(0xFF1068A3), size: 18),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1A2D3D),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPrepItem(IconData icon, String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FA), // Light grey background
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(
              icon,
              color: const Color(0xFF2E7D32),
              size: 22,
            ), // Dark green icon
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
