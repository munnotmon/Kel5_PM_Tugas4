// Lokasi: lib/Konseling/screen_detail_sesi.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart';

class ScreenDetailSesi extends StatefulWidget {
  final Map<String, dynamic>? sessionData;
  const ScreenDetailSesi({super.key, this.sessionData});

  @override
  State<ScreenDetailSesi> createState() => _ScreenDetailSesiState();
}

class _ScreenDetailSesiState extends State<ScreenDetailSesi> {
  final TextEditingController _catatanController = TextEditingController();
  bool _isEditingCatatan = false;

  // Variabel state untuk mengunci data sesi secara dinamis
  late Map<String, dynamic> _konselorData;
  late String _namaKonselor;
  late String _specialty;
  late String _tanggal;
  late String _waktu;

  @override
  void initState() {
    super.initState();
    
    // 1. Ambil nama konselor dari data parameter router
    _namaKonselor = widget.sessionData?['konselor'] ?? 
                    widget.sessionData?['counselor']?['name'] ?? 
                    'dr. Anton Wijaya';
                    
    _tanggal = widget.sessionData?['tanggal'] ?? 'Senin, 12 Okt';
    _waktu = widget.sessionData?['waktu'] ?? widget.sessionData?['jam'] ?? '10:30 WIB';

    // 2. Cari data lengkap dari daftarKonselor berdasarkan nama agar singkron
    final kModel = CounselingController.daftarKonselor.firstWhere(
      (k) => k.name == _namaKonselor,
      orElse: () => CounselingController.placeholderKonselor,
    );
    _konselorData = kModel.toMap();
    
    _specialty = _konselorData['specialty'] ?? 'Spesialis Konselor Klinis';
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1068A3)),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Detail Sesi',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        children: [
          // --- STATUS SESI ---
          _buildStatusSesi(),
          const SizedBox(height: 24),

          // --- KARTU KONSELOR ---
          _buildCounselorCard(),
          const SizedBox(height: 16),

          // --- INFO JADWAL (HARI & WAKTU) ---
          _buildScheduleTile(Icons.calendar_today_outlined, 'Hari & Tanggal', _tanggal),
          const SizedBox(height: 12),
          _buildScheduleTile(Icons.access_time_outlined, 'Waktu', _waktu),
          const SizedBox(height: 24),

          // --- KARTU GOOGLE MEET ---
          _buildMeetCard(),
          const SizedBox(height: 32),

          // --- PERSIAPAN SESI ---
          _buildSectionHeader(Icons.checklist_rtl_rounded, 'Persiapan Sesi'),
          const SizedBox(height: 16),
          _buildCheckItem('Cari tempat tenang dan minim gangguan'),
          _buildCheckItem('Siapkan air minum di dekat Anda'),
          _buildCheckItem('Pastikan koneksi internet stabil'),
          const SizedBox(height: 32),

          // --- CATATAN SAYA ---
          _buildCatatanBox(),
          const SizedBox(height: 40),

          // --- TOMBOL AKSI ---
          _buildActionButtons(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // --- WIDGET HELPER ---

  Widget _buildStatusSesi() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Status Sesi', style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500])),
            const SizedBox(height: 4),
            Text('Terjadwal', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.w800, color: const Color(0xFF1A2D3D))),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(color: const Color(0xFFE8F6EE), borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              const Icon(Icons.circle, size: 8, color: Color(0xFF2A9D6A)),
              const SizedBox(width: 8),
              Text('Aktif', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.bold, color: const Color(0xFF2A9D6A))),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCounselorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              // Menggunakan pravatar JPG/PNG agar tidak terjadi blank/error render SVG di Flutter
              'https://i.pravatar.cc/150?u=${_namaKonselor.replaceAll(' ', '')}', 
              width: 70, 
              height: 70, 
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: const Color(0xFF1068A3).withOpacity(0.1),
                  child: const Icon(Icons.person, color: Color(0xFF1068A3), size: 35),
                );
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: const Color(0xFFE1F5FE), borderRadius: BorderRadius.circular(6)),
                  child: Text('KONSELOR SENIOR', style: GoogleFonts.plusJakartaSans(fontSize: 9, fontWeight: FontWeight.w800, color: const Color(0xFF0288D1), letterSpacing: 0.5)),
                ),
                const SizedBox(height: 6),
                Text(_namaKonselor, style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D))),
                Text(_specialty, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey[500], height: 1.3)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF5F7FA), shape: BoxShape.circle),
            child: const Icon(Icons.chat_bubble_outline, color: Color(0xFF1068A3), size: 20),
          )
        ],
      ),
    );
  }

  Widget _buildScheduleTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: const Color(0xFFF1F4F8), borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[400], size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey[500], fontWeight: FontWeight.bold)),
              Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D))),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMeetCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)], 
          begin: Alignment.topLeft, 
          end: Alignment.bottomRight
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: const Color(0xFF1068A3).withOpacity(0.25), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Text('Tautan Virtual', style: GoogleFonts.plusJakartaSans(color: Colors.white70, fontSize: 11)),
                  const SizedBox(height: 2),
                  Text('Google Meet', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              )
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, 
                foregroundColor: const Color(0xFF1068A3), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), 
                elevation: 0
              ),
              child: Text('Join Meet', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF1068A3), size: 22),
        const SizedBox(width: 10),
        Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: const Color(0xFF1A2D3D))),
      ],
    );
  }

  Widget _buildCheckItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(16), 
          border: Border.all(color: Colors.grey.shade100)
        ),
        child: Row(
          children: [
            const Icon(Icons.check_circle, color: Color(0xFF1068A3), size: 20),
            const SizedBox(width: 12),
            Expanded(child: Text(text, style: GoogleFonts.plusJakartaSans(fontSize: 13, color: const Color(0xFF1A2D3D)))),
          ],
        ),
      ),
    );
  }

  Widget _buildCatatanBox() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.edit_note_rounded,
                    color: Color(0xFF1068A3),
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Catatan Saya',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () => setState(() => _isEditingCatatan = !_isEditingCatatan),
                child: Text(
                  _isEditingCatatan ? 'Simpan' : 'Edit',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1068A3),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _isEditingCatatan
              ? TextField(
                  controller: _catatanController,
                  maxLines: 3,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.6,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF1068A3)),
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                )
              : Text(
                  _catatanController.text.isNotEmpty
                      ? _catatanController.text
                      : 'Tuliskan hal-hal yang ingin kamu diskusikan dengan $_namaKonselor di sini...',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: _catatanController.text.isNotEmpty ? Colors.grey[700] : Colors.grey[400],
                    height: 1.6,
                    fontStyle: _catatanController.text.isNotEmpty ? FontStyle.italic : FontStyle.normal,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1068A3), Color(0xFF5AB6E5)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ElevatedButton.icon(
            onPressed: () => context.push('/counseling/reschedule', extra: _konselorData),
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              'Ubah Jadwal Sesi',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: OutlinedButton(
            onPressed: () => _showBatalkanDialog(context),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFFEBEE)),
              backgroundColor: const Color(0xFFFFF5F5),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text('Batalkan Sesi', style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.redAccent)),
          ),
        )
      ],
    );
  }

  void _showBatalkanDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Batalkan Sesi?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Apakah kamu yakin ingin membatalkan sesi konseling ini?',
          style: GoogleFonts.plusJakartaSans(fontSize: 14, color: Colors.grey[700]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Tidak', style: GoogleFonts.plusJakartaSans(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/counseling');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: Text('Ya, Batalkan', style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}