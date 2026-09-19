import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';

enum ScanStep {
  prompt,       // Step 1: Scan e-KTP
  result,       // Step 2: Hasil Pembacaan NFC
  validation,   // Step 3: Validasi Warga (Pilih Kontak)
  sendOtp,      // Step 4: Kirim Kode OTP
  inputOtp,     // Step 5: Autentikasi OTP (Input Kode)
  confirmation, // Step 6: Konfirmasi Pengajuan
  success       // Step 7: Transaksi Berhasil
}

class NfcScanController extends GetxController {
  final currentStep = ScanStep.prompt.obs;
  final isScanning = false.obs;
  final scannedUid = ''.obs;
  final errorMessage = ''.obs;
  
  final selectedContact = 0.obs;
  final isAgreed = false.obs;

  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  @override
  void onClose() {
    NfcManager.instance.stopSession();
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
    super.onClose();
  }

  void goToStep(ScanStep step) {
    currentStep.value = step;
  }

  void bypassScan() {
    scannedUid.value = 'E004123456789A';
    currentStep.value = ScanStep.result;
  }

  bool handleBack() {
    switch (currentStep.value) {
      case ScanStep.success:
        return false; 
      case ScanStep.confirmation:
        currentStep.value = ScanStep.inputOtp;
        return false;
      case ScanStep.inputOtp:
        currentStep.value = ScanStep.sendOtp;
        return false;
      case ScanStep.sendOtp:
        currentStep.value = ScanStep.validation;
        return false;
      case ScanStep.validation:
        currentStep.value = ScanStep.result;
        return false;
      case ScanStep.result:
        currentStep.value = ScanStep.prompt;
        return false;
      case ScanStep.prompt:
        return true;
    }
  }

  void startNfcSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (!isAvailable) {
      errorMessage.value = 'Perangkat tidak mendukung atau belum mengaktifkan NFC.';
      return;
    }

    isScanning.value = true;
    errorMessage.value = '';

    NfcManager.instance.startSession(
      pollingOptions: {
        NfcPollingOption.iso14443,
        NfcPollingOption.iso15693,
        NfcPollingOption.iso18092,
      },
      onDiscovered: (NfcTag tag) async {
        try {
          List<int>? identifier;
          final tagData = Map<String, dynamic>.from(tag.data as Map);

          if (tagData.containsKey('isodep') && tagData['isodep'] is Map) {
            identifier = List<int>.from((tagData['isodep'] as Map)['identifier'] ?? []);
          } else if (tagData.containsKey('nfca') && tagData['nfca'] is Map) {
            identifier = List<int>.from((tagData['nfca'] as Map)['identifier'] ?? []);
          }

          if (identifier != null && identifier.isNotEmpty) {
            scannedUid.value = identifier
                .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
                .join(':');
            isScanning.value = false;
            NfcManager.instance.stopSession();
            currentStep.value = ScanStep.result;
          } else {
            errorMessage.value = 'Kartu NFC tidak memiliki ID yang valid.';
            isScanning.value = false;
          }
        } catch (e) {
          errorMessage.value = 'Gagal membaca kartu: ${e.toString()}';
          isScanning.value = false;
        }
      },
    );
  }
}