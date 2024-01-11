import 'package:get/get.dart';

import '../controllers/input_jadwal_controller.dart';

class InputJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InputJadwalController>(
      () => InputJadwalController(),
    );
  }
}
