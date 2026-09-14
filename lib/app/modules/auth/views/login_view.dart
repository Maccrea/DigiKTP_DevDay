import 'package:digiktp/app/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_input_field.dart';
import '../../../theme/app_colors.dart';

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Autentikasi Petugas',
        showBackButton: true,
        showInfoButton: true,
        onInfoTap: () {
          // Bantuan / Info BottomSheet
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset('assets/icons/flag_id.png', width: 18, errorBuilder: (_, __, ___) => const Icon(Icons.flag, size: 16, color: Colors.red)),
                const SizedBox(width: 6),
                const Text(
                  'KEMENTERIAN DALAM NEGERI - RI',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            const Text(
              'Masuk Akun DigiKTP',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Silakan masukkan NIP resmi dan kata sandi Anda untuk mengakses pembaca NFC kartu e-KTP.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
            ),
            const SizedBox(height: 24),

            CustomTextField(
              label: 'NIP Petugas',
              hintText: 'Contoh: 199408122020121002',
              prefixIcon: Icons.person_outline,
              controller: controller.nipController,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              label: 'Kata Sandi',
              hintText: 'Masukkan kata sandi akun',
              prefixIcon: Icons.lock_outline,
              isPassword: true,
              controller: controller.passwordController,
            ),
            const SizedBox(height: 16),

            Obx(() => CustomDropdownField<String>(
              label: 'Instansi Induk',
              hintText: 'Pilih Instansi',
              prefixIcon: Icons.apartment_outlined,
              value: controller.selectedInstansi.value.isEmpty ? null : controller.selectedInstansi.value,
              items: controller.listInstansi.map((instansi) {
                return DropdownMenuItem(
                  value: instansi,
                  child: Text(instansi),
                );
              }).toList(),
              onChanged: (val) => controller.selectedInstansi.value = val ?? '',
            )),
            const SizedBox(height: 28),

            ElevatedButton(
              onPressed: () => controller.goToSetPosko(),
              child: const Text('MASUK & ATUR LOKASI'),
            ),
            const SizedBox(height: 16),

            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Lupa Kata Sandi Petugas?',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
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