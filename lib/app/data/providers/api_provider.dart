import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiProvider extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> cekWarga({required String nfcUid}) async {
    final cleanNfcUid = nfcUid.trim().toUpperCase();
    if (cleanNfcUid.isEmpty) {
      throw Exception('UID NFC wajib tersedia');
    }

    try {
      final accessToken =
          supabase.auth.currentSession?.accessToken ??
          GetStorage().read<String>('auth_token');
      if (accessToken == null || accessToken.isEmpty) {
        throw Exception('Token akses tidak tersedia');
      }

      final response = await supabase.functions.invoke(
        'cek-warga',
        body: {'nfc_uid': cleanNfcUid},
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      );

      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      print(
        'RESPON CEK WARGA: status=${responseData['status']}, '
        'message=${responseData['message']}',
      );

      if (responseData['status'] != 'success') {
        throw Exception(
          responseData['message'] ?? 'Data warga tidak ditemukan',
        );
      }

      return responseData;
    } on FunctionsHttpException catch (e) {
      print('ERROR CEK WARGA: status=${e.status}, details=${e.details}');
      if (e.status == 400) {
        throw Exception(_functionErrorMessage(e.details));
      }
      if (e.status == 404) {
        final directResponse = await registerCitizen(nfcUid: cleanNfcUid);
        if (directResponse != null) {
          return directResponse;
        }
        throw Exception(_functionErrorMessage(e.details));
      }
      throw Exception(_functionErrorMessage(e.details));
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  String _functionErrorMessage(dynamic details) {
    if (details is Map && details['message'] is String) {
      return details['message'] as String;
    }
    return 'Gagal memverifikasi data warga';
  }

  Future<Map<String, dynamic>?> registerCitizen({
    required String nfcUid,
  }) async {
    try {
      final row = await supabase
          .from('users_warga')
          .select()
          .eq('uid_nfc', nfcUid)
          .maybeSingle();

      if (row == null) return null;

      final data = Map<String, dynamic>.from(row);
      return {
        'status': 'success',
        'message': 'Data warga ditemukan',
        'data': {
          ...data,
          'nik': data['nik'] ?? '-',
          'nama_masking': data['nama_masking'] ?? data['nama_lengkap'] ?? '',
          'wilayah': data['wilayah'] ?? data['alamat'] ?? '',
          'is_active': data['is_active'] ?? true,
          'phone_last_digits': data['phone_last_digits'] ?? data['no_hp'] ?? '',
          'email': data['email'] ?? '',
        },
      };
    } catch (error) {
      print('FALLBACK USERS_WARGA GAGAL: $error');
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> fetchLayananLogs() async {
    final rows = await supabase
        .from('layanan_logs')
        .select('*, users_warga(nama_lengkap, link_foto)')
        .order('created_at', ascending: false);

    return (rows as List).map((row) {
      final log = Map<String, dynamic>.from(row as Map);

      final warga = log['users_warga'] is Map
          ? Map<String, dynamic>.from(log['users_warga'] as Map)
          : <String, dynamic>{};

      final status = (log['status_transaksi'] ?? 'PENDING').toString();

      return {
        'log_id': log['id_log'] ?? '-',

        'name': warga['nama_lengkap'] ?? log['nik_warga'] ?? 'Tanpa Nama',

        'nik': log['nik_warga'] ?? '-',

        'service': log['jenis_layanan'] ?? 'Layanan Dukcapil',

        'status': status,

        'isSuccess': status.toUpperCase() == 'SUCCESS',

        'time': log['created_at'] ?? '-',

        'photo_path': warga['link_foto'],
      };
    }).toList();
  }

  Future<Map<String, dynamic>> generateOtp({
    required String nfcUid,
    required String email,
  }) async {
    try {
      final requestBody = {
        'nfc_uid': nfcUid.trim(),
        'email_terpilih': email.trim(),
      };

      print('📤 MENGIRIM GENERATE OTP PAYLOAD: $requestBody');

      final response = await supabase.functions.invoke(
        'generate-otp',
        body: requestBody,
      );

      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      print('📥 RESPON GENERATE OTP: $responseData');

      return responseData;
    } catch (e) {
      print('DEBUG ERROR SUPABASE FUNCTIONS: $e');
      throw Exception('Gagal mengirim OTP: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String nfcUid,
    required String otpCode,
    required String nikWarga,
    required String idPetugas,
    required String idInstansi,
    String? lokasiTugas,
    String? jenisLayanan,
    String statusTransaksi = 'SUCCESS',
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'nfc_uid': nfcUid.trim(),
        'otp_code': otpCode.trim(),
        'nik_warga': nikWarga.trim(),
        'id_petugas': idPetugas.trim(),
        'id_instansi': idInstansi.trim(),
      };

      final cleanLokasiTugas = (lokasiTugas ?? '').trim();
      final cleanJenisLayanan = (jenisLayanan ?? '').trim();

      if (cleanLokasiTugas.isNotEmpty) {
        requestBody['lokasi_tugas'] = cleanLokasiTugas;
      }
      if (cleanJenisLayanan.isNotEmpty) {
        requestBody['jenis_layanan'] = cleanJenisLayanan;
      }
      requestBody['status_transaksi'] = statusTransaksi.trim();

      print('📤 MENGIRIM VERIFIKASI OTP PAYLOAD: $requestBody');

      final response = await supabase.functions.invoke(
        'verify-otp',
        body: requestBody,
      );

      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      print('📥 RESPON VERIFY OTP: $responseData');

      if (responseData.containsKey('error')) {
        throw Exception(responseData['error']);
      }

      if (responseData['status'] != 'success') {
        throw Exception('Verifikasi OTP gagal. Silakan coba lagi.');
      }

      return responseData;
    } catch (e) {
      print('❌ DEBUG ERROR VERIFY OTP MENTAH: $e');
      throw Exception('$e');
    }
  }

  Future<Map<String, dynamic>> loginPetugas({
    required String nip,
    required String password,
    // required String idInstansi,
    // required String location,
  }) async {
    try {
      print('LOGIN PETUGAS: mengirim NIP dan password ke login-petugas');
      final response = await supabase.functions.invoke(
        'login-petugas',
        body: {
          'nip': nip,
          'password': password,
          // 'id_instansi': idInstansi,
          // 'location': location,
        },
      );
      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);
      final nestedData = responseData['data'];
      final nestedDataKeys = nestedData is Map
          ? nestedData.keys.join(', ')
          : 'none';

      print(
        'LOGIN PETUGAS: respons HTTP ${response.status}, '
        'keys=${responseData.keys.join(', ')}, '
        'data keys=$nestedDataKeys, '
        'petugas tersedia=${responseData['petugas'] is Map}',
      );

      if (responseData['petugas'] is! Map ||
          responseData['petugas']['id_petugas'] == null) {
        throw Exception('Respons login tidak berisi ID petugas yang valid');
      }

      return responseData;
    } catch (e) {
      print('LOGIN PETUGAS GAGAL: $e');
      throw Exception('Login petugas gagal: $e');
    }
  }

  Future<void> updatePetugasLocation({
    required String idPetugas,
    required String newLocation,
  }) async {
    try {
      await supabase.functions.invoke(
        'update-location',
        body: {'id_petugas': idPetugas, 'new_location': newLocation},
      );
    } catch (e) {
      print('Update location error: $e');
    }
  }

  Future<Map<String, dynamic>> registerWargaBaru({
    required String nfcUid,
    required String base64Image,
  }) async {
    try {
      final requestBody = {
        'uid_nfc': nfcUid.trim(),
        'base64_image': base64Image,
      };

      print('📤 MENGIRIM DATA PROCESS KTP OCR: uid_nfc=${nfcUid.trim()}');

      final response = await supabase.functions.invoke(
        'process-ktp-ocr',
        body: requestBody,
      );

      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map? ?? {});

      print('📥 RESPON PROCESS KTP OCR: $responseData');

      if (responseData.containsKey('error')) {
        throw Exception(responseData['error']);
      }

      return responseData;
    } catch (e) {
      print('❌ ERROR PROCESS KTP OCR: $e');
      throw Exception('Gagal memproses KTP via OCR: $e');
    }
  }
}
