import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/change_profile_controller.dart';

class ChangeProfileView extends GetView<ChangeProfileController> {
  final Map<String, dynamic> user = Get.arguments;
  ChangeProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controller.nipC.text = user['nip'];
    controller.namaC.text = user['nama'];
    controller.emailC.text = user['email'];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Ubah Profile',
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
            readOnly: true,
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
          const SizedBox(height: 10),
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
          const SizedBox(height: 30),
          SizedBox(
            width: Get.width,
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Konfirmasi"),
                    content: const Text("Apakah data yang diubah sudah benar?"),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Periksa lagi",
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
                          await controller.changeProfile(user['uid']);
                        },
                        child: const Text("Ubah Profile"),
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
              child: Text(
                "Konfirmasi",
                style: GoogleFonts.lato(
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Note : Hanya dapat mengganti Nama dan NIP",
            style: GoogleFonts.lato(color: const Color(0xff190482)),
          )
        ],
      ),
    );
  }
}
