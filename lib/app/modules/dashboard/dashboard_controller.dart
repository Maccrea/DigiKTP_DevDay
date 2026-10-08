import 'package:get/get.dart';
import 'package:digiktp/app/data/providers/api_provider.dart';
import 'package:digiktp/app/data/services/auth_service.dart';
import 'package:digiktp/app/routes/app_routes.dart';

class DashboardController extends GetxController {
  final ApiProvider _apiProvider = Get.put(ApiProvider());
  final AuthService _authService = Get.find<AuthService>();
  final RxInt currentBottomNavIndex = 0.obs;
  final List<int> _tabHistory = [0];

  final RxString userName = 'Teman'.obs;
  final RxString userNip = ''.obs;
  final RxString activePosko = ''.obs;
  final RxString selectedService = 'Verifikasi e-KTP'.obs;

  final RxList<Map<String, dynamic>> dashboardActivities =
      <Map<String, dynamic>>[].obs;

  final RxBool isLoading = true.obs;
  final RxString errorMessage = ''.obs;

  int get eKtpScannedCount => dashboardActivities.length;
  int get dukcapilValidCount =>
      dashboardActivities.where((item) => item['isSuccess'] == true).length;

  String get validityPercentage {
    if (eKtpScannedCount == 0) return '0%';
    double percentage = (dukcapilValidCount / eKtpScannedCount) * 100;
    return '${percentage.toStringAsFixed(1)}% terverifikasi';
  }

  final selectedTimeFilter = 'Semua'.obs;
  final selectedStatusFilter = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final petugas = _authService.currentPetugas.value;
    if (petugas != null) {
      userName.value = petugas.nama;
      userNip.value = 'NIP ${petugas.nip}';
      activePosko.value = _authService.currentLocation.value;
    }
    loadLayananLogs();
  }

  Future<void> loadLayananLogs() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final logs = await _apiProvider.fetchLayananLogs().timeout(
        const Duration(seconds: 4),
        onTimeout: () {
          print(
            '⚠️ Keterlambatan koneksi API, memuat halaman secara offline/kosong.',
          );
          return [];
        },
      );

      dashboardActivities.assignAll(logs);
    } catch (error) {
      errorMessage.value = 'Gagal memuat data dari server.';
      print('GAGAL MEMUAT RIWAYAT LAYANAN: $error');
    } finally {
      isLoading.value = false;
    }
  }

  void changeBottomNavIndex(int index) {
    if (currentBottomNavIndex.value != index) {
      _tabHistory.remove(index);
      _tabHistory.add(index);
      currentBottomNavIndex.value = index;
    }
  }

  bool handleBackAction() {
    if (_tabHistory.length > 1) {
      _tabHistory.removeLast();
      currentBottomNavIndex.value = _tabHistory.last;
      return false;
    }
    return true;
  }

  void goToNfcScan([String? service]) {
    if (service != null) selectedService.value = service;

    if (!_authService.isLoggedIn.value) {
      Get.toNamed(Routes.LOGIN);
      return;
    }

    Get.toNamed(Routes.NFC_SCAN, arguments: {'service': selectedService.value});
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  void resetFilters() {
    selectedTimeFilter.value = 'Semua';
    selectedStatusFilter.value = 'Semua';
    searchQuery.value = '';
  }

  List<Map<String, dynamic>> get filteredActivities {
    return dashboardActivities.where((item) {
      final searchLower = searchQuery.value.toLowerCase();
      final nameMatches = (item['name'] ?? '').toLowerCase().contains(
        searchLower,
      );
      final nikMatches = (item['nik'] ?? '').toLowerCase().contains(
        searchLower,
      );
      final matchesSearch = searchLower.isEmpty || nameMatches || nikMatches;

      bool matchesStatus = true;
      if (selectedStatusFilter.value == 'Berhasil') {
        matchesStatus = item['isSuccess'] == true;
      } else if (selectedStatusFilter.value == 'Gagal') {
        matchesStatus = item['isSuccess'] == false;
      }

      bool matchesTime = true;
      if (selectedTimeFilter.value != 'Semua') {
        if (selectedTimeFilter.value == 'Hari Ini') {
          matchesTime = item['date_group'] == 'Hari Ini';
        } else if (selectedTimeFilter.value == 'Kemarin') {
          matchesTime = item['date_group'] == 'Kemarin';
        }
      }

      return matchesSearch && matchesStatus && matchesTime;
    }).toList();
  }
}
