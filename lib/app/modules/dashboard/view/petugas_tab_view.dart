import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';

class PetugasTabView extends GetView<DashboardController> {
  const PetugasTabView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Profil Operational Petugas',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Row(
                  children: [
                    ClipOval(
                      child: Container(
                        width: 56,
                        height: 56,
                        color: const Color(0xFF0F172A),
                        child: const Icon(Icons.person, color: Colors.white, size: 36),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(() => Text(controller.userName.value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))),
                          const SizedBox(height: 2),
                          Obx(() => Text(controller.userNip.value, style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)))),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFEFF6FF), borderRadius: BorderRadius.circular(6)),
                            child: const Text('Operator Posko Lapangan', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF2563EB))),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LOKASI TUGAS AKTIF', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8), letterSpacing: 0.8)),
                    const SizedBox(height: 6),
                    Obx(() => Text(controller.activePosko.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white))),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E293B),
                        minimumSize: const Size(double.infinity, 38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () => _showPoskoSelectorBottomSheet(context),
                      icon: const Icon(Icons.swap_horiz_rounded, size: 18, color: Color(0xFF38BDF8)),
                      label: const Text('Ganti Posko Tugas', style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Pengaturan & Hardware Reader', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
              const SizedBox(height: 10),
              _buildSettingTile(Icons.nfc_rounded, 'Status Sensor NFC', 'Internal Reader: Siap', true),
              _buildSettingTile(Icons.sync_rounded, 'Sinkronisasi Data Luring', '3 transaksi tersimpan lokal', false),
              _buildSettingTile(Icons.security_rounded, 'Keamanan Akses PIN', 'Aktif', false),

              const SizedBox(height: 24),

              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFEF4444),
                  side: const BorderSide(color: Color(0xFFFCA5A5)),
                  minimumSize: const Size(double.infinity, 46),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () {
                  // Panggil dialog konfirmasi langsung di sisi UI
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('Keluar Akun', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      content: const Text('Apakah Anda yakin ingin keluar dari sesi petugas posko ini?', style: TextStyle(fontSize: 13, color: Color(0xFF64748B))),
                      actions: [
                        TextButton(
                          onPressed: () => Get.back(),
                          child: const Text('Batal', style: TextStyle(color: Color(0xFF64748B))),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4444),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          onPressed: () {
                            Get.back();
                            controller.logout(); // Memanggil fungsi logout controller
                          },
                          child: const Text('Keluar', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text(
                  'Keluar Sesi Petugas',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile(IconData icon, String title, String subtitle, bool isStatus) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE2E8F0))),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2563EB), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0F172A))),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }

  void _showPoskoSelectorBottomSheet(BuildContext context) {
    final List<String> poskoList = [
      'Kelurahan Gambir • Posko Layanan Terpadu',
      'Kelurahan Kebon Sirih • Posko Mobile 1',
      'Kecamatan Menteng • Posko Utama',
    ];

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Posko Tugas Aktif', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
            const SizedBox(height: 12),
            ...poskoList.map(
              (posko) => ListTile(
                leading: const Icon(Icons.location_on_outlined, color: Color(0xFF2563EB)),
                title: Text(posko, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                onTap: () {
                  controller.activePosko.value = posko;
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}