import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

const kCanvasSize = 300.0;

class PictureRecorderBoard extends StatefulWidget {
  const PictureRecorderBoard({super.key});

  @override
  State<PictureRecorderBoard> createState() => _PictureRecorderBoardState();
}

Future<ui.Image> getImage({required List<DrawingPoint?> points}) async {
  final ui.PictureRecorder recorder = ui.PictureRecorder();
  Canvas canvas = Canvas(recorder);
  CustomPainter painter = _DrawingPainter(points);
  painter.paint(canvas, const Size(kCanvasSize, kCanvasSize));
  final ui.Picture picture = recorder.endRecording();
  return await picture.toImage(kCanvasSize.toInt(), kCanvasSize.toInt());
}

Future<Map<Color, int>> getImageStat(
    {required List<DrawingPoint?> points}) async {
  Map<Color, int> res = <Color, int>{};
  ui.Image image = await getImage(points: points);
  List<int> rgbList;
  ByteData? data =
      await image.toByteData(format: ui.ImageByteFormat.rawStraightRgba);
  rgbList = data?.buffer.asUint8List().toList() ?? Uint8List(0);
  for (var x = 0; x < rgbList.length; x += 4) {
    final int r = rgbList[x];
    final int g = rgbList[x + 1];
    final int b = rgbList[x + 2];
    Color color = Color.fromRGBO(r, g, b, 1);
    if (!res.keys.contains(color)) {
      res[color] = 1;
    } else {
      res[color] = (res[color] ?? 0) + 1;
    }
  }
  return res;
}

String getPercentage(Map<Color, int> perOfColor, int index) {
  int sum = 0;
  for (int i = 0; i < perOfColor.length; i++) {
    sum = sum + perOfColor.values.elementAt(i);
  }
  return '${((perOfColor.values.elementAt(index) / sum) * 100).toStringAsFixed(2)} %';
}

bool reduceIrrevalant(Map<Color, int> perOfColor, int value) {
  int sum = 0;
  for (int i = 0; i < perOfColor.length; i++) {
    sum = sum + perOfColor.values.elementAt(i);
  }
  return (value / sum) > 0.01;
}

class _PictureRecorderBoardState extends State<PictureRecorderBoard> {
  Color selectedColor = Colors.red;
  double strokeWidth = 30;
  List<DrawingPoint?> drawingPoints = [];
  List<Color> colors = [Colors.pink, Colors.red, Colors.blue, Colors.yellow];
  Map<Color, int> perOfColor = <Color, int>{};

  ByteData? imgBytes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    children: <Widget>[
                      const SizedBox(height: 20),
                      for (int i = 0; i < perOfColor.length; i++) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              height: 20,
                              width: 20,
                              color: perOfColor.keys.elementAt(i),
                            ),
                            const SizedBox(width: 50),
                            Text(getPercentage(perOfColor, i)),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ]
                    ],
                  ),
                  imgBytes != null
                      ? Center(
                          child: Image.memory(
                          Uint8List.view(imgBytes!.buffer),
                          width: kCanvasSize / 3,
                          height: kCanvasSize / 3,
                        ))
                      : Container(),
                  GestureDetector(
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
                    onPanEnd: (details) async {
                      drawingPoints.add(null);
                      ui.Image img = await getImage(points: drawingPoints);
                      imgBytes =
                          await img.toByteData(format: ui.ImageByteFormat.png);
                      perOfColor = await getImageStat(
                        points: drawingPoints,
                      );
                      perOfColor.removeWhere((Color color, int value) {
                        if (reduceIrrevalant(perOfColor, value)) {
                          return false;
                        } else {
                          return true;
                        }
                      });
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.greenAccent, width: 2)),
                      width: kCanvasSize,
                      height: kCanvasSize,
                      child: CustomPaint(
                        painter: _DrawingPainter(drawingPoints),
                        child: Container(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 0,
            child: Column(
              children: [
                Slider(
                  min: 20,
                  max: 100,
                  value: strokeWidth,
                  onChanged: (val) => setState(() => strokeWidth = val),
                ),
                MaterialButton(
                  onPressed: () => setState(
                    () {
                      drawingPoints = [];
                      perOfColor = {};
                      imgBytes = null;
                    },
                  ),
                  color: Colors.amberAccent,
                  child: const Text("Clear"),
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

  // final PictureRecorder pictureRecorder;
  List<Offset> offsetsList = [];

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRRect(RRect.fromRectXY(
      Rect.fromPoints(const Offset(0.0, 0.0),
          const Offset(kCanvasSize - 4, kCanvasSize - 4)),
      0,
      0,
    ));
    for (int i = 0; i < drawingPoints.length - 1; i++) {
      if (drawingPoints[i] != null && drawingPoints[i + 1] != null) {
        canvas.drawLine(drawingPoints[i]!.offset, drawingPoints[i + 1]!.offset,
            drawingPoints[i]!.paint);
      } else if (drawingPoints[i + 1] == null) {
        offsetsList.clear();
        offsetsList.add(drawingPoints[i]!.offset);

        canvas.drawPoints(
            ui.PointMode.points, offsetsList, drawingPoints[i]!.paint);
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
