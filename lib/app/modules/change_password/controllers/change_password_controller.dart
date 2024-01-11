import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  RxBool isLoading = false.obs;

  TextEditingController lamaC = TextEditingController();
  TextEditingController baruC = TextEditingController();
  TextEditingController konfirmasiC = TextEditingController();

  var isPassLamaHidden = true.obs;
  var isPassBaruHidden = true.obs;
  var isPassKonfirmasiHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (lamaC.text.isNotEmpty &&
        baruC.text.isNotEmpty &&
        konfirmasiC.text.isNotEmpty) {
      if (baruC.text == konfirmasiC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;
          await auth.signInWithEmailAndPassword(
              email: emailUser, password: lamaC.text);

          await auth.currentUser!.updatePassword(baruC.text);

          Get.back();
          Get.snackbar("Sukses", "Kata sandi berhasil diperbarui!");
        } on FirebaseAuthException catch (e) {
          if (e.code == 'wrong-password') {
            Get.snackbar("Terjadi Kesalahan", "Password lama Anda salah.");
          }
        } catch (e) {
          isLoading.value = false;
          Get.snackbar("Terjadi Kesalahan", "Tidak dapat mengganti password.");
        } finally {
          isLoading.value = false;
        }
      } else {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Konfirmasi kata sandi tidak cocok!");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Tidak boleh kosong!");
    }
  }
}
