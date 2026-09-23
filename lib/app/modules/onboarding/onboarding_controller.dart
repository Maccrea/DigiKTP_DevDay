import 'package:get/get.dart';
import 'package:digiktp/app/routes/app_pages.dart';

class OnboardingController extends GetxController {
  void goToNextPage() {
    Get.offAllNamed('/login');
  }
}
