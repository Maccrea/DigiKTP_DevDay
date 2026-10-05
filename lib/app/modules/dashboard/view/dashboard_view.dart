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
          height: 80,
          color: Colors.white,
          elevation: 12,
          shape: const CircularNotchedRectangle(),
          notchMargin: 8,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
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
                    const SizedBox(width: 72),
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
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 21),
              const SizedBox(height: 2),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: color,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 10,
                ),
              ),
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
    return Semantics(
      button: true,
      label: 'Mulai Scan e-KTP',
      child: Tooltip(
        message: 'Mulai Scan',
        child: Material(
          color: Colors.transparent,
          shape: const CircleBorder(),
          child: Ink(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFB08F), Color(0xFFFF805D), Color(0xFFED6547)],
              ),
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55FF805D),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
                BoxShadow(
                  color: Color(0x241A365D),
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: InkWell(
              onTap: onPressed,
              customBorder: const CircleBorder(),
              child: const Center(
                child: Icon(
                  Icons.nfc_rounded,
                  color: Colors.white,
                  size: 29,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}