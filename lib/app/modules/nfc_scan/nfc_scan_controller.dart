import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/providers/api_provider.dart';
import '../../data/services/auth_service.dart';
import 'ktp_ocr_parser.dart';
import 'package:digiktp/app/utils/app_snackbar.dart';

enum ScanStep {
  cekWarga,
  prompt,
  result,
  validation,
  sendOtp,
  inputOtp,
  confirmation,
  success,
}

class NfcScanController extends GetxController {
  static const String defaultPetugasId = 'P-001';

  final ApiProvider _apiProvider = Get.put(ApiProvider());

  RxList<Map<String, dynamic>> dashboardActivities =
      <Map<String, dynamic>>[].obs;
  final currentStep = ScanStep.prompt.obs;
  final isScanning = false.obs;
  final scannedUid = ''.obs;
  final errorMessage = ''.obs;

  final selectedContact = 0.obs;
  final TextEditingController customEmailController = TextEditingController();
  final newNikController = TextEditingController();
  final newNameController = TextEditingController();
  final newAddressController = TextEditingController();
  final newEmailController = TextEditingController();
  final scannedKtpFields = <String, String>{}.obs;
  final isReadingKtp = false.obs;
  final ktpPhotoRevision = 0.obs;
  final ImagePicker _imagePicker = ImagePicker();
  XFile? capturedKtpPhoto;
  String serviceName = 'Verifikasi e-KTP';

  final isLoading = false.obs;
  final isAgreed = false.obs;
  final TextEditingController nikController = TextEditingController();
  final nikDigitCount = 0.obs;

  final targetedEmail = ''.obs;

  RxMap<String, dynamic> verifiedWargaData = <String, dynamic>{}.obs;
  RxMap<String, dynamic> logData = <String, dynamic>{}.obs;

  final List<TextEditingController> otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> otpFocusNodes = List.generate(6, (_) => FocusNode());

  final RxInt countdown = 60.obs;
  final RxBool canResend = false.obs;

  Timer? _timer;
  String? _otpNfcUid;
  DateTime? _lastOtpRequestedAt;

  bool get hasValidOtpSession {
    if (_otpNfcUid == null ||
        _otpNfcUid!.trim().isEmpty ||
        _lastOtpRequestedAt == null) {
      return false;
    }

    final nowUtc = DateTime.now().toUtc();
    final requestedAtUtc = _lastOtpRequestedAt!.toUtc();
    final elapsed = nowUtc.difference(requestedAtUtc);
    return elapsed < const Duration(minutes: 2);
  }

  String get activeNfcUid {
    final current =
        (scannedUid.value.isNotEmpty ? scannedUid.value : (_otpNfcUid ?? ''))
            .trim();

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
    if (selectedContact.value < registeredEmails.length) return true;
    if (selectedContact.value == registeredEmails.length) {
      final text = customEmailController.text.trim();
      return text.isNotEmpty && text.contains('@') && text.contains('.');
    }
    return false;
  }

  List<String> get registeredEmails {
    final values = [
      verifiedWargaData['email'],
      verifiedWargaData['email_cadangan'],
      verifiedWargaData['email_alternatif'],
    ];
    return values
        .whereType<String>()
        .map((email) => email.trim())
        .where((email) => email.isNotEmpty)
        .toSet()
        .toList();
  }

