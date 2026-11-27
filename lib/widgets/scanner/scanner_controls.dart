import 'package:flutter/material.dart';

/// Control buttons for flash, shutter, and gallery photo picking.
class ScannerControls extends StatelessWidget {
  final VoidCallback onCapture;
  final VoidCallback onPickGallery;
  final VoidCallback onToggleFlash;
  final bool isFlashOn;

  const ScannerControls({
    super.key,
    required this.onCapture,
    required this.onPickGallery,
    required this.onToggleFlash,
    this.isFlashOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Flash button
          IconButton(
            icon: Icon(
              isFlashOn ? Icons.flash_on : Icons.flash_off,
              color: Colors.white,
              size: 26,
            ),
            onPressed: onToggleFlash,
          ),
          // Shutter button
          GestureDetector(
            onTap: onCapture,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 4),
                color: const Color(0xFF16A085),
              ),
              child: const Center(
                child: Icon(Icons.camera_alt, color: Colors.white, size: 32),
              ),
            ),
          ),
          // Gallery photo button
          IconButton(
            icon: const Icon(
              Icons.photo_library_outlined,
              color: Colors.white,
              size: 26,
            ),
            onPressed: onPickGallery,
          ),
        ],
      ),
    );
  }
}
