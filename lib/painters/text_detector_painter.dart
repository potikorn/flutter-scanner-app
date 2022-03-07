import 'dart:ui';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:scanner_app/painters/coor_translator.dart';
import 'package:touchable/touchable.dart';

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.context, this.recognisedText, this.absoluteImageSize,
      this.rotation, this.onTap);

  final BuildContext context;
  final RecognisedText recognisedText;
  final Size absoluteImageSize;
  final InputImageRotation rotation;
  final Function? onTap;

  @override
  void paint(Canvas canvas, Size size) {
    final touchableCanvas = TouchyCanvas(context, canvas);

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = Color(0x99000000);

    for (final textBlock in recognisedText.blocks) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
            textAlign: TextAlign.left,
            fontSize: 12,
            textDirection: TextDirection.ltr),
      );
      builder.pushStyle(
          ui.TextStyle(color: Colors.lightGreenAccent, background: background));
      builder.addText(textBlock.text);
      builder.pop();

      final left =
          translateX(textBlock.rect.left, rotation, size, absoluteImageSize);
      final top =
          translateY(textBlock.rect.top, rotation, size, absoluteImageSize);
      final right =
          translateX(textBlock.rect.right, rotation, size, absoluteImageSize);
      final bottom =
          translateY(textBlock.rect.bottom, rotation, size, absoluteImageSize);

      touchableCanvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint,
          onTapDown: (TapDownDetails tapDownDetails) =>
              onTap != null ? onTap!(textBlock.text) : {});

      touchableCanvas.drawParagraph(
        builder.build()
          ..layout(ParagraphConstraints(
            width: right - left,
          )),
        Offset(left, top),
      );
    }
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return oldDelegate.recognisedText != recognisedText;
  }
}
