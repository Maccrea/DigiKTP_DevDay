import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../nfc_scan_controller.dart';
import '../../../utils/custom_input_field.dart';

class CekWargaWidget extends GetView<NfcScanController> {
  const CekWargaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nikRegController = TextEditingController();
    final TextEditingController namaRegController = TextEditingController();
    final TextEditingController alamatRegController = TextEditingController();
    final TextEditingController emailRegController = TextEditingController();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
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
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: Color(0xFFD97706),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registrasi Warga Baru',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'UID NFC belum terdaftar di sistem.',
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
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.nfc, color: Color(0xFF030164), size: 18),
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

            CustomTextField(
              label: 'NIK Warga',
              hintText: 'Masukkan 16 digit NIK',
              prefixIcon: Icons.badge_outlined,
              controller: nikRegController,
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
              controller: namaRegController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Alamat Email',
              hintText: 'Untuk pengiriman otp',
              prefixIcon: Icons.email_outlined,
              controller: emailRegController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Alamat Sesuai e-KTP',
              hintText: 'Masukkan alamat domisili/KTP',
              prefixIcon: Icons.home_outlined,
              controller: alamatRegController,
              keyboardType: TextInputType.streetAddress,
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF030164),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  final cleanNik = nikRegController.text.trim();
                  final cleanNama = namaRegController.text.trim();
                  final cleanAlamat = alamatRegController.text.trim();
                  final emailAddress = emailRegController.text.trim();

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
                      : const Text(
                          'SIMPAN & LANJUTKAN',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
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
