import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fixsidang/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class NotificationService {
  static Future<void> initializeNotif() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    // AndroidInitializationSettings('assets/logo/logo.png');

    InitializationSettings initializationSettings =
        const InitializationSettings(android: androidInitializationSettings);

    await requestPermission(flutterLocalNotificationsPlugin);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveBackgroundNotificationResponse: getResponNotif);
  
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

  static getResponNotif(NotificationResponse notificationResponse) {
    if (notificationResponse.payload != null) {
      debugPrint("GET NOTIF RESPONSE ${notificationResponse.payload}");
    }
  }

  static Future<void> requestPermission(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    try {
      flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    } catch (e) {
      debugPrint("ERROR FROM REQUEST NOTIF $e");
    }
  }

  static Future<void> showNotif(
    int numberOfRepeats,
    String title,
    String body,
  ) async {
    List<int> vibrationPattern = [500, 500];

    // Duplicate the pattern for the specified number of repeats
    List<int> extendedPattern = List<int>.generate(
      numberOfRepeats * vibrationPattern.length,
      (index) => vibrationPattern[index % vibrationPattern.length],
    );
    Vibration.vibrate(duration: 0, pattern: extendedPattern);

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      '1111',
      'Notifikasi Bencana',
      importance: Importance.max,
      priority: Priority.high,
      ticker: "ticker",
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        1, title, body, notificationDetails);
  }

  @pragma('vm:entry-point')
  static void onStart(ServiceInstance service) async {
    DartPluginRegistrant.ensureInitialized();

    // panggil fungsi service notifikasi
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

    // panggil fungsi notifikasi lampu dan bencana
    listenLampu();
    listenBencana();
  }

  static void listenLampu() {
    // listen database lampu
    DatabaseReference ref = FirebaseDatabase.instance.ref("/lampu");
    ref.onValue.listen((event) async {
      var data = event.snapshot.value as Map<dynamic, dynamic>;

      // tampilkan notifikasi ketika kelas istirahat
      if (data['istirahat'] == 0) {
        NotificationService.showNotif(
            0, 'Istirahat', 'Yeayyy!!, waktunya istirahat');
      }

      // tampilkan notifikasi ketika kelas masuk
      if (data['masuk'] == 0) {
        NotificationService.showNotif(
            0, 'Masuk Kelas', 'Sudah waktunya masuk kelas nih');
      }
    });
  }

  static void listenBencana() {
    // listen database bencana
    DatabaseReference ref = FirebaseDatabase.instance.ref("/bencana");
    ref.onValue.listen((event) async {
      var data = event.snapshot.value as Map<dynamic, dynamic>;
      
      // tampilkan notifikasi ketika ada perubahan data benceana
      NotificationService.showNotif(
          0, 'Peringatan Bencana', data[data.keys.last]);
    });
  }
}
