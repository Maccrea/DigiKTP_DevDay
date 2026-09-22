import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:digiktp/app/data/services/auth_service.dart';
import 'package:digiktp/app/routes/app_routes.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:digiktp/app/utils/app_snackbar.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final password = ''.obs;
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



  final passwordHint = 'Gunakan minimal 8 karakter dengan kombinasi huruf besar, angka, dan simbol.'.obs;

void checkPasswordStrength(String value) {
  password.value = value;
  
  if (value.isEmpty) {
    passwordStrength.value = 0.0;
    passwordStrengthText.value = '';
    passwordStrengthColor.value = Colors.grey;
    passwordHint.value = 'Gunakan minimal 8 karakter dengan kombinasi huruf besar, angka, dan simbol.';
    return;
  }

  bool hasLength = value.length >= 8;
  bool hasUpper = value.contains(RegExp(r'[A-Z]'));
  bool hasDigit = value.contains(RegExp(r'[0-9]'));
  bool hasSpecial = value.contains(RegExp(r'[!@#$%^&*(),.?":{}[\]|<>]'));

  double strength = 0;
  if (hasLength) strength += 0.25; 
  if (hasUpper) strength += 0.25; 
  if (hasDigit) strength += 0.25; 
  if (hasSpecial) strength += 0.25; 

  passwordStrength.value = strength;

  List<String> missingRequirements = [];
  if (!hasLength) missingRequirements.add('minimal 8 karakter');
  if (!hasUpper) missingRequirements.add('huruf besar');
  if (!hasDigit) missingRequirements.add('angka');
  if (!hasSpecial) missingRequirements.add('simbol khusus');

  if (strength <= 0.25) {
    passwordStrengthText.value = 'Lemah';
    passwordStrengthColor.value = Colors.red;
    passwordHint.value = '⚠️ Keamanan rendah. Harap tambahkan: ${missingRequirements.join(', ')}.';
  } else if (strength <= 0.75) {
    passwordStrengthText.value = 'Sedang';
    passwordStrengthColor.value = Colors.orange;
    passwordHint.value = '⚠️ Hampir memenuhi standar. Kurang: ${missingRequirements.join(', ')}.';
  } else {
    passwordStrengthText.value = 'Kuat';
    passwordStrengthColor.value = Colors.green;
    passwordHint.value = '✔ Kata sandi telah memenuhi standar keamanan sistem.';
  }
}

  void goToSetPosko() {
    if (nipController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      AppSnackbar.show(message : 'NIP dan Kata Sandi wajib diisi.');
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
      AppSnackbar.show(
        message : 'Tidak dapat membuka aplikasi email.',
        icon: Icons.warning_amber_rounded,
      );
    }
  }
}