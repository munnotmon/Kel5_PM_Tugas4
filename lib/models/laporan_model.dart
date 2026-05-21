enum StatusLaporan { menunggu, diproses, selesai, ditolak }

class LaporanItem {
  final String id;
  final String judul;
  final String tanggal;
  final StatusLaporan status;
  final String deskripsi;

  const LaporanItem({
    required this.id,
    required this.judul,
    required this.tanggal,
    required this.status,
    required this.deskripsi,
  });
}

final List<LaporanItem> dummyLaporan = [
  LaporanItem(
    id: 'RPT-001',
    judul: 'Perundungan Verbal di Kelas',
    tanggal: '12 Mei 2026',
    status: StatusLaporan.diproses,
    deskripsi: 'Laporan mengenai tindakan verbal oleh senior kepada junior.',
  ),
  LaporanItem(
    id: 'RPT-002',
    judul: 'Intimidasi di Kantin',
    tanggal: '8 Mei 2026',
    status: StatusLaporan.selesai,
    deskripsi: 'Laporan intimidasi yang terjadi di area kantin kampus.',
  ),
  LaporanItem(
    id: 'RPT-003',
    judul: 'Cyberbullying Media Sosial',
    tanggal: '1 Mei 2026',
    status: StatusLaporan.menunggu,
    deskripsi: 'Penyebaran konten negatif di grup WhatsApp.',
  ),
];