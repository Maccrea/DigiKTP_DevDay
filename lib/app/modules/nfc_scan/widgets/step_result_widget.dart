import 'package:digiktp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../nfc_scan_controller.dart';
import 'ktp_photo_preview.dart';

class StepResultWidget extends GetView<NfcScanController> {
  const StepResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ChipReadStatus(controller: controller),
          const SizedBox(height: 14),
          Obx(() {
            final data = controller.verifiedWargaData;
            final hasData = data.isNotEmpty &&
                (data['nama_lengkap'] ?? data['nama_masking']) != null;
            if (!hasData) return const _ResidentLoadingCard();
            final displayData = Map<String, dynamic>.from(data)
              ..addAll(controller.scannedKtpFields);
            return _ResidentIdentityCard(data: displayData);
          }),
          const SizedBox(height: 13),
          Obx(() {
            controller.ktpPhotoRevision.value;
            final photo = controller.capturedKtpPhoto;
            if (photo != null) {
              return KtpPhotoPreview(path: photo.path, height: 182);
            }
            return OutlinedButton.icon(
              onPressed: controller.captureAndReadKtp,
              icon: const Icon(Icons.add_a_photo_outlined, size: 18),
              label: const Text('Tambah foto bukti'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.border),
                minimumSize: const Size.fromHeight(46),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            );
          }),
          const SizedBox(height: 18),
          Obx(() {
            final data = controller.verifiedWargaData;
            final hasData = data.isNotEmpty &&
                (data['nama_lengkap'] ?? data['nama_masking']) != null;
            if (!hasData) return const SizedBox.shrink();
            return SizedBox(
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => controller.goToStep(ScanStep.validation),
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: Text(
                  'Lanjut verifikasi',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ChipReadStatus extends StatelessWidget {
  const _ChipReadStatus({required this.controller});

  final NfcScanController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final uid = controller.scannedUid.value.trim();
      final hasUid = uid.isNotEmpty;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: hasUid ? const Color(0xFFE9F5F1) : const Color(0xFFFFF2E8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: hasUid ? const Color(0xFFC8E5DB) : const Color(0xFFF1D7C7),
          ),
        ),
        child: Row(
          children: [
            Icon(
              hasUid ? Icons.nfc_rounded : Icons.nfc_outlined,
              color: hasUid ? AppColors.success : AppColors.warning,
              size: 21,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hasUid ? 'Chip e-KTP terbaca' : 'Menunggu data chip',
                    style: GoogleFonts.inter(
                      color: AppColors.textPrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (hasUid) ...[
                    const SizedBox(height: 2),
                    Text(
                      'UID $uid',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hasUid)
              const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
          ],
        ),
      );
    });
  }
}

class _ResidentLoadingCard extends StatelessWidget {
  const _ResidentLoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(
            width: 21,
            height: 21,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: AppColors.secondary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Text(
              'Memuat hasil verifikasi warga',
              style: GoogleFonts.inter(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResidentIdentityCard extends StatelessWidget {
  const _ResidentIdentityCard({required this.data});

  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    final fullName = (data['nama_lengkap'] ?? data['nama_masking'] ?? 'Warga')
        .toString();
    final nik = (data['nik'] ?? '').toString();
    final birth = _value(data, ['tempat_tanggal_lahir', 'ttl']);
    final details = <MapEntry<String, String>>[
      MapEntry('Jenis kelamin', _value(data, ['jenis_kelamin'])),
      MapEntry('Alamat', _value(data, ['alamat', 'wilayah'])),
      MapEntry('RT/RW', _value(data, ['rt_rw'])),
      MapEntry('Kelurahan', _value(data, ['kelurahan_desa'])),
      MapEntry('Kecamatan', _value(data, ['kecamatan'])),
      MapEntry('Golongan darah', _value(data, ['golongan_darah'])),
      MapEntry('Agama', _value(data, ['agama'])),
      MapEntry('Status perkawinan', _value(data, ['status_perkawinan'])),
      MapEntry('Pekerjaan', _value(data, ['pekerjaan'])),
      MapEntry('Kewarganegaraan', _value(data, ['kewarganegaraan'])),
      MapEntry('Berlaku hingga', _value(data, ['berlaku_hingga'])),
    ].where((entry) => entry.value.isNotEmpty && entry.value != '-').toList();

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A193A56),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 41,
                height: 41,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF0F8),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  color: AppColors.primary,
                  size: 23,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fullName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.nunito(
                        color: AppColors.primary,
                        fontSize: 18,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (nik.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        'NIK  $nik',
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F5F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Terverifikasi',
                  style: GoogleFonts.inter(
                    color: AppColors.success,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          if (birth.isNotEmpty && birth != '-') ...[
            const SizedBox(height: 14),
            _IdentityInfoRow(label: 'Tempat, tanggal lahir', value: birth),
          ],
          if (details.isNotEmpty) ...[
            const SizedBox(height: 14),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 6),
            for (final detail in details) ...[
              const SizedBox(height: 7),
              _IdentityInfoRow(label: detail.key, value: detail.value),
            ],
          ],
        ],
      ),
    );
  }

  String _value(Map<String, dynamic> source, List<String> keys) {
    for (final key in keys) {
      final value = source[key]?.toString().trim();
      if (value != null && value.isNotEmpty) return value;
    }
    return '';
  }
}

class _IdentityInfoRow extends StatelessWidget {
  const _IdentityInfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 4,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 6,
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}