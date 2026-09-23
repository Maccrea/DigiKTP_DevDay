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
              selectedItemColor: const Color(0xFF2563EB),
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
