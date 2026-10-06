import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MiniKtpCard extends StatelessWidget {
  const MiniKtpCard({super.key, this.scale = 1});

  final double scale;

  static const double _w = 128;
  static const double _h = 80;
  static const Color _ink = Color(0xFF0B2A5B);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _w * scale,
      height: _h * scale,
      child: FittedBox(
        child: Container(
          width: _w,
          height: _h,
          padding: const EdgeInsets.fromLTRB(8, 7, 8, 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFFE6F1FF), Color(0xFFBBD5F4), Color(0xFFEAF3FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(color: Colors.white.withOpacity(0.7), width: 0.8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.28),
                blurRadius: 14,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REPUBLIK INDONESIA',
                    style: GoogleFonts.inter(
                      color: _ink,
                      fontSize: 5.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const Icon(Icons.contactless_rounded, size: 9, color: _ink),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '3271 0• •••• ••01',
                          style: GoogleFonts.inter(
                            color: _ink,
                            fontSize: 7,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                          ),
                        ),
                        const SizedBox(height: 4),
                        _bar(58),
                        const SizedBox(height: 3),
                        _bar(40),
                        const SizedBox(height: 6),
                        const _KtpChip(),
                      ],
                    ),
                  ),
                  Container(
                    width: 30,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _ink.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Icon(Icons.person_rounded, size: 24, color: _ink.withOpacity(0.45)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bar(double w) => Container(
        width: w,
        height: 3,
        decoration: BoxDecoration(
          color: _ink.withOpacity(0.25),
          borderRadius: BorderRadius.circular(2),
        ),
      );
}

class _KtpChip extends StatelessWidget {
  const _KtpChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 16,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
        gradient: const LinearGradient(
          colors: [Color(0xFFE9C46A), Color(0xFFB88A2B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: CustomPaint(painter: _ChipLinesPainter()),
    );
  }
}

class _ChipLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0xFF7A5A12).withOpacity(0.55)
      ..strokeWidth = 0.6;
    canvas.drawLine(Offset(0, size.height / 3), Offset(size.width, size.height / 3), p);
    canvas.drawLine(Offset(0, size.height * 2 / 3), Offset(size.width, size.height * 2 / 3), p);
    canvas.drawLine(Offset(size.width / 2, 0), Offset(size.width / 2, size.height), p);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}