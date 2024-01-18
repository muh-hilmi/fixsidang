import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:vibration/vibration.dart';

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
}
