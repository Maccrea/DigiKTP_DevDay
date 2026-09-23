import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiProvider extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> cekWarga({
    required String nfcUid,
  }) async {
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
        final directResponse = await _lookupWargaDirectly(
          nfcUid: cleanNfcUid,
        );
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

  Future<Map<String, dynamic>?> _lookupWargaDirectly({
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
        .select('*, users_warga(nama_lengkap)')
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
    required String idInstansi,
    required String location,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'petugas-login',
        body: {
          'nip': nip,
          'password': password,
          'id_instansi': idInstansi,
          'location': location,
        },
      );
      final responseData = response.data is Map<String, dynamic>
          ? response.data as Map<String, dynamic>
          : Map<String, dynamic>.from(response.data as Map);

      if (responseData['petugas'] is! Map ||
          responseData['petugas']['id_petugas'] == null ||
          responseData['petugas']['id_instansi'] == null) {
        throw Exception(
          'Respons login tidak berisi ID petugas/instansi yang valid',
        );
      }

      return responseData;
    } catch (e) {
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
}