  @override
  void onInit() {
    super.onInit();
    final arguments = Get.arguments;
    if (arguments is Map && arguments['service'] is String) {
      serviceName = arguments['service'] as String;
    }
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
    nikController.dispose();
    newNikController.dispose();
    newNameController.dispose();
    newAddressController.dispose();
    newEmailController.dispose();

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

  Future<void> captureAndReadKtp() async {
    if (defaultTargetPlatform != TargetPlatform.android &&
        defaultTargetPlatform != TargetPlatform.iOS) {
      Get.snackbar(
        'Kamera tidak tersedia',
        'Pindai e-KTP menggunakan aplikasi di perangkat Android atau iPhone.',
      );
      return;
    }

    try {
      isReadingKtp.value = true;
      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 88,
        maxWidth: 2000,
      );
      if (photo == null) return;

      capturedKtpPhoto = photo;
      ktpPhotoRevision.value++;

      final recognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      try {
        final recognized = await recognizer.processImage(
          InputImage.fromFilePath(photo.path),
        );
        _fillRegistrationFields(recognized.text);
      } finally {
        await recognizer.close();
      }

      Get.snackbar(
        'Foto terbaca',
        'Periksa kembali data yang terisi sebelum menyimpan.',
        snackPosition: SnackPosition.TOP,
      );
    } catch (error) {
      Get.snackbar(
        'Tidak dapat membaca e-KTP',
        'Coba ambil foto yang lebih terang dan tidak terpotong.',
        snackPosition: SnackPosition.TOP,
      );
      debugPrint('KTP OCR gagal: $error');
    } finally {
      isReadingKtp.value = false;
    }
  }

  void _fillRegistrationFields(String text) {
    final fields = KtpOcrParser.parse(text);
    scannedKtpFields.assignAll(fields);
    final nik = fields['nik'];
    final name = fields['nama_lengkap'];
    final address = fields['alamat'];
    if (nik != null) newNikController.text = nik;
    if (name != null) newNameController.text = name;
    if (address != null) newAddressController.text = address;
  }

  void prepareNextScan() {
    scannedUid.value = '';
    _otpNfcUid = null;
    _lastOtpRequestedAt = null;
    verifiedWargaData.clear();
    logData.clear();
    capturedKtpPhoto = null;
    ktpPhotoRevision.value++;
    newNikController.clear();
    newNameController.clear();
    newAddressController.clear();
    newEmailController.clear();
    scannedKtpFields.clear();
    clearOtpInput();
    currentStep.value = ScanStep.prompt;
  }

  void bypassScan() {
    syncNfcUid('0E:27:12:10:40:6F:33');
    currentStep.value = ScanStep.result;
  }

