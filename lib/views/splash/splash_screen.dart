import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_colors.dart';
import '../../config/app_constants.dart';
import '../../config/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _dots;
  late final AnimationController _intro;
  late final Animation<double> _fade;
  late final Animation<double> _scale;
  Timer? _timer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();

    _dots = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();
    _fade = CurvedAnimation(parent: _intro, curve: Curves.easeOut);
    _scale = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _intro, curve: Curves.easeOutBack));

    _timer = Timer(AppConstants.splashDuration, _goNext);
  }

  void _goNext() {
    if (_navigated || !mounted) return;
    _navigated = true;
    Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _dots.dispose();
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _goNext,
          child: SizedBox.expand(
            child: Stack(
              children: [
                Center(
                  child: FadeTransition(
                    opacity: _fade,
                    child: ScaleTransition(
                      scale: _scale,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _LogoMark(),
                          const SizedBox(height: 24),
                          const Text(
                            AppConstants.appName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 36,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            AppConstants.tagline,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.75),
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 48),
                          _LoadingDots(controller: _dots),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 48,
                  child: Text(
                    'Tap anywhere to skip',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ----------------------------- Logo mark ----------------------------- */

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 104,
      height: 104,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Center(
              child: CustomPaint(
                size: const Size(52, 52),
                painter: _LensPainter(),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline,
                color: AppColors.primary,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the lens icon on a 52x52 grid (same geometry as the prototype SVG).
class _LensPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 52;
    final c = Offset(26 * s, 26 * s);

    final stroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Outer ring
    stroke.strokeWidth = 2.5 * s;
    canvas.drawCircle(c, 20 * s, stroke);

    // Dashed inner ring (dash 4, gap 3 on a radius-10 circle)
    stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.butt;
    const r = 10.0;
    const dash = 4 / r;
    const gap = 3 / r;
    final rect = Rect.fromCircle(center: c, radius: r * s);
    double a = 0;
    while (a < 2 * math.pi) {
      final sweep = math.min(dash, 2 * math.pi - a);
      canvas.drawArc(rect, a, sweep, false, stroke);
      a += dash + gap;
    }

    // Centre dot
    canvas.drawCircle(c, 3 * s, Paint()..color = Colors.white);

    // Ticks
    stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(26 * s, 6 * s), Offset(26 * s, 10 * s), stroke);
    canvas.drawLine(Offset(26 * s, 42 * s), Offset(26 * s, 46 * s), stroke);
    canvas.drawLine(Offset(6 * s, 26 * s), Offset(10 * s, 26 * s), stroke);
    canvas.drawLine(Offset(42 * s, 26 * s), Offset(46 * s, 26 * s), stroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/* ---------------------------- Loading dots ---------------------------- */

class _LoadingDots extends StatelessWidget {
  final Animation<double> controller;
  const _LoadingDots({required this.controller});

  // 0 -> 1 -> 0 pulse: peak at 40%, back to rest at 80%
  double _pulse(double p) {
    if (p < 0.4) return p / 0.4;
    if (p < 0.8) return 1 - (p - 0.4) / 0.4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            // each dot is delayed by 0.2s of the 1.4s cycle
            final p = (controller.value - (i * 0.2 / 1.4)) % 1.0;
            final v = _pulse(p < 0 ? p + 1 : p);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Transform.scale(
                scale: 0.8 + 0.2 * v,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.4 + 0.6 * v),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
