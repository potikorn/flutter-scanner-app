import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:scanner_app/controllers/text_detector.dart';

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

  void detectText() async {
    final InputImage inputImage =
        InputImage.fromFile(File(widget.imageFile.path));
    textDetectorController.detectIngredients(inputImage).then((matched) {
      setState(() {
        matchIngredients = matched;
      });
    });
    debugPrint('============');
  }

  @override
  void initState() {
    super.initState();
    detectText();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 400,
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 9 / 20,
                child: Image.file(
                  File(widget.imageFile.path),
                  fit: BoxFit.contain,
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
            .map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('block ${e.key + 1}: ${e.value}',
                      style: TextStyle(
                          backgroundColor: RegExp('ingrédient')
                                  .hasMatch(e.value.toLowerCase())
                              ? Colors.amber
                              : Colors.transparent)),
                ))
            .toList(),
      ),
    );
  }
}
