import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController emailLoginC = TextEditingController();
  TextEditingController passLoginC = TextEditingController();
  TextEditingController newPassC = TextEditingController();

  var isPassHidden = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;
  void resetPassword() async {
    try {
      if (emailLoginC.text.isNotEmpty) {
        await auth.sendPasswordResetEmail(email: emailLoginC.text);
        Get.back();
        Get.snackbar(
          "Yeay 🎉",
          "Emailnya udah dikirim. Cek Email kamu ya!",
        );
      } else {
        Get.snackbar("Error", "Kok Kosong? 😣");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == "user-not-found") {
        Get.snackbar("Terjadi Kesalahan", "Email tidak terdaftar");
      }
    } catch (e) {
      Get.snackbar(
          "Terjadi Kesalahan", "Tidak dapat mengirim email reset password.");
    }
  }

  Future<void> login() async {
    if (emailLoginC.text.isNotEmpty && passLoginC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: emailLoginC.text,
          password: passLoginC.text,
        );
        // print(userCredential);

        if (userCredential.user != null) {
          if (userCredential.user!.emailVerified == true) {
            print(userCredential.user!.emailVerified);
            Get.offAllNamed(Routes.HOME);
          } else {
            isLoading.value = false;
            Get.defaultDialog(
              title: "Verifikasi Akun",
              middleText:
                  "Kamu belum verifikasi akun, Verifikasi Akun ada di email ya!",
              actions: [
                TextButton(
                  onPressed: () {
                    isLoading.value = false;
                    Get.back();
                  },
                  child: const Text(
                    'Batal',
                    style: TextStyle(color: Color(0XFF7752FE)),
                  ),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFF7752FE),
                      padding: const EdgeInsets.all(16),
                    ),
                    onPressed: () async {
                      isLoading.value = false;
                      try {
                        await userCredential.user!.sendEmailVerification();
                        Get.back();
                        Get.snackbar("Sukses", "Email sudah dikirimkan.");
                        isLoading.value = false;
                      } catch (e) {
                        isLoading.value = false;
                        Get.snackbar("Terjadi Kesalahan",
                            "Tidak dapat mengrim email verifikasi.");
                      }
                    },
                    child: const Text('Kirim Ulang'))
              ],
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'invalid-credential') {
          isLoading.value = false;
          Get.snackbar(
              "Terjadi Kesalahan", "Email atau Paswoord Kamu tidak benar 😶");
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat login.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Kok Kosong? 😪");
    }
  }
}
