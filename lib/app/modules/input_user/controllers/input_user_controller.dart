import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputUserController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController namaC = TextEditingController();
  TextEditingController nipC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  var roleC = ''.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void inputUser() async {
    if (namaC.text.isNotEmpty &&
        nipC.text.isNotEmpty &&
        roleC.isNotEmpty &&
        emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailC.text,
          password: "password",
        );
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          firestore.collection("user").doc(uid).set({
            "nama": namaC.text,
            "nip": nipC.text,
            "role": roleC.toString(),
            "email": emailC.text,
            "uid": uid,
            "createdAt": DateTime.now().toIso8601String(),
          });
          await userCredential.user!.sendEmailVerification();
          Get.offAllNamed(Routes.HOME);
          isLoading.value = false;
          Get.snackbar("Sukses", "User baru berhasil ditambahkan!");
        }

        // print(userCredential);
      } on FirebaseAuthException catch (e) {
        if (e.code == "weak-password") {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Password yang anda gunakan lemah");
        } else if (e.code == 'email-already-in-use') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Email sudah digunakan");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat mendaftarkan.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Tidak boleh kosong.");
    }
  }
}
