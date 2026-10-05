import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ServiceDetailView extends StatelessWidget {
  const ServiceDetailView({required this.serviceName, super.key});

  final String serviceName;

  _ServiceGuide get _guide => _guides[serviceName] ?? _guides.values.first;

  static const _guides = <String, _ServiceGuide>{
    'Administrasi Kependudukan': _ServiceGuide(
      title: 'Administrasi\nkependudukan',
      category: 'ADMINDUK',
      description: 'Dari verifikasi domisili sampai pengajuan dokumen.',
      icon: Icons.badge_outlined,
      color: Color(0xFF294A73),
      checklist: [
        'Verifikasi domisili RT/RW',
        'Sinkronisasi data KK',
        'Draf surat pengantar otomatis',
      ],
    ),
    'Layanan Kesehatan': _ServiceGuide(
      title: 'Layanan\nkesehatan',
      category: 'KESEHATAN',
      description: 'Identitas pasien dan kebutuhan antrean fasilitas.',
      icon: Icons.health_and_safety_outlined,
      color: Color(0xFF315B6B),
      checklist: [
        'Status BPJS Kesehatan',
        'Antrean poli atau IGD',
        'Kontak OTP aktif',
      ],
    ),
    'Verifikasi Bantuan Sosial': _ServiceGuide(
      title: 'Verifikasi\nbantuan sosial',
      category: 'BANTUAN SOSIAL',
      description: 'Bantu pencatatan bantuan agar lebih tertib.',
      icon: Icons.volunteer_activism_outlined,
      color: Color(0xFF47614F),
      checklist: [
        'Pemeriksaan data DTKS',
        'Status klaim bantuan',
        'Waktu penyaluran tercatat',
      ],
    ),
    'Pendataan Program MBG': _ServiceGuide(
      title: 'Pendataan\nprogram MBG',
      category: 'PROGRAM MBG',
      description: 'Pencatatan penerima dan penyerahan porsi harian.',
      icon: Icons.lunch_dining_rounded,
      color: Color(0xFF8A583C),
      checklist: [
        'Kuota penerima harian',
        'Catat penyerahan makanan',
        'Cegah distribusi ganda',
      ],
    ),
  };

  @override
  Widget build(BuildContext context) {
    final guide = _guide;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: Get.back,
                      tooltip: 'Kembali',
                      icon: const Icon(
                        Icons.arrow_back_rounded,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _ServiceHero(guide: guide),
                    const SizedBox(height: 28),
                    Text(
                      'Contoh fitur layanan',
                      style: GoogleFonts.nunito(
                        color: AppColors.primary,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EC),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.accent,
                            size: 18,
                          ),
                          const SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Pratinjau data contoh. Status BPJS, DTKS, dan kuota perlu integrasi sumber resmi.',
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontSize: 11,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    for (var index = 0;
                        index < guide.checklist.length;
                        index++) ...[
                      if (index > 0) const SizedBox(height: 10),
                      _ChecklistRow(
                        number: index + 1,
                        label: guide.checklist[index],
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EC),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.tips_and_updates_outlined,
                            color: AppColors.accent,
                            size: 19,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Data hasil scan tetap perlu diperiksa sebelum dikirim.',
                              style: GoogleFonts.inter(
                                color: AppColors.primary,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.find<DashboardController>()
                        .goToNfcScan(serviceName),
                    icon: const Icon(Icons.nfc_rounded),
                    label: Text(
                      'Mulai verifikasi',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
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

class _ServiceGuide {
  const _ServiceGuide({
    required this.title,
    required this.category,
    required this.description,
    required this.icon,
    required this.color,
    required this.checklist,
  });

  final String title;
  final String category;
  final String description;
  final IconData icon;
  final Color color;
  final List<String> checklist;
}

class _ServiceHero extends StatelessWidget {
  const _ServiceHero({required this.guide});

  final _ServiceGuide guide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 220,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: guide.color,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            top: -52,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withOpacity(0.13)),
              ),
            ),
          ),
          Positioned(
            right: 22,
            bottom: -76,
            child: Container(
              width: 176,
              height: 176,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    guide.category,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.86),
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  guide.title,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 26,
                    height: 1.02,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  guide.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.78),
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 24,
            top: 66,
            child: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.13),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.14)),
              ),
              child: Icon(guide.icon, color: Colors.white, size: 29),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({required this.number, required this.label});

  final int number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Row(
        children: [
          Container(
            width: 29,
            height: 29,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: Color(0xFFEAF0F8),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Color(0xFF94A3B8),
            size: 14,
          ),
        ],
      ),
    );
  }
}