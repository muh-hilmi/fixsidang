import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/input_user_controller.dart';

class InputUserView extends GetView<InputUserController> {
  const InputUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Input User',
          style: GoogleFonts.lato(color: const Color(0xff190482)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            style: GoogleFonts.lato(fontSize: 20),
            controller: controller.namaC,
            cursorColor: const Color(0xff190482),
            decoration: InputDecoration(
              label: Text(
                "Nama",
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
            controller: controller.nipC,
            cursorColor: const Color(0xff190482),
            decoration: InputDecoration(
              label: Text(
                "NIP",
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
            items: const [
              "Orang Tua",
              "Guru TK",
              "Guru SD",
              "Guru SMP",
              "Guru SMA",
              "Admin"
            ],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                border: InputBorder.none,
                label: Text(
                  "Status",
                  style: GoogleFonts.lato(
                    color: const Color(0xff190482),
                    fontSize: 18,
                  ),
                ),
                fillColor: const Color(0xffF6F7FA),
                filled: true,
                hintText: "Pilih sesuai Status",
              ),
            ),
            onChanged: (value) {
              // print(value);
              controller.roleC.value = value.toString();
            },
          ),
          const SizedBox(height: 10),
          TextField(
            style: GoogleFonts.lato(fontSize: 20),
            controller: controller.emailC,
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
          const SizedBox(height: 30),
          Obx(() {
            return SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Tambah User"),
                      content: const Text("Apakah data user sudah benar?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Periksa lagi"),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF190482)),
                          onPressed: () async {
                            Navigator.pop(context);
                            controller.inputUser();
                            // Get.snackbar("Sukses", "Akun Anda berhasil dibuat");
                          },
                          child: const Text("Tambah User"),
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
                        "Tambah User",
                        style: GoogleFonts.lato(
                          fontSize: 20,
                        ),
                      ),
              ),
            );
          }),
          const SizedBox(height: 10),
          Text(
            "Note : Password default untuk user yang didaftarkan admin: password",
            style: GoogleFonts.lato(color: const Color(0xff190482)),
          )
        ],
      ),
    );
  }
}
