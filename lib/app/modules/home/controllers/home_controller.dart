import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = await auth.currentUser!.uid;

    yield* firestore.collection("user").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamJadwal(String role) async* {
    initializeDateFormatting('id_ID', null);
    final dateFormat = DateFormat('EEEE', 'id_ID');
    String hariIni = dateFormat.format(DateTime.now());
    CollectionReference jadwal = firestore.collection('jadwal');

    Query query = jadwal.where('hari', isEqualTo: hariIni);

    if (role != "Admin" && role != "Tua") {
      query = query
          .where('jenjangSekolah', isEqualTo: role)
          .orderBy('kelas')
          .orderBy('waktuMasuk');
      // print("if = true, dieksekusi");
    } else {
      query = query.orderBy('kelas').orderBy('waktuMasuk');
      // print("if = false, dieksekusi");
    }

    Stream<QuerySnapshot<Map<String, dynamic>>> snapshots = query
        .snapshots()
        .map((event) => event as QuerySnapshot<Map<String, dynamic>>);

    yield* snapshots;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamLast5Absen() async* {
    String uid = await auth.currentUser!.uid;

    yield* firestore
        .collection("user")
        .doc(uid)
        .collection("absensi")
        .orderBy("date", descending: true)
        .limitToLast(5)
        .snapshots();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> todayAbsen() async* {
    String uid = await auth.currentUser!.uid;
    String todayID =
        DateFormat.yMd().format(DateTime.now()).replaceAll("/", "-");

    yield* firestore
        .collection("user")
        .doc(uid)
        .collection("absensi")
        .doc(todayID)
        .snapshots();
  }
}
