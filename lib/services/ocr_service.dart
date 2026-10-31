import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

/// Structured outcome of edge OCR text extraction
class OcrResult {
  final String rawText;
  final String cleanedText;
  final List<String> lines;
  final List<TextBlock> blocks;
  final bool hasIngredientKeywords;
  final String? isolatedIngredientsSection;

  OcrResult({
    required this.rawText,
    required this.cleanedText,
    required this.lines,
    required this.blocks,
    required this.hasIngredientKeywords,
    this.isolatedIngredientsSection,
  });

  Map<String, dynamic> toJson() {
    return {
      'raw_text': rawText,
      'cleaned_text': cleanedText,
      'lines': lines,
      'has_ingredient_keywords': hasIngredientKeywords,
      'isolated_ingredients_section': isolatedIngredientsSection,
    };
  }
}

/// Service handling on-device OCR using Google ML Kit Text Recognition
///
/// Implements Edge OCR processing for FoodLence mobile client as specified in SE5104 Proposal:
/// - Executes Latin script text recognition on local neural processing pipeline
/// - Performs post-OCR heuristic textual normalization and hyphen de-breaking
/// - Filters scanner noise, stray punctuation, and isolates ingredient disclosures
class OcrService {
  final TextRecognizer _textRecognizer;

  OcrService({TextRecognitionScript script = TextRecognitionScript.latin})
      : _textRecognizer = TextRecognizer(script: script);

  /// Common packaging keywords that signify the start of food ingredient disclosures
  static final List<RegExp> _ingredientHeaderPatterns = [
    RegExp(r'\bingredients?\b[:\s]?', caseSensitive: false),
    RegExp(r'\bcontains?\b[:\s]?', caseSensitive: false),
    RegExp(r'\ballergens?(\s+info(rmation)?)?\b[:\s]?', caseSensitive: false),
    RegExp(r'\bmay\s+contain\b[:\s]?', caseSensitive: false),
    RegExp(r'\bcomposition\b[:\s]?', caseSensitive: false),
  ];

  /// Common packaging metadata sections that signal the end of ingredients list
  static final List<RegExp> _ingredientEndPatterns = [
    RegExp(r'\bnutrition\s+facts\b', caseSensitive: false),
    RegExp(r'\bmanufactured\s+by\b', caseSensitive: false),
    RegExp(r'\bdistributed\s+by\b', caseSensitive: false),
    RegExp(r'\bstorage\s+instructions?\b', caseSensitive: false),
    RegExp(r'\bbest\s+before\b', caseSensitive: false),
    RegExp(r'\bexpiry\s+date\b', caseSensitive: false),
    RegExp(r'\bnet\s+wt\b', caseSensitive: false),
    RegExp(r'\bkeep\s+refrigerated\b', caseSensitive: false),
  ];

  /// Processes a local image file using ML Kit Text Recognition
  Future<OcrResult> processImage(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    final String raw = recognizedText.text;
    final List<String> extractedLines = [];

    for (final TextBlock block in recognizedText.blocks) {
      for (final TextLine line in block.lines) {
        final trimmed = line.text.trim();
        if (trimmed.isNotEmpty) {
          extractedLines.add(trimmed);
        }
      }
    }

    final String cleaned = _cleanAndNormalizeText(raw);
    final bool hasKeywords = _containsIngredientKeywords(cleaned);
    final String? isolatedIngredients = _isolateIngredientSection(cleaned);

    return OcrResult(
      rawText: raw,
      cleanedText: cleaned,
      lines: extractedLines,
      blocks: recognizedText.blocks,
      hasIngredientKeywords: hasKeywords,
      isolatedIngredientsSection: isolatedIngredients,
    );
  }

  /// Cleans OCR noise, normalizes line breaks, and repairs hyphenated words
  String _cleanAndNormalizeText(String input) {
    if (input.trim().isEmpty) return '';

    // 1. Normalize line endings and whitespace
    String text = input.replaceAll('\r\n', '\n').replaceAll('\r', '\n');

    // 2. Reconnect hyphenated word splits across lines (e.g., "so- \n dium" -> "sodium")
    text = text.replaceAllMapped(
      RegExp(r'(\w+)-\s*\n\s*(\w+)', multiLine: true),
      (match) => '${match[1]}${match[2]}',
    );

    // 3. Remove non-printable control characters while preserving valid Latin/Unicode text
    text = text.replaceAll(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F\x7F]'), '');

    // 4. Clean line by line: remove isolated stray symbols and bullet characters
    final lines = text.split('\n');
    final cleanedLines = <String>[];

    for (var line in lines) {
      String l = line.trim();
      // Replace bullet characters often used in ingredient lists with standard commas
      l = l.replaceAll(RegExp(r'^[•\-\*·▪■◆●]\s*'), '');
      l = l.replaceAll(RegExp(r'\s+[•·▪■◆●]\s+'), ', ');

      // Filter out lines that are purely noisy punctuation / symbols (e.g. "---", "...", "|")
      if (l.isNotEmpty && RegExp(r'[a-zA-Z0-9]').hasMatch(l)) {
        cleanedLines.add(l);
      }
    }

    return cleanedLines.join('\n');
  }

  /// Checks if any prominent ingredient disclosure headers are present
  bool _containsIngredientKeywords(String text) {
    for (final pattern in _ingredientHeaderPatterns) {
      if (pattern.hasMatch(text)) {
        return true;
      }
    }
    return false;
  }

  /// Attempts to extract the focused ingredients block from broader label packaging text
  String? _isolateIngredientSection(String text) {
    int startIdx = -1;

    for (final pattern in _ingredientHeaderPatterns) {
      final match = pattern.firstMatch(text);
      if (match != null) {
        if (startIdx == -1 || match.start < startIdx) {
          startIdx = match.start;
        }
      }
    }

    if (startIdx == -1) return null;

    final candidate = text.substring(startIdx);
    int endIdx = candidate.length;

    for (final pattern in _ingredientEndPatterns) {
      final match = pattern.firstMatch(candidate);
      if (match != null && match.start > 0 && match.start < endIdx) {
        endIdx = match.start;
      }
    }

    return candidate.substring(0, endIdx).trim();
  }

  /// Closes and releases native ML Kit resources
  Future<void> dispose() async {
    await _textRecognizer.close();
  }
}
