import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../nfc_scan_controller.dart';

class StepValidationWidget extends GetView<NfcScanController> {
  const StepValidationWidget({Key? key}) : super(key: key);

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
                      const Text('CHIP E-KTP TERVERIFIKASI', style: TextStyle(color: Color(0xFF52C41A), fontWeight: FontWeight.bold, fontSize: 11)),
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
                const Text('BIODATA PETUGAS TERKAIT', style: TextStyle(color: Color(0xFF8C8C8C), fontWeight: FontWeight.bold, fontSize: 11)),
                const Divider(height: 20),
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        width: 55,
                        height: 65,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.person, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Siti Rahmawati', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 2),
                          Text('NIK: 317101******0003', style: TextStyle(color: Colors.black54, fontSize: 12)),
                          SizedBox(height: 2),
                          Text('Gambir, Jakarta Pusat', style: TextStyle(color: Colors.black45, fontSize: 11)),
                        ],
                      ),
                    ),
                  ],
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
                const Text('PILIH NOMOR TELEPON AKTIF', style: TextStyle(color: Color(0xFF8C8C8C), fontWeight: FontWeight.bold, fontSize: 11)),
                const SizedBox(height: 6),
                const Text('Untuk keamanan nasional, kode OTP akan dikirimkan ke salah satu nomor yang terdaftar.', style: TextStyle(color: Colors.black54, fontSize: 11, height: 1.3)),
                const SizedBox(height: 14),

                Obx(() => _buildContactOption(
                  index: 0,
                  title: 'sitirahmawaty@gmail.com',
                  subtitle: 'SMS Telekomunikasi Indonesia (Utama)',
                  selectedIndex: controller.selectedContact.value,
                  onTap: () => controller.selectedContact.value = 0,
                )),
                const SizedBox(height: 8),

                Obx(() => _buildContactOption(
                  index: 1,
                  title: 'rahma@gmail.com',
                  subtitle: 'WhatsApp Messenger',
                  selectedIndex: controller.selectedContact.value,
                  onTap: () => controller.selectedContact.value = 1,
                )),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2F66F6), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), elevation: 0),
              onPressed: () {
                Get.snackbar('OTP Terkirim', 'Kode OTP telah dikirimkan.');
              },
              child: const Text('KIRIM OTP', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactOption({
    required int index,
    required String title,
    required String subtitle,
    required int selectedIndex,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedIndex == index;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF4FF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? const Color(0xFF2F66F6) : Colors.grey.shade300, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked : Icons.radio_button_off, color: isSelected ? const Color(0xFF2F66F6) : Colors.grey.shade400, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.black87)),
                  Text(subtitle, style: const TextStyle(color: Colors.black45, fontSize: 10)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}