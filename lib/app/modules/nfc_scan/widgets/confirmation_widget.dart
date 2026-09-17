
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';

class ConfirmationWidget extends GetView<NfcScanController> {
  const ConfirmationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('RINGKASAN FORMULIR', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 11)),
                const Divider(height: 20),
                _rowDetail('Nama Warga', 'Siti Rahmawati'),
                _rowDetail('NIK Warga', '3171012345670003'),
                _rowDetail('UID Kartu NFC', controller.scannedUid.value),
                _rowDetail('Posko Kerja', 'Kelurahan Gambir'),
                _rowDetail('Layanan', 'Bansos BPJS PBI'),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Obx(() => CheckboxListTile(
            value: controller.isAgreed.value,
            onChanged: (val) => controller.isAgreed.value = val!,
            title: const Text('Saya menyatakan telah memvalidasi fisik kartu e-KTP warga secara langsung.', style: TextStyle(fontSize: 11)),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          )),
          const SizedBox(height: 20),
          Obx(() => SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F66F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: controller.isAgreed.value ? () => controller.goToStep(ScanStep.success) : null,
              child: const Text('KONFIRMASI & PROSES', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          )),
        ],
      ),
    );
  }

  Widget _rowDetail(String title, String val) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black54, fontSize: 12)),
          Text(val, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}