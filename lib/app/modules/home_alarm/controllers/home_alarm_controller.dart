import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:fixsidang/app/services/notif_services.dart';
import 'package:get/get.dart';

class HomeAlarmController extends GetxController {
  final bool isDisaster = false;
  var isIstirahatOn = false.obs;
  var isMasukOn = false.obs;
  RxString currentTime = ''.obs;

  RxInt device1flame2 = 0.obs;
  RxInt device1flame3 = 0.obs;
  RxInt device1flame4 = 0.obs;
  RxInt device1gas = 0.obs;
  RxDouble device1magnitude = 0.0.obs;
  RxDouble device1temperature = 0.0.obs;
  RxInt device1humid = 0.obs;

  DatabaseReference ref = FirebaseDatabase.instance.ref("/lampu");
  DatabaseReference sensor1Ref = FirebaseDatabase.instance.ref();

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    // Memasang listener pada path yang sesuai di Firebase Realtime Database
    ref.onValue.listen((event) {
      // Mengupdate nilai dari isIstirahatOn berdasarkan data di Firebase
      var data = event.snapshot.value
          as Map<dynamic, dynamic>?; // Berikan tipe data Map<dynamic, dynamic>
      if (data != null) {
        // Update nilai isIstirahatOn
        if (data['istirahat'] != null) {
          isIstirahatOn.value = data['istirahat'] == 0;
        }

        // Update nilai isMasukOn
        if (data['masuk'] != null) {
          isMasukOn.value = data['masuk'] == 0;
        }
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
          print(device1humid);
        }
      }
    });

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTime();
    });
  }

  void istirahat() async {
    try {
      await ref.set({
        "istirahat": 1,
        "masuk": 1,
      });
      if (isIstirahatOn == true) {
        await ref.update({
          "istirahat": 0,
          "masuk": 1,
        });
      } else {
        await ref.update({
          "istirahat": 1,
          "masuk": 1,
        });
      }
    } catch (e) {
      Get.snackbar("Terjadi Kesalahan", "Error di Lampu Istirahat: $e");
    }
    NotificationService.showNotif(
        "Lampu Istirahat", "Yeay, akhirnya istirahat!");
  }

  void masuk() async {
    await ref.set({
      "istirahat": 1,
      "masuk": 1,
    });
    if (isMasukOn == true) {
      await ref.update({
        "istirahat": 1,
        "masuk": 0,
      });
    } else {
      await ref.update({
        "istirahat": 1,
        "masuk": 1,
      });
    }
    NotificationService.showNotif("Lampu Masuk", "Saatnya masuk kelas!");
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
