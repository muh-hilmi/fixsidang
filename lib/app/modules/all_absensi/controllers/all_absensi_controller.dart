import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllAbsensiController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllPresence() async* {
    String uid = await auth.currentUser!.uid;

    if (start == null) {
      yield* firestore
          .collection("user")
          .doc(uid)
          .collection("absensi")
          .where("date", isLessThan: end.toIso8601String())
          .orderBy("date", descending: true)
          .snapshots();
    } else {
      yield* firestore
          .collection("user")
          .doc(uid)
          .collection("absensi")
          .where("date", isGreaterThan: start!.toIso8601String())
          .where("date",
              isLessThan: end.add(const Duration(days: 1)).toIso8601String())
          .orderBy("date", descending: true)
          .snapshots();
    }
  }

  void pickDate(DateTime startDate, DateTime endDate) {
    start = startDate;
    end = endDate;
    update();
  }
}
