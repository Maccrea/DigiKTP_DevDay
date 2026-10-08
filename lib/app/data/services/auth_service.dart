import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/petugas_model.dart';
import '../providers/api_provider.dart';
import 'package:digiktp/app/utils/app_snackbar.dart';

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
      currentLocation.value =
          savedLocation ?? currentPetugas.value?.lokasiLayanan ?? '';
    }
  }

  Future<bool> login({required String nip, required String password}) async {
    try {
      final apiProvider = _apiProvider;
      if (apiProvider == null) {
        throw StateError('ApiProvider belum tersedia');
      }

      final responseData = await apiProvider.loginPetugas(
        nip: nip,
        password: password,
      );

      final petugas = PetugasModel.fromJson(responseData['petugas']);
      final token = responseData['token'];
      if (token is String && token.isNotEmpty) {
        await _storage.write('auth_token', token);
      }
      await _storage.write('petugas_data', responseData['petugas']);

      currentPetugas.value = petugas;
      currentLocation.value = petugas.lokasiLayanan;
      isLoggedIn.value = true;

      return true;
    } catch (e) {
      AppSnackbar.error(message: 'Login Gagal');
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
      AppSnackbar.error(message: 'Gagal Mengubah Lokasi');
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
