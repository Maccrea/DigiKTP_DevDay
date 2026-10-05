import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import '../nfc_scan_controller.dart';
import '../../../utils/custom_input_field.dart';
import 'ktp_photo_preview.dart';

class CekWargaWidget extends GetView<NfcScanController> {
  const CekWargaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Container(
        padding: const EdgeInsets.all(20),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEEE8),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data warga baru',
                        style: GoogleFonts.nunito(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Foto e-KTP untuk isi data otomatis.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.nfc, color: AppColors.primary, size: 18),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'UID: ${controller.activeNfcUid}',
                      style: const TextStyle(
                        fontFamily: 'Monospace',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Obx(() {
              final photo = controller.capturedKtpPhoto;
              final isReading = controller.isReadingKtp.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (photo != null) ...[
                    KtpPhotoPreview(path: photo.path, height: 150),
                    const SizedBox(height: 10),
                  ],
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isReading ? null : controller.captureAndReadKtp,
                    icon: isReading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.document_scanner_outlined),
                    label: Text(
                      isReading
                          ? 'Membaca e-KTP...'
                          : photo == null
                          ? 'Foto & baca e-KTP'
                          : 'Ambil ulang foto',
                    ),
                  ),
                  if (photo != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 7),
                      child: Text(
                        'Periksa lagi data hasil baca sebelum disimpan.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ),
                ],
              );
            }),
            const SizedBox(height: 18),

            CustomTextField(
              label: 'NIK Warga',
              hintText: 'Masukkan 16 digit NIK',
              prefixIcon: Icons.badge_outlined,
              controller: controller.newNikController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Nama Lengkap',
              hintText: 'Sesuai e-KTP',
              prefixIcon: Icons.person_outline,
              controller: controller.newNameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Alamat Email',
              hintText: 'Untuk pengiriman otp',
              prefixIcon: Icons.email_outlined,
              controller: controller.newEmailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Alamat Sesuai e-KTP',
              hintText: 'Masukkan alamat domisili/KTP',
              prefixIcon: Icons.home_outlined,
              controller: controller.newAddressController,
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                    final cleanNik = controller.newNikController.text.trim();
                    final cleanNama = controller.newNameController.text.trim();
                    final cleanAlamat =
                      controller.newAddressController.text.trim();
                    final emailAddress =
                      controller.newEmailController.text.trim();

                  if (cleanNik.length != 16 ||
                      cleanNama.isEmpty ||
                      emailAddress.isEmpty) {
                    Get.snackbar(
                      'Peringatan',
                      'Pastikan NIK (16 digit), Nama Lengkap, dan Email terisi.',
                      snackPosition: SnackPosition.TOP,
                      backgroundColor: const Color(0xFFEF4444),
                      colorText: Colors.white,
                    );
                    return;
                  }

                  final formData = {
                    "uid_nfc": controller.activeNfcUid,
                    "nik": cleanNik,
                    "nama_lengkap": cleanNama,
                    "email": emailAddress,
                  };

                  if (cleanAlamat.isNotEmpty) {
                    formData["alamat"] = cleanAlamat;
                  }

                  controller.submitRegistrasiWarga(formData);
                },
                child: Obx(
                  () => controller.isLoading.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : Text(
                          'Simpan & lanjutkan',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
