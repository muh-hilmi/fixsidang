import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            SizedBox(
              height: Get.height * 0.15,
              child: Image.asset(
                "assets/logo/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Aplikasi \n SLBN Cicendo",
              style: GoogleFonts.lato(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            TextField(
              style: GoogleFonts.lato(fontSize: 20),
              controller: controller.emailLoginC,
              cursorColor: const Color(0xff190482),
              decoration: InputDecoration(
                label: Text(
                  "Email",
                  style: GoogleFonts.lato(
                    color: const Color(0xff190482),
                    fontSize: 18,
                  ),
                ),
                fillColor: const Color(0xffF6F7FA),
                filled: true,
                border: InputBorder.none,
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => TextField(
                style: GoogleFonts.lato(fontSize: 20),
                controller: controller.passLoginC,
                obscureText: controller.isPassHidden.value,
                decoration: InputDecoration(
                  label: Text(
                    "Password",
                    style: GoogleFonts.lato(
                      color: const Color(0xff190482),
                      fontSize: 18,
                    ),
                  ),
                  fillColor: const Color(0xffF6F7FA),
                  filled: true,
                  border: InputBorder.none,
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPassHidden.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xff190482),
                    ),
                    onPressed: () {
                      controller.isPassHidden.value =
                          !controller.isPassHidden.value;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 50),
            Obx(() {
              return SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.login();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0XFF7752FE),
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                  ),
                  child: controller.isLoading.isTrue
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          "Ayo Masuk 😺",
                          style: GoogleFonts.lato(
                            fontSize: 20,
                          ),
                        ),
                ),
              );
            }),
            const SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Lupa Password",
                  content: Column(
                    children: [
                      Text(
                        'Cek Email untuk reset Passwordnya 😇',
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          color: const Color(0xff190482),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        style: GoogleFonts.lato(fontSize: 20),
                        controller: controller.emailLoginC,
                        cursorColor: const Color(0xff190482),
                        decoration: InputDecoration(
                          label: Text(
                            "Email",
                            style: GoogleFonts.lato(
                              fontSize: 20,
                              color: const Color(0xff190482),
                            ),
                          ),
                          fillColor: const Color(0xffF6F7FA),
                          filled: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF190482)),
                      onPressed: () {
                        controller.resetPassword();
                        Get.back(); // Menutup dialog setelah selesai
                      },
                      child: const Text("Ganti Password"),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back(); // Tombol untuk menutup dialog
                      },
                      child: Text(
                        "Batal",
                        style: GoogleFonts.lato(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff190482),
                        ),
                      ),
                    ),
                  ],
                );
              },
              child: Text(
                "Lupa Password?",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff190482),
                ),
              ),
            ),
            const SizedBox(height: 75),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Saya belum punya akun 🤧",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.ASK_GURUMURID);
                  },
                  child: Text(
                    "Daftar",
                    style: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff190482),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
