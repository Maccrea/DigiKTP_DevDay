import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KtpPhotoPreview extends StatelessWidget {
  const KtpPhotoPreview({required this.path, this.height = 176, super.key});

  final String path;
  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: SizedBox(
        width: double.infinity,
        height: height,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.file(
              File(path),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => ColoredBox(
                color: const Color(0xFFEAF0F8),
                child: const Icon(
                  Icons.badge_outlined,
                  color: Color(0xFF1A365D),
                  size: 42,
                ),
              ),
            ),
            const Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _NikitaWatermarkPainter()),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 43,
                padding: const EdgeInsets.symmetric(horizontal: 13),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.02),
                      Colors.black.withOpacity(0.68),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.verified_user_outlined,
                      color: Colors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      'HASIL PEMINDAIAN • NIKKita',
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'LOKAL',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 8,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NikitaWatermarkPainter extends CustomPainter {
  const _NikitaWatermarkPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final label = TextPainter(
      text: const TextSpan(
        text: 'NIKKita  •  SALINAN SCAN',
        style: TextStyle(
          color: Color(0xBFFFFFFF),
          fontSize: 9,
          fontWeight: FontWeight.w800,
          shadows: [Shadow(color: Color(0x66000000), blurRadius: 3)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    for (var y = -size.height; y < size.height * 2; y += 42) {
      for (var x = -size.width; x < size.width * 2; x += 142) {
        canvas
          ..save()
          ..translate(x, y)
          ..rotate(-0.45);
        label.paint(canvas, Offset.zero);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
