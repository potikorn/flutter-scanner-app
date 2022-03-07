import 'package:camera/camera.dart';

class CameraUtil {
  CameraUtil._();

  static Future<CameraDescription> getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) {
        return cameras.firstWhere(
          (CameraDescription camera) => camera.lensDirection == dir,
        );
      },
    );
  }
}
