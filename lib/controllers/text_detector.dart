import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:scanner_app/models/text_recognize_response.dart';

class TextDetectorController extends GetxController {
  final TextDetector textDetector = GoogleMlKit.vision.textDetector();

  @override
  void onClose() {
    textDetector.close();
    super.onClose();
  }

  // TODO extract ingredients and nutrition
  Future<TextRecognizeResponse> detectIngredientsAndNutrition(
      InputImage inputImage) async {
    final recognisedText = await textDetector.processImage(inputImage);
    debugPrint('Found ${recognisedText.blocks.length} textBlocks');
    debugPrint('Found text ${recognisedText.text}');
    for (TextBlock m in recognisedText.blocks) {
      debugPrint('element ${m.text}');
    }
    final ingredient = recognisedText.blocks
        .where((element) =>
            RegExp('ingrédient').hasMatch(element.text.toLowerCase()))
        .map((e) => e.text);
    final matched = recognisedText.blocks.map((e) => e.text.toString());
    final TextRecognizeResponse response = TextRecognizeResponse(
        ingredient.isNotEmpty ? ingredient.first.toString() : "",
        matched.toList());

    return response;
  }
}
