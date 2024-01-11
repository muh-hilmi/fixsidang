import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputJadwalController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<TimeOfDay?> selectedStartTime = const TimeOfDay(hour: 06, minute: 30).obs;
  Rx<TimeOfDay?> selectedEndTime = const TimeOfDay(hour: 08, minute: 00).obs;
  var jenjangSekolahC = ''.obs;
  var kelasC = ''.obs;
  var hariC = ''.obs;
  TextEditingController mataPelajaranC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final Map<String, int> indeksHari = {
    "Senin": 1,
    "Selasa": 2,
    "Rabu": 3,
    "Kamis": 4,
    "Jumat": 5,
    "Sabtu": 6,
    "Minggu": 7,
  };

  void inputjadwal() async {
    final String waktuMasuk =
        '${selectedStartTime.value!.hour.toString().padLeft(2, '0')}:${selectedStartTime.value!.minute.toString().padLeft(2, '0')}';
    final String waktuKeluar =
        '${selectedEndTime.value!.hour.toString().padLeft(2, '0')}:${selectedEndTime.value!.minute.toString().padLeft(2, '0')}';

    if (jenjangSekolahC.isNotEmpty &&
        kelasC.isNotEmpty &&
        hariC.isNotEmpty &&
        mataPelajaranC.text.isNotEmpty &&
        selectedStartTime.value != null &&
        selectedEndTime.value != null) {
      isLoading.value = true;
      try {
        int indeksHariValue = indeksHari[hariC] ?? 0;
        await firestore.collection("jadwal").doc().set({
          "jenjangSekolah": jenjangSekolahC.toString(),
          "kelas": kelasC.toString(),
          "hari": hariC.toString(),
          "indeksHari": indeksHariValue,
          "mataPelajaran": mataPelajaranC.text,
          "waktuMasuk": waktuMasuk.toString(),
          "waktuKeluar": waktuKeluar.toString(),
        });

        // print(selectedEndTime);
        Get.back();
        isLoading.value = false;
        Get.snackbar("Sukses", "Jadwal telah ditambah!");
      } catch (e) {
        // print(e);
        isLoading.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan jadwal.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Tidak boleh kosong.");
    }
  }

  Future<void> selectStartTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: selectedStartTime.value ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedStartTime.value) {
      selectedStartTime.value = picked;
    }
  }

  Future<void> selectEndTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: selectedEndTime.value ?? TimeOfDay.now(),
    );
    if (picked != null && picked != selectedEndTime.value) {
      selectedEndTime.value = picked;
    }
  }
}
