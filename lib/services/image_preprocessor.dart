import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;

/// Result metadata returned after running local preprocessing pipeline
class PreprocessingResult {
  final File processedFile;
  final int originalWidth;
  final int originalHeight;
  final int processedWidth;
  final int processedHeight;
  final int executionTimeMs;

  PreprocessingResult({
    required this.processedFile,
    required this.originalWidth,
    required this.originalHeight,
    required this.processedWidth,
    required this.processedHeight,
    required this.executionTimeMs,
  });
}

/// Localized Edge Image Preprocessor for Food Packaging OCR
///
/// Implements mathematical optimizations specified in SE5104 Proposal Section 5.1 (FR-01):
/// - Grayscale conversion (stripping color noise and chromatic reflections)
/// - Contrast normalization & stretching (enhancing text on glossy/curved wrappers)
/// - Gaussian noise reduction (filtering camera sensor grain under retail lighting)
/// - Dimension optimization (capping max dimension to 1920px for rapid edge OCR)
class ImagePreprocessor {
  /// Maximum dimension for edge processing to prevent high-latency memory exhaustion
  static const int maxDimension = 1920;

  /// Optimizes a raw captured label image file for text extraction
  static Future<PreprocessingResult> preprocessImageFile(
    File inputFile, {
    bool applyContrastStretch = true,
    bool applyDenoise = true,
  }) async {
    final stopwatch = Stopwatch()..start();

    final Uint8List rawBytes = await inputFile.readAsBytes();
    final img.Image? decodedImage = img.decodeImage(rawBytes);

    if (decodedImage == null) {
      throw Exception('Failed to decode captured food packaging image.');
    }

    final int origW = decodedImage.width;
    final int origH = decodedImage.height;

    // 1. Downscale if image exceeds max dimension while preserving aspect ratio
    img.Image processed = decodedImage;
    if (origW > maxDimension || origH > maxDimension) {
      if (origW > origH) {
        processed = img.copyResize(processed, width: maxDimension);
      } else {
        processed = img.copyResize(processed, height: maxDimension);
      }
    }

    // 2. Grayscale Conversion (Luminance extraction)
    processed = img.grayscale(processed);

    // 3. Contrast Normalization / Adjustment
    // Enhances printed ingredient text against metallic, shiny, or patterned packaging
    if (applyContrastStretch) {
      // Linear contrast adjustment (scale factor 1.25)
      processed = img.adjustColor(
        processed,
        contrast: 1.25,
        brightness: 1.05,
      );
    }

    // 4. Noise Reduction (Gaussian blur filter with radius 1 to soften sensor grain)
    if (applyDenoise) {
      processed = img.gaussianBlur(processed, radius: 1);
    }

    // 5. Encode to high-quality JPEG for Google ML Kit ingestion
    final Uint8List encodedBytes = Uint8List.fromList(img.encodeJpg(processed, quality: 92));

    // Save to preprocessed cache directory
    final String tempDir = inputFile.parent.path;
    final String outputPath = '$tempDir/preprocessed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File outputFile = File(outputPath);
    await outputFile.writeAsBytes(encodedBytes);

    stopwatch.stop();

    return PreprocessingResult(
      processedFile: outputFile,
      originalWidth: origW,
      originalHeight: origH,
      processedWidth: processed.width,
      processedHeight: processed.height,
      executionTimeMs: stopwatch.elapsedMilliseconds,
    );
  }

  /// Cleans up temporary preprocessed files generated during OCR scanning
  static Future<void> deleteTempFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (_) {
      // Ignore cleanup errors
    }
  }
}
