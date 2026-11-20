import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../models/scan_model.dart';

class ScannerScreen extends StatefulWidget {
  final Function(String, {Map<String, dynamic>? data})? go;
  final VoidCallback? onClose;

  const ScannerScreen({super.key, this.go, this.onClose});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  late Animation<double> _scanAnimation;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();

    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _scanAnimation = Tween<double>(begin: -60, end: 60).animate(
      CurvedAnimation(parent: _scanController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  void _navigate(String target, {Map<String, dynamic>? data}) {
    if (widget.go != null) {
      widget.go!(target, data: data);
      return;
    }
    if (target == "home") {
      if (widget.onClose != null) {
        widget.onClose!();
      } else {
        Navigator.of(context).maybePop();
      }
    } else if (target == "processing") {
      Navigator.of(
        context,
      ).pushNamed(AppRoutes.historyDetail, arguments: kHistory.first);
    } else if (target == "manual-input") {
      _showManualInputDialog();
    }
  }

  void _showManualInputDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Manual Ingredient Input'),
        content: TextField(
          controller: textController,
          maxLines: 4,
          decoration: const InputDecoration(
            hintText: 'Enter ingredients separated by commas...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF16A085),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              _navigate('processing');
            },
            child: const Text('Analyze'),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Scanning Tips'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. Keep the packaging label flat and inside the frame.'),
            SizedBox(height: 8),
            Text('2. Ensure good lighting or toggle flash in dark settings.'),
            SizedBox(height: 8),
            Text('3. Hold your phone steady for accurate text recognition.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Status bar
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "9:41",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(Icons.battery_full, color: Colors.white),
                ],
              ),
            ),

            // Top controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _circleButton(
                    icon: Icons.arrow_back,
                    onTap: () => _navigate("home", data: {"navTab": "home"}),
                  ),

                  const Text(
                    "Scan Label",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  Row(
                    children: [
                      _circleButton(
                        icon: _isFlashOn ? Icons.flash_on : Icons.flash_off,
                        onTap: () {
                          setState(() {
                            _isFlashOn = !_isFlashOn;
                          });
                        },
                      ),
                      const SizedBox(width: 8),
                      _circleButton(
                        icon: Icons.info_outline,
                        onTap: _showInfoDialog,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Camera viewfinder
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x33000000),
                          Colors.transparent,
                          Color(0x33000000),
                        ],
                      ),
                    ),
                  ),

                  // Simulated ingredient label
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: 192,
                      color: Colors.white.withValues(alpha: 0.05),
                      alignment: Alignment.center,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "Ingredients: Wheat flour, Sugar,\n"
                          "Cocoa powder, Milk powder...",
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 12,
                            fontFamily: "monospace",
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                  // Scanning frame
                  SizedBox(
                    width: 288,
                    height: 176,
                    child: Stack(
                      children: [
                        // Corner brackets
                        _corner(Alignment.topLeft),
                        _corner(Alignment.topRight),
                        _corner(Alignment.bottomLeft),
                        _corner(Alignment.bottomRight),

                        // Animated scan line
                        AnimatedBuilder(
                          animation: _scanAnimation,
                          builder: (context, child) {
                            return Positioned(
                              left: 0,
                              right: 0,
                              top: 88 + _scanAnimation.value,
                              child: Container(
                                height: 2,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Color(0xFF16A085),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Guide text
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              child: Column(
                children: [
                  Text(
                    "Place the ingredient list inside the frame",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Keep the label flat, clear and well lit",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),

            // Bottom controls
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 48),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Gallery
                  _bottomButton(
                    icon: Icons.image_outlined,
                    onTap: () => _navigate("processing"),
                  ),

                  // Capture button
                  GestureDetector(
                    onTap: () => _navigate("processing"),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: Container(
                          width: 56,
                          height: 56,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Manual input
                  _bottomButton(
                    icon: Icons.edit_outlined,
                    onTap: () => _navigate("manual-input"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Circular top button
  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }

  // Bottom button
  Widget _bottomButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }

  // Scanning frame corner
  Widget _corner(Alignment alignment) {
    const double size = 32;
    const double thickness = 3;

    BorderRadius radius;

    if (alignment == Alignment.topLeft) {
      radius = const BorderRadius.only(topLeft: Radius.circular(8));
    } else if (alignment == Alignment.topRight) {
      radius = const BorderRadius.only(topRight: Radius.circular(8));
    } else if (alignment == Alignment.bottomLeft) {
      radius = const BorderRadius.only(bottomLeft: Radius.circular(8));
    } else {
      radius = const BorderRadius.only(bottomRight: Radius.circular(8));
    }

    return Align(
      alignment: alignment,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border(
            top: alignment.y <= 0
                ? const BorderSide(color: Colors.white, width: thickness)
                : BorderSide.none,
            bottom: alignment.y >= 0
                ? const BorderSide(color: Colors.white, width: thickness)
                : BorderSide.none,
            left: alignment.x <= 0
                ? const BorderSide(color: Colors.white, width: thickness)
                : BorderSide.none,
            right: alignment.x >= 0
                ? const BorderSide(color: Colors.white, width: thickness)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
