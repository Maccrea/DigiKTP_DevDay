import 'dart:ui';
import 'package:digiktp/app/routes/app_routes.dart';
import 'package:digiktp/app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _motionController;
  late final Animation<double> _cardScale;
  late final Animation<double> _cardRotation;
  late final Animation<double> _ringScale;
  late final Animation<double> _scanLineProgress;

  @override
  void initState() {
    super.initState();
    _motionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);

    _cardScale = Tween<double>(begin: 0.95, end: 1.02).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );
    _cardRotation = Tween<double>(begin: -0.03, end: 0.03).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );
    _ringScale = Tween<double>(begin: 0.92, end: 1.05).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeOut),
    );
    _scanLineProgress = Tween<double>(begin: 0, end: 90).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );

    _openNextScreen();
  }

  Future<void> _openNextScreen() async {
    await Future<void>.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;

    final hasSeenOnboarding =
        GetStorage().read<bool>('has_seen_onboarding') ?? false;
    Get.offAllNamed(hasSeenOnboarding ? Routes.DASHBOARD : Routes.ONBOARDING);
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const baseColor = Color(0xFF0D233A);
    const darkColor = Color(0xFF081625);

    return Scaffold(
      backgroundColor: baseColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [baseColor, darkColor],
              ),
            ),
          ),

          Positioned(
            top: -50,
            right: -80,
            child: Transform.rotate(
              angle: 0.4,
              child: Container(
                width: 350,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.15),
                    width: 3,
                  ),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _peach.withOpacity(0.15),
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
            child: Container(color: Colors.transparent),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 36),
              child: Column(
                children: [
                  const Spacer(),

                  AnimatedBuilder(
                    animation: _motionController,
                    builder: (context, child) => Transform.scale(
                      scale: _ringScale.value,
                      child: Container(
                        width: 290,
                        height: 290,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.08),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: _peach.withOpacity(0.05),
                              blurRadius: 40,
                              spreadRadius: 10,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Container(
                            width: 230,
                            height: 230,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _peach.withOpacity(0.4),
                                width: 1.5,
                              ),
                            ),
                            child: Center(child: child),
                          ),
                        ),
                      ),
                    ),
                    child: AnimatedBuilder(
                      animation: _motionController,
                      builder: (context, child) => Transform.rotate(
                        angle: _cardRotation.value,
                        child: Transform.scale(
                          scale: _cardScale.value,
                          child: child,
                        ),
                      ),
                      child: Container(
                        width: 180,
                        height: 114,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFFE2F0F9), Color(0xFFC7E0F4)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                            BoxShadow(
                              color: Colors.white.withOpacity(0.8),
                              blurRadius: 2,
                              spreadRadius: -1,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    width: 80,
                                    height: 4,
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFF0F172A,
                                      ).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                                ),

                                Expanded(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(height: 4),
                                            _buildDataLine(60, 6),
                                            const SizedBox(height: 6),
                                            _buildDataLine(40, 4),
                                            const SizedBox(height: 4),
                                            _buildDataLine(50, 4),
                                            const SizedBox(height: 4),
                                            _buildDataLine(35, 4),
                                            const Spacer(),
                                            const Icon(
                                              Icons.memory_rounded,
                                              color: Color(0xFFB48529),
                                              size: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        width: 42,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: const Color(
                                            0xFF94A3B8,
                                          ).withOpacity(0.4),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(
                                              0.5,
                                            ),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.person_rounded,
                                          color: Colors.white.withOpacity(0.8),
                                          size: 32,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                              left: 0,
                              right: 0,
                              top: 0,
                              child: AnimatedBuilder(
                                animation: _scanLineProgress,
                                builder: (context, child) =>
                                    Transform.translate(
                                      offset: Offset(
                                        0,
                                        _scanLineProgress.value,
                                      ),
                                      child: child,
                                    ),
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.transparent,
                                        _peach.withOpacity(0.9),
                                        Colors.transparent,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: _peach.withOpacity(0.6),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 56),

                  Text(
                    'NIKKita',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 42,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 4),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: Text(
                      'Universal Government Gateway',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDataLine(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A).withOpacity(0.3),
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}

const _peach = Color(0xFFF97316);
