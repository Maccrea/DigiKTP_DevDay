import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_tab_view.dart';
import 'activity_tab_view.dart';
import 'petugas_tab_view.dart';
import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool exitApp = controller.handleBackAction();
        return exitApp;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF1F5F9),
        body: Obx(() {
          if (controller.isLoading.value && controller.dashboardActivities.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(color: Color(0xFF030164)),
                  SizedBox(height: 16),
                  Text(
                    'Memuat data posko & riwayat...',
                    style: TextStyle(
                      color: Color(0xFF64748B),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.errorMessage.isNotEmpty && controller.dashboardActivities.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.orange),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Color(0xFF334155), fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF030164)),
                      onPressed: () => controller.loadLayananLogs(),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            );
          }

          switch (controller.currentBottomNavIndex.value) {
            case 0:
              return const HomeTabView();
            case 1:
              return const ActivityTabView();
            case 2:
              return const PetugasTabView();
            default:
              return const HomeTabView();
          }
        }),

        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Obx(
            () => BottomNavigationBar(
              currentIndex: controller.currentBottomNavIndex.value,
              onTap: (index) => controller.changeBottomNavIndex(index),
              backgroundColor: Colors.white,
              selectedItemColor: const Color(0xFF030164),
              unselectedItemColor: const Color(0xFF94A3B8),
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history_rounded),
                  label: 'Aktivitas',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  label: 'Petugas',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}