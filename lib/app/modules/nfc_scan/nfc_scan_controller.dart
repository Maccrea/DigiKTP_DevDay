import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import '../../data/providers/api_provider.dart';
import '../../data/services/auth_service.dart';
import 'ktp_ocr_parser.dart';
import 'package:digiktp/app/utils/app_snackbar.dart';
import 'package:ktp_extractor/ktp_extractor.dart';
import 'dart:io';
import 'dart:convert';

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
    return elapsed < const Duration(minutes: 5);
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
    final data = verifiedWargaData;
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
      AppSnackbar.warning(
        title: 'Kamera tidak tersedia',
        message:
            'Pindai e-KTP menggunakan aplikasi di perangkat Android atau iPhone.',
      );
      return;
    }

    try {
      isReadingKtp.value = true;

      final photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
        maxWidth: 1200,
      );

      if (photo == null) {
        isReadingKtp.value = false;
        return;
      }

      File imageFile = File(photo.path);

      File? croppedImage = await KtpExtractor.cropImageForKtp(imageFile);

      File imageToProcess = croppedImage ?? imageFile;

      capturedKtpPhoto = XFile(imageToProcess.path);
      ktpPhotoRevision.value++;

      KtpModel ktpData = await KtpExtractor.extractKtp(imageToProcess);

      if (ktpData.nik != null) newNikController.text = ktpData.nik!;
      if (ktpData.name != null) newNameController.text = ktpData.name!;
      if (ktpData.address != null) newAddressController.text = ktpData.address!;

      scannedKtpFields.clear();
      scannedKtpFields['nik'] = ktpData.nik ?? '';
      scannedKtpFields['nama_lengkap'] = ktpData.name ?? '';
      scannedKtpFields['alamat'] = ktpData.address ?? '';
      scannedKtpFields['tempat_tanggal_lahir'] = ktpData.birthDay ?? '';

      verifiedWargaData['photo_path'] = imageToProcess.path;

      AppSnackbar.success(
        title: 'KTP Terbaca',
        message: 'Data berhasil diekstrak. Silakan periksa kembali.',
      );
    } catch (error) {
      AppSnackbar.error(
        title: 'Pemindaian Gagal',
        message:
            'Gagal membaca KTP. Pastikan pencahayaan cukup dan KTP tidak buram.',
      );
      debugPrint('KTP Extractor Error: $error');
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
      AppSnackbar.warning(
        title: 'NFC Belum Dipindai',
        message: 'Silakan scan e-KTP terlebih dahulu.',
      );
      return;
    }

    if (nik.length != 16) {
      AppSnackbar.error(
        title: 'NIK Tidak Valid',
        message:
            'NIK harus terdiri dari 16 digit angka. Terbaca ${nik.length} digit.',
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
      AppSnackbar.error(title: 'Cek Data Warga Gagal', message: message);
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

  Future<void> submitRegistrasiWarga() async {
    try {
      isLoading.value = true;
      update();

      final nfcUid = activeNfcUid;
      if (nfcUid.isEmpty) {
        throw Exception(
          'UID NFC belum tersedia. Silakan scan e-KTP terlebih dahulu.',
        );
      }

      final email = newEmailController.text.trim();
      if (!email.contains('@') || !email.contains('.')) {
        throw Exception('Email wajib diisi dengan format yang benar.');
      }

      final photoPath =
          capturedKtpPhoto?.path ?? verifiedWargaData['photo_path'];
      if (photoPath == null || photoPath.toString().isEmpty) {
        throw Exception(
          'Foto KTP belum tersedia. Silakan ambil foto KTP terlebih dahulu.',
        );
      }

      final imageFile = File(photoPath);
      if (!await imageFile.exists()) {
        throw Exception('File foto KTP tidak ditemukan di perangkat.');
      }

      final bytes = await imageFile.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await _apiProvider.registerWargaBaru(
        nfcUid: nfcUid,
        base64Image: base64Image,
      );

      if (response.containsKey('data')) {
        final responseWarga = response['data'] is Map
            ? Map<String, dynamic>.from(response['data'] as Map)
            : <String, dynamic>{};
        verifiedWargaData.assignAll(responseWarga);
      } else {
        verifiedWargaData.assignAll(Map<String, dynamic>.from(response));
      }

      verifiedWargaData['email'] = email;
      try {
        await _apiProvider.supabase
            .from('users_warga')
            .update({'email': email})
            .eq('uid_nfc', nfcUid);
      } catch (e) {
        debugPrint('SIMPAN EMAIL GAGAL: $e');
      }

      AppSnackbar.show(
        message: 'Registrasi & OCR KTP Berhasil!',
        icon: Icons.check_circle_outline,
      );

      currentStep.value = ScanStep.validation;
    } catch (e) {
      print('❌ ERROR REGISTRASI KTP OCR: $e');

      String errorMessage = e.toString().replaceFirst('Exception: ', '');
      if (errorMessage.contains('duplicate key') ||
          errorMessage.contains('already exists')) {
        final email = newEmailController.text.trim();
        if (email.isNotEmpty) verifiedWargaData['email'] = email;
        currentStep.value = ScanStep.validation;
        AppSnackbar.show(
          message:
              'UID NFC ini sudah terdaftar di sistem. Silakan lanjutkan verifikasi.',
        );
        return;
      }

      AppSnackbar.show(message: errorMessage);
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
    if (isLoading.value) return;

    final enteredOtp = otpControllers.map((c) => c.text.trim()).join();
    final nfcUid = activeNfcUid;

    if (nfcUid.trim().isEmpty) {
      AppSnackbar.warning(
        title: 'Peringatan',
        message: 'UID NFC belum tersedia. Silakan scan e-KTP lagi.',
      );
      return;
    }

    if (!hasValidOtpSession) {
      AppSnackbar.show(
        title: 'Peringatan',
        message: 'Sesi OTP sudah kadaluarsa. Silakan kirim OTP baru.',
      );
      return;
    }

    if (enteredOtp.length != 6) {
      AppSnackbar.show(
        title: 'Peringatan',
        message: 'Masukkan 6 digit kode OTP secara lengkap.',
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

      String nikWarga =
          (verifiedWargaData['nik'] ?? scannedKtpFields['nik'] ?? '')
              .toString()
              .trim();
      if (nikWarga.isEmpty) {
        throw Exception('NIK warga belum tersedia untuk mencatat layanan.');
      }

      debugPrint('📤 MENGIRIM VERIFIKASI OTP PAYLOAD KE API...');

      final responseData = await _apiProvider.verifyOtp(
        nfcUid: nfcUid,
        otpCode: enteredOtp,
        nikWarga: nikWarga,
        idPetugas: petugas.idPetugas.trim().isNotEmpty
            ? petugas.idPetugas.trim()
            : defaultPetugasId,
        idInstansi: petugas.idInstansi,
        lokasiTugas: authService.currentLocation.value,
        jenisLayanan: serviceName,
      );

      final warga = responseData['warga'] ?? {};
      final log = responseData['log'] ?? {};

      debugPrint('========== VERIFY OTP BERHASIL ==========');
      debugPrint('WARGA RESPONSE: $warga');
      debugPrint('LOG RESPONSE: $log');

      if (warga.isNotEmpty) {
        verifiedWargaData.value = Map<String, dynamic>.from(warga);
      }
      if (log.isNotEmpty) {
        logData.value = Map<String, dynamic>.from(log);
      }

      final Map<String, dynamic> mappedActivityItem = {
        'log_id': log['id_log'] ?? log['id'] ?? 'UUID-UNKNOWN',
        'name': warga['nama_lengkap'] ?? 'Tanpa Nama',
        'nik': warga['nik'] ?? nikWarga,
        'service': serviceName,
        'status': log['status_transaksi'] ?? 'SUCCESS',
        'isSuccess': (log['status_transaksi'] ?? '') == 'SUCCESS',
        'time': log['created_at'] ?? 'Baru saja',
      };

      mappedActivityItem['photo_path'] =
          warga['link_foto'] ?? verifiedWargaData['link_foto'];

      dashboardActivities.insert(0, mappedActivityItem);

      AppSnackbar.show(message: 'OTP Valid! Data berhasil diambil.');

      currentStep.value = ScanStep.confirmation;
    } catch (e) {
      final rawError = e.toString().replaceFirst('Exception: ', '');
      debugPrint('❌ ERROR VERIFY OTP: $rawError');

      final otpDitolak = rawError.contains('OTP');
      if (otpDitolak) clearOtpInput();

      AppSnackbar.error(
        title: 'Verifikasi Gagal',
        message: otpDitolak
            ? 'Kode OTP salah atau sudah dipakai. Kirim ulang OTP untuk kode baru.'
            : rawError,
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
