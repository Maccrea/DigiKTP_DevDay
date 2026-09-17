import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';

class PromptWidget extends GetView<NfcScanController> {
  const PromptWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade200, width: 1.5),
            ),
            child: Column(
              children: const [
                Icon(Icons.wifi, size: 48, color: Color(0xFF2F66F6)),
                SizedBox(height: 16),
                Text('Tempelkan e-KTP di Belakang HP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 6),
                Text('Rapatkan chip KTP pada area sensor NFC', style: TextStyle(color: Colors.black45, fontSize: 12)),
              ],
            ),
          ),
          
          const SizedBox(height: 32), 

          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: const Color(0xFFEFF4FF), borderRadius: BorderRadius.circular(12)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Panduan Sensor NFC:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF2F66F6))),
                SizedBox(height: 6),
                Text('1. Pastikan fitur NFC pada e-KTP bersih.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                SizedBox(height: 2),
                Text('2. Lepaskan casing tebal jika KTP tidak terdeteksi.', style: TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F66F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: controller.isScanning.value ? null : () => controller.startNfcSession(),
              onLongPress: () => controller.bypassScan(), 
              icon: controller.isScanning.value
                  ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.contactless, color: Colors.white),
              label: Text(
                controller.isScanning.value ? 'MENUNGGU KTP...' : 'MULAI PEMINDAIAN',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          )),
        ],
      ),
    );
  }
}