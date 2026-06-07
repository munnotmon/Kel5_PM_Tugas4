import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart';

class ConfirmAppointmentPage extends StatefulWidget {
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
  State<ConfirmAppointmentPage> createState() => _ConfirmAppointmentPageState();
}

class _ConfirmAppointmentPageState extends State<ConfirmAppointmentPage> {
  bool _isSubmitting = false;
  final TextEditingController _keluhanController = TextEditingController();
  String? _keluhanErrorText;

  @override
  void dispose() {
    _keluhanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Data fallback jika tidak ada data yang dilempar
    final data = widget.counselorData ??
        (CounselingController.daftarKonselor.isNotEmpty
            ? CounselingController.daftarKonselor[0].toMap()
            : <String, dynamic>{});
    final tgl = widget.tanggal ?? "Senin, 12 Okt";
    final wkt = widget.waktu ?? "10:30 WIB";
    final md = widget.mode ?? "Lokal";

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

                    _buildKeluhanInput(),
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
                    onPressed: _isSubmitting ? null : () async {
                      final scheduleId = data['scheduleId'];
                      if (scheduleId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("ID Jadwal tidak ditemukan! Silakan pilih ulang."),
                            backgroundColor: Colors.orangeAccent,
                          ),
                        );
                        return;
                      }

                      final keluhan = _keluhanController.text.trim();
                      if (keluhan.isEmpty) {
                        setState(() {
                          _keluhanErrorText = "Keluhan wajib diisi";
                        });
                        return;
                      }

                      setState(() {
                        _isSubmitting = true;
                        _keluhanErrorText = null;
                      });
                      final errorMessage = await CounselingController.createBooking(
                        scheduleId,
                        keluhan,
                        adminId: data['id'],
                      );
                      
                      if (mounted) {
                        setState(() => _isSubmitting = false);
                      }

                      if (errorMessage != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(errorMessage),
                            backgroundColor: Colors.redAccent,
                          ),
                        );
                        return;
                      }

                      context.push(
                        '/counseling/sukses',
                        extra: {
                          'counselor': widget.counselorData,
                          'tanggal': widget.tanggal,
                          'waktu': widget.waktu,
                          'mode': widget.mode,
                          'keluhan': keluhan,
                        },
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
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

  // --- SEMUA WIDGET HELPER SEKARANG ADA DI DALAM CLASS ---

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
                  (data['foto_profil'] != null && data['foto_profil'].toString().isNotEmpty)
                      ? data['foto_profil']
                      : "https://i.pravatar.cc/150?u=${data['name']}",
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

  Widget _buildKeluhanInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "Keluhan / Deskripsi Masalah ",
            style: GoogleFonts.plusJakartaSans(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1068A3),
            ),
            children: const [
              TextSpan(
                text: "*",
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _keluhanController,
          maxLines: 4,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            color: Colors.black87,
          ),
          onChanged: (val) {
            if (_keluhanErrorText != null && val.trim().isNotEmpty) {
              setState(() {
                _keluhanErrorText = null;
              });
            }
          },
          decoration: InputDecoration(
            hintText: "Silakan ceritakan kendala atau keluhan yang sedang Anda hadapi secara singkat...",
            hintStyle: GoogleFonts.plusJakartaSans(
              color: Colors.black38,
              fontSize: 13,
            ),
            filled: true,
            fillColor: const Color(0xFFF8F9FA),
            contentPadding: const EdgeInsets.all(16),
            errorText: _keluhanErrorText,
            errorStyle: GoogleFonts.plusJakartaSans(
              color: const Color(0xFFD32F2F),
              fontSize: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Color(0xFF1068A3), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0),
              borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2.0),
            ),
          ),
        ),
      ],
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
