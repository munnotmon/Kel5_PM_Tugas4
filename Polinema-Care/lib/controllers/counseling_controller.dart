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
          if (jadwal != null) {
            final rawDate = jadwal['tanggal']?.toString() ?? '';
            dateStr = _formatDate(rawDate);
            final start = jadwal['jam_mulai']?.toString().substring(0, 5) ?? '';
            final end = jadwal['jam_selesai']?.toString().substring(0, 5) ?? '';
            timeStr = '$start - $end';
          }

          final statusStr = item['status']?.toString() ?? 'Diajukan';
          final status = _parseStatus(statusStr);

          return KonselingItem(
            id: 'KSL-$id',
            konselor: adminName,
            tanggal: dateStr,
            jam: timeStr,
            status: status,
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

  static Future<bool> createBooking(int scheduleId, String keluhan) async {
    try {
      final response = await ApiService.post('/konseling', {
        'jadwal_id': scheduleId,
        'keluhan': keluhan,
      });
      final body = jsonDecode(response.body);
      return (response.statusCode == 201 || response.statusCode == 200) && body['success'] == true;
    } catch (e) {
      print('Error creating booking: $e');
      return false;
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
        return StatusKonseling.menunggu;
      case 'diterima':
      case 'berlangsung':
        return StatusKonseling.dikonfirmasi;
      case 'selesai':
        return StatusKonseling.selesai;
      case 'dibatalkan':
        return StatusKonseling.dibatalkan;
      default:
        return StatusKonseling.menunggu;
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
      return riwayatKonselingList.where((s) => s.tanggal.contains('Jun') || s.tanggal.contains('Okt')).toList();
    }
    if (selectedFilter == 2) {
      return riwayatKonselingList.where((s) => s.status == StatusKonseling.selesai).toList();
    }
    return riwayatKonselingList;
  }
}
