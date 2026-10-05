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
    _cardScale = Tween<double>(begin: 0.97, end: 1).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );
    _cardRotation = Tween<double>(begin: -0.025, end: 0.025).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );
    _ringScale = Tween<double>(begin: 0.94, end: 1.08).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeOut),
    );
    _scanLineProgress = Tween<double>(begin: 0, end: 72).animate(
      CurvedAnimation(parent: _motionController, curve: Curves.easeInOut),
    );
    _openNextScreen();
  }

  Future<void> _openNextScreen() async {
    await Future<void>.delayed(const Duration(milliseconds: 2100));
    if (!mounted) return;

    final hasSeenOnboarding =
        GetStorage().read<bool>('has_seen_onboarding') ?? false;
    Get.offAllNamed(
      hasSeenOnboarding ? Routes.DASHBOARD : Routes.ONBOARDING,
    );
  }

  @override
  void dispose() {
    _motionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(28, 28, 28, 24),
              child: Column(
                children: [
                  const Spacer(),
                  AnimatedBuilder(
                    animation: _motionController,
                    builder: (context, child) => Transform.scale(
                      scale: _ringScale.value,
                      child: Container(
                        width: 274,
                        height: 274,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withOpacity(0.11),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Container(
                            width: 220,
                            height: 220,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _peach.withOpacity(0.3),
                                width: 1.2,
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
                        width: 178,
                        height: 116,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 38,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 54,
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFEAF0F8),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: AppColors.primary,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 72,
                                        height: 8,
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      const SizedBox(height: 9),
                                      Container(
                                        width: 58,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFCBD5E1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      const Spacer(),
                                      const Icon(
                                        Icons.contactless_rounded,
                                        color: _peach,
                                        size: 25,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              top: 3,
                              child: AnimatedBuilder(
                                animation: _scanLineProgress,
                                builder: (context, child) => Transform.translate(
                                  offset: Offset(0, _scanLineProgress.value),
                                  child: child,
                                ),
                                child: Container(
                                  height: 2,
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
                                        color: _peach.withOpacity(0.55),
                                        blurRadius: 8,
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
                  const SizedBox(height: 42),
                  Text(
                    'NIKita',
                    style: GoogleFonts.nunito(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Layanan warga, lebih dekat',
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.76),
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 42,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        minHeight: 3,
                          backgroundColor: Color(0x55FFFFFF),
                        valueColor: AlwaysStoppedAnimation<Color>(_peach),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const _peach = Color(0xFFFF8A65);