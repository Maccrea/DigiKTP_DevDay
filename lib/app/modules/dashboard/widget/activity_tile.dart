import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ActivityTile extends StatelessWidget {
  final dynamic item; 

  const ActivityTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final bool isSuccess = item['isSuccess'] ?? false;

    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showAuditLogDetailBottomSheet(context, item),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isSuccess ? const Color(0xFFEFF6FF) : const Color(0xFFFFFBEB),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isSuccess ? Icons.badge_rounded : Icons.warning_amber_rounded,
                    color: isSuccess ? const Color(0xFF2563EB) : const Color(0xFFD97706),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(item['name'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                      const SizedBox(height: 2),
                      Text('NIK: ${item['nik']} • ${item['service']}', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isSuccess ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['status'] ?? '',
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: isSuccess ? const Color(0xFF15803D) : const Color(0xFFD97706)),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(item['time'] ?? '', style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAuditLogDetailBottomSheet(BuildContext context, Map<String, dynamic> item) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Detail Audit Log', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: const Color(0xFF0F172A), borderRadius: BorderRadius.circular(14)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID LOG AKTIVITAS: ${item['log_id']}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8))),
                  const SizedBox(height: 4),
                  Text('Warga: ${item['name']} (${item['nik']})', style: const TextStyle(fontSize: 12, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text('KRONOLOGI VALIDASI NFC', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
            const SizedBox(height: 10),
            _buildLogStep('09:39:12 WIB', 'Scan NFC Diinisiasi', 'UID fisik kartu e-KTP terbaca oleh sensor internal.'),
            _buildLogStep('09:40:05 WIB', 'Autentikasi OTP', 'SMS token berhasil diverifikasi.'),
            _buildLogStep('09:41:12 WIB', 'Registrasi Selesai', 'Data disimpan ke database Dukcapil.'),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () => Get.back(),
              child: const Text('TUTUP AUDIT LOG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogStep(String time, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.circle, size: 10, color: Color(0xFF2563EB)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$time • $title', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                Text(desc, style: const TextStyle(fontSize: 10, color: Color(0xFF64748B))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}