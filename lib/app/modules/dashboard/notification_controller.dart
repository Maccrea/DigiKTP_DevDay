import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/theme/app_colors.dart';

enum NotifType { success, info, error, warning }

class NotificationItem {
  final String id;
  final String title;
  final String subtitle;
  final String time;
  final String dateGroup;
  final NotifType type;
  bool isUnread;

  NotificationItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.dateGroup,
    required this.type,
    this.isUnread = true,
  });
}

class NotificationController extends GetxController {
  final RxList<NotificationItem> notifications = <NotificationItem>[
    NotificationItem(
      id: '1',
      dateGroup: 'Hari Ini',
        title: 'Tips pemindaian NFC',
        subtitle:
          'Lepas case tebal dan tahan e-KTP di area NFC sampai data terkonfirmasi.',
        time: '08:30',
        type: NotifType.info,
      isUnread: true,
    ),
    NotificationItem(
      id: '2',
      dateGroup: 'Hari Ini',
        title: 'Jadwal pemeliharaan',
        subtitle:
          '12 Oktober, 23.00–01.00 WIB. Beberapa layanan mungkin terasa lebih lambat.',
        time: '07:15',
      type: NotifType.info,
      isUnread: true,
    ),
    NotificationItem(
      id: '3',
      dateGroup: 'Kemarin',
        title: 'Pengingat keamanan',
        subtitle:
          'Periksa kecocokan data dan status verifikasi sebelum meneruskan layanan.',
        time: 'Kemarin',
        type: NotifType.warning,
      isUnread: false,
    ),
    NotificationItem(
      id: '4',
      dateGroup: 'Kemarin',
        title: 'Terima kasih, petugas',
        subtitle:
          'Terima kasih sudah membantu warga mendapatkan layanan yang lebih mudah.',
        time: 'Kemarin',
        type: NotifType.success,
      isUnread: false,
    ),
  ].obs;

  void markAllAsRead() {
    for (var i = 0; i < notifications.length; i++) {
      notifications[i].isUnread = false;
    }
    notifications.refresh();
  }

  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1 && notifications[index].isUnread) {
      notifications[index].isUnread = false;
      notifications.refresh();
    }
  }

  IconData getIcon(NotifType type) {
    switch (type) {
      case NotifType.success:
        return Icons.check_circle_rounded;
      case NotifType.info:
        return Icons.mark_email_read_rounded;
      case NotifType.error:
        return Icons.error_rounded;
      case NotifType.warning:
        return Icons.sync_rounded;
    }
  }

  Color getColor(NotifType type) {
    switch (type) {
      case NotifType.success:
        return AppColors.success;
      case NotifType.info:
        return AppColors.primary;
      case NotifType.error:
        return AppColors.danger;
      case NotifType.warning:
        return AppColors.warning;
    }
  }
}
