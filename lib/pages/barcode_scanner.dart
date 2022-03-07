import 'package:flutter/material.dart';
import 'package:scan/scan.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({Key? key}) : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
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
            child: const Text('Resume'),
          )
        ],
      ),
    );
  }
}
