import 'package:get/get.dart';
import 'package:digiktp/app/data/providers/api_provider.dart';

class DashboardController extends GetxController {
  final ApiProvider _apiProvider = Get.put(ApiProvider());
  final RxInt currentBottomNavIndex = 0.obs;
  final List<int> _tabHistory = [0];

  final RxString userName = 'Budi Santoso'.obs;
  final RxString userNip = 'NIP. 199408122020121002'.obs;
  final RxString activePosko = 'Kelurahan Gambir • Posko Layanan Terpadu'.obs;

  RxList<Map<String, dynamic>> dashboardActivities =
      <Map<String, dynamic>>[].obs;
  final RxInt eKtpScannedCount = 142.obs;
  final RxInt dukcapilValidCount = 138.obs;

  final selectedTimeFilter = 'Semua'.obs;
  final selectedStatusFilter = 'Semua'.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadLayananLogs();
  }

  Future<void> loadLayananLogs() async {
    try {
      final logs = await _apiProvider.fetchLayananLogs();
      dashboardActivities.assignAll(logs);
      eKtpScannedCount.value = logs.length;
      dukcapilValidCount.value = logs
          .where((log) => log['isSuccess'] == true)
          .length;
    } catch (error) {
      print('GAGAL MEMUAT RIWAYAT LAYANAN: $error');
    }
  }

  final RxList<Map<String, dynamic>> recentActivities = <Map<String, dynamic>>[
    {
      'log_id': 'TX-9871239-0129-DKI',
      'name': 'Siti Rahmawati',
      'nik': '3171012345670003',
      'service': 'BPJS PBI Baru',
      'time': 'Baru saja',
      'date_group': 'Hari Ini',
      'status': 'VALID',
      'isSuccess': true,
    },
    {
      'log_id': 'TX-9871239-0128-DKI',
      'name': 'Joko Supriyanto',
      'nik': '3171041908920001',
      'service': 'KTP-el Hilang',
      'time': '15 mnt lalu',
      'date_group': 'Hari Ini',
      'status': 'VALID',
      'isSuccess': true,
    },
    {
      'log_id': 'TX-9871239-0127-DKI',
      'name': 'Andi Wijaya',
      'nik': '3201082502880004',
      'service': 'Perekaman Baru',
      'time': '45 mnt lalu',
      'date_group': 'Hari Ini',
      'status': 'UID TERBACA',
      'isSuccess': false,
    },
    {
      'log_id': 'TX-9871239-0120-DKI',
      'name': 'Rini Astuti',
      'nik': '317302520002',
      'service': 'Update Alamat',
      'time': 'Kemarin',
      'date_group': 'Kemarin',
      'status': 'VALID',
      'isSuccess': true,
    },
    {
      'log_id': 'TX-9871239-0119-DKI',
      'name': 'Heru Prasetyo',
      'nik': '317109150005',
      'service': 'Aktivasi NFC',
      'time': 'Kemarin',
      'date_group': 'Kemarin',
      'status': 'VALID',
      'isSuccess': true,
    },
  ].obs;

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

  void goToNfcScan() {
    Get.toNamed('/nfc-scan');
  }

  void logout() {
    Get.offAllNamed('/login');
  }

  void resetFilters() {
    selectedTimeFilter.value = 'Semua';
    selectedStatusFilter.value = 'Semua';
    searchQuery.value = '';
  }

  List<Map<String, dynamic>> get filteredActivities {
    return recentActivities.where((item) {
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
