import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/detail_absensi_controller.dart';

class DetailAbsensiView extends GetView<DetailAbsensiController> {
  DetailAbsensiView({Key? key}) : super(key: key);
  final Map<String, dynamic> data = Get.arguments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Detail Absensi',
          style: GoogleFonts.lato(color: const Color(0xff190482)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: ListView(padding: const EdgeInsets.all(10), children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff8E8FFA),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "${DateFormat.yMMMMEEEEd('id_ID').format(DateTime.parse(data['date']))}",
                  style: GoogleFonts.lato(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Masuk",
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "Jam : ${DateFormat.Hm().format(DateTime.parse(data['masuk']!['date']))}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                "Posisi pada ${data['masuk']['lat']}, ${data['masuk']['long']}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                "Jarak ${data['masuk']['distance'].toString().split('.').first} meter",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                "Status kamu berada ${data['masuk']['status']}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                "Kamu absen masuk di ${data['masuk']!['address']}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Keluar",
                style: GoogleFonts.lato(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                data['keluar']?['date'] == null
                    ? "Kamu belum Absen keluar 😄"
                    : "Jam : ${DateFormat.Hm().format(DateTime.parse(data['keluar']!['date']))}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                data['keluar']?['lat'] == null
                    ? ""
                    : "Posisi pada ${data['masuk']['lat']}, ${data['masuk']['long']}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                data['keluar']?['distance'] == null
                    ? ""
                    : "Jarak ${data['masuk']['distance'].toString().split('.').first} meter",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                data['keluar']?['status'] == null
                    ? "Lokasi belum diketahui"
                    : "Status kamu berada ${data['masuk']['status']}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              Text(
                data['keluar']?['address'] == null
                    ? "Absen keluar dahulu untuk mendapatkan informasi"
                    : "Kamu absen keluar di ${data['keluar']!['address']}",
                style: GoogleFonts.lato(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
