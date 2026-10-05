import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/modules/dashboard/widget/activity_tile.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTabView extends GetView<DashboardController> {
  const ActivityTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 18, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Riwayat layanan',
                          style: GoogleFonts.nunito(
                            color: AppColors.primary,
                            fontSize: 23,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Catatan pemindaian warga',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Muat ulang',
                    onPressed: controller.loadLayananLogs,
                    icon: const Icon(Icons.refresh_rounded),
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Obx(() {
                final total = controller.dashboardActivities.length;
                final successful = controller.dukcapilValidCount;
                return Row(
                  children: [
                    Expanded(
                      child: _HistoryMetric(
                        label: 'Total',
                        value: total.toString(),
                        icon: Icons.receipt_long_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: _HistoryMetric(
                        label: 'Berhasil',
                        value: successful.toString(),
                        icon: Icons.check_circle_outline_rounded,
                        color: AppColors.success,
                      ),
                    ),
                  ],
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 15, 22, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => controller.searchQuery.value = value,
                      style: GoogleFonts.inter(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Cari nama atau NIK',
                        prefixIcon: const Icon(Icons.search_rounded, size: 20),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 9),
                  Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    child: InkWell(
                      onTap: () => _showFilters(context),
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Icon(
                          Icons.tune_rounded,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Obx(() {
                final activities = controller.filteredActivities;
                if (activities.isEmpty) {
                  return _EmptyHistory(
                    isLoading: controller.isLoading.value,
                    hasQuery: controller.searchQuery.value.isNotEmpty ||
                        controller.selectedStatusFilter.value != 'Semua' ||
                        controller.selectedTimeFilter.value != 'Semua',
                    onRefresh: controller.loadLayananLogs,
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadLayananLogs,
                  color: AppColors.primary,
                  child: ListView.separated(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(22, 2, 22, 28),
                    itemCount: activities.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 9),
                    itemBuilder: (context, index) => ActivityTile(
                      item: Map<String, dynamic>.from(activities[index]),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilters(BuildContext context) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(22, 12, 22, 24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Filter riwayat',
              style: GoogleFonts.nunito(
                color: AppColors.primary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            _FilterGroup(
              title: 'Waktu',
              options: const ['Semua', 'Hari Ini', 'Kemarin'],
              selected: controller.selectedTimeFilter,
            ),
            const SizedBox(height: 17),
            _FilterGroup(
              title: 'Status',
              options: const ['Semua', 'Berhasil', 'Gagal'],
              selected: controller.selectedStatusFilter,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: Get.back,
                child: const Text('Terapkan'),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

class _HistoryMetric extends StatelessWidget {
  const _HistoryMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.nunito(
              color: AppColors.primary,
              fontSize: 19,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterGroup extends StatelessWidget {
  const _FilterGroup({
    required this.title,
    required this.options,
    required this.selected,
  });

  final String title;
  final List<String> options;
  final RxString selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Wrap(
            spacing: 7,
            runSpacing: 7,
            children: options.map((option) {
              final isSelected = selected.value == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (_) => selected.value = option,
                showCheckmark: false,
                selectedColor: const Color(0xFFEAF0F8),
                backgroundColor: Colors.white,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
                labelStyle: GoogleFonts.inter(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({
    required this.isLoading,
    required this.hasQuery,
    required this.onRefresh,
  });

  final bool isLoading;
  final bool hasQuery;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppColors.primary,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(32),
        children: [
          const SizedBox(height: 45),
          Icon(
            isLoading
                ? Icons.sync_rounded
                : hasQuery
                ? Icons.search_off_rounded
                : Icons.receipt_long_outlined,
            size: 38,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 12),
          Text(
            isLoading
                ? 'Memuat riwayat'
                : hasQuery
                ? 'Tidak ada hasil'
                : 'Belum ada transaksi',
            textAlign: TextAlign.center,
            style: GoogleFonts.nunito(
              color: AppColors.primary,
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}