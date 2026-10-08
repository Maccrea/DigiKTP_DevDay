import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class InsightTabView extends GetView<DashboardController> {
  const InsightTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          final activities = controller.dashboardActivities.toList();

          final now = DateTime.now();

          final today = activities
              .where((item) => _isSameDay(item, now))
              .toList();

          final todaySuccess = today.where(_isSuccess).length;

          final successRatio = today.isEmpty
              ? 0.0
              : todaySuccess / today.length;

          final lastSevenDays = List.generate(
            7,
            (index) => DateTime(now.year, now.month, now.day - 6 + index),
          );

          final dailyCounts = lastSevenDays
              .map(
                (day) =>
                    activities.where((item) => _isSameDay(item, day)).length,
              )
              .toList();

          final maxDailyCount = dailyCounts.fold<int>(
            0,
            (max, count) => count > max ? count : max,
          );

          final serviceCounts = _serviceCounts(activities);

          return RefreshIndicator(
            onRefresh: controller.loadLayananLogs,
            color: AppColors.primary,
            backgroundColor: Colors.white,
            displacement: 24,
            strokeWidth: 2.5,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan',
                    style: GoogleFonts.nunito(
                      color: AppColors.primary,
                      fontSize: 25,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Aktivitas layanan warga',
                    style: GoogleFonts.inter(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _TodayOverview(
                    total: today.length,
                    successful: todaySuccess,
                    successRatio: successRatio,
                  ),
                  const SizedBox(height: 24),
                  _SectionHeading(title: '7 hari terakhir'),
                  const SizedBox(height: 12),
                  _WeeklyActivityChart(
                    days: lastSevenDays,
                    counts: dailyCounts,
                    maxCount: maxDailyCount,
                  ),
                  const SizedBox(height: 24),
                  _SectionHeading(title: 'Layanan teratas'),
                  const SizedBox(height: 12),
                  _ServiceBreakdown(items: serviceCounts),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  bool _isSameDay(Map<String, dynamic> item, DateTime date) {
    final createdAt = DateTime.tryParse(
      item['time']?.toString() ?? '',
    )?.toLocal();

    return createdAt != null &&
        createdAt.year == date.year &&
        createdAt.month == date.month &&
        createdAt.day == date.day;
  }

  bool _isSuccess(Map<String, dynamic> item) {
    return (item['status'] ?? '').toString().toUpperCase() == 'SUCCESS' ||
        item['isSuccess'] == true;
  }

  List<MapEntry<String, int>> _serviceCounts(
    List<Map<String, dynamic>> activities,
  ) {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));

    final counts = <String, int>{};

    for (final item in activities) {
      final createdAt = DateTime.tryParse(
        item['time']?.toString() ?? '',
      )?.toLocal();

      if (createdAt == null || createdAt.isBefore(cutoff)) {
        continue;
      }

      final service = (item['service'] ?? 'Layanan lainnya').toString().trim();

      counts.update(service, (count) => count + 1, ifAbsent: () => 1);
    }

    final result = counts.entries.toList()
      ..sort((left, right) => right.value.compareTo(left.value));

    return result.take(3).toList();
  }
}

class _TodayOverview extends StatelessWidget {
  const _TodayOverview({
    required this.total,
    required this.successful,
    required this.successRatio,
  });

  final int total;
  final int successful;
  final double successRatio;

  @override
  Widget build(BuildContext context) {
    final percentage = (successRatio * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.18),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HARI INI',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.65),
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '$total',
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 42,
                    height: 1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'pemindaian',
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF72DED2),
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$successful berhasil',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 86,
            height: 86,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: successRatio,
                  strokeWidth: 7,
                  strokeCap: StrokeCap.round,
                  backgroundColor: Colors.white.withOpacity(0.16),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFFFA483),
                  ),
                ),
                Center(
                  child: Text(
                    '$percentage%',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.nunito(
        color: AppColors.primary,
        fontSize: 18,
        fontWeight: FontWeight.w800,
      ),
    );
  }
}

class _WeeklyActivityChart extends StatelessWidget {
  const _WeeklyActivityChart({
    required this.days,
    required this.counts,
    required this.maxCount,
  });

  final List<DateTime> days;
  final List<int> counts;
  final int maxCount;

  static const _weekdayLabels = [
    'Min',
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 112,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(days.length, (index) {
                final count = counts[index];

                final barHeight = maxCount == 0
                    ? 5.0
                    : 10 + (count / maxCount) * 62;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (count > 0)
                        Text(
                          '$count',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      const SizedBox(height: 5),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 18,
                        height: barHeight,
                        decoration: BoxDecoration(
                          color: index == days.length - 1
                              ? AppColors.accent
                              : const Color(0xFFDCE8F2),
                          borderRadius: BorderRadius.circular(9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _weekdayLabels[days[index].weekday % 7],
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
          if (maxCount == 0) ...[
            const SizedBox(height: 10),
            Text(
              'Aktivitas akan muncul setelah pemindaian pertama.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _ServiceBreakdown extends StatelessWidget {
  const _ServiceBreakdown({required this.items});

  final List<MapEntry<String, int>> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          'Belum ada data layanan minggu ini.',
          style: GoogleFonts.inter(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      );
    }

    final maxCount = items.first.value;

    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          if (index > 0) const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        items[index].key,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Text(
                      '${items[index].value}',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: LinearProgressIndicator(
                    value: items[index].value / maxCount,
                    minHeight: 6,
                    backgroundColor: const Color(0xFFEAF0F8),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      index == 0 ? AppColors.accent : AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
