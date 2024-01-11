import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class AskGurumuridView extends GetView {
  const AskGurumuridView({Key? key}) : super(key: key);
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
              "assets/lotties/ask_school.json",
              // fit: BoxFit.cover,
              repeat: true,
            ),
            const SizedBox(height: 25),
            Text(
              "Kamu daftar sebagai apa?",
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Pastikan kamu tidak salah pilih ya!",
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
                  var isGuru = true;
                  Get.toNamed(Routes.SIGNUP, arguments: isGuru);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF190482),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                child: Text(
                  "👨‍🏫 Saya Guru atau Admin Sekolah",
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
                  var isGuru = false;
                  Get.toNamed(Routes.SIGNUP, arguments: isGuru);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF7752FE),
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                ),
                child: Text(
                  "📒 Saya Siswa atau Orang Tua",
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
