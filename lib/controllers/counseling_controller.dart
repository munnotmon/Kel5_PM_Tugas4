import 'package:flutter/material.dart';
import '../models/counseling_model.dart';
import '../models/counselor_model.dart';

class CounselingController {
  // Static list of counselors populated from the old data_konselor.dart
  static final List<Konselor> daftarKonselor = [
    Konselor(
      name: 'dr. Anton Wijaya',
      specialty: 'Spesialis Trauma & Perundungan',
      rating: '4.9',
      experienceYears: '12 Tahun Eksp.',
      sessions: '120 Sesi',
      about:
          'Halo, saya dr. Anton. Saya mendedikasikan karir saya untuk membantu individu yang menghadapi dampak psikologis dari trauma dan perundungan. Melalui pendekatan yang empatik dan ruang yang aman, kita akan bekerja sama untuk memulihkan kepercayaan diri dan kesehatan mental Anda.',
      specialties: ['Trauma', 'Perundungan', 'Konseling Remaja'],
      educations: [
        EducationItem(
          title: 'S3 Psikologi Klinis',
          subtitle: 'Universitas Indonesia • 2015',
        ),
      ],
      experiences: [
        ExperienceItem(
          title: 'Kepala Konselor',
          subtitle: 'Pusat Rehabilitasi Mental Nasional • 2018 - Sekarang',
        ),
      ],
      practiceDays: [1, 3, 5],
      availableTimes: ["09:00 WIB", "10:30 WIB", "13:00 WIB", "15:30 WIB"],
    ),
    Konselor(
      name: 'Siska, M.Psi',
      specialty: 'Kecemasan Sosial',
      rating: '4.8',
      experienceYears: '8 Tahun Eksp.',
      sessions: '85 Sesi',
      about:
          'Halo, saya Siska. Saya fokus pada penanganan kecemasan sosial dan depresi ringan. Mari kita ciptakan ruang nyaman untuk bercerita tanpa penghakiman.',
      specialties: ['Kecemasan Sosial', 'Depresi'],
      educations: [
        EducationItem(
          title: 'S2 Psikologi Profesi',
          subtitle: 'Universitas Gadjah Mada • 2018',
        ),
      ],
      experiences: [
        ExperienceItem(
          title: 'Psikolog Klinis',
          subtitle: 'Klinik Sehati • 2019 - Sekarang',
        ),
      ],
      practiceDays: [2, 4],
      availableTimes: ["10:00 WIB", "11:30 WIB", "14:00 WIB", "16:30 WIB"],
    ),
    Konselor(
      name: 'Budi Hartono, S.Psi',
      specialty: 'Konselor Akademik & Karir',
      rating: '4.8',
      experienceYears: '5 Tahun Eksp.',
      sessions: '210 Sesi',
      about:
          'Halo, saya Budi. Khawatir dengan masa depan atau tugas kampus yang menumpuk? Mari kita obrolkan strategi belajar dan pemetaan karirmu secara terstruktur.',
      specialties: ['Stres Akademik', 'Karir', 'Manajemen Waktu'],
      educations: [
        EducationItem(
          title: 'S1 Psikologi',
          subtitle: 'Universitas Airlangga • 2021',
        ),
      ],
      experiences: [
        ExperienceItem(
          title: 'Konselor Akademik',
          subtitle: 'Pusat Bimbingan Kampus • 2022 - Sekarang',
        ),
      ],
      practiceDays: [1, 2, 4],
      availableTimes: ["08:30 WIB", "10:00 WIB", "13:30 WIB", "15:00 WIB"],
    ),
    Konselor(
      name: 'dr. Sarah Johnson',
      specialty: 'Konselor Psikologi Klinis',
      rating: '4.9',
      experienceYears: '10 Tahun Eksp.',
      sessions: '320 Sesi',
      about:
          'Halo, saya dr. Sarah. Saya berdedikasi membantu individu dalam mengelola stres, kecemasan, dan masalah psikologis klinis lainnya. Mari kita temukan akar masalah dan merancang langkah pemulihan yang tepat bersama-sama.',
      specialties: ['Psikologi Klinis', 'Manajemen Stres', 'Kecemasan'],
      educations: [
        EducationItem(
          title: 'S3 Psikologi Klinis',
          subtitle: 'Universitas Padjadjaran • 2016',
        ),
      ],
      experiences: [
        ExperienceItem(
          title: 'Psikolog Klinis Utama',
          subtitle: 'Klinik Sehat Jiwa • 2017 - Sekarang',
        ),
        ExperienceItem(
          title: 'Konselor Relawan',
          subtitle: 'Yayasan Peduli Mental • 2015 - 2017',
        ),
      ],
      practiceDays: [3, 5],
      availableTimes: ["09:30 WIB", "11:00 WIB", "14:30 WIB", "16:00 WIB"],
    ),
  ];

  // Static list of counseling sessions populated from the old data_riwayat_konseling.dart
  static final List<KonselingItem> riwayatKonselingList = [
    KonselingItem(
      id: 'KSL-001',
      konselor: 'dr. Sarah Johnson',
      tanggal: 'Senin, 12 Okt 2026',
      jam: '14:00 - 15:00',
      status: StatusKonseling.selesai,
    ),
    KonselingItem(
      id: 'KSL-002',
      konselor: 'dr. Anton Wijaya',
      tanggal: 'Kamis, 28 Sep 2026',
      jam: '13:00 - 14:00',
      status: StatusKonseling.selesai,
    ),
    KonselingItem(
      id: 'KSL-003',
      konselor: 'dr. Budi Santoso',
      tanggal: 'Selasa, 26 Sep 2023',
      jam: '09:00 - 10:00 WIB',
      status: StatusKonseling.dibatalkan,
    ),
  ];

  static void addAppointment({
    required String konselor,
    required String tanggal,
    required String jam,
  }) {
    final nextId = 'KSL-00${riwayatKonselingList.length + 1}';
    riwayatKonselingList.add(
      KonselingItem(
        id: nextId,
        konselor: konselor,
        tanggal: tanggal,
        jam: jam,
        status: StatusKonseling.menunggu,
      ),
    );
  }

  static String getSpecialty(String name) {
    try {
      final found = daftarKonselor.firstWhere(
        (k) => k.name.toLowerCase() == name.toLowerCase(),
      );
      return found.specialty;
    } catch (_) {
      return '';
    }
  }

  static List<KonselingItem> getFilteredSessions(int selectedFilter) {
    if (selectedFilter == 0) return riwayatKonselingList;
    if (selectedFilter == 1) {
      return riwayatKonselingList.where((s) => s.tanggal.contains('Okt')).toList();
    }
    if (selectedFilter == 2) {
      return riwayatKonselingList.where((s) => s.status == StatusKonseling.selesai).toList();
    }
    return riwayatKonselingList;
  }
}
