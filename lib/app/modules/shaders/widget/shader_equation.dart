import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ShaderEquation extends StatefulWidget {
  const ShaderEquation(this.shaderPath, {Key? key}) : super(key: key);
  final String shaderPath;

  @override
  State<ShaderEquation> createState() => _ShaderEquationState();
}

class _ShaderEquationState extends State<ShaderEquation> {
  ui.FragmentProgram? fragmentProgram;

  late TimerService _timerService;

  @override
  void initState() {
    super.initState();
    _timerService = TimerService();
    _load(widget.shaderPath);
  }

  void _load(String path) async {
    fragmentProgram = await ui.FragmentProgram.fromAsset(widget.shaderPath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _timerService,
      builder: (context, child) {
        ValueNotifier<Duration> notifier =
            ValueNotifier(_timerService.currentDuration);
        return CustomPaint(
          painter:
              BlurPaint(notifier, shader: fragmentProgram?.fragmentShader()),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

class BlurPaint extends CustomPainter {
  final ValueNotifier<Duration> notifier;
  final ui.FragmentShader? shader;
  final color = Colors.amberAccent;

  BlurPaint(this.notifier, {required this.shader}) : super(repaint: notifier);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (shader == null) {
      return;
    }
    List<List<int>> graphData = [
      [100, 100, 2],
      [800, 500, 1],
      [100, 200, 3]
    ];

    shader?.setFloat(0, size.width);
    shader?.setFloat(1, size.height);
    shader?.setFloat(2, graphData.length.toDouble());
    int totalDuration = 0;
    int maxHeight = 0;
    int shaderFloatCount = 3;
    for (int i = 0; i < 3; i++) {
      if (graphData.length > i) {
        totalDuration = totalDuration + graphData[i].first;
        if (graphData[i].length >= 2) {
          if (graphData[i][1] > maxHeight) {
            maxHeight = graphData[i][1];
          }
        }
      }
      for (int j = 0; j < 3; j++) {
        if (graphData.length > i) {
          shader?.setFloat(shaderFloatCount, graphData[i][j].toDouble());
        } else {
          shader?.setFloat(shaderFloatCount, 0);
        }
        shaderFloatCount = shaderFloatCount + 1;
      }
    }
    shader?.setFloat(shaderFloatCount, totalDuration.toDouble());
    shaderFloatCount = shaderFloatCount + 1;
    shader?.setFloat(shaderFloatCount, maxHeight.toDouble());

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(BlurPaint oldDelegate) => true;
}

class TimerService extends ChangeNotifier {
  late Stopwatch _watch;
  Timer? _timer;

  Duration get currentDuration => _currentDuration;
  Duration _currentDuration = Duration.zero;

  TimerService() {
    _watch = Stopwatch();
    start();
  }

  void _onTick(Timer timer) {
    _currentDuration = _watch.elapsed;

    notifyListeners();
  }

  void start() {
    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(milliseconds: 16), _onTick);
    _watch.start();

    notifyListeners();
  }
}
