import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_tab_view.dart';
import 'activity_tab_view.dart';
import 'petugas_tab_view.dart';
import 'insight_tab_view.dart';
import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => controller.handleBackAction(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        resizeToAvoidBottomInset: false,
        body: Obx(() {
          switch (controller.currentBottomNavIndex.value) {
            case 0:
              return const HomeTabView();
            case 1:
              return const InsightTabView();
            case 2:
              return const ActivityTabView();
            case 3:
              return const PetugasTabView();
            default:
              return const HomeTabView();
          }
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _ScanDockButton(
          onPressed: controller.goToNfcScan,
        ),
        bottomNavigationBar: BottomAppBar(
          height: 56, 
          color: Colors.white,
          elevation: 8,
          shape: const CircularNotchedRectangle(),
          notchMargin: 6,
          surfaceTintColor: Colors.white,
          shadowColor: Colors.black26,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              child: Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _DashboardNavItem(
                        label: 'Beranda',
                        icon: Icons.home_rounded,
                        selected: controller.currentBottomNavIndex.value == 0,
                        onTap: () => controller.changeBottomNavIndex(0),
                      ),
                    ),
                    Expanded(
                      child: _DashboardNavItem(
                        label: 'Ringkas',
                        icon: Icons.insights_rounded,
                        selected: controller.currentBottomNavIndex.value == 1,
                        onTap: () => controller.changeBottomNavIndex(1),
                      ),
                    ),
                    const SizedBox(width: 60), 
                    Expanded(
                      child: _DashboardNavItem(
                        label: 'Riwayat',
                        icon: Icons.history_rounded,
                        selected: controller.currentBottomNavIndex.value == 2,
                        onTap: () => controller.changeBottomNavIndex(2),
                      ),
                    ),
                    Expanded(
                      child: _DashboardNavItem(
                        label: 'Profil',
                        icon: Icons.person_outline_rounded,
                        selected: controller.currentBottomNavIndex.value == 3,
                        onTap: () => controller.changeBottomNavIndex(3),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashboardNavItem extends StatelessWidget {
  const _DashboardNavItem({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF1A365D) : const Color(0xFF94A3B8);
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, 
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 26),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScanDockButton extends StatelessWidget {
  const _ScanDockButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56, 
      height: 56,
      margin: const EdgeInsets.only(top: 10),
      child: Semantics(
        button: true,
        label: 'Mulai Scan e-KTP',
        child: Tooltip(
          message: 'Mulai Scan',
          child: Material(
            color: Colors.transparent,
            clipBehavior: Clip.antiAlias,
            shape: const CircleBorder(),
            elevation: 4,
            child: Ink(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFB08F), Color(0xFFFF805D), Color(0xFFED6547)],
                ),
                border: Border.all(color: Colors.white, width: 3),
              ),
              child: InkWell(
                onTap: onPressed,
                customBorder: const CircleBorder(),
                child: const Center(
                  child: Icon(
                    Icons.nfc_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}