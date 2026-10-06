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
      physics: const BouncingScrollPhysics(),
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
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.badge_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registrasi Warga',
                        style: GoogleFonts.nunito(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Pindai fisik e-KTP untuk auto-fill data.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Obx(() {
              final photo = controller.capturedKtpPhoto;
              final isReading = controller.isReadingKtp.value;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (photo != null) ...[
                    KtpPhotoPreview(path: photo.path, height: 180),
                    const SizedBox(height: 12),
                  ] else ...[
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: const Color(0xFFCBD5E1),
                          style: BorderStyle.solid,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.document_scanner_outlined, size: 42, color: Color(0xFF94A3B8)),
                            const SizedBox(height: 10),
                            Text(
                              'Area Pemindaian KTP',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: photo == null ? AppColors.primary : Colors.white,
                      foregroundColor: photo == null ? Colors.white : AppColors.primary,
                      minimumSize: const Size.fromHeight(50),
                      elevation: 0,
                      side: photo != null ? const BorderSide(color: AppColors.primary) : null,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: isReading ? null : controller.captureAndReadKtp,
                    icon: isReading
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : Icon(photo == null ? Icons.camera_alt_rounded : Icons.refresh_rounded),
                    label: Text(
                      isReading
                          ? 'Menganalisis Data...'
                          : photo == null
                          ? 'Mulai Pemindaian OCR'
                          : 'Pindai Ulang KTP',
                      style: GoogleFonts.inter(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 24),
            
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 20),

            CustomTextField(
              label: 'NIK Warga',
              hintText: '16 digit angka',
              prefixIcon: Icons.pin_outlined,
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
              hintText: 'Sesuai KTP',
              prefixIcon: Icons.person_outline,
              controller: controller.newNameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),
            CustomTextField(
              label: 'Email Verifikasi',
              hintText: 'Untuk pengiriman OTP',
              prefixIcon: Icons.alternate_email_rounded,
              controller: controller.newEmailController,
              keyboardType: TextInputType.emailAddress,
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
                  final formData = {
                    "uid_nfc": controller.activeNfcUid,
                    "nik": controller.newNikController.text.trim(),
                    "nama_lengkap": controller.newNameController.text.trim(),
                    "email": controller.newEmailController.text.trim(),
                  };
                  controller.submitRegistrasiWarga(formData);
                },
                child: Obx(
                  () => controller.isLoading.value
                      ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                      : Text(
                          'Simpan & Lanjutkan',
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
      ),
    );
  }
}