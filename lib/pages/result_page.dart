import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:scanner_app/controllers/text_detector.dart';
import 'package:scanner_app/painters/text_detector_painter.dart';
import 'package:touchable/touchable.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key, required this.imageFile}) : super(key: key);

  final XFile imageFile;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  final TextDetector textDetector = GoogleMlKit.vision.textDetector();
  final TextDetectorController textDetectorController =
      Get.put(TextDetectorController());

  List<String> matchIngredients = List<String>.empty(growable: true);
  String textFound = '';
  CanvasTouchDetector? customPaint;
  Size? _imageSize;

  void detectText() async {
    final InputImage inputImage =
        InputImage.fromFile(File(widget.imageFile.path));
    textDetectorController
        .detectIngredientsAndNutrition(inputImage)
        .then((results) {
      setState(() {
        matchIngredients = results.matched;
      });
    });
    final imgSize = await _getImageSize(File(widget.imageFile.path));
    drawPainter(inputImage, imgSize);
    debugPrint('============');
  }

  void drawPainter(
    InputImage inputImage,
    Size? imageSize,
  ) async {
    final recognisedText = await textDetector.processImage(inputImage);
    if (imageSize != null) {
      customPaint = CanvasTouchDetector(
        builder: (context) => CustomPaint(
          painter: TextDetectorPainter(
              context,
              recognisedText,
              imageSize,
              InputImageRotation.Rotation_0deg,
              (text) => debugPrint('text: $text')),
        ),
      );
    } else {
      customPaint = null;
    }
    setState(() {});
  }

  // Fetching the image size from the image file
  Future<Size?> _getImageSize(File imageFile) async {
    final Completer<Size> completer = Completer<Size>();

    final Image image = Image.file(imageFile);
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );

    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
    return imageSize;
  }

  @override
  void initState() {
    super.initState();
    detectText();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('custom paint: ${customPaint}');
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 9 / 20,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(
                      File(widget.imageFile.path),
                      fit: BoxFit.contain,
                    ),
                    if (customPaint != null) customPaint!
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: SingleChildScrollView(
                child: (matchIngredients.isNotEmpty)
                    ? _buildMatchedTextList()
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMatchedTextList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: matchIngredients
            .asMap()
            .entries
            .map(
              (e) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'block ${e.key + 1}: ${e.value}',
                  style: TextStyle(
                      backgroundColor:
                          RegExp('ingrédient').hasMatch(e.value.toLowerCase())
                              ? Colors.amber
                              : Colors.transparent),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
