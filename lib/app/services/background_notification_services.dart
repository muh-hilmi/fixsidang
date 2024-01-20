import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fixsidang/app/services/notif_services.dart';
import 'package:fixsidang/firebase_options.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundNotificationService {
  static Future<void> initService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );

    await service.startService();
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    notificationService();
  }

  @pragma('vm:entry-point')
  static Future<bool> onIosBackground(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    return false;
  }

  static void notificationService() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    FirebaseDatabase.instance.setPersistenceEnabled(true);

    listenLampu();
    listenBencana();
  }

  static void listenLampu() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("/lampu");

    ref.onValue.listen((event) async {
      var data = event.snapshot.value as Map<dynamic, dynamic>;

      if (data['istirahat'] == 0 && data['masuk'] == 1) {
        NotificationService.showNotif(
            0, 'Istirahat', 'Yeayyy!!, waktunya istirahat');
      }

      if (data['masuk'] == 0 && data['istirahat'] == 1) {
        NotificationService.showNotif(
            0, 'Masuk Kelas', 'Sudah waktunya masuk kelas nih');
      }
    });
  }

  static void listenBencana() {
    DatabaseReference ref = FirebaseDatabase.instance.ref("/bencana");
    ref.onValue.listen((event) async {
      var data = event.snapshot.value as Map<dynamic, dynamic>;
      
      NotificationService.showNotif(
          0, 'Peringatan Bencana', data[data.keys.last]);
    });
  }
}
