import 'dart:async';
import 'dart:math' as math;

import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/modules/dashboard/view/ktp_card.dart';
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
    final time = DateTime.tryParse(activity['time']?.toString() ?? '')?.toLocal();
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
                    offset: const Offset(0, -22),
                    child: DailyStatsRow(controller: controller),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: const GovNewsSlider(),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Pilar Layanan',
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        'Pilih modul warga',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ServiceCategoryGrid(onSelect: _openService),
                  const SizedBox(height: 28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Aktivitas Terbaru',
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontSize: 20,
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
                          'Lihat Semua',
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


class KtpHero extends StatefulWidget {
  const KtpHero({super.key});

  @override
  State<KtpHero> createState() => _KtpHeroState();
}

class _KtpHeroState extends State<KtpHero> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: const Duration(seconds: 4))..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 100,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final float = math.sin(_ctrl.value * 2 * math.pi) * 3;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _PulsePainter(_ctrl.value)),
              ),
              Positioned(
                left: 22,
                top: 14 - float * 0.5,
                child: Transform.rotate(
                  angle: 0.10,
                  child: Container(
                    width: 120,
                    height: 76,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.14),
                      border: Border.all(color: Colors.white.withOpacity(0.25)),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 8,
                top: 8 + float,
                child: Transform.rotate(
                  angle: -0.12,
                  child: const MiniKtpCard(scale: 0.95),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _PulsePainter extends CustomPainter {
  _PulsePainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width * 0.5, size.height * 0.52);
    for (int i = 0; i < 3; i++) {
      final p = (t + i / 3) % 1.0;
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..color = Colors.white.withOpacity((1 - p) * 0.16);
      canvas.drawCircle(c, 50 + 80 * p, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PulsePainter old) => old.t != t;
}


class DashboardHeader extends StatelessWidget {
  const DashboardHeader({required this.controller, super.key});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Stack(
        children: [
          const Positioned(right: 10, bottom: 34, child: KtpHero()),
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 46),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.contactless_rounded, color: Colors.white, size: 18),
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NIKita',
                                style: GoogleFonts.nunito(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 0.5,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              Text(
                                'Universal Government Gateway',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.2)),
                        ),
                        child: const Icon(Icons.person_outline_rounded, color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Obx(() {
                    final name = controller.userName.value.trim();
                    final firstName = name.isEmpty ? 'Petugas' : name.split(RegExp(r'\s+')).first;
                    return Padding(
                      padding: const EdgeInsets.only(right: 130),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Halo, $firstName! 👋',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunito(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Siap melayani warga dengan senyuman hari ini?',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
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
              label: 'Total Scan',
              value: today.length.toString(),
              icon: Icons.nfc_rounded,
              tint: const Color(0xFFEFF6FF),
              iconColor: AppColors.primary,
            );
          }),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Obx(() {
            final successful = _todayActivities(controller.dashboardActivities).where((item) {
              return (item['status'] ?? '').toString().toUpperCase() == 'SUCCESS' ||
                  item['isSuccess'] == true;
            }).length;
            return _StatCard(
              label: 'Berhasil',
              value: successful.toString(),
              icon: Icons.check_circle_outline_rounded,
              tint: const Color(0xFFF0FDF4),
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
      clipBehavior: Clip.antiAlias,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            right: -22,
            bottom: -26,
            child: Icon(icon, size: 82, color: iconColor.withOpacity(0.06)),
          ),
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(color: tint, borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: GoogleFonts.nunito(
                        color: AppColors.primary,
                        fontSize: 24,
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
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
    ('Administrasi', Icons.badge_outlined, 'Administrasi Kependudukan', AppColors.primary),
    ('Kesehatan', Icons.health_and_safety_outlined, 'Layanan Kesehatan', AppColors.success),
    ('Bansos', Icons.volunteer_activism_outlined, 'Verifikasi Bantuan Sosial', Color(0xFFD97706)),
    ('Program MBG', Icons.lunch_dining_rounded, 'Pendataan Program MBG', Color(0xFFE11D48)),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _services
          .map(
            (s) => Expanded(
              child: _ServiceBubble(
                label: s.$1,
                icon: s.$2,
                color: s.$4,
                onTap: () => onSelect(s.$3),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ServiceBubble extends StatefulWidget {
  const _ServiceBubble({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_ServiceBubble> createState() => _ServiceBubbleState();
}

class _ServiceBubbleState extends State<_ServiceBubble> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final c = widget.color;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.94 : 1,
        duration: const Duration(milliseconds: 120),
        child: Column(
          children: [
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: c.withOpacity(0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: c, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              widget.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 11,
                height: 1.2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecentActivityList extends StatelessWidget {
  const RecentActivityList({required this.controller, super.key});

  final DashboardController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final latest = _todayActivities(controller.dashboardActivities).take(3).toList();

      return Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFF1F5F9)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: latest.isEmpty
            ? const _EmptyActivity()
            : Column(
                children: [
                  for (int i = 0; i < latest.length; i++) ...[
                    _ActivityRow(activity: latest[i]),
                    if (i != latest.length - 1)
                      const Divider(height: 1, thickness: 1, indent: 70, color: Color(0xFFF1F5F9)),
                  ],
                ],
              ),
      );
    });
  }
}

class _EmptyActivity extends StatelessWidget {
  const _EmptyActivity();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.nfc_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Belum ada pemindaian hari ini',
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Tempelkan e-KTP warga untuk memulai.',
                  style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.activity});

  final Map<String, dynamic> activity;

  @override
  Widget build(BuildContext context) {
    final status = (activity['status'] ?? '').toString().toUpperCase();
    final ok = status == 'SUCCESS' || activity['isSuccess'] == true;
    final accent = ok ? AppColors.success : const Color(0xFFEF4444);
    final name = (activity['name'] ?? '').toString().trim();
    final initial = name.isEmpty ? 'W' : name[0].toUpperCase();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Text(
              initial,
              style: GoogleFonts.nunito(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
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
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${activity['service'] ?? 'Layanan Warga'}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _timeOfDay(activity['time']),
                style: GoogleFonts.inter(
                  color: const Color(0xFF64748B),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    ok ? 'Berhasil' : 'Perlu Tinjauan',
                    style: GoogleFonts.inter(
                      color: accent,
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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

  String _timeOfDay(dynamic rawTime) {
    final parsed = DateTime.tryParse(rawTime?.toString() ?? '')?.toLocal();
    if (parsed == null) return '';
    return '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  }
}

class GovNewsSlider extends StatefulWidget {
  const GovNewsSlider({super.key});

  @override
  State<GovNewsSlider> createState() => _GovNewsSliderState();
}

class _GovNewsSliderState extends State<GovNewsSlider> {
  final PageController _pageController = PageController();
  Timer? _timer;
  int _currentPage = 0;

  final List<Map<String, dynamic>> _news = [
    {
      'badge': 'New Update',
      'title': 'Scan e-KTP Kini Lebih Cepat',
      'subtitle': 'Proses verifikasi data warga selesai dalam waktu kurang dari 3 detik.',
      'imageAsset': 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?q=80&w=1000&auto=format&fit=crop',
      'visual': 'ktp',
      'icon': Icons.nfc_rounded,
    },
    {
      'badge': 'Info Dukcapil',
      'title': 'Integrasi Pusat 100% Aktif',
      'subtitle': 'Sinkronisasi data kependudukan langsung dari server pusat tanpa kendala.',
      'imageAsset': 'https://images.unsplash.com/photo-1557804506-669a67965ba0?q=80&w=1000&auto=format&fit=crop',
      'visual': 'icon',
      'icon': Icons.hub_rounded,
    },
    {
      'badge': 'Keamanan Data',
      'title': 'Standar Enkripsi B2G Resmi',
      'subtitle': 'Seluruh data pemindaian dijamin aman sesuai regulasi perlindungan data.',
      'imageAsset': 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?q=80&w=1000&auto=format&fit=crop',
      'visual': 'icon',
      'icon': Icons.shield_rounded,
    },
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 6), (Timer timer) {
      if (!mounted) return;
      if (_currentPage < _news.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 175,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemCount: _news.length,
            itemBuilder: (context, index) {
              final item = _news[index];
              final isKtp = item['visual'] == 'ktp';
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      item['imageAsset'] as String,
                      fit: BoxFit.cover,
                      color: Colors.black.withOpacity(0.55),
                      colorBlendMode: BlendMode.darken,
                      errorBuilder: (_, __, ___) => const ColoredBox(color: AppColors.primary),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black87],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    if (isKtp) ...[
                      Positioned(
                        right: -20,
                        top: -10,
                        child: Icon(
                          item['icon'] as IconData,
                          size: 120,
                          color: Colors.white.withOpacity(0.07),
                        ),
                      ),
                      Positioned(
                        right: 18,
                        top: 18,
                        child: Transform.rotate(
                          angle: -0.1,
                          child: const MiniKtpCard(scale: 0.9),
                        ),
                      ),
                    ] else
                      Positioned(
                        right: -16,
                        top: -12,
                        child: Icon(
                          item['icon'] as IconData,
                          size: 130,
                          color: Colors.white.withOpacity(0.12),
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white.withOpacity(0.3)),
                              ),
                              child: Text(
                                item['badge'] as String,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item['title'] as String,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.nunito(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      item['subtitle'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.inter(
                                        color: Colors.white.withOpacity(0.8),
                                        fontSize: 11,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _news.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 4,
              width: _currentPage == index ? 16 : 6,
              decoration: BoxDecoration(
                color: _currentPage == index ? AppColors.primary : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}