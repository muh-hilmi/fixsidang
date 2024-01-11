import 'package:get/get.dart';

import '../controllers/all_jadwal_controller.dart';

class AllJadwalBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllJadwalController>(
      () => AllJadwalController(),
    );
  }
}
