class LaporanModel {
  final String nama;
  final String nim;
  final String telepon;
  final String prodi;
  final String waktu;
  final String lokasi;
  final String jenis;
  final String deskripsi;
  final List<String> lampiran;
  final String korban;
  final String pelaku;
  final String saksi;

  LaporanModel({
    this.nama = '',
    this.nim = '',
    this.telepon = '',
    this.prodi = '',
    this.waktu = '',
    this.lokasi = '',
    this.jenis = '',
    this.deskripsi = '',
    this.lampiran = const [],
    this.korban = '',
    this.pelaku = '',
    this.saksi = '',
  });

  LaporanModel copyWith({
    String? nama,
    String? nim,
    String? telepon,
    String? prodi,
    String? waktu,
    String? lokasi,
    String? jenis,
    String? deskripsi,
    List<String>? lampiran,
    String? korban,
    String? pelaku,
    String? saksi,
  }) {
    return LaporanModel(
      nama: nama ?? this.nama,
      nim: nim ?? this.nim,
      telepon: telepon ?? this.telepon,
      prodi: prodi ?? this.prodi,
      waktu: waktu ?? this.waktu,
      lokasi: lokasi ?? this.lokasi,
      jenis: jenis ?? this.jenis,
      deskripsi: deskripsi ?? this.deskripsi,
      lampiran: lampiran ?? this.lampiran,
      korban: korban ?? this.korban,
      pelaku: pelaku ?? this.pelaku,
      saksi: saksi ?? this.saksi,
    );
  }

  factory LaporanModel.fromMap(Map<String, dynamic> map) {
    return LaporanModel(
      nama: map['nama'] ?? '',
      nim: map['nim'] ?? '',
      telepon: map['telepon'] ?? '',
      prodi: map['prodi'] ?? '',
      waktu: map['waktu'] ?? '',
      lokasi: map['lokasi'] ?? '',
      jenis: map['jenis'] ?? '',
      deskripsi: map['deskripsi'] ?? '',
      lampiran: List<String>.from(map['lampiran'] ?? []),
      korban: map['korban'] ?? '',
      pelaku: map['pelaku'] ?? '',
      saksi: map['saksi'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'nim': nim,
      'telepon': telepon,
      'prodi': prodi,
      'waktu': waktu,
      'lokasi': lokasi,
      'jenis': jenis,
      'deskripsi': deskripsi,
      'lampiran': lampiran,
      'korban': korban,
      'pelaku': pelaku,
      'saksi': saksi,
    };
  }
}
