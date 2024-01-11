import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future<void> initializeNotif() async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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
    String title,
    String body,
  ) async {
    final Int64List vibrationPattern = Int64List(4);
    vibrationPattern[0] = 1000;
    vibrationPattern[1] = 500;
    vibrationPattern[2] = 1000;
    vibrationPattern[3] = 500;
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      "1",
      "Aplikasi SLBN Cicendo",
      importance: Importance.high,
      priority: Priority.high,
      ticker: "ticker",
      enableVibration: true,
      onlyAlertOnce: false,
      vibrationPattern: vibrationPattern, // Not working
    );

    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);

    await flutterLocalNotificationsPlugin.show(
        0, title, body, notificationDetails);
  }
}
