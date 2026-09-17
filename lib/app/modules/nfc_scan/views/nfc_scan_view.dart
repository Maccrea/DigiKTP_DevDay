import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';
import '../widgets/step_prompt_widget.dart';
import '../widgets/step_result_widget.dart';
import '../widgets/step_validation_widget.dart';
import '../widgets/send_otp_widget.dart';
import '../widgets/input_otp_widget.dart';
import '../widgets/confirmation_widget.dart';
import '../widgets/success_widget.dart';

class NfcScanView extends GetView<NfcScanController> {
  const NfcScanView({Key? key}) : super(key: key);

  String _getAppBarTitle(ScanStep step) {
    switch (step) {
      case ScanStep.prompt: return 'Pemindaian e-KTP';
      case ScanStep.result: return 'Hasil Pembacaan NFC';
      case ScanStep.validation: return 'Validasi Warga';
      case ScanStep.sendOtp: return 'Kirim Kode OTP';
      case ScanStep.inputOtp: return 'Autentikasi OTP';
      case ScanStep.confirmation: return 'Konfirmasi Pengajuan';
      case ScanStep.success: return 'Transaksi Berhasil';
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        final shouldPop = controller.handleBack();
        if (shouldPop) Get.back();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF4F6F9),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Obx(() => controller.currentStep.value == ScanStep.success
              ? const SizedBox.shrink()
              : IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    final shouldPop = controller.handleBack();
                    if (shouldPop) Get.back();
                  },
                )),
          title: Obx(() => Text(
            _getAppBarTitle(controller.currentStep.value),
            style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18),
          )),
          centerTitle: true,
        ),
        body: Obx(() {
          switch (controller.currentStep.value) {
            case ScanStep.prompt: return const PromptWidget();
            case ScanStep.result: return const StepResultWidget();
            case ScanStep.validation: return const StepValidationWidget();
            case ScanStep.sendOtp: return const SendOtpWidget();
            case ScanStep.inputOtp: return const InputOtpWidget();
            case ScanStep.confirmation: return const ConfirmationWidget();
            case ScanStep.success: return const SuccessWidget();
          }
        }),
      ),
    );
  }
}