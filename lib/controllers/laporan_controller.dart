import '../models/laporan_model.dart';

class LaporanController {
  static final List<LaporanModel> submittedReports = [
    LaporanModel(
      nama: 'Kelompok 5',
      nim: '21090123',
      telepon: '08123456789',
      prodi: 'Teknologi Informasi',
      waktu: '12 Okt 2026, 10:00',
      lokasi: 'Gedung Sipil Lt. 2',
      jenis: 'Fisik',
      deskripsi: 'Insiden terjadi saat jam istirahat...',
      lampiran: ['foto_kejadian.jpg', 'screenshot_chat.png'],
      korban: 'saya',
      pelaku: 'Siswa lain',
      saksi: 'Dodi',
    ),
  ];

  static LaporanModel activeReport = LaporanModel();

  static void resetActiveReport() {
    activeReport = LaporanModel();
  }

  static void updateStep1({
    required String nama,
    required String nim,
    required String telepon,
    required String prodi,
  }) {
    activeReport = activeReport.copyWith(
      nama: nama,
      nim: nim,
      telepon: telepon,
      prodi: prodi,
    );
  }

  static void updateStep2({
    required String waktu,
    required String lokasi,
    required String jenis,
    required String deskripsi,
    required List<String> lampiran,
  }) {
    activeReport = activeReport.copyWith(
      waktu: waktu,
      lokasi: lokasi,
      jenis: jenis,
      deskripsi: deskripsi,
      lampiran: lampiran,
    );
  }

  static void updateStep3({
    required String korban,
    required String pelaku,
    required String saksi,
  }) {
    activeReport = activeReport.copyWith(
      korban: korban,
      pelaku: pelaku,
      saksi: saksi,
    );
  }

  static void submitReport() {
    submittedReports.add(activeReport);
    resetActiveReport();
  }
}
