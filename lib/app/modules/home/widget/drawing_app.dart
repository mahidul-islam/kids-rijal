import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import 'package:kids_rijal/app/utils/canvas_helpers.dart';

class DrawingBoard extends StatefulWidget {
  const DrawingBoard({super.key, required this.path});
  final String path;

  @override
  State<DrawingBoard> createState() => _DrawingBoardState();
}

class _DrawingBoardState extends State<DrawingBoard> {
  List<Offset?> drawingPoints = [];
  ui.Image? image;

  void _load(String path) async {
    var bytes = await rootBundle.load(path);
    image = await decodeImageFromList(bytes.buffer.asUint8List());
    setState(() {});
  }

  @override
  void initState() {
    _load(widget.path);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GestureDetector(
            onPanStart: (details) {
              setState(() {
                drawingPoints.add(
                  details.localPosition,
                );
              });
            },
            onPanUpdate: (details) {
              setState(() {
                drawingPoints.add(
                  details.localPosition,
                );
              });
            },
            onPanEnd: (details) {
              setState(() {
                drawingPoints.add(
                  null,
                );
              });
            },
            child: CustomPaint(
              painter: _DrawingPainter(drawingPoints, image),
              child: Container(),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<Offset?> drawingPoints;
  final ui.Image? image;
  Rect? clip;
  Matrix4? matrix;
  late Size imageSize;

  _DrawingPainter(this.drawingPoints, this.image) {
    imageSize =
        Size(image?.width.toDouble() ?? 0, image?.height.toDouble() ?? 0);
  }

  List<Offset> offsetsList = [];
  Paint clearBrush = Paint()
    ..isAntiAlias = true
    ..color = Colors.transparent
    ..strokeWidth = 80
    ..strokeCap = StrokeCap.round
    ..blendMode = BlendMode.clear;

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null) {
      return;
    }

    if (matrix == null) {
      matrix = sizeToRect(imageSize, Offset.zero & size);
      clip = MatrixUtils.transformRect(matrix!, Offset.zero & imageSize);
    }

    canvas.clipRect(clip!);

    paintImage(
      canvas: canvas,
      rect: clip!,
      image: image!,
    );

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    paintImage(
      canvas: canvas,
      rect: clip!,
      image: image!,
      colorFilter: const ColorFilter.mode(
        Colors.blueGrey,
        BlendMode.srcATop,
      ),
    );

    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i + 1] != null && drawingPoints[i] != null) {
        canvas.drawLine(
          drawingPoints[i]!,
          drawingPoints[i + 1]!,
          clearBrush,
        );
      } else if (drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i]!);
        canvas.drawPoints(PointMode.points, offsetsList, clearBrush);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
