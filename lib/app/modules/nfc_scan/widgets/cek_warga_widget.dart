import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../nfc_scan_controller.dart';

class CekWargaWidget extends GetView<NfcScanController> {
  const CekWargaWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Cocokkan dengan NIK warga',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masukkan NIK untuk memastikan kartu ini milik warga yang benar.',
            style: TextStyle(
              fontSize: 12,
              height: 1.4,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: controller.nikController,
            autofocus: true,
            maxLength: 20,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            onChanged: (value) {
              controller.nikDigitCount.value =
                  value.replaceAll(RegExp(r'[^0-9]'), '').length;
            },
            onSubmitted: (_) => controller.cekWargaApi(),
            decoration: InputDecoration(
              labelText: 'Nomor Induk Kependudukan',
              hintText: 'Masukkan 16 digit NIK',
              prefixIcon: const Icon(Icons.badge_outlined),
              counterText: '',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
            ),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.only(top: 6, left: 4),
              child: Text(
                '${controller.nikDigitCount.value}/16 digit',
                style: TextStyle(
                  fontSize: 12,
                  color: controller.nikDigitCount.value == 16
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.cekWargaApi,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: controller.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'CEK DATA WARGA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
