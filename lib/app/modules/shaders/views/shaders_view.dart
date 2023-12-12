import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kids_rijal/app/modules/shaders/widget/first.dart';
import 'package:kids_rijal/app/modules/shaders/widget/shader_equation.dart';
import 'package:kids_rijal/app/modules/shaders/widget/shape_function.dart';

import '../controllers/shaders_controller.dart';

class ShadersView extends GetView<ShadersController> {
  const ShadersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example Shaders'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            children: const <Widget>[
              ShapeFunction('assets/shader/shape_func.frag'),
              ShaderEquation('assets/shader/equation.frag'),
              ShaderFirst('assets/shader/first.frag'),
            ],
          ),
          Positioned(
            bottom: 20,
            right: 0,
            left: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'right2',
                  onPressed: () {
                    controller.pageController.previousPage(
                        duration: .2.seconds, curve: Curves.bounceInOut);
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                FloatingActionButton(
                  heroTag: 'left2',
                  onPressed: () {
                    controller.pageController.nextPage(
                        duration: .2.seconds, curve: Curves.bounceInOut);
                  },
                  child: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
