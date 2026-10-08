import 'package:digiktp/app/modules/dashboard/notification_controller.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:digiktp/app/utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationPage extends GetView<NotificationController> {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(NotificationController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(
        title: 'Notifikasi',
        extraActions: [
          Obx(() {
            final unread = controller.notifications.any(
              (item) => item.isUnread,
            );

            if (!unread) {
              return const SizedBox(width: 8);
            }

            return TextButton(
              onPressed: controller.markAllAsRead,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Baca semua',
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            );
          }),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return const _EmptyNotificationState();
          }

          return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(
              20,
              16,
              20,
              28,
            ),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final item = controller.notifications[index];

              final showDate =
                  index == 0 ||
                  item.dateGroup !=
                      controller
                          .notifications[index - 1]
                          .dateGroup;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showDate) ...[
                    if (index > 0)
                      const SizedBox(height: 18),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 2,
                        bottom: 9,
                      ),
                      child: Text(
                        item.dateGroup,
                        style: GoogleFonts.nunito(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ],
                  _NotificationCard(
                    item: item,
                    icon: controller.getIcon(item.type),
                    color: controller.getColor(item.type),
                    onTap: () {
                      controller.markAsRead(item.id);
                    },
                  ),
                ],
              );
            },
          );
        }),
      ),
    );
  }
}

class _EmptyNotificationState extends StatelessWidget {
  const _EmptyNotificationState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Tidak ada notifikasi',
              textAlign: TextAlign.center,
              style: GoogleFonts.nunito(
                color: AppColors.primary,
                fontSize: 19,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Semua informasi terbaru akan muncul di sini.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.item,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final NotificationItem item;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isUnread = item.isUnread;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isUnread
              ? color.withOpacity(0.22)
              : AppColors.border.withOpacity(0.7),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          splashColor: color.withOpacity(0.05),
          highlightColor: color.withOpacity(0.025),
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _NotificationIcon(
                  icon: icon,
                  color: color,
                  isUnread: isUnread,
                ),
                const SizedBox(width: 13),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              maxLines: 2,
                              overflow:
                                  TextOverflow.ellipsis,
                              style: GoogleFonts.nunito(
                                color:
                                    AppColors.textPrimary,
                                fontSize: 14,
                                height: 1.2,
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 7,
                              height: 7,
                              margin:
                                  const EdgeInsets.only(
                                top: 4,
                              ),
                              decoration:
                                  const BoxDecoration(
                                color: AppColors.accent,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.subtitle,
                        maxLines: 3,
                        overflow:
                            TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color:
                              AppColors.textSecondary,
                          fontSize: 11.5,
                          height: 1.45,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 9),
                      Text(
                        item.time,
                        style: GoogleFonts.inter(
                          color:
                              AppColors.textSecondary
                                  .withOpacity(0.75),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationIcon extends StatelessWidget {
  const _NotificationIcon({
    required this.icon,
    required this.color,
    required this.isUnread,
  });

  final IconData icon;
  final Color color;
  final bool isUnread;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(
              isUnread ? 0.11 : 0.07,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        if (isUnread)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
