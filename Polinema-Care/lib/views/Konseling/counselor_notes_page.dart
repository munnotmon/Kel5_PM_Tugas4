import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/counseling_controller.dart';

class CounselorNotesPage extends StatelessWidget {
  final Map<String, dynamic>? sessionData;

  const CounselorNotesPage({super.key, this.sessionData});

  @override
  Widget build(BuildContext context) {
    final name = sessionData?['konselor'] ?? 
                 sessionData?['counselor']?['name'] ?? 
                 'Nama Konselor';
    final specialty = sessionData?['specialty'] ?? 
                      sessionData?['counselor']?['specialty'] ?? 
                      'Konselor Profesional';
    final tanggal = sessionData?['tanggal'] ?? 'Tanggal Sesi';

    final counselorModel = CounselingController.findKonselorByName(name);
    final String? avatarUrl = (counselorModel.fotoProfil != null && counselorModel.fotoProfil!.isNotEmpty)
        ? counselorModel.fotoProfil
        : null;

    final String catatanKonselor = sessionData?['catatan_konselor'] ?? '';
    final String rekomendasiPemulihan = sessionData?['rekomendasi_pemulihan'] ?? '';

    final specialties = counselorModel.specialties.map((e) => e.toLowerCase()).toList();

    List<String> poinRangkuman = [];
    List<Map<String, String>> rekomendasiList = [];

    if (catatanKonselor.isNotEmpty || rekomendasiPemulihan.isNotEmpty) {
      if (catatanKonselor.isNotEmpty) {
        poinRangkuman = catatanKonselor
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
      } else {
        poinRangkuman = ['Tidak ada catatan rangkuman sesi yang ditambahkan.'];
      }

      if (rekomendasiPemulihan.isNotEmpty) {
        final lines = rekomendasiPemulihan
            .split('\n')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList();
        rekomendasiList = lines.map((line) {
          return {
            'icon': 'self_improvement_outlined',
            'title': 'Rekomendasi Pemulihan',
            'desc': line,
          };
        }).toList();
      } else {
        rekomendasiList = [
          {
            'icon': 'self_improvement_outlined',
            'title': 'Rekomendasi Pemulihan',
            'desc': 'Tidak ada rekomendasi pemulihan khusus yang diberikan.',
          }
        ];
      }
    } else {
      if (specialties.contains('depresi')) {
        poinRangkuman = [
          'Mengevaluasi pola pikir negatif yang sering memicu perasaan putus asa dan tidak berharga.',
          'Membahas pentingnya rutinitas harian sederhana untuk menjaga tingkat energi dan motivasi.',
          'Mengajarkan cara menghadapi distorsi kognitif ketika mulai menyalahkan diri sendiri.'
        ];
        rekomendasiList = [
          {
            'icon': 'self_improvement_outlined',
            'title': 'Aktivitas Fisik Ringan',
            'desc': 'Lakukan jalan kaki 10-15 menit di pagi hari untuk merangsang endorfin.',
          },
          {
            'icon': 'edit_note_outlined',
            'title': 'Jurnal Mood Harian',
            'desc': 'Catat tingkat energi Anda setiap sore untuk memetakan pemicu kelelahan mental.',
          }
        ];
      } else if (specialties.contains('kecemasan')) {
        poinRangkuman = [
          'Membahas kekhawatiran berlebihan terkait penilaian akademis dan masa depan.',
          'Mengidentifikasi gejala fisik kecemasan seperti jantung berdebar dan sesak napas.',
          'Mempelajari teknik grounding dan relaksasi untuk mengendalikan serangan cemas.'
        ];
        rekomendasiList = [
          {
            'icon': 'self_improvement_outlined',
            'title': 'Pernapasan Perut (4-7-8)',
            'desc': 'Lakukan latihan pernapasan selama 5 menit saat Anda mulai merasa panik.',
          },
          {
            'icon': 'edit_note_outlined',
            'title': 'Batasi Kafein & Layar',
            'desc': 'Kurangi kopi setelah jam 2 siang dan matikan gadget 30 menit sebelum tidur.',
          }
        ];
      } else if (specialties.contains('perundungan')) {
        poinRangkuman = [
          'Menganalisis dampak traumatis dari perlakuan tidak menyenangkan di lingkungan sekitar.',
          'Membangun kembali rasa percaya diri dan keberhargaan diri yang terganggu.',
          'Menyusun batasan diri (boundaries) yang jelas serta langkah pertahanan yang aman.'
        ];
        rekomendasiList = [
          {
            'icon': 'self_improvement_outlined',
            'title': 'Latihan Asertif',
            'desc': 'Praktikkan cara merespon perkataan negatif dengan nada tenang namun tegas.',
          },
          {
            'icon': 'edit_note_outlined',
            'title': 'Hubungi Pihak Kampus',
            'desc': 'Simpan kontak darurat Polinema Care untuk melaporkan intimidasi dengan segera.',
          }
        ];
      } else if (specialties.contains('trauma')) {
        poinRangkuman = [
          'Mengeksplorasi memori masa lalu yang belum terselesaikan secara aman perlahan-laman.',
          'Mempelajari cara menstabilkan emosi ketika terpicu (triggered) oleh situasi tertentu.',
          'Mengembangkan narasi diri baru yang berfokus pada kekuatan dan pemulihan.'
        ];
        rekomendasiList = [
          {
            'icon': 'self_improvement_outlined',
            'title': 'Teknik Grounding 5-4-3-2-1',
            'desc': 'Sebutkan 5 benda terlihat, 4 sentuhan fisik, 3 suara, 2 bau, dan 1 rasa.',
          },
          {
            'icon': 'edit_note_outlined',
            'title': 'Catat Pemicu Emosi',
            'desc': 'Tuliskan situasi yang membuat Anda terpicu untuk dibahas di sesi selanjutnya.',
          }
        ];
      } else if (specialties.contains('karir')) {
        poinRangkuman = [
          'Mengeksplorasi potensi diri, minat akademis, dan pilihan karir pasca-kelulusan.',
          'Mengatasi stres dan kebingungan dalam menentukan langkah magang atau studi lanjutan.',
          'Merumuskan target jangka pendek yang terukur dan realistis demi mengurangi cemas karir.'
        ];
        rekomendasiList = [
          {
            'icon': 'self_improvement_outlined',
            'title': 'Analisis SWOT Diri',
            'desc': 'Petakan kelebihan, kelemahan, peluang, serta hambatan profesional Anda.',
          },
          {
            'icon': 'edit_note_outlined',
            'title': 'Perbarui Portofolio',
            'desc': 'Mulai susun CV dan kumpulkan hasil karya terbaik Anda dalam satu berkas rapi.',
          }
        ];
      } else {
        poinRangkuman = [
          'Membahas manajemen waktu yang kurang seimbang antara kuliah dan kehidupan pribadi.',
          'Mengevaluasi tingkat kelelahan fisik dan mental (burnout) akibat beban tugas.',
          'Berdiskusi tentang pentingnya istirahat yang berkualitas dan pola tidur sehat.'
        ];
        rekomendasiList = [
          {
            'icon': 'self_improvement_outlined',
            'title': 'Metode Pomodoro',
            'desc': 'Belajar fokus selama 25 menit diikuti istirahat singkat selama 5 menit.',
          },
          {
            'icon': 'edit_note_outlined',
            'title': 'Skala Prioritas Eisenhower',
            'desc': 'Kelompokkan tugas harian Anda ke dalam kuadran penting vs mendesak.',
          }
        ];
      }
    }

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
          'Catatan Sesi dari Konselor',
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
          // Header Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Riwayat Konseling',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tanggal,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1A2D3D),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F6EE),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF2A9D6A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Selesai',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2A9D6A),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Counselor Card
          Container(
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
                  backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                  child: avatarUrl == null ? const Icon(Icons.person, color: Colors.white) : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1A2D3D),
                        ),
                      ),
                      Text(
                        specialty,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Rangkuman Sesi dari Konselor
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 20,
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
                      'Rangkuman Sesi dari Konselor',
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
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
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
          ),
          const SizedBox(height: 20),

          // Rekomendasi Konselor
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
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
                      'Rekomendasi Pemulihan',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...rekomendasiList.map(
                  (rec) {
                    final iconData = rec['icon'] == 'self_improvement_outlined'
                        ? Icons.self_improvement_outlined
                        : Icons.edit_note_outlined;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildRecommendationTile(
                        icon: iconData,
                        title: rec['title']!,
                        subtitle: rec['desc']!,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Info Footer
          Text(
            'Catatan dan rekomendasi ini dibuat oleh konselor Anda untuk membantu proses perkembangan kesehatan mental Anda.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),

          // Button Back to Home
          SizedBox(
            width: double.infinity,
            height: 55,
            child: OutlinedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.home_outlined, color: Color(0xFF1068A3)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF1068A3)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              label: Text(
                'Kembali ke Beranda',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1068A3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationTile({
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
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(10),
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
}
