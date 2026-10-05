import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';
import 'package:digiktp/app/theme/app_colors.dart';

class StepValidationWidget extends GetView<NfcScanController> {
  const StepValidationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedOption = controller.selectedContact;
    final customEmailController = controller.customEmailController;

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
                                  color: AppColors.primary,
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
                          'EMAIL WARGA',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Gunakan email yang tersimpan atau tambahkan email lain.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            height: 1.3,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Obx(() {
                          final emails = controller.registeredEmails;
                          final addEmailIndex = emails.length;
                          return Column(
                            children: [
                              for (final entry in emails.asMap().entries) ...[
                                if (entry.key > 0)
                                  const SizedBox(height: 10),
                                _buildContactRadioTile(
                                  index: entry.key,
                                  selectedIndex: selectedOption.value,
                                  title: entry.value,
                                  subtitle: 'Email terdaftar',
                                  onTap: () => selectedOption.value = entry.key,
                                ),
                              ],
                              if (emails.isNotEmpty)
                                const SizedBox(height: 10),
                              _buildContactRadioTile(
                                index: addEmailIndex,
                                selectedIndex: selectedOption.value,
                                title: 'Tambahkan email lain',
                                subtitle: 'Gunakan alamat email berbeda',
                                onTap: () => selectedOption.value = addEmailIndex,
                              ),
                              if (selectedOption.value == addEmailIndex)
                                Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: TextField(
                                    controller: customEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: 'nama@email.com',
                                      prefixIcon: Icon(Icons.email_outlined),
                                    ),
                                  ),
                                ),
                            ],
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
                          backgroundColor: AppColors.accent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () async {
                            if (controller.selectedContact.value ==
                              controller.registeredEmails.length &&
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
                                : Text(
                                  'Kirim OTP',
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w700,
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
          color: isSelected ? const Color(0xFFEAF0F8) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
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
                      ? AppColors.primary
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
