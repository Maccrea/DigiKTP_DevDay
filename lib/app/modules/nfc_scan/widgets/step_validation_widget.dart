import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';

class StepValidationWidget extends GetView<NfcScanController> {
  const StepValidationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final RxInt selectedOption = 0.obs;
    final TextEditingController customEmailController = TextEditingController();

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
                  const SizedBox(height: 8),

                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'BIODATA WARGA TERKAIT',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const Divider(height: 20, color: Color(0xFFF1F5F9)),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                width: 54,
                                height: 64,
                                color: const Color(0xFFEFF6FF),
                                child: const Icon(
                                  Icons.person_rounded,
                                  color: Color(0xFF030164),
                                  size: 38,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller
                                            .verifiedWargaData['nama_masking'] ??
                                        'Nama warga',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'NIK: ${controller.verifiedWargaData['nik'] ?? '-'}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Color(0xFF475569),
                                      fontFamily: 'Monospace',
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    '${controller.verifiedWargaData['wilayah'] ?? '-'} • ${controller.verifiedWargaData['phone_last_digits'] ?? '-'}',
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PILIH ALAMAT EMAIL / KONTAK AKTIF',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Kode OTP verifikasi akan dikirimkan ke salah satu kontak terdaftar di bawah ini.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Obx(
                          () => _buildContactRadioTile(
                            index: 0,
                            selectedIndex: selectedOption.value,
                            title: 'macreynardosan@gmail.com',
                            subtitle: 'Email Utama Dukcapil',
                            onTap: () => selectedOption.value = 0,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Obx(
                          () => _buildContactRadioTile(
                            index: 1,
                            selectedIndex: selectedOption.value,
                            title: 'alyaaranaraya@gmail.com',
                            subtitle: 'Email Cadangan Terverifikasi',
                            onTap: () => selectedOption.value = 1,
                          ),
                        ),
                        const SizedBox(height: 10),

                        Obx(
                          () => _buildContactRadioTile(
                            index: 2,
                            selectedIndex: selectedOption.value,
                            title: 'Gunakan Alamat Email Lain',
                            subtitle: 'Kirim OTP ke email baru',
                            onTap: () => selectedOption.value = 2,
                          ),
                        ),

                        Obx(() {
                          if (selectedOption.value != 2)
                            return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: TextField(
                              controller: customEmailController,
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF0F172A),
                              ),
                              decoration: InputDecoration(
                                hintText: 'Masukkan email aktif...',
                                hintStyle: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 13,
                                ),
                                prefixIcon: const Icon(
                                  Icons.email_outlined,
                                  color: Color(0xFF64748B),
                                  size: 18,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF8FAFC),
                                contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                  horizontal: 14,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFCBD5E1),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE2E8F0),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF030164),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Padding(
                    padding: const EdgeInsets.only(top: 16.0, bottom: 8.0),
                    child: SizedBox(
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
                        onPressed: () async {
                          if (controller.selectedContact.value == 2 &&
                              !controller.isEmailValid) {
                            Get.snackbar(
                              'Peringatan',
                              'Masukkan format email aktif yang valid.',
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: const Color(0xFFEF4444),
                              colorText: Colors.white,
                            );
                            return;
                          }

                          await controller.requestOtpApi(
                            controller.selectedContact.value,
                          );
                        },
                        child: Obx(
                          () => controller.isLoading.value
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'KIRIM OTP',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
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

  Widget _buildContactRadioTile({
    required int index,
    required int selectedIndex,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    final isSelected = index == selectedIndex;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF030164)
                : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF030164)
                      : const Color(0xFF94A3B8),
                  width: isSelected ? 5.5 : 1.5,
                ),
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: isSelected
                          ? const Color(0xFF1E40AF)
                          : const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
