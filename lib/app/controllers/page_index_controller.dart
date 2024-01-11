import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:fixsidang/app/services/locations_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  void changePage(int i) async {
    pageIndex.value = i;
    switch (i) {
      case 1:
        // pageIndex.value = i;
        // Get.offAllNamed(Routes.HOME_ABSENSI);
        Get.dialog(
          const Center(
            child: CircularProgressIndicator(),
          ),
          // barrierDismissible: false,
        );
        Map<String, dynamic> dataResponse =
            await LocationServices.determinePosition();
        if (dataResponse['error'] == true) {
          Get.snackbar("Terjadi Kesalahan", dataResponse['message']);
        } else {
          Position position = dataResponse["position"];

          List<Placemark> placemarks = await placemarkFromCoordinates(
              position.latitude, position.longitude);

          String address =
              "${placemarks[0].street} ${placemarks[0].subLocality} ${placemarks[0].locality} ${placemarks[0].subAdministrativeArea}";

          double distance = Geolocator.distanceBetween(-6.910769388380838,
              107.6046105810483, position.latitude, position.longitude);

          await LocationServices.updatePosition(position, address);
          Get.back();

          await absensi(position, address, distance);
          Get.snackbar("Mendapat lokasi 🛵", " Anda berada di $address");

          await deleteOldAbsensi();
        }
        break;

      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }
}

Future<void> absensi(Position position, String address, double distance) async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = await auth.currentUser!.uid;
  DateTime now = DateTime.now();

  CollectionReference<Map<String, dynamic>> colPresence =
      await firestore.collection('user').doc(uid).collection("absensi");

  QuerySnapshot<Map<String, dynamic>> snapAbsensi = await colPresence.get();

  String todayDocID = DateFormat.yMd().format(now).replaceAll('/', "-");
  String status = "Kamu berada di luar area SLBN Cicendo";

  if (distance <= 75) {
    //didalam area
    status = "Kamu berada dalam area SLBN Cicendo";
  }
  if (now.hour > 6 && now.hour <= 18) {
    if (snapAbsensi.docs.isEmpty) {
      // belum pernah absen

      await Get.defaultDialog(
          title: "Absen Masuk 👩‍🏫",
          middleText:
              "Apakah kamu yakin akan Absen MASUK sekarang? \nData Absensi tidak dapat diubah",
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                "Batal",
                style: GoogleFonts.lato(
                  color: const Color(0xff190482),
                  fontSize: 18,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await colPresence.doc(todayDocID).set({
                  'date': now.toIso8601String(),
                  'masuk': {
                    'date': now.toIso8601String(),
                    'lat': position.latitude,
                    'long': position.longitude,
                    "address": address,
                    "status": status,
                    "distance": distance,
                  }
                });
                Get.back();
                Get.snackbar("Berhasil",
                    "Anda telah ABSEN MASUK pada jam ${DateFormat.Hm().format(now)} 😍");
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  const Color(0xff190482),
                ),
              ),
              child: Text(
                "Absen Sekarang",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ]);
    } else {
      // sudah pernah absen
      DocumentSnapshot<Map<String, dynamic>> todayDoc =
          await colPresence.doc(todayDocID).get();
      if (todayDoc.exists == true) {
        // tinggal absen keluar atau sudah absen masuk+keluar
        Map<String, dynamic>? dataAbsenToday = todayDoc.data();
        if (dataAbsenToday?['keluar'] != null) {
          // sudah absen masuk dan keluar
          Get.snackbar("Hmm...",
              "Kamu sudah absen masuk dan keluar, sampai jumpa esok hari! 😉");
        } else {
          //absen keluar

          await Get.defaultDialog(
              title: "Absen Keluar 🙋‍♀️",
              middleText:
                  "Apakah kamu yakin akan Absen KELUAR sekarang? \nData Absensi tidak dapat diubah",
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Batal",
                    style: GoogleFonts.lato(
                      color: const Color(0xff190482),
                      fontSize: 18,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await colPresence.doc(todayDocID).update({
                      'date': now.toIso8601String(),
                      'keluar': {
                        'date': now.toIso8601String(),
                        'lat': position.latitude,
                        'long': position.longitude,
                        "address": address,
                        "status": status,
                        "distance": distance,
                      }
                    });
                    Get.back();
                    Get.snackbar("Berhasil",
                        "Anda telah ABSEN KELUAR pada jam ${DateFormat.Hm().format(now)} 🎉");
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      const Color(0xff190482),
                    ),
                  ),
                  child: Text(
                    "Absen Sekarang",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ]);
        }
      } else {
        // absen masuk

        await Get.defaultDialog(
            title: "Absen Masuk 👩‍🏫",
            middleText:
                "Apakah kamu yakin akan Absen MASUK sekarang? \nData Absensi tidak dapat diubah",
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text(
                  "Batal",
                  style: GoogleFonts.lato(
                    color: const Color(0xff190482),
                    fontSize: 18,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  await colPresence.doc(todayDocID).set({
                    'date': now.toIso8601String(),
                    'masuk': {
                      'date': now.toIso8601String(),
                      'lat': position.latitude,
                      'long': position.longitude,
                      "address": address,
                      "status": status,
                      "distance": distance,
                    }
                  });
                  Get.back();
                  Get.snackbar("Berhasil",
                      "Anda telah ABSEN MASUK pada jam ${DateFormat.Hm().format(now)} 😍");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    const Color(0xff190482),
                  ),
                ),
                child: Text(
                  "Absen Sekarang",
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ]);
      }
    }
  } else {
    Get.snackbar("Maaf 🙏",
        "Ini bukan waktu sekolah 😅\nAbsen pada jam 6 pagi - 6 sore ya!");
  }
}

Future<void> deleteOldAbsensi() async {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String uid = auth.currentUser!.uid;

  CollectionReference<Map<String, dynamic>> colPresence =
      firestore.collection('user').doc(uid).collection("absensi");

  QuerySnapshot<Map<String, dynamic>> snapAbsensi = await colPresence.get();
  DateTime now = DateTime.now();

  for (QueryDocumentSnapshot<Map<String, dynamic>> doc in snapAbsensi.docs) {
    DateTime docDate = DateFormat.yMd().parse(doc.id.replaceAll('-', '/'));
    Duration difference = now.difference(docDate);

    // Hapus data yang sudah lewat 30 hari
    if (difference.inDays > 30) {
      await colPresence.doc(doc.id).delete();
    }
  }
}
