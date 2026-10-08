import 'package:digiktp/app/modules/auth/auth_controller.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:digiktp/app/utils/custom_app_bar.dart';
import 'package:digiktp/app/utils/custom_input_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchPoskoView extends GetView<AuthController> {
  const SwitchPoskoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(title: 'Penempatan petugas'),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'LANGKAH 2 DARI 2',
                          style: GoogleFonts.inter(
                            color: AppColors.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: const LinearProgressIndicator(
                              value: 1,
                              minHeight: 4,
                              backgroundColor: AppColors.border,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Pilih lokasi tugas',
                      style: GoogleFonts.nunito(
                        color: AppColors.primary,
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Pastikan posko dan shift yang dipilih sudah benar.',
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 13,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.border),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x0C193A56),
                            blurRadius: 14,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _OrganizationSummary(controller: controller),
                          const SizedBox(height: 21),
                          CustomDropdownField<String>(
                            label: 'Wilayah',
                            hintText: 'Pilih wilayah',
                            prefixIcon: Icons.map_outlined,
                            value: controller.selectedWilayah.value,
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
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedWilayah.value = value;
                              }
                            },
                          ),
                          const SizedBox(height: 17),
                          CustomDropdownField<String>(
                            label: 'Posko layanan',
                            hintText: 'Pilih posko',
                            prefixIcon: Icons.location_on_outlined,
                            value: controller.selectedPosko.value,
                            items: const [
                              DropdownMenuItem(
                                value: 'Posko Layanan Kelurahan Gambir',
                                child: Text('Kelurahan Gambir'),
                              ),
                              DropdownMenuItem(
                                value: 'Posko Mobilitas Gelora',
                                child: Text('Posko Mobilitas Gelora'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedPosko.value = value;
                              }
                            },
                          ),
                          const SizedBox(height: 17),
                          CustomDropdownField<String>(
                            label: 'Shift',
                            hintText: 'Pilih shift',
                            prefixIcon: Icons.schedule_rounded,
                            value: controller.selectedShift.value,
                            items: const [
                              DropdownMenuItem(
                                value: 'Shift 1 — Pagi (08:00 - 15:00)',
                                child: Text('Pagi · 08.00–15.00'),
                              ),
                              DropdownMenuItem(
                                value: 'Shift 2 — Siang (15:00 - 21:00)',
                                child: Text('Siang · 15.00–21.00'),
                              ),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                controller.selectedShift.value = value;
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          _NfcReadiness(controller: controller),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: controller.submitLoginAndPosko,
                    icon: const Icon(Icons.arrow_forward_rounded, size: 19),
                    label: Text(
                      'Simpan penempatan',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrganizationSummary extends StatelessWidget {
  const _OrganizationSummary({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFEAF0F8),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.account_balance_outlined,
            color: AppColors.primary,
            size: 21,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Instansi',
                style: GoogleFonts.inter(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 2),
              Obx(
                () => Text(
                  controller.selectedInstansi.value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NfcReadiness extends StatelessWidget {
  const _NfcReadiness({required this.controller});

  final AuthController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final active = controller.isNfcActive.value;
      final statusColor = active ? AppColors.success : AppColors.warning;
      return Row(
        children: [
          Icon(Icons.nfc_rounded, color: statusColor, size: 19),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              active ? 'NFC siap digunakan' : 'NFC belum aktif',
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      );
    });
  }
}
