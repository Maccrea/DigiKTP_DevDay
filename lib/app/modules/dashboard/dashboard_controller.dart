import 'package:get/get.dart';

class DashboardController extends GetxController {
  final RxInt currentBottomNavIndex = 0.obs;

  final RxString userName = 'Budi Santoso'.obs;
  final RxString userNip = 'NIP. 199408122020121002'.obs;
  final RxString activePosko = 'Kelurahan Gambir • Posko Layanan Terpadu'.obs;

  final RxInt eKtpScannedCount = 142.obs;
  final RxInt dukcapilValidCount = 138.obs;

  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'Semua'.obs;

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
    currentBottomNavIndex.value = index;
  }

  void goToNfcScan() {
    Get.toNamed('/nfc-scan');
  }

  void logout() {
    Get.offAllNamed('/login');
  }
}