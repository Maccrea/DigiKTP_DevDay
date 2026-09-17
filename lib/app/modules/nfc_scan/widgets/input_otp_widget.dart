import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';

class InputOtpWidget extends GetView<NfcScanController> {
  const InputOtpWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( 
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text('Masukkan Kode OTP', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Silakan masukkan 6 digit kode yang telah dikirimkan.', style: TextStyle(color: Colors.black54, fontSize: 12)),
          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(6, (index) {
              return SizedBox(
                width: 45,
                height: 50,
                child: TextField(
                  controller: controller.otpControllers[index],
                  focusNode: controller.otpFocusNodes[index],
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  maxLength: 1,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  decoration: InputDecoration(
                    counterText: '',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onChanged: (val) {
                    if (val.isNotEmpty && index < 5) {
                      controller.otpFocusNodes[index + 1].requestFocus();
                    } else if (val.isEmpty && index > 0) {
                      controller.otpFocusNodes[index - 1].requestFocus();
                    }
                  },
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          const Text('Kirim Ulang Kode (01:45)', style: TextStyle(color: Color(0xFF2F66F6), fontWeight: FontWeight.bold, fontSize: 12)),
          
          const SizedBox(height: 40), // Ganti Spacer() dengan SizedBox agar tidak error di SingleChildScrollView

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F66F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => controller.goToStep(ScanStep.confirmation),
              child: const Text('VERIFIKASI & SIMPAN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}