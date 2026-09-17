import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/nfc_scan/nfc_scan_controller.dart';

class SuccessWidget extends GetView<NfcScanController> {
  const SuccessWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFF52C41A),
            child: Icon(Icons.check, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 16),
          const Text('Pencatatan Audit Sukses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text(
            'Data transaksi pembacaan chip telah dienkripsi penuh dan diteruskan ke database server.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('RESI PEMINDAIAN', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 10)),
                    Text('TERKIRIM', style: TextStyle(color: Color(0xFF52C41A), fontWeight: FontWeight.bold, fontSize: 10)),
                  ],
                ),
                const Divider(height: 16),
                const Text('NOMOR REFERENSI AUDIT', style: TextStyle(fontSize: 10, color: Colors.grey)),
                const Text('TX-9871239-0129-DKI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F66F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => Get.back(), // Mengarahkan kembali ke dashboard
              child: const Text('KEMBALI KE DASHBOARD', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}