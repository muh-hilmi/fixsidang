import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController namaSignupC = TextEditingController();
  TextEditingController nipSignupC = TextEditingController();
  var roleSignupC = ''.obs;
  TextEditingController emailSignupC = TextEditingController();
  TextEditingController passSignupC = TextEditingController();
  var isPassHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  void signup() async {
    if (namaSignupC.text.isNotEmpty &&
        nipSignupC.text.isNotEmpty &&
        roleSignupC.isNotEmpty &&
        emailSignupC.text.isNotEmpty &&
        passSignupC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential =
            await auth.createUserWithEmailAndPassword(
          email: emailSignupC.text,
          password: passSignupC.text,
        );
        if (userCredential.user != null) {
          String uid = userCredential.user!.uid;
          firestore.collection("user").doc(uid).set({
            "nama": namaSignupC.text,
            "nip": nipSignupC.text,
            "role": roleSignupC.toString(),
            "email": emailSignupC.text,
            "uid": uid,
            "createdAt": Timestamp.fromDate(DateTime.now()),
          });
          await userCredential.user!.sendEmailVerification();
          Get.offAllNamed(Routes.LOGIN);
          Get.snackbar("Yeay 🎉", "Akun kamu berhasil dibuat!");
        }

        // print(userCredential);
      } on FirebaseAuthException catch (e) {
        // print(e.code);
        if (e.code == "weak-password") {
          isLoading.value = false;
          Get.snackbar(
              "Terjadi Kesalahan", "Kamu menggunakan Password yang lemah 😪");
        } else if (e.code == 'email-already-in-use') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Emailnya sudah digunakan nih 🤔");
        } else if (e.code == 'invalid-email') {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Emailnya ga bener euy😅");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat mendaftarkan.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Kok Kosong? 😫");
    }
  }
}
