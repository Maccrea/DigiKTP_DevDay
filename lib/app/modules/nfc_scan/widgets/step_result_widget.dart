import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../nfc_scan_controller.dart';

class StepResultWidget extends GetView<NfcScanController> {
  const StepResultWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F0),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF52C41A).withOpacity(0.5)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Color(0xFF52C41A), shape: BoxShape.circle),
                  child: const Icon(Icons.check, color: Colors.white, size: 14),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CHIP e-KTP TERVALIDASI', style: TextStyle(color: Color(0xFF52C41A), fontWeight: FontWeight.bold, fontSize: 11)),
                      Obx(() => Text(
                        'UID: ${controller.scannedUid.value.isEmpty ? "E004123456789A" : controller.scannedUid.value}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('DATA WARGA (DUKCAPIL)', style: TextStyle(color: Color(0xFF8C8C8C), fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('TEREGISTRASI', style: TextStyle(color: Color(0xFF52C41A), fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                ),
                const Divider(height: 20),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 60,
                        height: 70,
                        color: Colors.red.shade700,
                        child: const Icon(Icons.person, color: Colors.white, size: 40),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Siti Rahmawati', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 2),
                          Text('NIK: 3171012345670003', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          SizedBox(height: 2),
                          Text('Tempat, Tgl Lahir: Jakarta, 12-05-1994', style: TextStyle(color: Colors.black45, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Status Hubungan', style: TextStyle(color: Colors.black45, fontSize: 12)),
                    Text('Kepala Keluarga', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Alamat e-KTP', style: TextStyle(color: Colors.black45, fontSize: 12)),
                    Text('Jl. Kebon Sirih No. 12', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFFFFBE6), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFFFD666))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Icon(Icons.warning_amber_rounded, color: Color(0xFFFAAD14), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Data Belum Terdaftar di Posko?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                      SizedBox(height: 2),
                      Text('Jika warga ini membutuhkan registrasi bantuan sosial atau verifikasi khusus posko daerah baru.', style: TextStyle(fontSize: 11, color: Colors.black54)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F66F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              onPressed: () => controller.goToStep(ScanStep.validation),
              child: const Text('VERIFIKASI & SIMPAN', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 10),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), side: const BorderSide(color: Color(0xFF2F66F6))),
              onPressed: () => controller.goToStep(ScanStep.validation),
              child: const Text('DAFTARKAN DATA BARU', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2F66F6))),
            ),
          ),
        ],
      ),
    );
  }
}