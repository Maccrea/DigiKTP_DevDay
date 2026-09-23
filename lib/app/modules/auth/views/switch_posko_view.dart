import 'package:digiktp/app/modules/auth/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/custom_app_bar.dart';
import '../../../utils/custom_input_field.dart';
import '../../../theme/app_colors.dart';

class SwitchPoskoView extends GetView<AuthController> {
  const SwitchPoskoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: const CustomAppBar(
        title: 'Pengaturan Posko Kerja',
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tentukan Lokasi Tugas',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Lokasi operasional digunakan untuk melacak validasi berkas fisik e-KTP secara berkala.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Color(0xFF030164),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.business_center,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'INSTANSI TERPILIH',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF030164),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Obx(
                        () => Text(
                          controller.selectedInstansi.value.isEmpty
                              ? 'Disdukcapil DKI Jakarta'
                              : controller.selectedInstansi.value,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            CustomDropdownField<String>(
              label: 'Wilayah Tugas (Kecamatan/Kota)',
              hintText: 'Jakarta Pusat',
              prefixIcon: Icons.location_on_outlined,
              items: const [
                DropdownMenuItem(
                  value: 'Jakarta Pusat',
                  child: Text('Jakarta Pusat'),
                ),
                DropdownMenuItem(
                  value: 'Jakarta Selatan',
                  child: Text('Jakarta Selatan'),
                ),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),

            CustomDropdownField<String>(
              label: 'Nama Posko Operasional',
              hintText: 'Posko Layanan Kelurahan Gambir',
              prefixIcon: Icons.home_work_outlined,
              items: const [
                DropdownMenuItem(
                  value: 'Posko Layanan Kelurahan Gambir',
                  child: Text('Posko Layanan Kelurahan Gambir'),
                ),
                DropdownMenuItem(
                  value: 'Posko Mobilitas Gelora',
                  child: Text('Posko Mobilitas Gelora'),
                ),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 16),

            CustomDropdownField<String>(
              label: 'Shift Kerja Aktif',
              hintText: 'Shift 1 — Pagi (08:00 - 15:00)',
              prefixIcon: Icons.access_time,
              items: const [
                DropdownMenuItem(
                  value: 'Shift 1',
                  child: Text('Shift 1 — Pagi (08:00 - 15:00)'),
                ),
                DropdownMenuItem(
                  value: 'Shift 2',
                  child: Text('Shift 2 — Siang (15:00 - 21:00)'),
                ),
              ],
              onChanged: (val) {},
            ),
            const SizedBox(height: 20),

            Obx(() {
              final bool isActive = controller.isNfcActive.value;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isActive
                        ? AppColors.border
                        : const Color(0xFFFCA5A5),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.developer_board,
                          size: 20,
                          color: isActive
                              ? AppColors.textSecondary
                              : const Color(0xFFEF4444),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PERANGKAT DETEKSI',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'NFC Reader Internal',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: isActive
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        isActive ? 'SIAP AKTIF' : 'TIDAK AKTIF',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isActive
                              ? AppColors.success
                              : const Color(0xFFEF4444),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => controller.submitLoginAndPosko(),
                child: const Text(
                  'TERAPKAN POSKO',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
