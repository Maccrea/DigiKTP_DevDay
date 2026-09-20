import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digiktp/app/data/services/auth_service.dart';
import 'package:digiktp/app/routes/app_routes.dart';
import 'package:nfc_manager/nfc_manager.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final isNfcActive = false.obs;
  final nipController = TextEditingController();
  final passwordController = TextEditingController();
  
  final listInstansi = ['Kementerian Dalam Negeri', 'KPU Pusat', 'Bawaslu'].obs;
  final selectedInstansi = ''.obs;
  final selectedWilayah = 'Jakarta Pusat'.obs;
  final selectedPosko = 'Posko Layanan Kelurahan Gambir'.obs;
  final selectedShift = 'Shift 1 — Pagi (08:00 - 15:00)'.obs;

  final isLoading = false.obs;

  final passwordStrength = 0.0.obs;
  final passwordStrengthText = ''.obs;
  final passwordStrengthColor = Colors.grey.obs;

  @override
  void onInit() {
    super.onInit();
    if (listInstansi.isNotEmpty) {
      selectedInstansi.value = listInstansi.first;
    }
    checkNfcStatus();
  }

  @override
  void onClose() {
    nipController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> checkNfcStatus() async {
  try {
    bool isAvailable = await NfcManager.instance.isAvailable();
    isNfcActive.value = isAvailable;
  } catch (e) {
    isNfcActive.value = false;
  }
}
  Future<void> submitLogin() async {
    if (nipController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar('Peringatan', 'NIP dan Kata Sandi harus diisi!');
      return;
    }

    isLoading.value = true;
    
    await Future.delayed(const Duration(seconds: 2)); 
    
    isLoading.value = false;
    goToSetPosko();
  }

  Future<void> submitLoginAndPosko() async {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success = await _authService.login(
      nip: nipController.text.trim(),
      password: passwordController.text.trim(),
      idInstansi: selectedInstansi.value,
      poskoLocation: selectedPosko.value,
    );

    Get.back(); 

    if (success) {
      Get.offAllNamed(Routes.DASHBOARD);
    }
  }



  void checkPasswordStrength(String password) {
    if (password.isEmpty) {
      passwordStrength.value = 0.0;
      passwordStrengthText.value = '';
      return;
    }

    double strength = 0;
    if (password.length >= 8) strength += 0.25; 
    if (password.contains(RegExp(r'[A-Z]'))) strength += 0.25; 
    if (password.contains(RegExp(r'[0-9]'))) strength += 0.25; 
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) strength += 0.25; 

    passwordStrength.value = strength;

    if (strength <= 0.25) {
      passwordStrengthText.value = 'Lemah';
      passwordStrengthColor.value = Colors.red;
    } else if (strength <= 0.75) {
      passwordStrengthText.value = 'Sedang';
      passwordStrengthColor.value = Colors.orange;
    } else {
      passwordStrengthText.value = 'Kuat';
      passwordStrengthColor.value = Colors.green;
    }
  }

  void goToSetPosko() {
    if (nipController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.rawSnackbar(
        messageText: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.info_outline_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'NIP dan Kata Sandi wajib diisi.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1E293B),
        borderRadius: 30, 
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
      return;
    }

    Get.toNamed(Routes.SWITCH_POSKO);
  }

  Future<void> contactAdmin() async {
    final String subject = Uri.encodeComponent('Lupa Kata Sandi Petugas - DigiKTP');
    final String body = Uri.encodeComponent(
        'Halo Admin,\n\nSaya lupa kata sandi untuk akun saya. Berikut detail saya:\nNIP: ${nipController.text}\nInstansi: ${selectedInstansi.value}\n\nMohon bantuannya untuk mereset kata sandi saya.');
    
    final Uri emailLaunchUri = Uri.parse('mailto:admin@digiktp.go.id?subject=$subject&body=$body');

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      Get.rawSnackbar(
        messageText: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 16),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Tidak dapat membuka aplikasi email.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF1E293B), 
        borderRadius: 30,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        duration: const Duration(seconds: 3),
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );
    }
  }
}