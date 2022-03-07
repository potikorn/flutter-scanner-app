import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanner_app/pages/result_page.dart';
import 'package:scanner_app/utils/camera_util.dart';

class CameraViewPage extends StatefulWidget {
  const CameraViewPage({Key? key}) : super(key: key);

  @override
  State<CameraViewPage> createState() => _CameraViewPageState();
}

class _CameraViewPageState extends State<CameraViewPage> {
  CameraController? controller;

  void initCamera() async {
    final camera = await CameraUtil.getCamera(CameraLensDirection.back);
    controller =
        CameraController(camera, ResolutionPreset.max, enableAudio: false);
    controller?.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    initCamera();
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
            controller != null ? CameraPreview(controller!) : Container(),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.only(top: 48, left: 24),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: IconButton(
                    onPressed: () {
                      if (controller?.value.flashMode == FlashMode.torch) {
                        controller?.setFlashMode(FlashMode.off);
                      } else {
                        controller?.setFlashMode(FlashMode.torch);
                      }
                      setState(() {});
                    },
                    icon: Icon(
                      controller?.value.flashMode == FlashMode.torch
                          ? Icons.flash_on_sharp
                          : Icons.flash_off_sharp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
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
