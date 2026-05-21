class LaporanModel {
  String? nama;
  String? nim;
  String? telepon;
  String? prodi;
  String? jenisPerundungan;
  String? deskripsi;
  String? lokasi;
  String? tanggal;
  String? buktiPath; // File path atau URL bukti foto

  LaporanModel({
    this.nama,
    this.nim,
    this.telepon,
    this.prodi,
    this.jenisPerundungan,
    this.deskripsi,
    this.lokasi,
    this.tanggal,
    this.buktiPath,
  });

  // Fungsi untuk membersihkan form laporan setelah disubmit
  void clear() {
    nama = null;
    nim = null;
    telepon = null;
    prodi = null;
    jenisPerundungan = null;
    deskripsi = null;
    lokasi = null;
    tanggal = null;
    buktiPath = null;
  }
}
