import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';

import '../../data/providers/api_provider.dart';
import 'package:digiktp/app/utils/app_snackbar.dart';

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
  final ApiProvider _apiProvider = Get.put(ApiProvider());

  RxList<Map<String, dynamic>> dashboardActivities = <Map<String, dynamic>>[].obs;
  final currentStep = ScanStep.prompt.obs;
  final isScanning = false.obs;
  final scannedUid = ''.obs;
  final errorMessage = ''.obs;
  
  final selectedContact = 0.obs;
  final TextEditingController customEmailController = TextEditingController();
  
  final isLoading = false.obs;
  final isAgreed = false.obs;

  final targetedEmail = ''.obs;

  RxMap<String, dynamic> verifiedWargaData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> logData = <String, dynamic>{}.obs;

  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  final RxInt countdown = 60.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;
  String? _otpNfcUid;
  DateTime? _lastOtpRequestedAt;

  bool get hasValidOtpSession {
    if (_otpNfcUid == null || _otpNfcUid!.trim().isEmpty || _lastOtpRequestedAt == null) {
      return false;
    }

    final nowUtc = DateTime.now().toUtc();
    final requestedAtUtc = _lastOtpRequestedAt!.toUtc();
    final elapsed = nowUtc.difference(requestedAtUtc);
    return elapsed < const Duration(minutes: 2);
  }

  String get activeNfcUid {
    final current = (scannedUid.value.isNotEmpty ? scannedUid.value : (_otpNfcUid ?? '')).trim();

    if (current.isNotEmpty) {
      _otpNfcUid = current;
      scannedUid.value = current;
    }

    return current;
  }

  void syncNfcUid(String uid) {
    final cleanUid = uid.trim();
    if (cleanUid.isEmpty) return;

    scannedUid.value = cleanUid;
    _otpNfcUid = cleanUid;
  }

  bool get isEmailValid {
    if (selectedContact.value == 0 || selectedContact.value == 1) return true;
    if (selectedContact.value == 2) {
      final text = customEmailController.text.trim();
      return text.isNotEmpty && text.contains('@') && text.contains('.');
    }
    return false;
  }

  @override
  void onInit() {
    super.onInit();
    customEmailController.addListener(() {
      update();
    });
  }

  void startOtpTimer() {
    countdown.value = 60;
    canResend.value = false;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void resendOtp() {
    if (!canResend.value) return;

    clearOtpInput();
    requestOtpApi(selectedContact.value);
  }

  @override
  void onClose() {
    _timer?.cancel();
    NfcManager.instance.stopSession();
    customEmailController.dispose();

    for (final c in otpControllers) {
      c.dispose();
    }
    for (final f in otpFocusNodes) {
      f.dispose();
    }

    super.onClose();
  }

  void goToStep(ScanStep step) {
    currentStep.value = step;
  }

  void bypassScan() {
    syncNfcUid('0E:27:12:10:40:6F:33');
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
        clearOtpInput();
        currentStep.value = ScanStep.sendOtp;
        return false;
      case ScanStep.sendOtp:
        clearOtpInput();
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

  Future<void> requestOtpApi(int selectedOptionIndex) async {
    try {
      isLoading.value = true;
      update();

      String targetEmail = '';
      if (selectedOptionIndex == 0) {
        targetEmail = 'macreynardosan@gmail.com';
      } else if (selectedOptionIndex == 1) {
        targetEmail = 'alyaaranaraya@gmail.com';
      } else {
        targetEmail = customEmailController.text.trim();
      }

      targetedEmail.value = targetEmail;

      final nfcUid = activeNfcUid;
      if (nfcUid.isEmpty) {
        throw Exception('UID NFC belum tersedia. Silakan scan e-KTP terlebih dahulu.');
      }

      await _apiProvider.generateOtp(
        nfcUid: nfcUid,
        email: targetEmail,
      );

      _otpNfcUid = nfcUid;
      _lastOtpRequestedAt = DateTime.now().toUtc();
      scannedUid.value = nfcUid;
      clearOtpInput();
      currentStep.value = ScanStep.sendOtp;
      startOtpTimer();
    } catch (e) {
      final errorMessage = e.toString().replaceAll('Exception: ', '');
      AppSnackbar.show(
        message: errorMessage,
        icon: Icons.warning_amber_rounded,
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> verifyOtpApi() async {
    final enteredOtp = otpControllers.map((c) => c.text.trim()).join();
    final nfcUid = activeNfcUid;

    if (nfcUid.trim().isEmpty) {
      Get.snackbar(
        'Peringatan',
        'UID NFC belum tersedia. Silakan scan e-KTP lagi.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (!hasValidOtpSession) {
      Get.snackbar(
        'Peringatan',
        'Sesi OTP sudah kadaluarsa. Silakan kirim OTP baru.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (enteredOtp.length != 6) {
      Get.snackbar(
        'Peringatan',
        'Masukkan 6 digit kode OTP secara lengkap.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      isLoading.value = true;
      update();

      final responseData = await _apiProvider.verifyOtp(
        nfcUid: nfcUid,
        otpCode: enteredOtp,
        idPetugas: 'PTG-001',
        idInstansi: 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11',
        lokasiTugas: 'Kantor Cabang Pemuda',
        jenisLayanan: 'Pendaftaran Layanan Kesehatan',
      );

      final warga = responseData['warga'] ?? {};
      final log = responseData['log'] ?? {};

      if (warga.isNotEmpty) {
        verifiedWargaData.value = Map<String, dynamic>.from(warga);
      }
      if (log.isNotEmpty) {
        logData.value = Map<String, dynamic>.from(log);
      }

      final Map<String, dynamic> mappedActivityItem = {
        'log_id': log['id'] ?? 'UUID-UNKNOWN',
        'name': warga['nama_lengkap'] ?? 'Tanpa Nama',
        'nik': warga['nik'] ?? 'NIK-UNKNOWN',
        'service': 'Pendaftaran Layanan Kesehatan',
        'status': log['status_transaksi'] ?? 'SUCCESS',
        'isSuccess': (log['status_transaksi'] ?? '') == 'SUCCESS',
        'time': log['created_at'] ?? 'Baru saja',
      };

      dashboardActivities.insert(0, mappedActivityItem);

      Get.snackbar(
        'Sukses',
        responseData['message'] ?? 'OTP Valid! Data berhasil diambil.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green[100],
        colorText: Colors.green[900],
      );

      currentStep.value = ScanStep.confirmation;
    } catch (e) {
      final cleanError = e.toString()
          .replaceAll('Exception: Exception: ', '')
          .replaceAll('Exception: ', '');

      final lowerError = cleanError.toLowerCase();
      if (lowerError.contains('kadaluarsa') ||
          lowerError.contains('tidak valid') ||
          lowerError.contains('expired')) {
        clearOtpInput();
        Get.snackbar(
          'OTP Tidak Valid',
          'Kode OTP salah atau sudah kadaluarsa. Silakan kirim ulang OTP.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFEF4444),
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
        return;
      }

      Get.snackbar(
        'Verifikasi Gagal',
        cleanError,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<void> verifyOtpAndFetchData() async {
    await verifyOtpApi();
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
      pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693, NfcPollingOption.iso18092},
      onDiscovered: (NfcTag tag) async {
        try {
          List<int> identifier = [];
          dynamic tagData = tag.data;

          try { if (tagData.id != null) identifier = List<int>.from(tagData.id); } catch (_) {}
          if (identifier.isEmpty) { try { identifier = List<int>.from(tagData.nfca.identifier); } catch (_) {} }
          if (identifier.isEmpty) { try { identifier = List<int>.from(tagData.isodep.identifier); } catch (_) {} }
          if (identifier.isEmpty) { try { identifier = List<int>.from(tagData.mifare.identifier); } catch (_) {} }

          if (identifier.isNotEmpty) {
            String uidString = identifier.map((e) => e.toRadixString(16).padLeft(2, '0').toUpperCase()).join(':');
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

  void clearOtpInput() {
    for (final controller in otpControllers) {
      controller.clear();
    }

    if (otpFocusNodes.isNotEmpty) {
      otpFocusNodes[0].requestFocus();
    }
  }
}