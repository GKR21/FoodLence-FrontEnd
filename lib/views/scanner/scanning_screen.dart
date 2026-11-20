import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../models/scan_model.dart';

class ProcessingScreen extends StatefulWidget {
  final Function(String, {Map<String, dynamic>? data})? go;

  const ProcessingScreen({
    super.key,
    this.go,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen>
    with TickerProviderStateMixin {
  final List<String> steps = [
    'Reading label',
    'Detecting ingredients',
    'Checking allergens',
    'Preparing result',
  ];

  final List<int> delays = [0, 1200, 2200, 3000];

  List<int> completed = [];
  int active = 0;

  late AnimationController scanController;
  late Animation<double> scanAnimation;

  late AnimationController pulseController;

  final List<Timer> timers = [];

  @override
  void initState() {
    super.initState();

    // Scanner animation
    scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    scanAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(scanController);

    // Pulse animation
    pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    // Processing steps
    for (int i = 0; i < steps.length; i++) {
      timers.add(
        Timer(Duration(milliseconds: delays[i]), () {
          if (!mounted) return;

          setState(() {
            active = i;

            if (i > 0 && !completed.contains(i - 1)) {
              completed.add(i - 1);
            }
          });
        }),
      );
    }

    // Complete all steps
    timers.add(
      Timer(const Duration(milliseconds: 3800), () {
        if (!mounted) return;

        setState(() {
          completed = [0, 1, 2, 3];
        });
      }),
    );

    // Navigate to OCR review
    timers.add(
      Timer(const Duration(milliseconds: 4200), () {
        if (mounted) {
          if (widget.go != null) {
            widget.go!('ocr-review');
          } else {
            Navigator.of(context).pushReplacementNamed(
              AppRoutes.historyDetail,
              arguments: kHistory.first,
            );
          }
        }
      }),
    );
  }

  @override
  void dispose() {
    for (final timer in timers) {
      timer.cancel();
    }

    scanController.dispose();
    pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated scanner icon
                _scannerAnimation(),

                const SizedBox(height: 40),

                // Title
                const Text(
                  'Analysing Label',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 8),

                // Subtitle
                const Text(
                  'This usually takes a few seconds.',
                  style: TextStyle(
                    color: Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 40),

                // Processing steps
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: List.generate(
                      steps.length,
                      (index) => _stepItem(index),
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

  // Scanner with pulse rings
  Widget _scannerAnimation() {
    return SizedBox(
      width: 128,
      height: 128,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Pulse ring 1
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final scale = 1 + (pulseController.value * 0.3);
              final opacity = 0.6 * (1 - pulseController.value);

              return Transform.scale(
                scale: scale,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF16A085).withOpacity(opacity * 0.35),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Pulse ring 2
          AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final value = (pulseController.value + 0.5) % 1;
              final scale = 1 + (value * 0.3);
              final opacity = 0.6 * (1 - value);

              return Transform.scale(
                scale: scale,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color(0xFF16A085).withOpacity(opacity * 0.2),
                      width: 2,
                    ),
                  ),
                ),
              );
            },
          ),

          // Scanner background
          Container(
            width: 128,
            height: 128,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5F2),
              borderRadius: BorderRadius.circular(24),
            ),
            alignment: Alignment.center,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF16A085),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                clipBehavior: Clip.hardEdge,
                alignment: Alignment.center,
                children: [
                  // Camera icon
                  const Icon(
                    Icons.camera_alt_outlined,
                    color: Color(0xFF16A085),
                    size: 28,
                  ),

                  // Animated scan line
                  AnimatedBuilder(
                    animation: scanAnimation,
                    builder: (context, child) {
                      return Positioned(
                        left: 0,
                        right: 0,
                        top: scanAnimation.value * 80,
                        child: Container(
                          height: 2,
                          color: const Color(0x9916A085),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Processing step
  Widget _stepItem(int index) {
    final bool done = completed.contains(index);
    final bool isActive = active == index && !done;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Status icon
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: done
                  ? const Color(0xFF16A085)
                  : Colors.transparent,
              border: done
                  ? null
                  : Border.all(
                      color: isActive
                          ? const Color(0xFF16A085)
                          : const Color(0xFFE5E7EB),
                      width: 2,
                    ),
            ),
            child: Center(
              child: done
                  ? const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : isActive
                      ? _loadingIndicator()
                      : Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFE5E7EB),
                          ),
                        ),
            ),
          ),

          const SizedBox(width: 16),

          // Step text
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: done
                  ? const Color(0xFF16A085)
                  : isActive
                      ? const Color(0xFF111827)
                      : const Color(0xFFD1D5DB),
            ),
            child: Text(
              '${steps[index]}${done ? " ✓" : isActive ? "..." : ""}',
            ),
          ),
        ],
      ),
    );
  }

  // Loading spinner for active step
  Widget _loadingIndicator() {
    return SizedBox(
      width: 12,
      height: 12,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: const AlwaysStoppedAnimation<Color>(
          Color(0xFF16A085),
        ),
      ),
    );
  }
}

/// Alias for compatibility with the file naming convention.
typedef ScanningScreen = ProcessingScreen;
