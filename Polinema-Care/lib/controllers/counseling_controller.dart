import 'dart:convert';
import '../models/counseling_model.dart';
import '../models/counselor_model.dart';
import '../services/api_service.dart';

class CounselingController {
  // Cache daftar konselor — diisi dinamis dari API (GET /konselor).
  static List<Konselor> daftarKonselor = [];
  // Jumlah konselor yang sedang online (dari API).
  static int onlineCount = 0;

  // Ambil daftar konselor dari backend.
  static Future<List<Konselor>> fetchKonselor() async {
    try {
      final response = await ApiService.get('/konselor');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final List list = body['data'] ?? [];
        final items = list
            .map((e) => Konselor.fromMap(Map<String, dynamic>.from(e)))
            .toList();
        daftarKonselor = items;
        onlineCount = body['online_count'] is int
            ? body['online_count']
            : items.where((k) => k.isOnline).length;
        return items;
      }
    } catch (e) {
      print('Error fetching konselor: $e');
    }
    return daftarKonselor;
  }

  // Ambil detail satu konselor dari backend.
  static Future<Konselor?> fetchKonselorDetail(int id) async {
    try {
      final response = await ApiService.get('/konselor/$id');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        return Konselor.fromMap(Map<String, dynamic>.from(body['data']));
      }
    } catch (e) {
      print('Error fetching konselor detail: $e');
    }
    return null;
  }

  // Konselor placeholder aman agar akses data tidak pernah crash saat cache kosong.
  static Konselor get placeholderKonselor => Konselor(
        name: 'Konselor',
        specialty: 'Polinema Care',
        rating: '5.0',
        experienceYears: '',
        sessions: '',
        about: '',
        specialties: const [],
        educations: const [],
        experiences: const [],
        practiceDays: const [],
        availableTimes: const [],
      );

  // Ambil konselor berdasarkan indeks dari cache, fallback ke placeholder bila kosong.
  static Konselor konselorAt(int index) {
    if (index >= 0 && index < daftarKonselor.length) {
      return daftarKonselor[index];
    }
    return placeholderKonselor;
  }

  // Cari konselor dari cache berdasarkan nama, fallback ke placeholder.
  static Konselor findKonselorByName(String name) {
    try {
      return daftarKonselor.firstWhere(
        (k) => k.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (_) {
      return placeholderKonselor;
    }
  }

  // Static list of counseling sessions populated from the old data_riwayat_konseling.dart
  static final List<KonselingItem> riwayatKonselingList = [];

  static Future<List<Map<String, dynamic>>> fetchSchedules() async {
    try {
      final response = await ApiService.get('/jadwal');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final List list = body['data'] ?? [];
        return List<Map<String, dynamic>>.from(list);
      }
    } catch (e) {
      print('Error fetching schedules: $e');
    }
    return [];
  }

  static Future<List<KonselingItem>> fetchBookings() async {
    try {
      final response = await ApiService.get('/konseling');
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final List list = body['data'] ?? [];
        final items = list.map((item) {
          final id = item['id']?.toString() ?? '';
          final adminName = item['admin']?['nama'] ?? 'Admin Polinema Care';
          
          final jadwal = item['jadwal_konseling'];
          String dateStr = '-';
          String timeStr = '-';
          String lokasi = '-';
          if (jadwal != null) {
            final rawDate = jadwal['tanggal']?.toString() ?? '';
            dateStr = _formatDate(rawDate);
            final start = jadwal['jam_mulai']?.toString().substring(0, 5) ?? '';
            final end = jadwal['jam_selesai']?.toString().substring(0, 5) ?? '';
            timeStr = '$start - $end';
            lokasi = jadwal['lokasi']?.toString() ?? '-';
          }

          final statusStr = item['status']?.toString() ?? 'Diajukan';
          var status = _parseStatus(statusStr);

          if (jadwal != null && (status == StatusKonseling.diterima || status == StatusKonseling.berlangsung || status == StatusKonseling.diajukan)) {
            final rawDateStr = jadwal['tanggal']?.toString() ?? '';
            final rawTimeEndStr = jadwal['jam_selesai']?.toString() ?? '23:59:59';
            if (rawDateStr.isNotEmpty) {
              try {
                final datePart = rawDateStr.substring(0, 10);
                final timePart = rawTimeEndStr.length >= 8 ? rawTimeEndStr.substring(0, 8) : rawTimeEndStr;
                final sessionEndDateTime = DateTime.parse("${datePart}T$timePart");
                if (DateTime.now().isAfter(sessionEndDateTime)) {
                  status = StatusKonseling.selesai;
                }
              } catch (e) {
                print('Error parsing session end datetime: $e');
              }
            }
          }
          final rawKeluhan = item['keluhan']?.toString() ?? '';
          final rawCatatan = item['catatan_mahasiswa']?.toString();
          final rawCatatanKonselor = item['catatan_konselor']?.toString();
          final rawRekomendasiPemulihan = item['rekomendasi_pemulihan']?.toString();

          String mode = 'Online';
          if (rawKeluhan.toLowerCase().contains('offline') || 
              (!lokasi.toLowerCase().contains('online') && lokasi != '-' && lokasi.isNotEmpty)) {
            mode = 'Offline';
          }

          Map<String, dynamic>? counselorData;
          final admin = item['admin'];
          if (admin != null) {
            counselorData = {
              'id': admin['id'],
              'name': admin['nama'] ?? '',
              'email': admin['email'] ?? '',
              'role': admin['role'] ?? 'admin',
              'specialty': admin['spesialisasi'] ?? '',
              'rating': admin['rating'] ?? 5.0,
              'experience_years': admin['pengalaman_tahun'] ?? '',
              'about': admin['tentang'] ?? '',
              'foto_profil': admin['foto_profil'],
              'nomor_telepon': admin['nomor_telepon'],
              'is_online': admin['is_online'] == true || admin['is_online'] == 1,
              'is_quota_full': admin['is_quota_full'] == true || admin['is_quota_full'] == 1,
              'specialties': admin['spesialisasi_list'] ?? [],
              'educations': admin['pendidikan'] ?? [],
              'experiences': admin['pengalaman'] ?? [],
              'practice_days': admin['hari_praktik'] ?? [],
              'available_times': admin['jam_tersedia'] ?? [],
            };
          }

          return KonselingItem(
            id: 'KSL-$id',
            konselor: adminName,
            tanggal: dateStr,
            jam: timeStr,
            status: status,
            keluhan: rawKeluhan,
            mode: mode,
            lokasi: lokasi,
            catatan: rawCatatan,
            counselorData: counselorData,
            catatanKonselor: rawCatatanKonselor,
            rekomendasiPemulihan: rawRekomendasiPemulihan,
          );
        }).toList();
        
        riwayatKonselingList.clear();
        riwayatKonselingList.addAll(items);
        return items;
      }
    } catch (e) {
      print('Error fetching bookings: $e');
    }
    return riwayatKonselingList;
  }

  static Future<String?> createBooking(int scheduleId, String keluhan, {int? adminId}) async {
    try {
      final response = await ApiService.post('/konseling', {
        'jadwal_id': scheduleId,
        'keluhan': keluhan,
        if (adminId != null) 'admin_id': adminId,
      });
      final body = jsonDecode(response.body);
      if ((response.statusCode == 201 || response.statusCode == 200) && body['success'] == true) {
        return null;
      }
      return body['message'] ?? "Gagal membuat janji temu.";
    } catch (e) {
      print('Error creating booking: $e');
      return "Terjadi kesalahan jaringan.";
    }
  }

  static String _formatDate(String rawDate) {
    if (rawDate.isEmpty || rawDate.length < 10) return rawDate;
    try {
      final dt = DateTime.parse(rawDate.substring(0, 10));
      final days = ['Minggu', 'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu'];
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
      return '${days[dt.weekday % 7]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
    } catch (_) {
      return rawDate;
    }
  }

  static StatusKonseling _parseStatus(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'diajukan':
        return StatusKonseling.diajukan;
      case 'diterima':
        return StatusKonseling.diterima;
      case 'berlangsung':
        return StatusKonseling.berlangsung;
      case 'selesai':
        return StatusKonseling.selesai;
      case 'dibatalkan':
        return StatusKonseling.dibatalkan;
      default:
        return StatusKonseling.diajukan;
    }
  }

  static void addAppointment({
    required String konselor,
    required String tanggal,
    required String jam,
  }) {
    // Legacy support, deprecated
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
      return riwayatKonselingList.where((s) => s.status == StatusKonseling.diajukan).toList();
    }
    if (selectedFilter == 2) {
      return riwayatKonselingList.where((s) => s.status == StatusKonseling.diterima).toList();
    }
    if (selectedFilter == 3) {
      return riwayatKonselingList.where((s) => s.status == StatusKonseling.berlangsung).toList();
    }
    if (selectedFilter == 4) {
      return riwayatKonselingList.where((s) => s.status == StatusKonseling.selesai).toList();
    }
    if (selectedFilter == 5) {
      return riwayatKonselingList.where((s) => s.status == StatusKonseling.dibatalkan).toList();
    }
    return riwayatKonselingList;
  }

  static Future<bool> cancelBooking(String bookingId) async {
    try {
      final cleanId = bookingId.replaceAll('KSL-', '');
      final response = await ApiService.post('/konseling/$cleanId/status', {
        'status': 'Dibatalkan',
      });
      final body = jsonDecode(response.body);
      return response.statusCode == 200 && body['success'] == true;
    } catch (e) {
      print('Error canceling booking: $e');
      return false;
    }
  }

  static Future<bool> updateCatatan(String bookingId, String catatan) async {
    try {
      final cleanId = bookingId.replaceAll('KSL-', '');
      final response = await ApiService.post('/konseling/$cleanId/catatan', {
        'catatan': catatan,
      });
      final body = jsonDecode(response.body);
      if (response.statusCode == 200 && body['success'] == true) {
        final idx = riwayatKonselingList.indexWhere((item) => item.id == bookingId);
        if (idx != -1) {
          final oldItem = riwayatKonselingList[idx];
          riwayatKonselingList[idx] = KonselingItem(
            id: oldItem.id,
            konselor: oldItem.konselor,
            tanggal: oldItem.tanggal,
            jam: oldItem.jam,
            status: oldItem.status,
            keluhan: catatan,
            mode: oldItem.mode,
            lokasi: oldItem.lokasi,
            catatan: catatan,
            counselorData: oldItem.counselorData,
            catatanKonselor: oldItem.catatanKonselor,
            rekomendasiPemulihan: oldItem.rekomendasiPemulihan,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print('Error updating catatan: $e');
      return false;
    }
  }
}
