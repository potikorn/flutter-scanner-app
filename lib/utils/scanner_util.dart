import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class ScannerUtil {
  ScannerUtil._();

  static Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) {
        return cameras.firstWhere(
          (CameraDescription camera) => camera.lensDirection == dir,
        );
      },
    );
  }

  static Future<dynamic> detect({
    required CameraImage image,
    required int imageRotation,
    required Function onProcess,
  }) async {
    final WriteBuffer allBytes = WriteBuffer();
    for (Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(
      image.width.toDouble(),
      image.height.toDouble(),
    );

    final InputImageFormat inputImageFormat =
        InputImageFormatMethods.fromRawValue(image.format.raw) ??
            InputImageFormat.NV21;

    final planeData = image.planes.map((Plane plane) {
      return InputImagePlaneMetadata(
        bytesPerRow: plane.bytesPerRow,
        height: plane.height,
        width: plane.width,
      );
    });

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: InputImageRotation.Rotation_0deg,
      inputImageFormat: inputImageFormat,
      planeData: planeData.toList(),
    );

    final inputImage =
        InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);

    onProcess(inputImage);
  }
}
