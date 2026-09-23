import 'package:digiktp/app/modules/auth/auth_binding.dart';
import 'package:digiktp/app/modules/auth/views/login_view.dart';
import 'package:digiktp/app/modules/auth/views/switch_posko_view.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_binding.dart';
import 'package:digiktp/app/modules/nfc_scan/views/nfc_scan_view.dart';
import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/modules/dashboard/dashboard_binding.dart';
import 'package:digiktp/app/modules/dashboard/view/dashboard_view.dart';
import 'package:digiktp/app/modules/onboarding/onboarding_binding.dart';
import 'package:digiktp/app/modules/onboarding/onboarding_controller.dart';
import 'package:digiktp/app/modules/onboarding/onboarding_view.dart';
import 'package:digiktp/app/modules/splashscreen/splash_screen.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),
    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.SWITCH_POSKO,
      page: () => const SwitchPoskoView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.NFC_SCAN,
      page: () => const NfcScanView(),
      binding: NfcScanBinding(),
    ),
  ];
}
