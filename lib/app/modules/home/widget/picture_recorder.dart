import 'dart:ui';
import 'package:flutter/material.dart';

const kCanvasSize = 300.0;

class PictureRecorderBoard extends StatefulWidget {
  const PictureRecorderBoard({super.key});

  @override
  State<PictureRecorderBoard> createState() => _PictureRecorderBoardState();
}

class _PictureRecorderBoardState extends State<PictureRecorderBoard> {
  Color selectedColor = Colors.black;
  double strokeWidth = 5;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [
    Colors.pink,
    Colors.red,
    Colors.black,
    Colors.yellow,
    Colors.amberAccent,
    Colors.purple,
    Colors.green,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            body: Center(
              child: GestureDetector(
                onPanStart: (details) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        Paint()
                          ..color = selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanUpdate: (details) {
                  setState(() {
                    drawingPoints.add(
                      DrawingPoint(
                        details.localPosition,
                        Paint()
                          ..color = selectedColor
                          ..isAntiAlias = true
                          ..strokeWidth = strokeWidth
                          ..strokeCap = StrokeCap.round,
                      ),
                    );
                  });
                },
                onPanEnd: (details) {
                  setState(() {
                    drawingPoints.add(null);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.greenAccent, width: 2)),
                  width: kCanvasSize,
                  height: kCanvasSize,
                  child: CustomPaint(
                    painter: _DrawingPainter(drawingPoints),
                    child: Container(),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 30,
            child: Row(
              children: [
                Slider(
                  min: 0,
                  max: 40,
                  value: strokeWidth,
                  onChanged: (val) => setState(() => strokeWidth = val),
                ),
                ElevatedButton.icon(
                  onPressed: () => setState(() => drawingPoints = []),
                  icon: const Icon(Icons.clear),
                  label: const Text("Clear Board"),
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 100),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(
              colors.length,
              (index) => _buildColorChose(colors[index]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorChose(Color color) {
    bool isSelected = selectedColor == color;
    return GestureDetector(
      onTap: () => setState(() => selectedColor = color),
      child: Container(
        height: isSelected ? 47 : 40,
        width: isSelected ? 47 : 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: Colors.white, width: 3) : null,
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<DrawingPoint?> drawingPoints;

  _DrawingPainter(this.drawingPoints);

  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRRect(RRect.fromRectXY(
      Rect.fromPoints(const Offset(0.0, 0.0),
          const Offset(kCanvasSize - 4, kCanvasSize - 4)),
      0,
      0,
    ));
    for (int i = 0; i < drawingPoints.length; i++) {
      if (drawingPoints[i + 1] != null && drawingPoints[i] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i]!.offset);

        canvas.drawPoints(
            PointMode.points, offsetsList, drawingPoints[i]!.paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DrawingPoint {
  Offset offset;
  Paint paint;

  DrawingPoint(this.offset, this.paint);
}
