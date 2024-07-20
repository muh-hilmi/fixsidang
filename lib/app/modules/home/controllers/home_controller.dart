import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  // DatabaseReference ref = FirebaseDatabase.instance.ref("/bencana");
  RxString timeAgo = "Tidak ada".obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   // bencana();
  // }

  // void bencana() {
  //   print("DIJALANKAN");
  //   ref.onValue.listen((event) async {
  //     var data = event.snapshot.value as Map<dynamic, dynamic>;
  //     // print(data.keys.last);
  //     var dataTerakhir = data.keys.last.toString();

  //     // Mendapatkan nilai untuk tanggal hari ini
  //     var todayData = data[data.keys.last];

  //     // Memeriksa apakah ada data untuk tanggal hari ini
  //     if (todayData != null) {
  //       // Mendapatkan nilai waktu dari string
  //       String timeString = todayData.split(" ")[6];
  //       // print(timeString);

  //       // Membuat string lengkap dengan tanggal dan waktu
  //       String dateTimeString = "$dataTerakhir $timeString";

  //       // Mengonversi string menjadi objek DateTime
  //       DateTime dateTime = DateTime.parse(dateTimeString);

  //       // Menghitung selisih waktu
  //       Duration difference = DateTime.now().difference(dateTime);

  //       // Mengonversi selisih waktu menjadi format yang diinginkan
  //       timeAgo.value = formatTimeAgo(difference);

  //       // print(timeAgo);
  //     } else {
  //       print("data kosong");
  //     }
  //   });
  // }

  // String formatTimeAgo(Duration difference) {
  //   if (difference.inDays > 0) {
  //     return '${difference.inDays} hari yang lalu';
  //   } else if (difference.inHours > 0) {
  //     return '${difference.inHours} jam yang lalu';
  //   } else if (difference.inMinutes > 0) {
  //     return '${difference.inMinutes} menit yang lalu';
  //   } else {
  //     return 'baru saja';
  //   }
  // }

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = await auth.currentUser!.uid;

    yield* firestore.collection("user").doc(uid).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamJadwal(String role) async* {
    initializeDateFormatting('id_ID', null);
    final dateFormat = DateFormat('EEEE', 'id_ID');
    String hariIni = dateFormat.format(DateTime.now());
    CollectionReference jadwal = firestore.collection('jadwal');

    var query = jadwal.where('hari', isEqualTo: hariIni);

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
