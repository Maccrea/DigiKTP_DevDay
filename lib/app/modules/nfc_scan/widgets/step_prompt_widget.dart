import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:digiktp/app/theme/app_colors.dart';

class PromptWidget extends GetView<NfcScanController> {
  const PromptWidget({Key? key}) : super(key: key);

  Future<void> _handleStartScanning(BuildContext context) async {
    try {
      bool isAvailable = await NfcManager.instance.isAvailable();
      if (!isAvailable) {
        Get.snackbar(
          'Perangkat Tidak Didukung',
          'Smartphone Anda tidak memiliki sensor NFC aktif.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
        );
        return;
      }
      if (controller.isScanning.value) return;
      controller.startNfcSession();
    } catch (e) {
      Get.snackbar(
        'NFC Belum Aktif',
        'Harap aktifkan fitur NFC di pengaturan perangkat Anda.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFD97706),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
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
                  child: const Icon(Icons.contactless_rounded, size: 56, color: AppColors.accent),
                ),
                const SizedBox(height: 20),
                Text(
                  'Tempelkan e-KTP',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posisikan chip e-KTP tepat pada area sensor NFC di bagian belakang ponsel Anda.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    color: const Color(0xFF64748B),
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tips Pemindaian:',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '• Lepaskan casing HP jika terlalu tebal.\n'
                  '• Tahan e-KTP dan jangan digerakkan saat memindai.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                onPressed: controller.isScanning.value ? null : () => _handleStartScanning(context),
                onLongPress: () => controller.bypassScan(),
                icon: controller.isScanning.value
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                    : const Icon(Icons.wifi_tethering_rounded, color: Colors.white, size: 22),
                label: Text(
                  controller.isScanning.value ? 'MENUNGGU KTP...' : 'MULAI PEMINDAIAN',
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}