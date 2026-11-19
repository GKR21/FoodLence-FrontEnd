/// Stub. Replace with google_mlkit_text_recognition when you add the camera.
class OcrService {
  static const _sample =
      'Ingredients: Wheat flour, Sugar, Cocoa powder, Milk powder, Casein?, '
      'Vegetable oil (palm), Salt, Sodium benzoate (E211), Natural flavours, '
      'Lecithin (soy).';

  Future<String> extractText(String? imagePath) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _sample;
  }
}
