import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:fixsidang/app/services/notif_services.dart';
import 'package:get/get.dart';

class HomeAlarmController extends GetxController {
  final bool isDisaster = false;
  var isIstirahatOn = false.obs;
  var isMasukOn = false.obs;
  RxString currentTime = ''.obs;

  var device1flame2 = 0.obs;
  var device1flame3 = 0.obs;
  var device1flame4 = 0.obs;
  var device1gas = 0.obs;
  var device1magnitude = 0.0.obs;
  var device1temperature = 0.0.obs;
  var device1humid = 0.0.obs;

  var device2flame2 = 0.obs;
  var device2flame3 = 0.obs;
  var device2flame4 = 0.obs;
  var device2gas = 0.obs;
  var device2magnitude = 0.0.obs;
  var device2temperature = 0.0.obs;
  var device2humid = 0.0.obs;

  var device3flame2 = 0.obs;
  var device3flame3 = 0.obs;
  var device3flame4 = 0.obs;
  var device3gas = 0.obs;
  var device3magnitude = 0.0.obs;
  var device3temperature = 0.0.obs;
  var device3humid = 0.obs;

  DatabaseReference ref = FirebaseDatabase.instance.ref("/lampu");
  DatabaseReference sensor1Ref = FirebaseDatabase.instance.ref("/device1");
  DatabaseReference sensor2Ref = FirebaseDatabase.instance.ref("/device2");
  DatabaseReference sensor3Ref = FirebaseDatabase.instance.ref("/device3");

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    // Memasang listener pada path yang sesuai di Firebase Realtime Database
    ref.onValue.listen((event) async {
      // Mengupdate nilai dari isIstirahatOn berdasarkan data di Firebase
      var data = event.snapshot.value
          as Map<dynamic, dynamic>?; // Berikan tipe data Map<dynamic, dynamic>
      print(data);
      if (data != null) {
        isIstirahatOn.value = data['istirahat'] == 0;
        if (isIstirahatOn.value) {
          NotificationService.showNotif(
              8, "Lampu Istirahat", "Yeay, Akhirnya istirahat");
        }
        isMasukOn.value = data['masuk'] == 0;
        if (isMasukOn.value) {
          NotificationService.showNotif(
              8, "Lampu Masuk", "Saatnya masuk kelas!");
        }
      } else {
        await ref.set({
          "istirahat": 1,
          "masuk": 1,
        });
      }
    });

    // Mendengarkan perubahan pada path tertentu di Firebase
    sensor1Ref.onValue.listen((event) {
      var data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        if (data['Api2'] != null) {
          device1flame2.value = data['Api2'];
        }
        if (data['Api3'] != null) {
          device1flame3.value = data['Api3'];
        }
        if (data['Api4'] != null) {
          device1flame4.value = data['Api4'];
        }
        if (data['Gas'] != null) {
          device1gas.value = data['Gas'];
        }
        if (data['Magnitude'] != null) {
          device1magnitude.value = data['Magnitude'];
        }
        if (data['Temperature'] != null) {
          device1temperature.value = data['Temperature'];
        }
        if (data['Humidity'] != null) {
          device1humid.value = data['Humidity'];
        }
      }
    });
    sensor2Ref.onValue.listen((event) {
      var data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        if (data['Api2'] != null) {
          device2flame2.value = data['Api2'];
        }
        if (data['Api3'] != null) {
          device2flame3.value = data['Api3'];
        }
        if (data['Api4'] != null) {
          device2flame4.value = data['Api4'];
        }
        if (data['Gas'] != null) {
          device2gas.value = data['Gas'];
        }
        if (data['Magnitude'] != null) {
          device2magnitude.value = data['Magnitude'];
        }
        if (data['Temperature'] != null) {
          device2temperature.value = data['Temperature'];
        }
        if (data['Humidity'] != null) {
          device2humid.value = data['Humidity'];
        }
      }
    });
    sensor3Ref.onValue.listen((event) {
      var data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        if (data['Api2'] != null) {
          device3flame2.value = data['Api2'];
        }
        if (data['Api3'] != null) {
          device3flame3.value = data['Api3'];
        }
        if (data['Api4'] != null) {
          device3flame4.value = data['Api4'];
        }
        if (data['Gas'] != null) {
          device3gas.value = data['Gas'];
        }
        if (data['Magnitude'] != null) {
          device3magnitude.value = data['Magnitude'];
        }
        if (data['Temperature'] != null) {
          device3temperature.value = data['Temperature'];
        }
        if (data['Humidity'] != null) {
          device3humid.value = data['Humidity'];
        }
      }
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTime();
    });
  }

  void istirahat() async {
    try {
      await ref.update({
        "istirahat": isIstirahatOn == true ? 0 : 1,
        "masuk": 1,
      });
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Error di Lampu Istirahat: $e");
    }
  }

  void masuk() async {
    try {
      await ref.update({
        "istirahat": 1,
        "masuk": isMasukOn == true ? 0 : 1,
      });
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Error di Lampu Istirahat: $e");
    }
  }

  // Function to update the current time
  void updateTime() {
    currentTime.value = DateTime.now().toString().substring(11, 19);
  }

  @override
  void onClose() {
    // Batalkan timer saat controller ditutup untuk mencegah kebocoran memori
    timer?.cancel();
    super.onClose();
  }
}
