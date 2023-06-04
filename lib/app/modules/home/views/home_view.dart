import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kids_rijal/app/modules/home/widget/blur_view.dart';
import 'package:kids_rijal/app/modules/home/widget/drawing_app.dart';
import 'package:kids_rijal/app/modules/home/widget/picture_recorder.dart';
import 'package:kids_rijal/app/modules/home/widget/shader.dart';
import 'package:kids_rijal/app/modules/home/widget/world_map.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example R&D'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          PageView(
            controller: controller.pageController,
            children: const <Widget>[
              ShaderExp('assets/shader/shader.frag'),
              PictureRecorderBoard(),
              DrawingBoard(path: 'assets/shoe.png'),
              WorldMap(),
              BlurView('assets/mine.png'),
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
                  onPressed: () {
                    controller.pageController.previousPage(
                        duration: .2.seconds, curve: Curves.bounceInOut);
                  },
                  child: const Icon(Icons.arrow_back_ios),
                ),
                FloatingActionButton(
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
