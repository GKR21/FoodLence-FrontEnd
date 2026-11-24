import 'package:flutter/material.dart';
import '../../config/app_routes.dart';
import '../../models/scan_model.dart';

class OCRReviewScreen extends StatefulWidget {
  final Function(String, Map<String, dynamic>?)? go;

  const OCRReviewScreen({
    super.key,
    this.go,
  });

  @override
  State<OCRReviewScreen> createState() => _OCRReviewScreenState();
}

class _OCRReviewScreenState extends State<OCRReviewScreen> {
  String text =
      "Ingredients: Wheat flour, Sugar, Cocoa powder, Milk powder, "
      "Casein, Vegetable oil (palm), Salt, Sodium benzoate (E211), "
      "Natural flavours, Lecithin (soy).";

  bool editing = false;
  late final TextEditingController _textController;

  static const Color primaryColor = Color(0xFF16A085);
  static const Color backgroundColor = Color(0xFFF8FAFC);

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: text);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _navigate(String target, [Map<String, dynamic>? data]) {
    if (widget.go != null) {
      widget.go!(target, data);
      return;
    }
    if (target == "scanner") {
      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } else if (target == "result") {
      Navigator.of(context).pushReplacementNamed(
        AppRoutes.historyDetail,
        arguments: kHistory.first,
      );
    } else {
      Navigator.of(context).maybePop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Rescan button
                  InkWell(
                    onTap: () => _navigate("scanner", {"navTab": "scan"}),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: 20,
                          color: primaryColor,
                        ),
                        SizedBox(width: 8),
                        Text(
                          "Rescan",
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    "Review Extracted Text",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    "We found this ingredient list. Check highlighted words "
                    "if the label was unclear.",
                    style: TextStyle(
                      color: isDark
                          ? const Color(0xFF94A3B8)
                          : const Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Main content
            Expanded(
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics(),
                ),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Scan image thumbnail
                    Container(
                      height: 112,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE5E7EB),
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Image.network(
                        "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=340&h=112&fit=crop&auto=format",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: isDark
                                ? const Color(0xFF334155)
                                : Colors.grey.shade200,
                            child: const Center(
                              child: Icon(
                                Icons.image,
                                color: Colors.grey,
                                size: 40,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Warning box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFFFF7ED),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFFD97706).withValues(alpha: 0.3)
                              : const Color(0xFFFED7AA),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.warning_amber_rounded,
                            color: Color(0xFFF59E0B),
                            size: 18,
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text.rich(
                              const TextSpan(
                                children: [
                                  TextSpan(
                                    text: "1 word ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        "could not be read clearly and is "
                                        "highlighted below. Please verify "
                                        "before continuing.",
                                  ),
                                ],
                              ),
                              style: TextStyle(
                                color: isDark
                                    ? const Color(0xFFFDE68A)
                                    : const Color(0xFF92400E),
                                fontSize: 12,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Extracted Ingredient List Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : Colors.white,
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE5E7EB),
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Card header
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Extracted Ingredient List",
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF374151),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              InkWell(
                                onTap: () {
                                  setState(() {
                                    editing = !editing;
                                    if (editing) {
                                      _textController.text = text;
                                      _textController.selection =
                                          TextSelection.collapsed(
                                        offset: text.length,
                                      );
                                    } else {
                                      text = _textController.text;
                                    }
                                  });
                                },
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.edit_outlined,
                                      size: 15,
                                      color: primaryColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      editing ? "Done" : "Edit",
                                      style: const TextStyle(
                                        color: primaryColor,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Text editor / highlighted text
                          if (editing)
                            TextField(
                              controller: _textController,
                              maxLines: 6,
                              onChanged: (value) {
                                text = value;
                              },
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF111827),
                                fontSize: 13,
                                height: 1.6,
                              ),
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: isDark
                                    ? const Color(0xFF0F172A)
                                    : const Color(0xFFF0FDF8),
                                contentPadding:
                                    const EdgeInsets.all(12),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: primaryColor,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            )
                          else
                            _buildHighlightedText(isDark),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Continue Analysis Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _navigate("result", {"resultType": "unsafe"});
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                          elevation: 4,
                        ),
                        child: const Text(
                          "Continue Analysis",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Rescan Button
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () {
                          _navigate("scanner", {"navTab": "scan"});
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor:
                              isDark ? const Color(0xFF1E293B) : Colors.white,
                          foregroundColor: isDark
                              ? const Color(0xFFCBD5E1)
                              : const Color(0xFF6B7280),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          side: BorderSide(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE5E7EB),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          "Rescan",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Ingredient text with highlighted uncertain word
  Widget _buildHighlightedText(bool isDark) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: isDark ? const Color(0xFFE2E8F0) : const Color(0xFF374151),
          fontSize: 13,
          height: 1.6,
        ),
        children: [
          const TextSpan(
            text: "Ingredients: Wheat flour, Sugar, Cocoa powder, "
                "Milk powder, ",
          ),

          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 1,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? const Color(0xFF78350F).withValues(alpha: 0.6)
                    : const Color(0xFFFEF3C7),
                border: Border.all(
                  color: isDark
                      ? const Color(0xFFB45309)
                      : const Color(0xFFFDE68A),
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                "Casein?",
                style: TextStyle(
                  color: isDark
                      ? const Color(0xFFFDE68A)
                      : const Color(0xFF92400E),
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          ),

          const TextSpan(
            text: ", Vegetable oil (palm), Salt, Sodium benzoate "
                "(E211), Natural flavours, Lecithin (soy).",
          ),
        ],
      ),
    );
  }
}

/// Compatibility alias matching the 65-file architecture naming.
typedef ImagePreviewScreen = OCRReviewScreen;
