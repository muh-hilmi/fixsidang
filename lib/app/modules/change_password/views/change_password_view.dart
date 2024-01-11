import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Ganti Password',
          style: GoogleFonts.lato(color: const Color(0xff190482)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: Center(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Obx(
              () => TextField(
                style: GoogleFonts.lato(fontSize: 20),
                controller: controller.lamaC,
                obscureText: controller.isPassLamaHidden.value,
                decoration: InputDecoration(
                  label: Text(
                    "Password Lama",
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
                      controller.isPassLamaHidden.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xff190482),
                    ),
                    onPressed: () {
                      controller.isPassLamaHidden.value =
                          !controller.isPassLamaHidden.value;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => TextField(
                style: GoogleFonts.lato(fontSize: 20),
                controller: controller.baruC,
                obscureText: controller.isPassBaruHidden.value,
                decoration: InputDecoration(
                  label: Text(
                    "Password Baru",
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
                      controller.isPassBaruHidden.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xff190482),
                    ),
                    onPressed: () {
                      controller.isPassBaruHidden.value =
                          !controller.isPassBaruHidden.value;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Obx(
              () => TextField(
                style: GoogleFonts.lato(fontSize: 20),
                controller: controller.konfirmasiC,
                obscureText: controller.isPassKonfirmasiHidden.value,
                decoration: InputDecoration(
                  label: Text(
                    "Konfirmasi Password Baru",
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
                      controller.isPassKonfirmasiHidden.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: const Color(0xff190482),
                    ),
                    onPressed: () {
                      controller.isPassKonfirmasiHidden.value =
                          !controller.isPassKonfirmasiHidden.value;
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    if (controller.isLoading.isFalse) {
                      controller.updatePass();
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
                          "Ganti Password",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                          ),
                        ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
