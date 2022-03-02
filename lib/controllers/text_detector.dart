import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

import '../constants/ingredients.dart';

class TextDetectorController extends GetxController {
  final TextDetector textDetector = GoogleMlKit.vision.textDetector();

  Future<List<String>> detectIngredients(InputImage inputImage) async {
    final recognisedText = await textDetector.processImage(inputImage);
    debugPrint('Found ${recognisedText.blocks.length} textBlocks');
    debugPrint('Found text ${recognisedText.text}');
    for (TextBlock m in recognisedText.blocks) {
      debugPrint('element ${m.text}');
    }
    final matched = recognisedText.blocks
        // .where((element) => MATCH_INS.contains(element.text.toLowerCase()))
        .map((e) => e.text.toString());

    return matched.toList();
  }
}
