// Lokasi: lib/controllers/laporan_controller.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LaporanController {
  // =====================================================================
  // CONTROLLERS & DATA - STEP 1 (Data Diri Pelapor)
  // =====================================================================
  final TextEditingController step1NamaController = TextEditingController();
  final TextEditingController step1NimController = TextEditingController();
  final TextEditingController step1TeleponController = TextEditingController();
  String? step1SelectedProdi;

  void disposeStep1() {
    step1NamaController.dispose();
    step1NimController.dispose();
    step1TeleponController.dispose();
  }

  void processStep1(
      BuildContext context, GlobalKey<FormState> formKey, Map<String, dynamic>? prevData) {
    if (formKey.currentState!.validate()) {
      final safePrevData = prevData ?? {};
      final isEdit = safePrevData['isEdit'] == true;

      final currentData = {
        ...safePrevData,
        'nama': step1NamaController.text,
        'nim': step1NimController.text,
        'telepon': step1TeleponController.text,
        'prodi': step1SelectedProdi,
      };

      if (isEdit) {
        context.push('/activity/laporan/step4', extra: currentData);
      } else {
        context.push('/activity/laporan/step2', extra: currentData);
      }
    }
  }

  // =====================================================================
  // CONTROLLERS & DATA - STEP 2 (Detail Kejadian)
  // =====================================================================
  final TextEditingController step2LokasiController = TextEditingController();
  final TextEditingController step2DeskripsiController = TextEditingController();
  
  void disposeStep2() {
    step2LokasiController.dispose();
    step2DeskripsiController.dispose();
  }

  String formatDateTime(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}, '
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void processStep2(
    BuildContext context, 
    GlobalKey<FormState> formKey, 
    Map<String, dynamic> prevData, 
    DateTime? selectedDateTime,
    String? selectedJenis,
    List<String> attachmentsPath
  ) {
    if (formKey.currentState!.validate()) {
      if (selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Waktu kejadian wajib diisi'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }
      
      final isEdit = prevData['isEdit'] == true;

      final currentData = {
        ...prevData,
        'waktu': formatDateTime(selectedDateTime),
        'lokasi': step2LokasiController.text,
        'jenis': selectedJenis ?? '',
        'deskripsi': step2DeskripsiController.text,
        'lampiran': attachmentsPath,
      };

      if (isEdit) {
        context.push('/activity/laporan/step4', extra: currentData);
      } else {
        context.push('/activity/laporan/step3', extra: currentData);
      }
    }
  }

  // =====================================================================
  // CONTROLLERS & DATA - STEP 3 (Pihak Terlibat)
  // =====================================================================
  final TextEditingController step3PelakuController = TextEditingController();
  final TextEditingController step3SaksiController = TextEditingController();

  void disposeStep3() {
    step3PelakuController.dispose();
    step3SaksiController.dispose();
  }

  void processStep3(
      BuildContext context, GlobalKey<FormState> formKey, Map<String, dynamic> prevData, String selectedKorban) {
    if (formKey.currentState!.validate()) {
      context.push('/activity/laporan/step4', extra: {
        ...prevData,
        'korban': selectedKorban,
        'pelaku': step3PelakuController.text,
        'saksi': step3SaksiController.text,
      });
    }
  }
}