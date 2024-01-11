import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  SignupView({Key? key}) : super(key: key);
  final isGuru = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 30),
            SizedBox(
              height: Get.height * 0.1,
              child: Image.asset(
                "assets/logo/logo.png",
                fit: BoxFit.contain,
              ),
            ),
            Text(
              "Aplikasi \n SLBN Cicendo",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 100),
            Text(
              "Pastikan kamu mengisi dengan benar ya! 🐱",
              style: GoogleFonts.lato(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 10),
            TextField(
              style: GoogleFonts.lato(fontSize: 20),
              controller: controller.namaSignupC,
              cursorColor: const Color(0xff190482),
              decoration: InputDecoration(
                label: Text(
                  "Nama Kamu",
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
            TextField(
              style: GoogleFonts.lato(fontSize: 20),
              controller: controller.nipSignupC,
              cursorColor: const Color(0xff190482),
              decoration: InputDecoration(
                label: Text(
                  isGuru == true ? "NIP" : "Nomor Absen Kamu",
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
            DropdownSearch<String>(
              clearButtonProps: const ClearButtonProps(
                isVisible: true,
              ),
              popupProps: const PopupProps.menu(
                fit: FlexFit.loose,
                showSelectedItems: true,
              ),
              items: isGuru == true
                  ? ["Guru TK", "Guru SD", "Guru SMP", "Guru SMA", "Admin"]
                  : [
                      "Orang Tua",
                      "Siswa TK",
                      "Siswa SD",
                      "Siswa SMP",
                      "Siswa SMA",
                    ],
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  border: InputBorder.none,
                  label: Text(
                    "Status Kamu",
                    style: GoogleFonts.lato(
                      color: const Color(0xff190482),
                      fontSize: 18,
                    ),
                  ),
                  fillColor: const Color(0xffF6F7FA),
                  filled: true,
                  hintText: "Pilih sesuai Status Anda",
                ),
              ),
              onChanged: (value) {
                // print(value);
                controller.roleSignupC.value = value.toString();
              },
            ),
            const SizedBox(height: 10),
            TextField(
              style: GoogleFonts.lato(fontSize: 20),
              controller: controller.emailSignupC,
              cursorColor: const Color(0xff190482),
              decoration: InputDecoration(
                label: Text(
                  "Email Kamu",
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
                controller: controller.passSignupC,
                obscureText: controller.isPassHidden.value,
                cursorColor: const Color(0xff190482),
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
            const SizedBox(height: 20),
            Text(
              "Note : Untuk Orang Tua, isi kolom Nomor Absen dengan Nomor Absen Anak",
              style: GoogleFonts.lato(
                fontSize: 18,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 50),
            Obx(() {
              return SizedBox(
                width: Get.width,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Sebentar 😁"),
                        content: Text(
                          "Kamu yakin sudah isi data dengan benar?",
                          style: GoogleFonts.lato(
                            fontSize: 18,
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Belum",
                              style: GoogleFonts.lato(
                                color: const Color(0xff190482),
                                fontSize: 18,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF190482)),
                            onPressed: () async {
                              Navigator.pop(context);
                              if (controller.isLoading.isFalse) {
                                controller.signup();
                              }
                              // Get.snackbar("Sukses", "Akun Anda berhasil dibuat");
                            },
                            child: const Text("Sudah dong!"),
                          ),
                        ],
                      ),
                    );
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
                          "Daftar",
                          style: GoogleFonts.lato(
                            fontSize: 20,
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
