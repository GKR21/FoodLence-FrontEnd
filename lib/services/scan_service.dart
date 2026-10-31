import 'dart:convert';
import 'dart:io';
import 'image_preprocessor.dart';
import 'ocr_service.dart';

/// Standardized payload packaged by the mobile client for backend analysis (/api/v1/analyze)
class ScanPayload {
  final String ocrText;
  final String rawText;
  final String? isolatedIngredients;
  final String? profileId;
  final List<String> rawLines;
  final bool hasIngredientKeywords;
  final Map<String, dynamic> clientMetadata;

  ScanPayload({
    required this.ocrText,
    required this.rawText,
    this.isolatedIngredients,
    this.profileId,
    required this.rawLines,
    required this.hasIngredientKeywords,
    required this.clientMetadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'ocr_text': ocrText,
      'raw_text': rawText,
      'isolated_ingredients': isolatedIngredients,
      'profile_id': profileId,
      'raw_lines': rawLines,
      'has_ingredient_keywords': hasIngredientKeywords,
      'client_metadata': clientMetadata,
    };
  }

  String toFormattedJson() => const JsonEncoder.withIndent('  ').convert(toJson());
}

/// Complete result of edge scan execution containing preprocessing and OCR telemetry
class ScanExecutionResult {
  final bool isSuccess;
  final PreprocessingResult? preprocessingResult;
  final OcrResult? ocrResult;
  final ScanPayload? payload;
  final String? errorMessage;

  ScanExecutionResult._({
    required this.isSuccess,
    this.preprocessingResult,
    this.ocrResult,
    this.payload,
    this.errorMessage,
  });

  factory ScanExecutionResult.success({
    required PreprocessingResult preprocessingResult,
    required OcrResult ocrResult,
    required ScanPayload payload,
  }) {
    return ScanExecutionResult._(
      isSuccess: true,
      preprocessingResult: preprocessingResult,
      ocrResult: ocrResult,
      payload: payload,
    );
  }

  factory ScanExecutionResult.failure({required String errorMessage}) {
    return ScanExecutionResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}

/// Orchestration service for FoodLence mobile scanning pipeline
///
/// Implements full client-side edge workflow (Stage 2):
/// 1. Takes raw captured label image
/// 2. Executes mathematical preprocessing (grayscale, contrast, denoise, scaling)
/// 3. Extracts text via Google ML Kit Text Recognition
/// 4. Normalizes and isolates ingredient listings
/// 5. Packages standardized ScanPayload ready for FastAPI backend inference
class ScanService {
  final OcrService _ocrService;
  final bool _autoDisposeOcr;

  ScanService({OcrService? ocrService})
      : _ocrService = ocrService ?? OcrService(),
        _autoDisposeOcr = ocrService == null;

  /// Executes the complete edge pipeline on a captured food packaging image
  Future<ScanExecutionResult> processCapturedLabel({
    required File imageFile,
    String? activeProfileId,
    bool retainPreprocessedFile = false,
  }) async {
    File? preprocessedFile;
    try {
      if (!await imageFile.exists()) {
        return ScanExecutionResult.failure(
          errorMessage: 'Source image file does not exist at ${imageFile.path}',
        );
      }

      // Step 1: Preprocess raw image
      final PreprocessingResult prepResult = await ImagePreprocessor.preprocessImageFile(imageFile);
      preprocessedFile = prepResult.processedFile;

      // Step 2: Edge OCR text extraction
      final OcrResult ocrResult = await _ocrService.processImage(preprocessedFile);

      // Step 3: Package payload for backend
      final payload = ScanPayload(
        ocrText: ocrResult.cleanedText,
        rawText: ocrResult.rawText,
        isolatedIngredients: ocrResult.isolatedIngredientsSection,
        profileId: activeProfileId,
        rawLines: ocrResult.lines,
        hasIngredientKeywords: ocrResult.hasIngredientKeywords,
        clientMetadata: {
          'preprocessing_time_ms': prepResult.executionTimeMs,
          'original_dimensions': '${prepResult.originalWidth}x${prepResult.originalHeight}',
          'processed_dimensions': '${prepResult.processedWidth}x${prepResult.processedHeight}',
          'timestamp': DateTime.now().toUtc().toIso8601String(),
          'client_platform': Platform.operatingSystem,
        },
      );

      // Clean up temporary image file unless caller requests retaining it
      if (!retainPreprocessedFile) {
        await ImagePreprocessor.deleteTempFile(preprocessedFile);
      }

      return ScanExecutionResult.success(
        preprocessingResult: prepResult,
        ocrResult: ocrResult,
        payload: payload,
      );
    } catch (e) {
      // Clean up if failure occurred
      if (preprocessedFile != null && !retainPreprocessedFile) {
        await ImagePreprocessor.deleteTempFile(preprocessedFile);
      }
      return ScanExecutionResult.failure(
        errorMessage: 'OCR Processing Pipeline failed: $e',
      );
    }
  }

  /// Dispatches the scan payload to the FastAPI backend service
  Future<Map<String, dynamic>> submitScanToBackend({
    required ScanPayload payload,
    required Uri backendUri,
    String? bearerToken,
    Duration timeout = const Duration(seconds: 15),
  }) async {
    final client = HttpClient();
    client.connectionTimeout = timeout;

    try {
      final request = await client.postUrl(backendUri);
      request.headers.contentType = ContentType.json;
      if (bearerToken != null && bearerToken.isNotEmpty) {
        request.headers.set(HttpHeaders.authorizationHeader, 'Bearer $bearerToken');
      }

      final bodyJson = jsonEncode(payload.toJson());
      request.write(bodyJson);

      final response = await request.close().timeout(timeout);
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(responseBody) as Map<String, dynamic>;
      } else {
        throw HttpException(
          'Backend returned status ${response.statusCode}: $responseBody',
          uri: backendUri,
        );
      }
    } finally {
      client.close();
    }
  }

  /// Releases native OCR resources
  Future<void> dispose() async {
    if (_autoDisposeOcr) {
      await _ocrService.dispose();
    }
  }
}
