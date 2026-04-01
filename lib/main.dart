import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      home: const KonselingPage(),
    );
  }
}

class KonselingPage extends StatelessWidget {
  const KonselingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "Konseling",
          style: TextStyle(
            fontWeight: FontWeight.bold, // Ini untuk menebalkan teks
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Perintah pindah ke halaman riwayat
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HalamanRiwayat()),
              );
            },
            child: const Text(
              "Riwayat Konseling",
              style: TextStyle(
                color: Color.fromARGB(
                  255,
                  29,
                  155,
                  233,
                ), // Opsional: Ubah warna agar senada dengan gambar Anda
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // CARD ATAS
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 219, 237, 219),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                // Perhatikan huruf kapital 'R'
                children: [
                  Expanded(
                    child: Column(
                      // Tambahkan 'child:' di sini
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Pastikan 'const' dihapus jika ada widget dinamis di dalamnya
                        Text(
                          "Butuh teman bicara?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Jadwalkan sesi privat dengan konselor profesional kami.",
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // BUTTON
                  ElevatedButton(
                    onPressed: () {
                      // Fungsi untuk pindah halaman
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HalamanJadwal(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 43, 103, 47),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Jadwalkan"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // CARD BAWAH
            Material(
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DetailSesi()),
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundImage: NetworkImage(""),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "BESOK, 10:00",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.blue,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Sesi dengan dr. WILDAN",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HalamanJadwal extends StatelessWidget {
  const HalamanJadwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Jadwal"), // Judul halaman baru
      ),
      body: const Center(
        child: Text("Halaman Jadwal Kosong"), // Isi halaman
      ),
    );
  }
}

class HalamanRiwayat extends StatelessWidget {
  const HalamanRiwayat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Konseling")),
      body: const Center(child: Text("Belum ada riwayat konseling.")),
    );
  }
}

class DetailSesi extends StatelessWidget {
  const DetailSesi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Sesi")),
      body: const Center(child: Text("Belum ada detail sesi yang tersedia.")),
    );
  }
}
