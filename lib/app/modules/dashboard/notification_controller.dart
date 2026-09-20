import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      title: 'Verifikasi Berhasil',
      subtitle: 'E-KTP atas nama Siti Rahmawati telah berhasil diverifikasi dan direkam sistem.',
      time: '10:45 WIB',
      type: NotifType.success,
      isUnread: true,
    ),
    NotificationItem(
      id: '2',
      dateGroup: 'Hari Ini',
      title: 'OTP Terkirim',
      subtitle: 'Kode OTP untuk verifikasi data telah dikirimkan ke email sitirahmawati@gmail.com.',
      time: '10:40 WIB',
      type: NotifType.info,
      isUnread: true,
    ),
    NotificationItem(
      id: '3',
      dateGroup: 'Kemarin',
      title: 'Pemindaian Gagal',
      subtitle: 'Chip NFC KTP atas nama Budi Santoso gagal terbaca. Pastikan KTP tidak terhalang case.',
      time: '14:20 WIB',
      type: NotifType.error,
      isUnread: false,
    ),
    NotificationItem(
      id: '4',
      dateGroup: 'Kemarin',
      title: 'Sinkronisasi Data Tertunda',
      subtitle: 'Data 5 warga belum disinkronkan ke server pusat. Ketuk untuk menyinkronkan ulang.',
      time: '09:15 WIB',
      type: NotifType.warning,
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
      case NotifType.success: return Icons.check_circle_rounded;
      case NotifType.info: return Icons.mark_email_read_rounded;
      case NotifType.error: return Icons.error_rounded;
      case NotifType.warning: return Icons.sync_rounded;
    }
  }

  Color getColor(NotifType type) {
    switch (type) {
      case NotifType.success: return const Color(0xFF10B981);
      case NotifType.info: return const Color(0xFF3B82F6);
      case NotifType.error: return const Color(0xFFEF4444);
      case NotifType.warning: return const Color(0xFFF59E0B);
    }
  }
}