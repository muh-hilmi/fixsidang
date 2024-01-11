import 'package:get/get.dart';

import '../controllers/input_user_controller.dart';

class InputUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputUserController>(
      () => InputUserController(),
    );
  }
}
