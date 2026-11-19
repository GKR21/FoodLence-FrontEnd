import 'package:flutter/material.dart';
import 'package:foodlence/config/app_colors.dart';
import 'package:foodlence/config/app_routes.dart';
import 'package:foodlence/models/scan_model.dart';
import 'package:foodlence/widgets/scanner/camera_overlay.dart';
import 'package:foodlence/widgets/scanner/scanner_controls.dart';

/// Camera scanner screen for capturing food labels and extracting ingredients.
class ScannerScreen extends StatefulWidget {
  final VoidCallback? onClose;

  const ScannerScreen({super.key, this.onClose});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool _isFlashOn = false;
  bool _isProcessing = false;

  void _processScan() {
    setState(() => _isProcessing = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      setState(() => _isProcessing = false);
      Navigator.of(
        context,
      ).pushNamed(AppRoutes.historyDetail, arguments: kHistory.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Viewfinder area
            Positioned.fill(
              child: Container(
                color: const Color(0xFF1E293B),
                child: const CameraOverlay(),
              ),
            ),

            // Top bar controls
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      if (widget.onClose != null) {
                        widget.onClose!();
                      } else {
                        Navigator.of(context).maybePop();
                      }
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'AI Label Scanner',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Processing indicator
            if (_isProcessing)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.7),
                  child: const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: AppColors.teal),
                        SizedBox(height: 16),
                        Text(
                          'Detecting Allergens & Additives...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Bottom camera controls
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: ScannerControls(
                isFlashOn: _isFlashOn,
                onToggleFlash: () => setState(() => _isFlashOn = !_isFlashOn),
                onCapture: _processScan,
                onPickGallery: _processScan,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
