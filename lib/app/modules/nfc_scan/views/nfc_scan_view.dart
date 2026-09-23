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
import '../widgets/cek_warga_widget.dart';

class NfcScanView extends GetView<NfcScanController> {
  const NfcScanView({Key? key}) : super(key: key);

  String _getStepTitle(ScanStep step) {
    switch (step) {
      case ScanStep.cekWarga:
        return 'Verifikasi NIK Warga';
      case ScanStep.prompt:
        return 'Pemindaian e-KTP';
      case ScanStep.result:
        return 'Hasil Pembacaan NFC';
      case ScanStep.validation:
        return 'Validasi Data Warga';
      case ScanStep.sendOtp:
        return 'Pengiriman Kode OTP';
      case ScanStep.inputOtp:
        return 'Verifikasi Kode OTP';
      case ScanStep.confirmation:
        return 'Konfirmasi Pengajuan';
      case ScanStep.success:
        return 'Registrasi Berhasil';
    }
  }

  int _getStepPhaseIndex(ScanStep step) {
    switch (step) {
      case ScanStep.prompt:
        return 0;
      case ScanStep.result:
      case ScanStep.cekWarga:
        return 1;
      case ScanStep.validation:
        return 2;
      case ScanStep.sendOtp:
      case ScanStep.inputOtp:
        return 3;
      case ScanStep.confirmation:
      case ScanStep.success:
        return 4;
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
        backgroundColor: const Color(0xFFF1F5F9),
        body: Column(
          children: [
            Obx(() {
              if (controller.currentStep.value == ScanStep.success) {
                return const SizedBox.shrink();
              }
              return _buildPremiumFlowHeader(controller.currentStep.value);
            }),
            Expanded(
              child: Obx(() {
                switch (controller.currentStep.value) {
                  case ScanStep.cekWarga:
                    return const CekWargaWidget();
                  case ScanStep.prompt:
                    return const PromptWidget();
                  case ScanStep.result:
                    return const StepResultWidget();
                  case ScanStep.validation:
                    return const StepValidationWidget();
                  case ScanStep.sendOtp:
                    return const SendOtpWidget();
                  case ScanStep.inputOtp:
                    return const InputOtpWidget();
                  case ScanStep.confirmation:
                    return const ConfirmationWidget();
                  case ScanStep.success:
                    return const SuccessWidget();
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumFlowHeader(ScanStep currentStep) {
    final currentPhase = _getStepPhaseIndex(currentStep);
    const totalPhases = 5;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'LANGKAH ${currentPhase + 1} DARI $totalPhases',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF030164),
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              Text(
                _getStepTitle(currentStep),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 28),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(totalPhases * 2 - 1, (i) {
                  if (i.isEven) {
                    final index = i ~/ 2;
                    final isCompleted = index < currentPhase;
                    final isActive = index == currentPhase;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOutCubic,
                      width: isActive ? 36 : 28,
                      height: isActive ? 36 : 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted
                            ? const Color(0xFF10B981)
                            : (isActive
                                  ? const Color(0xFF030164)
                                  : const Color(0xFFF1F5F9)),
                        border: isActive
                            ? Border.all(
                                color: const Color(0xFFDBEAFE),
                                width: 4,
                              )
                            : Border.all(
                                color: isCompleted
                                    ? const Color(0xFF10B981)
                                    : const Color(0xFFCBD5E1),
                                width: 1.5,
                              ),
                        boxShadow: isActive
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xFF030164,
                                  ).withOpacity(0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? const Icon(
                                Icons.check_rounded,
                                size: 16,
                                color: Colors.white,
                              )
                            : Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontSize: isActive ? 13 : 11,
                                  fontWeight: FontWeight.bold,
                                  color: isActive
                                      ? Colors.white
                                      : const Color(0xFF64748B),
                                ),
                              ),
                      ),
                    );
                  }

                  final lineIndex = i ~/ 2;
                  final isLineCompleted = lineIndex < currentPhase;

                  return Expanded(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 3,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: isLineCompleted
                            ? const Color(0xFF10B981)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
