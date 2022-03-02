import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:scan/scan.dart';
import 'package:scanner_app/pages/result_page.dart';
import 'package:scanner_app/painters/coor_translator.dart';
import 'package:scanner_app/utils/scanner_util.dart';

List<CameraDescription>? cameras;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CameraApp(),
    );
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  final TextDetector textDetector = GoogleMlKit.vision.textDetector();

  CameraController? controller;
  CameraDescription? camera;

  bool _isDetecting = false;

  late List<TextElement> textElements;

  CustomPaint? customPaint;

  // void startStream() async {
  //   await controller?.startImageStream(
  //     (CameraImage image) async {
  //       if (_isDetecting) return;
  //       _isDetecting = true;

  //       ScannerUtil.detect(
  //         image: image,
  //         imageRotation: camera?.sensorOrientation ?? 0,
  //         onProcess: (InputImage inputImage) async {
  //           final recognisedText = await textDetector.processImage(inputImage);
  //           debugPrint('Found ${recognisedText.blocks.length} textBlocks');

  //           if (inputImage.inputImageData?.size != null &&
  //               inputImage.inputImageData?.imageRotation != null) {
  //             final painter = TextDetectorPainter(
  //                 inputImage.inputImageData!.size, recognisedText);
  //             customPaint = CustomPaint(painter: painter);
  //           } else {
  //             customPaint = null;
  //           }
  //           _isDetecting = false;
  //           if (mounted) {
  //             setState(() {});
  //           }
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  void initState() {
    super.initState();
    camera = cameras![0];
    controller =
        CameraController(cameras![0], ResolutionPreset.max, enableAudio: false);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      } else {
        // startStream();
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller?.value.isInitialized == false) {
      return Container();
    }
    return Scaffold(
      body: Container(
        color: Colors.black,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CameraPreview(controller!),
            if (customPaint != null) customPaint!,
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 32.0),
                child: Container(
                  padding: const EdgeInsets.only(right: 16.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      controller?.takePicture().then(
                        (XFile file) async {
                          Get.to(() => ResultPage(imageFile: file));
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.camera,
                      color: Colors.amber,
                    ),
                    label: const Text(
                      'Capture',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScanController controller = ScanController();
  String qrcode = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile Scanner')),
      body: Column(
        children: [
          AspectRatio(
            aspectRatio: 1 / 1,
            child: SizedBox(
              width: double.infinity, // custom wrap size
              child: ScanView(
                controller: controller,
                // custom scan area, if set to 1.0, will scan full area
                scanAreaScale: 1.0,
                scanLineColor: Colors.green.shade400,
                onCapture: (data) {
                  // do something
                  setState(() {
                    qrcode = data;
                  });
                },
              ),
            ),
          ),
          Text(qrcode),
          ElevatedButton(
              onPressed: () {
                controller.resume();
              },
              child: Text('Resume'))
        ],
      ),
    );
  }
}
