import 'package:get/get.dart';

import '../controllers/home_alarm_controller.dart';

class HomeAlarmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeAlarmController>(
      () => HomeAlarmController(),
    );
  }
}
