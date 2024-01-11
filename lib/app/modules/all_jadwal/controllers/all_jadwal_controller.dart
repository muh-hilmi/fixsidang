import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AllJadwalController extends GetxController {
  DateTime? start;
  DateTime end = DateTime.now();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = await auth.currentUser!.uid;

    yield* firestore.collection("user").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamAllJadwal(
      String sekolah) async* {
    if (sekolah != "Admin" && sekolah != "Tua") {
      yield* firestore
          .collection("jadwal")
          .orderBy("indeksHari")
          .where('jenjangSekolah', isEqualTo: sekolah)
          .orderBy("kelas")
          .snapshots();
    } else {
      yield* firestore
          .collection("jadwal")
          .orderBy("indeksHari")
          .orderBy("kelas")
          .snapshots();
      ;
    }
  }

  void pickDate(DateTime startDate, DateTime endDate) {
    start = startDate;
    end = endDate;
    update();
  }

  Future<void> deleteJadwal(String jenjangSekolah, kelas, hari) async {
    try {
      // Dapatkan referensi koleksi
      CollectionReference collectionRef =
          FirebaseFirestore.instance.collection('jadwal');

      // Dapatkan semua dokumen yang memenuhi kriteria tertentu
      QuerySnapshot querySnapshot = await collectionRef
          .where('jenjangSekolah', isEqualTo: jenjangSekolah)
          .where('kelas', isEqualTo: kelas)
          .where('hari', isEqualTo: hari)
          .get();

      // Loop melalui hasil query dan hapus setiap dokumen
      WriteBatch batch = FirebaseFirestore.instance.batch();
      querySnapshot.docs.forEach((doc) {
        batch.delete(doc.reference);
      });

      // Komitkan transaksi batch
      await batch.commit();

      Get.snackbar("Sukses", "Jadwal telah terhapus");
    } catch (e) {
      print('Error: $e');
    }
  }
}
