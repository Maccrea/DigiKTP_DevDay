import 'package:digiktp/app/data/services/auth_service.dart';
import 'package:digiktp/app/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();

  final nipController = TextEditingController();
  final passwordController = TextEditingController();

  final selectedInstansi = ''.obs;
  final selectedWilayah = 'Jakarta Pusat'.obs;
  final selectedPosko = 'Posko Layanan Kelurahan Gambir'.obs;
  final selectedShift = 'Shift 1 — Pagi (08:00 - 15:00)'.obs;

  final listInstansi = <String>[
    'Dinas Kependudukan & Pencatatan Sipil',
    'BPJS Kesehatan',
    'Dinas Sosial',
    'RSUD Tarakan',
  ].obs;

  @override
  void onInit() {
    super.onInit();
    if (listInstansi.isNotEmpty) {
      selectedInstansi.value = listInstansi.first;
    }
  }

  @override
  void onClose() {
    nipController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void goToSetPosko() {
    if (nipController.text.trim().isEmpty || passwordController.text.trim().isEmpty) {
      Get.snackbar(
        'Peringatan',
        'NIP dan Kata Sandi wajib diisi!',
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
      return;
    }

    Get.toNamed(Routes.SWITCH_POSKO);
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
}