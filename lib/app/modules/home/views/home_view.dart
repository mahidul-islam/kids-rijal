import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kids_rijal/app/modules/home/widget/world_map.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: PageView(
        controller: controller.pageController,
        children: const <Widget>[
          WorldMap(),
        ],
      ),
    );
  }
}
