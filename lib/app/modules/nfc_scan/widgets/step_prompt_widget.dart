import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';
import 'package:nfc_manager/nfc_manager.dart'; // Pastikan package ini terimpor
import 'package:digiktp/app/theme/app_colors.dart';

class PromptWidget extends GetView<NfcScanController> {
  const PromptWidget({Key? key}) : super(key: key);

  // Fungsi helper untuk mengecek ketersediaan & keaktifan NFC
  Future<void> _handleStartScanning(BuildContext context) async {
    try {
      // 1. Cek apakah perangkat mendukung NFC
      bool isAvailable = await NfcManager.instance.isAvailable();
      
      if (!isAvailable) {
        // Jika HP tidak punya sensor NFC sama sekali
        Get.snackbar(
          'Perangkat Tidak Didukung',
          'Smartphone Anda tidak memiliki sensor NFC atau modul NFC rusak.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      // 2. Jika perangkat mendukung tapi NFC-nya sedang MATI
      // (Catatan: di beberapa device, isAvailable mengembalikan false jika NFC mati)
      // Kita tambahkan pengecekan dengan memicu startSession atau langsung beri peringatan standar
      if (controller.isScanning.value) return;

      // Jalankan fungsi scan jika aman
      controller.startNfcSession();
      
    } catch (e) {
      // Jika NFC nonaktif, nfc_manager biasanya melempar exception atau gagal memulai session
      Get.snackbar(
        'NFC Belum Aktif',
        'Harap aktifkan fitur NFC di pengaturan perangkat Anda sebelum memindai e-KTP.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFD97706), // Warna oranye peringatan
        colorText: Colors.white,
        icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
        duration: const Duration(seconds: 4),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight - 32.0,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Spacer(),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 32,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFFFFEEE8),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.contactless,
                            size: 56,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Tempelkan e-KTP di Belakang HP',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.nunito(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Posisikan chip e-KTP tepat pada area sensor NFC ponsel Anda.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            color: Color(0xFF475569),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Tips Pemindaian:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '• Lepaskan casing HP jika terlalu tebal.\n'
                          '• Tahan e-KTP dan jangan digerakkan saat memindai.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                    child: Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.accent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                          // 👉 Pengecekan NFC aktif dipicu saat tombol ditekan
                          onPressed: controller.isScanning.value
                              ? null
                              : () => _handleStartScanning(context),
                          onLongPress: () => controller.bypassScan(),
                          icon: controller.isScanning.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.wifi_tethering,
                                  color: Colors.white,
                                  size: 22,
                                ),
                          label: Text(
                            controller.isScanning.value
                                ? 'MENUNGGU KTP...'
                                : 'MULAI PEMINDAIAN',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}