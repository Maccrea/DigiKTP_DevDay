import 'package:digiktp/app/modules/auth/auth_binding.dart';
import 'package:digiktp/app/modules/auth/views/login_view.dart';
import 'package:digiktp/app/modules/auth/views/switch_posko_view.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_binding.dart';
import 'package:digiktp/app/modules/nfc_scan/views/nfc_scan_view.dart';

import 'package:get/get.dart';
import 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.NFC_SCAN;

  static final routes = [
    // GetPage(
    //   name: Routes.ONBOARDING,
    //   page: () => const OnboardingView(),
    //   binding: OnboardingBinding(),
    // ),
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
    // GetPage(
    //   name: Routes.DASHBOARD,
    //   page: () => const DashboardView(),
    //   binding: DashboardBinding(),
    // ),
    GetPage(
      name: Routes.NFC_SCAN,
      page: () => const NfcScanView(),
      binding: NfcScanBinding(),
    ),
    // GetPage(
    //   name: Routes.OTP_CHANNEL,
    //   page: () => const OtpChannelView(),
    //   binding: OtpBinding(),
    // ),
    // GetPage(
    //   name: Routes.OTP_INPUT,
    //   page: () => const OtpInputView(),
    //   binding: OtpBinding(),
    // ),
    // GetPage(
    //   name: Routes.DATA_UNLOCKED,
    //   page: () => const DataUnlockedView(),
    //   binding: OtpBinding(),
    // ),
    // GetPage(
    //   name: Routes.SERVICE_FORM,
    //   page: () => const FormLayananView(),
    //   binding: ServiceFormBinding(),
    // ),
    // GetPage(
    //   name: Routes.CONFIRM_SUBMISSION,
    //   page: () => const KonfirmasiPengajuanView(),
    //   binding: ServiceFormBinding(),
    // ),
    // GetPage(
    //   name: Routes.SUCCESS_RESULT,
    //   page: () => const SuccessResultView(),
    //   binding: SuccessResultBinding(),
    // ),
    // GetPage(
    //   name: Routes.AUDIT_HISTORY,
    //   page: () => const LogHistoryView(),
    //   binding: AuditLogBinding(),
    // ),
    // GetPage(
    //   name: Routes.AUDIT_DETAIL,
    //   page: () => const LogDetailView(),
    //   binding: AuditLogBinding(),
    // ),
  ];
}