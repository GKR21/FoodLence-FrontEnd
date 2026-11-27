import 'package:flutter/material.dart';

/// Viewfinder overlay with corner brackets for food label scanning.
class CameraOverlay extends StatelessWidget {
  final double cornerLength;
  final double cornerWidth;
  final Color cornerColor;

  const CameraOverlay({
    super.key,
    this.cornerLength = 28.0,
    this.cornerWidth = 4.0,
    this.cornerColor = const Color(0xFF16A085),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxSize = (constraints.maxWidth * 0.75).clamp(240.0, 320.0);

        return Center(
          child: Container(
            width: boxSize,
            height: boxSize,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                // Top-Left Corner
                Positioned(
                  top: 0,
                  left: 0,
                  child: _buildCorner(isTop: true, isLeft: true),
                ),
                // Top-Right Corner
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildCorner(isTop: true, isLeft: false),
                ),
                // Bottom-Left Corner
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: _buildCorner(isTop: false, isLeft: true),
                ),
                // Bottom-Right Corner
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: _buildCorner(isTop: false, isLeft: false),
                ),
                // Center hint
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Align food label text here',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCorner({required bool isTop, required bool isLeft}) {
    return Container(
      width: cornerLength,
      height: cornerLength,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? BorderSide(color: cornerColor, width: cornerWidth)
              : BorderSide.none,
          bottom: !isTop
              ? BorderSide(color: cornerColor, width: cornerWidth)
              : BorderSide.none,
          left: isLeft
              ? BorderSide(color: cornerColor, width: cornerWidth)
              : BorderSide.none,
          right: !isLeft
              ? BorderSide(color: cornerColor, width: cornerWidth)
              : BorderSide.none,
        ),
      ),
    );
  }
}
