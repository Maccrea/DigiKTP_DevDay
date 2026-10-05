import 'package:digiktp/app/modules/auth/auth_controller.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:digiktp/app/utils/custom_app_bar.dart';
import 'package:digiktp/app/utils/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Masuk',
        showBackButton: true,
        showInfoButton: true,
        onInfoTap: _showAppInfo,
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFEEE8),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.contactless_rounded,
                      color: AppColors.accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'NIKita',
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Layanan warga, lebih dekat',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 26),
              Text(
                'Masuk sebagai petugas',
                style: GoogleFonts.nunito(
                  color: AppColors.textPrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Akses layanan kependudukan dengan akun Anda.',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: AppColors.border),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0C193A56),
                      blurRadius: 14,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
              CustomTextField(
                label: 'NIP Petugas',
                hintText: 'Contoh: 19940812',
                prefixIcon: Icons.person_outline_rounded,
                controller: controller.nipController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              const SizedBox(height: 18),
              CustomTextField(
                label: 'Kata Sandi',
                hintText: 'Masukkan kata sandi',
                prefixIcon: Icons.lock_outline_rounded,
                isPassword: true,
                controller: controller.passwordController,
                onChanged: controller.checkPasswordStrength,
              ),
              const SizedBox(height: 10),
              Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: controller.passwordStrength.value,
                        color: controller.passwordStrengthColor.value,
                        backgroundColor: AppColors.border,
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Keamanan kata sandi',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          controller.passwordStrengthText.value.isEmpty
                              ? 'Belum diisi'
                              : controller.passwordStrengthText.value,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: controller.passwordStrengthColor.value,
                          ),
                        ),
                      ],
                    ),
                    if (controller.password.value.isNotEmpty &&
                        controller.passwordStrength.value < 1) ...[
                      const SizedBox(height: 6),
                      Text(
                        controller.passwordHint.value,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Obx(
                () => CustomDropdownField<String>(
                  label: 'Instansi Induk',
                  hintText: 'Pilih instansi',
                  prefixIcon: Icons.apartment_outlined,
                  value: controller.selectedInstansi.value.isEmpty
                      ? null
                      : controller.selectedInstansi.value,
                  items: controller.listInstansi
                      .map(
                        (instansi) => DropdownMenuItem(
                          value: instansi,
                          child: Text(instansi),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    controller.selectedInstansi.value = value ?? '';
                  },
                ),
              ),
                  ],
                ),
              ),
              const SizedBox(height: 22),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: Obx(
                  () => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : controller.goToSetPosko,
                    child: controller.isLoading.value
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Lanjut pilih posko'),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: controller.contactAdmin,
                  child: Text(
                    'Butuh bantuan masuk?',
                    style: GoogleFonts.inter(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppInfo() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tentang NIKita',
              style: GoogleFonts.nunito(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'NIKita membantu petugas memverifikasi e-KTP melalui NFC dan memproses layanan warga.',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: Get.back,
                child: const Text('Mengerti'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}