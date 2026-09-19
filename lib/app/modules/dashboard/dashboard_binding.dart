import 'package:get/get.dart';
import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(
      () => DashboardController(),
    );
  }
}