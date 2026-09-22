import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/modules/dashboard/widget/activity_tile.dart';

class ActivityTabView extends GetView<DashboardController> {
  const ActivityTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Pemindaian',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.help_outline_rounded, color: Color(0xFF64748B)),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) => controller.searchQuery.value = val,
                      decoration: InputDecoration(
                        hintText: 'Cari NIK atau Nama warga...',
                        hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                        prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _showFilterBottomSheet(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: const Icon(Icons.tune_rounded, color: Color(0xFF2563EB), size: 20),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              Expanded(
                child: Obx(() {
  if (controller.dashboardActivities.isEmpty) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Text('Belum ada riwayat aktivitas pemindaian hari ini.'),
      ),
    );
  }

  return ListView.separated(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    itemCount: controller.dashboardActivities.length,
    separatorBuilder: (context, index) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
      final activityItem = controller.dashboardActivities[index];
      return ActivityTile(item: activityItem); // Menggunakan widget ActivityTile milikmu!
    },
  );
})
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFilterBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Filter Riwayat', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    controller.resetFilters();
                    Get.back();
                  },
                  child: const Text('Reset', style: TextStyle(color: Colors.red)),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text('Waktu Pemindaian', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 10),
            Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ['Semua', 'Hari Ini', 'Kemarin', 'Minggu Lalu', 'Bulan Lalu'].map((time) {
                final isSelected = controller.selectedTimeFilter.value == time;
                return ChoiceChip(
                  label: Text(time),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) controller.selectedTimeFilter.value = time;
                  },
                  selectedColor: const Color(0xFFEFF6FF),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
                );
              }).toList(),
            )),
            const SizedBox(height: 20),
            const Text('Status Validasi', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 10),
            Obx(() => Wrap(
              spacing: 8,
              children: ['Semua', 'Berhasil', 'Gagal'].map((status) {
                final isSelected = controller.selectedStatusFilter.value == status;
                return ChoiceChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    if (selected) controller.selectedStatusFilter.value = status;
                  },
                  selectedColor: const Color(0xFFEFF6FF),
                  labelStyle: TextStyle(
                    color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF64748B),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  side: BorderSide(color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE2E8F0)),
                );
              }).toList(),
            )),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Get.back(),
              child: const Text('TERAPKAN FILTER', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}