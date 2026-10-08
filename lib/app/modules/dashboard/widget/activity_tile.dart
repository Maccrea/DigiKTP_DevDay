import 'package:digiktp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({required this.item, super.key});

  final Map<String, dynamic> item;

  bool get _succeeded =>
      (item['status'] ?? '').toString().toUpperCase() == 'SUCCESS' ||
      item['isSuccess'] == true;

  String get _status => _succeeded ? 'Berhasil' : 'Perlu ditinjau';

  String? get _photoUrl {
    final value = item['photo_path'];

    if (value == null) return null;

    final path = value.toString().trim();

    if (path.isEmpty) return null;

    if (path.startsWith('https://') || path.startsWith('http://')) {
      return path;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _succeeded ? AppColors.success : AppColors.warning;

    final name = (item['name'] ?? 'Tanpa nama').toString();
    final service = (item['service'] ?? 'Layanan warga').toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF1F5F9)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => _showDetails(context),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                _buildLeading(statusColor, _photoUrl),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        service,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _status,
                        style: GoogleFonts.inter(
                          color: statusColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTime(item['time']),
                      style: GoogleFonts.inter(
                        color: const Color(0xFF94A3B8),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeading(Color statusColor, String? photoUrl) {
    final hasPhoto = photoUrl != null && photoUrl.trim().isNotEmpty;

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: hasPhoto ? AppColors.border : statusColor.withOpacity(0.2),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: hasPhoto
                ? Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                    cacheWidth: 150,
                    cacheHeight: 150,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }

                      return Container(
                        color: const Color(0xFFF8FAFC),
                        child: const Center(
                          child: SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return _fallbackIcon(statusColor);
                    },
                  )
                : _fallbackIcon(statusColor),
          ),
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              padding: const EdgeInsets.all(1),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _succeeded ? Icons.check_circle : Icons.error,
                color: statusColor,
                size: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackIcon(Color statusColor) {
    return Container(
      color: statusColor.withOpacity(0.08),
      child: Icon(
        _succeeded ? Icons.how_to_reg_rounded : Icons.priority_high_rounded,
        color: statusColor,
        size: 22,
      ),
    );
  }

  String _formatTime(dynamic value) {
    final parsed = DateTime.tryParse(value?.toString() ?? '')?.toLocal();

    if (parsed == null) return 'Baru';

    return '${parsed.hour.toString().padLeft(2, '0')}:'
        '${parsed.minute.toString().padLeft(2, '0')}';
  }

  void _showDetails(BuildContext context) {
    final photoUrl = _photoUrl;

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 42,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                Text(
                  'Detail Transaksi',
                  style: GoogleFonts.nunito(
                    color: AppColors.primary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 20),

                if (photoUrl != null) ...[
                  _buildWatermarkedPhoto(photoUrl),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Foto dilindungi watermark untuk mencegah penyalahgunaan.',
                          style: GoogleFonts.inter(
                            color: const Color(0xFF64748B),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _DetailLine(
                        label: 'Warga',
                        value: item['name'] ?? 'Tanpa nama',
                      ),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _DetailLine(label: 'NIK', value: item['nik'] ?? '-'),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _DetailLine(
                        label: 'Layanan',
                        value: item['service'] ?? 'Layanan warga',
                      ),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _DetailLine(label: 'Status', value: _status),
                      const Divider(height: 16, color: Color(0xFFE2E8F0)),
                      _DetailLine(
                        label: 'Waktu',
                        value: _formatDateTime(item['time']),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: Get.back,
                    child: Text(
                      'Tutup',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildWatermarkedPhoto(String photoUrl) {
    final maskedNik = _maskedNik;
    final timestamp = _formatDateTime(item['time']);

    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              photoUrl,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  color: const Color(0xFFF8FAFC),
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return _detailPhotoFallback();
              },
            ),

            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.04)),
            ),

            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _WatermarkPainter(
                    text: 'NIKita • DOKUMEN VERIFIKASI',
                  ),
                ),
              ),
            ),

            Center(
              child: Transform.rotate(
                angle: -0.18,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.white.withOpacity(0.28)),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Nikita',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.82),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'DOKUMEN VERIFIKASI',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.72),
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            Positioned(
              left: 12,
              right: 12,
              bottom: 10,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _watermarkLabel('NIK • $maskedNik'),
                  _watermarkLabel(timestamp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _watermarkLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.42),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.82),
          fontSize: 7,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  String get _maskedNik {
    final nik = (item['nik'] ?? '').toString().trim();

    if (nik.length <= 4) {
      return nik.isEmpty ? '--------' : nik;
    }

    return '${'•' * (nik.length - 4)}${nik.substring(nik.length - 4)}';
  }

  Widget _detailPhotoFallback() {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFFF1F5F9),
      child: const Center(
        child: Icon(
          Icons.broken_image_outlined,
          size: 36,
          color: Color(0xFF94A3B8),
        ),
      ),
    );
  }

  String _formatDateTime(dynamic value) {
    final parsed = DateTime.tryParse(value?.toString() ?? '')?.toLocal();

    if (parsed == null) {
      return value?.toString() ?? '-';
    }

    final day = parsed.day.toString().padLeft(2, '0');
    final month = parsed.month.toString().padLeft(2, '0');
    final hour = parsed.hour.toString().padLeft(2, '0');
    final minute = parsed.minute.toString().padLeft(2, '0');

    return '$day/$month/${parsed.year} · $hour:$minute';
  }
}

class _WatermarkPainter extends CustomPainter {
  final String text;

  const _WatermarkPainter({required this.text});

  @override
  void paint(Canvas canvas, Size size) {
    final textStyle = TextStyle(
      color: Colors.white.withOpacity(0.16),
      fontSize: 11,
      fontWeight: FontWeight.w800,
      letterSpacing: 1.2,
    );

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    canvas.save();

    canvas.translate(size.width / 2, size.height / 2);

    canvas.rotate(-0.45);

    const spacingX = 170.0;
    const spacingY = 58.0;

    for (double y = -size.height * 2; y < size.height * 2; y += spacingY) {
      for (double x = -size.width * 2; x < size.width * 2; x += spacingX) {
        textPainter.paint(canvas, Offset(x, y));
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _WatermarkPainter oldDelegate) {
    return oldDelegate.text != text;
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({required this.label, required this.value});

  final String label;
  final dynamic value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: const Color(0xFF64748B),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.toString(),
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
