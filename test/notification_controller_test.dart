import 'package:digiktp/app/modules/dashboard/notification_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  test('adds success notification from service log payload', () {
    final controller = NotificationController();
    controller.notifications.clear();

    controller.addLogNotification(
      log: {
        'id_log': 'LOG-9001',
        'status_transaksi': 'SUCCESS',
        'created_at': '2026-09-22T10:45:00',
      },
      warga: {'nama_lengkap': 'Siti Rahmawati'},
    );

    expect(controller.notifications.length, 1);
    expect(controller.notifications.first.title, 'Verifikasi Berhasil');
    expect(controller.notifications.first.isUnread, isTrue);
    expect(controller.unreadCount.value, 1);
  });
}
