import 'package:get/get.dart';

import '../controllers/shaders_controller.dart';

class ShadersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShadersController>(
      () => ShadersController(),
    );
  }
}
