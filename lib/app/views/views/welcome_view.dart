import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class WelcomeView extends GetView {
  const WelcomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              width: Get.width * 1,
              height: Get.width * 1,
              "assets/lotties/hello.json",
              // fit: BoxFit.cover,
              repeat: true,
            ),
            const SizedBox(height: 25),
            Text(
              "Aplikasi SLBN Cicendo",
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Aplikasi untuk Sekolah SLBN Cicendo, yang digunakan untuk Sistem Peringatan Dini Bencana dan Pergantian Kelas",
              style: GoogleFonts.lato(
                fontSize: 16,
                color: const Color(0xff8C8C8C),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 75),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.LOGIN);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF190482),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                child: Text(
                  "🏢 Saya ingin Masuk",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.ASK_GURUMURID);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF7752FE),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                child: Text(
                  "📒 Saya ingin Daftar",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