  bool handleBack() {
    switch (currentStep.value) {
      case ScanStep.cekWarga:
        return true;
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

  Future<void> cekWargaApi() async {
    final nik = nikController.text.replaceAll(RegExp(r'[^0-9]'), '');
    nikDigitCount.value = nik.length;
    final nfcUid = activeNfcUid;

    if (nfcUid.isEmpty) {
      Get.snackbar(
        'NFC Belum Dipindai',
        'Silakan scan e-KTP terlebih dahulu.',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (nik.length != 16) {
      Get.snackbar(
        'NIK Tidak Valid',
        'NIK harus terdiri dari 16 digit angka. Terbaca ${nik.length} digit.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      debugPrint('CEK WARGA: mengirim ${nik.length} digit NIK');

      final responseData = await _apiProvider.cekWarga(nfcUid: nfcUid);

      final warga = Map<String, dynamic>.from(responseData['data'] as Map);
      verifiedWargaData.value = warga;
    } catch (e) {
      final message = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        'Cek Data Warga Gagal',
        message,
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFFEF4444),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cekWargaApiByUid() async {
    final nfcUid = activeNfcUid;
    if (nfcUid.isEmpty) return;

    try {
      isLoading.value = true;
      final responseData = await _apiProvider.cekWarga(nfcUid: nfcUid);

      final warga = Map<String, dynamic>.from(responseData['data'] as Map);
      verifiedWargaData.value = warga;

      currentStep.value = ScanStep.result;
    } catch (e) {
      verifiedWargaData.clear();
      currentStep.value = ScanStep.cekWarga;

      AppSnackbar.show(message: "KTP Belum Terdaftar");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitRegistrasiWarga(Map<String, dynamic> formData) async {
  try {
    isLoading.value = true;
    update();

    final response = await _apiProvider.registerWargaBaru(formData: formData);

    if (response != null) {
      if (response is Map && response.containsKey('data')) {
        final responseWarga = response['data'] is Map
            ? Map<String, dynamic>.from(response['data'] as Map)
            : <String, dynamic>{};
        verifiedWargaData.value = {...formData, ...responseWarga};
      } else {
        verifiedWargaData.value = Map<String, dynamic>.from(formData);
      }

      AppSnackbar.show(
        message: 'Registrasi KTP Berhasil!',
        icon: Icons.check_circle_outline,
      );

      currentStep.value = ScanStep.validation;
    } else {
      verifiedWargaData.value = Map<String, dynamic>.from(formData);
      currentStep.value = ScanStep.validation;
    }
    
  } catch (e) {
    print('❌ ERROR REGISTRASI KTP: $e');
    
    String errorMessage = e.toString().replaceFirst('Exception: ', '');
    if (errorMessage.contains('duplicate key') || errorMessage.contains('already exists')) {
      errorMessage = 'UID NFC ini sudah terdaftar di sistem. Silakan lanjutkan verifikasi.';
      currentStep.value = ScanStep.validation;
      return;
    }

    Get.snackbar(
      '',
      errorMessage,
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

  Future<void> requestOtpApi(int selectedOptionIndex) async {
    try {
      isLoading.value = true;
      update();

      final emails = registeredEmails;
      final String targetEmail;
      if (selectedOptionIndex < emails.length) {
        targetEmail = emails[selectedOptionIndex];
      } else if (selectedOptionIndex == emails.length) {
        targetEmail = customEmailController.text.trim();
      } else {
        throw Exception('Pilih alamat email untuk menerima kode OTP.');
      }

      targetedEmail.value = targetEmail;

      final nfcUid = activeNfcUid;
      if (nfcUid.isEmpty) {
        throw Exception(
          'UID NFC belum tersedia. Silakan scan e-KTP terlebih dahulu.',
        );
      }

      await _apiProvider.generateOtp(nfcUid: nfcUid, email: targetEmail);

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

      final authService = Get.find<AuthService>();
      final petugas = authService.currentPetugas.value;
      if (petugas == null || petugas.idPetugas.trim().isEmpty) {
        throw Exception('Sesi petugas tidak ditemukan. Silakan login ulang.');
      }
      final nikWarga = (verifiedWargaData['nik'] ?? '').toString().trim();
      if (nikWarga.isEmpty) {
        throw Exception('NIK warga belum tersedia untuk mencatat layanan.');
      }

      final responseData = await _apiProvider.verifyOtp(
        nfcUid: nfcUid,
        otpCode: enteredOtp,
        nikWarga: nikWarga,
        idPetugas: defaultPetugasId,
        idInstansi: petugas.idInstansi,
        lokasiTugas: authService.currentLocation.value,
        jenisLayanan: serviceName,
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
        'log_id': log['id_log'] ?? log['id'] ?? 'UUID-UNKNOWN',
        'name': warga['nama_lengkap'] ?? 'Tanpa Nama',
        'nik': warga['nik'] ?? 'NIK-UNKNOWN',
        'service': serviceName,
        'status': log['status_transaksi'] ?? 'SUCCESS',
        'isSuccess': (log['status_transaksi'] ?? '') == 'SUCCESS',
        'time': log['created_at'] ?? 'Baru saja',
      };

      dashboardActivities.insert(0, mappedActivityItem);

      AppSnackbar.show(message: 'OTP Valid! Data berhasil diambil.');

      currentStep.value = ScanStep.confirmation;
    } catch (e) {
      final cleanError = e
          .toString()
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
    if (currentStep.value != ScanStep.confirmation) return;
    currentStep.value = ScanStep.success;
  }

  void startNfcSession() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      errorMessage.value =
          'NFC tidak tersedia atau belum diaktifkan pada HP ini.';
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
            if (tagData.id != null) identifier = List<int>.from(tagData.id);
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
            await cekWargaApiByUid();
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
