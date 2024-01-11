import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeProfileController extends GetxController {
  TextEditingController nipC = TextEditingController();
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Future<void> changeProfile(String uid) async {
    if (nipC.text.isNotEmpty &&
        namaC.text.isNotEmpty &&
        emailC.text.isNotEmpty) {
      try {
        await firestore.collection("user").doc(uid).update({
          "nama": namaC.text,
          "nip": nipC.text,
        });
        Get.back();
        Get.snackbar("Sukses", "Profile Anda berhasil diubah!");
      } catch (e) {
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengubah profile.");
      }
    } else {
      Get.snackbar("Terjadi Kesalahan", "Tidak boleh kosong.");
    }
  }
}
