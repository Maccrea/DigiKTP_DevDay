import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/petugas_model.dart';
import '../providers/api_provider.dart';

class AuthService extends GetxService {
  final GetStorage _storage = GetStorage();
  ApiProvider? _apiProvider; 

  final RxBool isLoggedIn = false.obs;
  final Rxn<PetugasModel> currentPetugas = Rxn<PetugasModel>();
  final RxString currentLocation = ''.obs;

  Future<AuthService> init() async {
    if (Get.isRegistered<ApiProvider>()) {
      _apiManagerInit();
    }
    _loadSessionFromStorage();
    return this;
  }

  void _apiManagerInit() {
    try {
      _apiProvider = Get.find<ApiProvider>();
    } catch (_) {}
  }

  void _loadSessionFromStorage() {
    final token = _storage.read<String>('auth_token');
    final petugasData = _storage.read<Map<String, dynamic>>('petugas_data');
    final savedLocation = _storage.read<String>('current_location');

    if (token != null && petugasData != null) {
      isLoggedIn.value = true;
      currentPetugas.value = PetugasModel.fromJson(petugasData);
      currentLocation.value = savedLocation ?? currentPetugas.value?.lokasiLayanan ?? '';
    }
  }

  Future<bool> login({
    required String nip,
    required String password,
    required String idInstansi,
    required String poskoLocation,
  }) async {
    try {
      Map<String, dynamic> responseData;

      if (_apiProvider != null) {
        responseData = await _apiProvider!.loginPetugas(
          nip: nip,
          password: password,
          idInstansi: idInstansi,
          location: poskoLocation,
        );
      } else {
        await Future.delayed(const Duration(milliseconds: 500)); 
        responseData = {
          'token': 'mock_jwt_token_xyz123',
          'petugas': {
            'id_petugas': 'P-10928',
            'nip': nip,
            'nama': 'Budi Santoso',
            'email': 'budi.santoso@jakarta.go.id',
            'id_instansi': idInstansi,
            'current_location': poskoLocation,
            'role': 'petugas_layanan',
          }
        };
      }

      final petugas = PetugasModel.fromJson(responseData['petugas']);
      await _storage.write('auth_token', responseData['token']);
      await _storage.write('petugas_data', responseData['petugas']);
      await _storage.write('current_location', poskoLocation);

      currentPetugas.value = petugas;
      currentLocation.value = poskoLocation;
      isLoggedIn.value = true;

      return true;
    } catch (e) {
      Get.snackbar('Login Gagal', e.toString());
      return false;
    }
  }

  Future<bool> updateLocation(String newLocation) async {
    try {
      if (_apiProvider != null && currentPetugas.value != null) {
        await _apiProvider!.updatePetugasLocation(
          idPetugas: currentPetugas.value!.idPetugas,
          newLocation: newLocation,
        );
      }

      await _storage.write('current_location', newLocation);
      currentLocation.value = newLocation;
      
      return true;
    } catch (e) {
      Get.snackbar('Gagal Mengubah Lokasi', e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.remove('auth_token');
    await _storage.remove('petugas_data');
    await _storage.remove('current_location');

    isLoggedIn.value = false;
    currentPetugas.value = null;
    currentLocation.value = '';

    Get.offAllNamed('/login');
  }
}