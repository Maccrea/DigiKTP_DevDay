import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:digiktp/app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  void goToNextPage() {
    GetStorage().write('has_seen_onboarding', true);

    Get.offAllNamed('/login');
  }
}
