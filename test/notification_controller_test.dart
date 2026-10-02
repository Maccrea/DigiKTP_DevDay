import 'package:digiktp/app/modules/dashboard/notification_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.reset();
  });

  test('marks unread notifications as read', () {
    final controller = NotificationController();

    expect(controller.notifications.where((item) => item.isUnread), isNotEmpty);

    controller.markAllAsRead();

    expect(controller.notifications.every((item) => !item.isUnread), isTrue);
  });
}
