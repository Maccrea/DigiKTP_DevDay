import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';
import 'package:get/get.dart';
class NfcScanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NfcScanController>(() => NfcScanController());
  }
}