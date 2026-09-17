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
  
  // Selection & Form State
  final selectedContact = 0.obs;
  final isAgreed = false.obs;

  // Controllers untuk input OTP (6 Digit)
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

  // Bypass NFC untuk testing di emulator
  void bypassScan() {
    scannedUid.value = 'E004123456789A';
    currentStep.value = ScanStep.result;
  }

  // Menangani penekanan tombol Back HP
  bool handleBack() {
    switch (currentStep.value) {
      case ScanStep.success:
        return false; // Mencegah back setelah transaksi sukses
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
        return true; // Keluar dari halaman
    }
  }

  void startNfcSession() async {
  bool isAvailable = await NfcManager.instance.isAvailable();

  if (!isAvailable) {
    errorMessage.value = 'NFC tidak tersedia atau belum diaktifkan pada HP ini.';
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
        List<int> identifier = [];
        dynamic tagData = tag.data;

        try {
          if (tagData.id != null) {
            identifier = List<int>.from(tagData.id);
          }
        } catch (_) {}

        if (identifier.isEmpty) {
          try {
            identifier = List<int>.from(tagData.nfca.identifier);
          } catch (_) {}
        }

        if (identifier.isEmpty) {
          try {
            identifier = List<int>.from(tagData.isodep.identifier);
          } catch (_) {}
        }

        if (identifier.isEmpty) {
          try {
            identifier = List<int>.from(tagData.mifare.identifier);
          } catch (_) {}
        }

        if (identifier.isNotEmpty) {
          String uidString = identifier
              .map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase())
              .join(':');

          scannedUid.value = uidString;
          isScanning.value = false;
          await NfcManager.instance.stopSession();
          currentStep.value = ScanStep.result;
        } else {
          errorMessage.value = 'KTP terdeteksi, tetapi UID gagal diekstrak.';
          isScanning.value = false;
        }
      } catch (e) {
        errorMessage.value = 'Gagal membaca KTP: ${e.toString()}';
        isScanning.value = false;
      }
    },
  );
}
}