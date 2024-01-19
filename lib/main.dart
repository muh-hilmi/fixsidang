import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fixsidang/app/controllers/page_index_controller.dart';
import 'package:fixsidang/app/modules/home/views/home_view.dart';
import 'package:fixsidang/app/services/notif_services.dart';
import 'package:fixsidang/app/views/views/splashscreen_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';

import 'package:get/get.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  await NotificationService.initializeNotif();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final pageindex = Get.put(PageIndexController());
  final home = Get.put(HomeView());

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.subscribeToTopic('slbncicendo');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.delayed(const Duration(seconds: 1)),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const SplashscreenView();
          } else {
            return GetMaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              debugShowCheckedModeBanner: false,
              title: "Aplikasi SLBN Cicendo",
              initialRoute: FirebaseAuth.instance.currentUser != null
                  ? FirebaseAuth.instance.currentUser!.emailVerified == true
                      ? Routes.HOME
                      : Routes.LOGIN
                  : Routes.WELCOME,
              getPages: AppPages.routes,
            );
          }
        });
  }
}
