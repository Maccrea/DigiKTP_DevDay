import 'package:digiktp/app/modules/dashboard/dashboard_controller.dart';
import 'package:digiktp/app/modules/dashboard/view/ktp_card.dart';
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
      title: 'Administrasi\nKependudukan',
      category: 'ADMINDUK',
      description:
          'Verifikasi domisili, sinkronisasi KK, hingga draf surat pengantar.',
      icon: Icons.badge_outlined,
      gradient: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
      checklist: [
        'Verifikasi domisili warga secara real-time',
        'Sinkronisasi data Kartu Keluarga terbaru',
        'Pembuatan draf surat pengantar otomatis',
      ],
    ),
    'Layanan Kesehatan': _ServiceGuide(
      title: 'Layanan\nKesehatan',
      category: 'KESEHATAN',
      description:
          'Validasi identitas pasien darurat dan antrean fasilitas faskes.',
      icon: Icons.health_and_safety_outlined,
      gradient: [Color(0xFF047857), Color(0xFF10B981)],
      checklist: [
        'Pengecekan status keaktifan BPJS Kesehatan',
        'Registrasi antrean cepat poli atau IGD',
        'Konfirmasi kontak OTP darurat pasien',
      ],
    ),
    'Verifikasi Bantuan Sosial': _ServiceGuide(
      title: 'Verifikasi\nBantuan Sosial',
      category: 'BANTUAN SOSIAL',
      description: 'Pencatatan distribusi BLT dan sembako agar tepat sasaran.',
      icon: Icons.volunteer_activism_outlined,
      gradient: [Color(0xFFB45309), Color(0xFFF59E0B)],
      checklist: [
        'Pemeriksaan kuota Data Terpadu (DTKS)',
        'Validasi status klaim bantuan warga',
        'Pencatatan waktu penyaluran transparan',
      ],
    ),
    'Pendataan Program MBG': _ServiceGuide(
      title: 'Pendataan\nProgram MBG',
      category: 'PROGRAM MBG',
      description:
          'Pencatatan penerima dan distribusi porsi makan bergizi harian.',
      icon: Icons.lunch_dining_rounded,
      gradient: [Color(0xFFBE123C), Color(0xFFF43F5E)],
      checklist: [
        'Validasi kuota penerima manfaat harian',
        'Pencatatan penyerahan paket makanan',
        'Sistem kunci otomatis cegah klaim ganda',
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
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFF1F5F9)),
                          ),
                          child: IconButton(
                            onPressed: Get.back,
                            tooltip: 'Kembali',
                            icon: const Icon(
                              Icons.arrow_back_rounded,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          'Detail Layanan',
                          style: GoogleFonts.nunito(
                            color: AppColors.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    _ServiceHero(guide: guide),
                    const SizedBox(height: 20),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFDBEAFE)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.info_outline_rounded,
                            color: AppColors.primary,
                            size: 18,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Modul ini terhubung langsung dengan gateway pusat untuk memastikan keabsahan data kependudukan secara instan.',
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
                    const SizedBox(height: 24),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Alur Proses Layanan',
                          style: GoogleFonts.nunito(
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          '${guide.checklist.length} langkah',
                          style: GoogleFonts.inter(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFF1F5F9)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          for (var i = 0; i < guide.checklist.length; i++) ...[
                            _ChecklistRow(
                              number: i + 1,
                              label: guide.checklist[i],
                              accent: guide.gradient.first,
                            ),
                            if (i != guide.checklist.length - 1)
                              const Divider(
                                height: 1,
                                thickness: 1,
                                indent: 58,
                                color: Color(0xFFF1F5F9),
                              ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: () => Get.find<DashboardController>()
                        .goToNfcScan(serviceName),
                    icon: const Icon(Icons.nfc_rounded, size: 20),
                    label: Text(
                      'Mulai Verifikasi e-KTP',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accent,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
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
    required this.gradient,
    required this.checklist,
  });

  final String title;
  final String category;
  final String description;
  final IconData icon;
  final List<Color> gradient;
  final List<String> checklist;
}

class _ServiceHero extends StatelessWidget {
  const _ServiceHero({required this.guide});

  final _ServiceGuide guide;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: guide.gradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: guide.gradient.last.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -24,
            bottom: -28,
            child: Icon(
              guide.icon,
              size: 150,
              color: Colors.white.withOpacity(0.10),
            ),
          ),
          Positioned(
            right: 18,
            top: 18,
            child: Transform.rotate(
              angle: -0.1,
              child: const MiniKtpCard(scale: 0.8),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(22),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.3)),
                  ),
                  child: Text(
                    guide.category,
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 9,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  guide.title,
                  style: GoogleFonts.nunito(
                    color: Colors.white,
                    fontSize: 24,
                    height: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  guide.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 11,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.number,
    required this.label,
    required this.accent,
  });

  final int number;
  final String label;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: accent.withOpacity(0.10),
              shape: BoxShape.circle,
            ),
            child: Text(
              '$number',
              style: GoogleFonts.nunito(
                color: accent,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 12,
                height: 1.3,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.success,
            size: 18,
          ),
        ],
      ),
    );
  }
}
