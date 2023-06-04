import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class ShaderExp extends StatefulWidget {
  const ShaderExp(this.shaderPath, {Key? key}) : super(key: key);
  final String shaderPath;

  @override
  State<ShaderExp> createState() => _ShaderExpState();
}

class _ShaderExpState extends State<ShaderExp> {
  ui.FragmentProgram? fragmentProgram;

  @override
  void initState() {
    super.initState();
    _load(widget.shaderPath);
  }

  void _load(String path) async {
    fragmentProgram = await ui.FragmentProgram.fromAsset(widget.shaderPath);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<Offset> notifier = ValueNotifier(Offset.infinite);
    return Listener(
      onPointerDown: (event) => notifier.value = event.localPosition,
      onPointerMove: (event) => notifier.value = event.localPosition,
      child: CustomPaint(
        painter: BlurPaint(notifier, shader: fragmentProgram?.fragmentShader()),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class BlurPaint extends CustomPainter {
  final ValueNotifier<Offset> notifier;
  final ui.FragmentShader? shader;
  final color = Colors.amberAccent;

  BlurPaint(this.notifier, {required this.shader}) : super(repaint: notifier);

  @override
  void paint(ui.Canvas canvas, ui.Size size) {
    if (shader == null) {
      return;
    }
    shader?.setFloat(0, size.width);
    shader?.setFloat(1, size.height);
    shader?.setFloat(2, color.red.toDouble() / 255);
    shader?.setFloat(3, color.green.toDouble() / 255);
    shader?.setFloat(4, color.blue.toDouble() / 255);
    shader?.setFloat(5, color.alpha.toDouble() / 255);
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..shader = shader,
    );
  }

  @override
  bool shouldRepaint(BlurPaint oldDelegate) => true;
}
