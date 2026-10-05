import 'dart:async';

import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/modules/dashboard/view/service_detail_view.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

List<Map<String, dynamic>> _todayActivities(
  Iterable<Map<String, dynamic>> activities,
) {
  final now = DateTime.now();
  return activities.where((activity) {
    final time = DateTime.tryParse(activity['time']?.toString() ?? '')
        ?.toLocal();
    return time != null &&
        time.year == now.year &&
        time.month == now.month &&
        time.day == now.day;
  }).toList();
}

class HomeTabView extends GetView<DashboardController> {
  const HomeTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DashboardHeader(controller: controller),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Transform.translate(
                    offset: const Offset(0, -18),
                    child: DailyStatsRow(controller: controller),
                  ),
                  const AnnouncementCarousel(),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Layanan',
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Pilih kebutuhan warga',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 11),
                  ServiceCategoryGrid(onSelect: _openService),
                  const SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aktivitas terbaru',
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => controller.changeBottomNavIndex(2),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        iconAlignment: IconAlignment.end,
                        icon: const Icon(Icons.arrow_forward_rounded, size: 15),
                        label: Text(
                          'Semua',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RecentActivityList(controller: controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openService(String serviceName) {
    Get.to(() => ServiceDetailView(serviceName: serviceName));
  }
}

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.controller, super.key});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 19, 24, 35),
          child: Row(
            children: [
              Expanded(
                child: Obx(() {
                  final name = controller.userName.value.trim();
                  final firstName = name.isEmpty
                      ? 'Teman'
                      : name.split(RegExp(r'\s+')).first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Halo, $firstName!',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.nunito(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Layanan warga hari ini',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.78),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(width: 14),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.28)),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: Colors.white,
                  size: 25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DailyStatsRow extends StatelessWidget {
  const DailyStatsRow({required this.controller, super.key});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Obx(() {
            final today = _todayActivities(controller.dashboardActivities);
            return _StatCard(
              label: 'Total scan',
              value: today.length.toString(),
              icon: Icons.nfc_rounded,
              tint: const Color(0xFFEAF0F8),
              iconColor: AppColors.primary,
            );
          }),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Obx(() {
            final successful = _todayActivities(
              controller.dashboardActivities,
            ).where((item) {
              return (item['status'] ?? '').toString().toUpperCase() ==
                      'SUCCESS' ||
                  item['isSuccess'] == true;
            }).length;
            return _StatCard(
              label: 'Berhasil',
              value: successful.toString(),
              icon: Icons.check_circle_outline_rounded,
              tint: const Color(0xFFE9F5F1),
              iconColor: AppColors.success,
            );
          }),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.tint,
    required this.iconColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color tint;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 86),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: tint,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 19),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.nunito(
                    color: AppColors.primary,
                    fontSize: 22,
                    height: 1,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
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

class AnnouncementCarousel extends StatefulWidget {
  const AnnouncementCarousel({super.key});

  @override
  State<AnnouncementCarousel> createState() => _AnnouncementCarouselState();
}

class _AnnouncementCarouselState extends State<AnnouncementCarousel> {
  static const _announcements = [
    _Announcement(
      category: 'Jadwal layanan',
      title: 'Pemeliharaan server',
      body: '12 Oktober, 23.00–01.00 WIB. Pemindaian mungkin terasa lebih lambat.',
      icon: Icons.construction_rounded,
      accent: AppColors.accent,
    ),
    _Announcement(
      category: 'Tips petugas',
      title: 'Scan lebih lancar',
      body: 'Lepas case tebal, tempel kartu di area NFC, lalu tahan sampai terkonfirmasi.',
      icon: Icons.lightbulb_outline_rounded,
      accent: AppColors.secondary,
    ),
    _Announcement(
      category: 'Apresiasi posko',
      title: 'Terima kasih, petugas!',
      body: 'Ketelitianmu membantu warga mendapat layanan yang lebih mudah dan nyaman.',
      icon: Icons.emoji_events_outlined,
      accent: Color(0xFFBD7A35),
    ),
    _Announcement(
      category: 'Pengingat keamanan',
      title: 'Pastikan chip tervalidasi',
      body: 'Cocokkan data di layar dan lanjutkan setelah verifikasi server berhasil.',
      icon: Icons.verified_user_outlined,
      accent: AppColors.success,
    ),
  ];

  final _pageController = PageController();
  Timer? _autoAdvanceTimer;
  int _activePage = 0;

  @override
  void initState() {
    super.initState();
    _autoAdvanceTimer = Timer.periodic(const Duration(seconds: 7), (_) {
      if (!mounted || !_pageController.hasClients) return;
      _pageController.animateToPage(
        (_activePage + 1) % _announcements.length,
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _autoAdvanceTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 158,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _announcements.length,
            onPageChanged: (index) => setState(() => _activePage = index),
            itemBuilder: (context, index) => _AnnouncementCard(
              announcement: _announcements[index],
              page: index + 1,
              pageCount: _announcements.length,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _announcements.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: index == _activePage ? 18 : 6,
              height: 5,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: index == _activePage
                    ? AppColors.primary
                    : AppColors.border,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _Announcement {
  const _Announcement({
    required this.category,
    required this.title,
    required this.body,
    required this.icon,
    required this.accent,
  });

  final String category;
  final String title;
  final String body;
  final IconData icon;
  final Color accent;
}

class _AnnouncementCard extends StatelessWidget {
  const _AnnouncementCard({
    required this.announcement,
    required this.page,
    required this.pageCount,
  });

  final _Announcement announcement;
  final int page;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 2),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x101A365D),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(width: 4, color: announcement.accent),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 13, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                color: announcement.accent.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                announcement.icon,
                                color: announcement.accent,
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                announcement.category,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              '$page/$pageCount',
                              style: GoogleFonts.inter(
                                color: AppColors.textSecondary,
                                fontSize: 9,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Text(
                          announcement.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.nunito(
                            color: AppColors.primary,
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          announcement.body,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      announcement.icon,
                      color: AppColors.primary,
                      size: 21,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceCategoryGrid extends StatelessWidget {
  const ServiceCategoryGrid({required this.onSelect, super.key});

  final ValueChanged<String> onSelect;

  static const _services = [
    ('Administrasi', Icons.badge_outlined, 'Administrasi Kependudukan'),
    ('Kesehatan', Icons.health_and_safety_outlined, 'Layanan Kesehatan'),
    ('Bansos', Icons.volunteer_activism_outlined, 'Verifikasi Bantuan Sosial'),
    ('Program MBG', Icons.lunch_dining_rounded, 'Pendataan Program MBG'),
  ];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _services.map((service) {
        return SizedBox(
          width: (MediaQuery.sizeOf(context).width - 58) / 2,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => onSelect(service.$3),
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EC),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Icon(service.$2, color: AppColors.accent, size: 20),
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        service.$1,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({required this.controller, super.key});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final latest = _todayActivities(controller.dashboardActivities)
          .take(3)
          .toList();
      if (latest.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              const Icon(Icons.history_rounded, color: AppColors.textSecondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Belum ada pemindaian hari ini.',
                  style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12),
                ),
              ),
            ],
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: latest.length,
        separatorBuilder: (context, index) => const SizedBox(height: 8),
        itemBuilder: (context, index) => _RecentActivityTile(activity: latest[index]),
      );
    });
  }
}

class _RecentActivityTile extends StatelessWidget {
  const _RecentActivityTile({required this.activity});

  final Map<String, dynamic> activity;

  @override
  Widget build(BuildContext context) {
    final status = (activity['status'] ?? '').toString().toUpperCase();
    final succeeded = status == 'SUCCESS' || activity['isSuccess'] == true;
    final name = (activity['name'] ?? '').toString().trim();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              color: succeeded ? const Color(0xFFE9F5F1) : const Color(0xFFFFF2E8),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              succeeded ? Icons.check_rounded : Icons.priority_high_rounded,
              color: succeeded ? AppColors.success : const Color(0xFFB86D31),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _maskName(name),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${activity['service'] ?? 'Layanan warga'} · ${succeeded ? 'Berhasil' : 'Perlu ditinjau'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(_relativeTime(activity['time']), style: GoogleFonts.inter(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w600)),
              Text(_timeOfDay(activity['time']), style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 9)),
            ],
          ),
        ],
      ),
    );
  }

  String _maskName(String name) {
    if (name.isEmpty) return 'Warga';
    final parts = name.split(RegExp(r'\s+'));
    return parts.length == 1 ? '${parts.first[0]}***' : '${parts.first[0]}*** ${parts.last}';
  }

  String _relativeTime(dynamic rawTime) {
    final parsed = DateTime.tryParse(rawTime?.toString() ?? '')?.toLocal();
    if (parsed == null) return 'Baru';
    final difference = DateTime.now().difference(parsed);
    if (difference.inMinutes < 1) return 'Baru';
    if (difference.inHours < 1) return '${difference.inMinutes} mnt';
    return '${difference.inHours} jam';
  }

  String _timeOfDay(dynamic rawTime) {
    final parsed = DateTime.tryParse(rawTime?.toString() ?? '')?.toLocal();
    if (parsed == null) return '';
    return '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  }
}