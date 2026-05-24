// Lokasi: lib/Konseling/screen3_detail_history.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

class Screen3DetailHistory extends StatefulWidget {
  final Map<String, dynamic>? sessionData;
  const Screen3DetailHistory({super.key, this.sessionData});

  @override
  State<Screen3DetailHistory> createState() => _Screen3DetailHistoryState();
}

class _Screen3DetailHistoryState extends State<Screen3DetailHistory> {
  bool _isEditingCatatan = false;
  late TextEditingController _catatanController;

  // 1. BUAT VARIABEL STATE UNTUK MENGUNCI DATA AGAR TIDAK ILANG SAAT REBUILD
  late String _namaDokter;
  late String _spesialisasi;
  late String _tanggalSesi;
  late String _jamSesi;

  @override
  void initState() {
    super.initState();
    
    // 2. KUNCI DATA DARI WIDGET KE DALAM STATE LOKAL DI SINI
    _namaDokter = widget.sessionData?['konselor'] ?? 'Nama Konselor';
    _spesialisasi = widget.sessionData?['specialty'] ?? 'Spesialis Konselor';
    _tanggalSesi = widget.sessionData?['tanggal'] ?? 'Tanggal Sesi';
    _jamSesi = widget.sessionData?['jam'] ?? 'Jam Sesi';

    // Mengambil nama dokter secara dinamis untuk teks catatan default
    _catatanController = TextEditingController(
      text: '"Hari ini merasa lebih tenang setelah bercerita dengan $_namaDokter. Ternyata selama ini aku terlalu keras pada diri sendiri. Besok harus mulai coba latihan napasnya."',
    );
  }

  @override
  void dispose() {
    _catatanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Detail Riwayat Sesi',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF1A2D3D),
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // --- STATUS + BAGIKAN ---
          _buildStatusBar(context),
          const SizedBox(height: 16),

          // --- JUDUL SESI ---
          _buildSessionTitle(),
          const SizedBox(height: 20),

          // --- KONSELOR CARD ---
          _buildKonselorCard(context),
          const SizedBox(height: 24),

          // --- RANGKUMAN SESI ---
          _buildRangkumanSesi(),
          const SizedBox(height: 20),

          // --- REKOMENDASI KONSELOR ---
          _buildRekomendasiKonselor(),
          const SizedBox(height: 20),

          // --- CATATAN PRIBADI ---
          _buildCatatanPribadi(),
          const SizedBox(height: 28),

          // --- TOMBOL AKSI ---
          _buildActionButtons(context),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: const Color(0xFF4ADE80),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF22C55E).withOpacity(0.28),
                blurRadius: 28,
                spreadRadius: 6,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 9, 72, 32),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'Selesai',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color.fromARGB(255, 9, 72, 32),
                ),
              ),
            ],
          ),
        ),

        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              const Icon(
                Icons.share_outlined,
                color: Color(0xFF1068A3),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                'Bagikan',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1068A3),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSessionTitle() {
    // 3. GUNAKAN VARIABEL LOKAL YANG SUDAH AMAN DARI REBUILD
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sesi Counseling Individu',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13,
            color: Colors.grey[500],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _tanggalSesi,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF1A2D3D),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time_outlined,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              _jamSesi,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKonselorCard(BuildContext context) {
    // 4. GUNAKAN VARIABEL LOKAL YANG SUDAH AMAN DARI REBUILD
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
            radius: 26,
            backgroundColor: Colors.grey[200],
            backgroundImage: NetworkImage(
              'https://i.pravatar.cc/150?u=$_namaDokter',
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _namaDokter,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A2D3D),
                  ),
                ),
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
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        _spesialisasi.isNotEmpty ? _spesialisasi : 'Spesialis Profesional',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFF1068A3).withOpacity(0.12), 
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.chat_bubble_outline,
              color: Color(0xFF1068A3), 
              size: 21,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRangkumanSesi() {
    final List<String> poinRangkuman = [
      'Membahas strategi koping untuk menghadapi tekanan tugas kuliah yang menumpuk.',
      'Identifikasi pemicu kecemasan saat berada di lingkungan sosial yang ramai.',
      'Refleksi mengenai pola komunikasi dengan teman sebaya.',
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), 
            blurRadius: 20,                        
            spreadRadius: 1,                       
            offset: const Offset(0, 8),            
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.description_outlined,
                color: Color(0xFF1068A3),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Rangkuman Sesi',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1068A3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...poinRangkuman.map(
            (poin) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 5,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: Color(0xFF1068A3),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      poin,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRekomendasiKonselor() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 209, 231, 211), 
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.lightbulb_outline,
                color: Color(0xFF2E7D32), 
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Rekomendasi Konselor',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildRekomendasiItem(
            icon: Icons.self_improvement_outlined,
            title: 'Latihan Pernapasan',
            subtitle: 'Lakukan 5 menit setiap pagi setelah bangun tidur.',
          ),
          const SizedBox(height: 12),

          _buildRekomendasiItem(
            icon: Icons.edit_note_outlined,
            title: 'Jurnal Harian',
            subtitle: 'Tuliskan 3 hal positif yang terjadi setiap hari.',
          ),
        ],
      ),
    );
  }

  Widget _buildRekomendasiItem({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08), 
            blurRadius: 16,
            spreadRadius: 5,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9), 
              borderRadius: BorderRadius.circular(12), 
            ),
            child: Icon(icon, color: const Color(0xFF2E7D32), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF212121), 
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: const Color(0xFF616161), 
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatatanPribadi() {
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
                    Icons.person_outline,
                    color: Color(0xFF1068A3),
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Catatan Pribadi',
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
                  maxLines: 4,
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
                  _catatanController.text,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.6,
                    fontStyle: FontStyle.italic,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
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
            onPressed: () => context.push('/counseling/reschedule'),
            icon: const Icon(
              Icons.calendar_month_outlined,
              color: Colors.white,
              size: 18,
            ),
            label: Text(
              'Jadwalkan Ulang dengan Konselor Ini',
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
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.download_rounded,
              color: Color(0xFF1A2D3D),
              size: 20,
            ),
            label: Text(
              'Unduh Ringkasan Sesi (PDF)',
              style: GoogleFonts.plusJakartaSans(
                color: const Color(0xFF1A2D3D),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ),
      ],
    );
  }
}