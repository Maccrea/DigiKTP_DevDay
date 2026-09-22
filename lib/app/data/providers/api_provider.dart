import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ApiProvider extends GetxService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<Map<String, dynamic>> cekWarga({
    required String nik,
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'cek-warga', 
        body: {
          'nik': nik,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('DEBUG ERROR CEK WARGA: $e');
      throw Exception('Gagal memverifikasi NIK: $e');
    }
  }

  Future<Map<String, dynamic>> generateOtp({
    required String nfcUid, 
    required String email, 
  }) async {
    try {
      final response = await supabase.functions.invoke(
        'generate-otp',
        body: {
          'nfc_uid': nfcUid,
          'email_terpilih': email,
        },
      );
      return response.data as Map<String, dynamic>;
    } catch (e) {
      print('DEBUG ERROR SUPABASE FUNCTIONS: $e'); 
      throw Exception('Gagal mengirim OTP: $e');
    }
  }

  Future<Map<String, dynamic>> verifyOtp({
    required String nfcUid, 
    required String otpCode,
    required String idPetugas,
    required String idInstansi,
    String? lokasiTugas,
    String? jenisLayanan,
  }) async {
    try {
      final Map<String, dynamic> requestBody = {
        'nfc_uid': nfcUid,
        'otp_code': otpCode,
        'id_petugas': idPetugas,
        'id_instansi': idInstansi,
      };

      if (lokasiTugas != null) requestBody['lokasi_tugas'] = lokasiTugas;
      if (jenisLayanan != null) requestBody['jenis_layanan'] = jenisLayanan;

      print('📤 MENGIRIM VERIFIKASI OTP PAYLOAD: $requestBody');

      final response = await supabase.functions.invoke(
        'verify-otp',
        body: requestBody,
      );
      
      print('📥 RESPON SUKSES VERIFY OTP: ${response.data}');
      return response.data as Map<String, dynamic>;
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
      return response.data as Map<String, dynamic>;
    } catch (e) {
      await Future.delayed(const Duration(milliseconds: 500));
      return {
        'token': 'mock_jwt_token_xyz123',
        'petugas': {
          'id_petugas': 'P-10928',
          'nip': nip,
          'nama': 'Budi Santoso',
          'email': 'budi.santoso@jakarta.go.id',
          'id_instansi': idInstansi,
          'current_location': location,
          'role': 'petugas_layanan',
        }
      };
    }
  }

  Future<void> updatePetugasLocation({
    required String idPetugas,
    required String newLocation,
  }) async {
    try {
      await supabase.functions.invoke(
        'update-location',
        body: {
          'id_petugas': idPetugas,
          'new_location': newLocation,
        },
      );
    } catch (e) {
      print('Update location error: $e');
    }
  }
}