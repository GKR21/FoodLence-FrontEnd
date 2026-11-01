import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

const Color kTeal = Color(0xFF16A085);

class SplashScreen extends StatefulWidget {
  /// Called when the splash finishes (after 2.8s) or the user taps to skip.
  final VoidCallback onFinish;

  const SplashScreen({super.key, required this.onFinish});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _timer;
  bool _done = false;

  @override
  void initState() {
    super.initState();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();

    _timer = Timer(const Duration(milliseconds: 2800), _finish);
  }

  void _finish() {
    if (_done || !mounted) return;
    _done = true;
    _timer?.cancel();
    widget.onFinish();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kTeal,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque, // "Tap anywhere to skip"
        onTap: _finish,
        child: SizedBox.expand(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _LogoMark(),
                  const SizedBox(height: 24),
                  const Text(
                    'FoodLense',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.9, // tracking-tight
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Know what's inside your food.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.75),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 48),
                  _LoadingDots(controller: _pulse),
                ],
              ),
              Positioned(
                bottom: 48,
                child: Text(
                  'Tap anywhere to skip',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rounded frosted square with the target icon + check badge.
class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
              child: Container(
                width: 96,
                height: 96,
                color: Colors.white.withOpacity(0.2),
                alignment: Alignment.center,
                child: const CustomPaint(
                  size: Size(52, 52),
                  painter: _TargetPainter(),
                ),
              ),
            ),
          ),
          Positioned(
            right: -4,
            bottom: -4,
            child: Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                size: 16,
                color: kTeal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws the 52x52 SVG: outer ring, dashed inner ring, centre dot, 4 ticks.
class _TargetPainter extends CustomPainter {
  const _TargetPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 52; // scale from SVG viewBox
    final c = Offset(26 * s, 26 * s);

    final stroke25 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * s
      ..strokeCap = StrokeCap.round;

    final stroke2 = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;

    // Outer circle
    canvas.drawCircle(c, 20 * s, stroke25);

    // Dashed inner circle (dash 4, gap 3)
    final inner = Path()..addOval(Rect.fromCircle(center: c, radius: 10 * s));
    for (final metric in inner.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final end = (d + 4 * s).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(d, end), stroke2);
        d += 7 * s;
      }
    }

    // Centre dot
    canvas.drawCircle(c, 3 * s, Paint()..color = Colors.white);

    // Tick marks
    canvas.drawLine(Offset(26 * s, 6 * s), Offset(26 * s, 10 * s), stroke25);
    canvas.drawLine(Offset(26 * s, 42 * s), Offset(26 * s, 46 * s), stroke25);
    canvas.drawLine(Offset(6 * s, 26 * s), Offset(10 * s, 26 * s), stroke25);
    canvas.drawLine(Offset(42 * s, 26 * s), Offset(46 * s, 26 * s), stroke25);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Three staggered pulsing dots (same keyframes as the CSS version).
class _LoadingDots extends StatelessWidget {
  final Animation<double> controller;

  const _LoadingDots({required this.controller});

  static const double _cycleMs = 1400;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = (i * 200) / _cycleMs;
            final p = (controller.value - delay) % 1.0;

            // 0%,80%,100% -> 0 ; 40% -> 1
            double v;
            if (p < 0.4) {
              v = p / 0.4;
            } else if (p < 0.8) {
              v = 1 - (p - 0.4) / 0.4;
            } else {
              v = 0;
            }
            v = Curves.easeInOut.transform(v);

            final opacity = 0.4 + 0.6 * v;
            final scale = 0.8 + 0.2 * v;

            return Padding(
              padding: EdgeInsets.only(left: i == 0 ? 0 : 8),
              child: Transform.scale(
                scale: scale,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.4 * opacity),
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