import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/all_absensi_controller.dart';

class AllAbsensiView extends GetView<AllAbsensiController> {
  const AllAbsensiView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Riwayat Absensi',
          style: GoogleFonts.lato(color: const Color(0xff190482)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: GetBuilder<AllAbsensiController>(
        builder: (context) {
          return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: controller.streamAllPresence(),
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snap.data?.docs.length == 0 || snap.data == null) {
                return SizedBox(
                  height: 200,
                  child: Center(
                    child: Text(
                      "Kamu belum pernah Absensi 😥",
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: snap.data!.docs.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> data = snap.data!.docs[index].data();

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Material(
                      color: const Color(0xff8E8FFA),
                      borderRadius: BorderRadius.circular(20),
                      child: InkWell(
                        onTap: () =>
                            Get.toNamed(Routes.DETAIL_ABSENSI, arguments: data),
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Masuk",
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "${DateFormat.yMMMMEEEEd('id_ID').format(DateTime.parse(data["date"]))}",
                                    style: GoogleFonts.lato(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              Text(
                                data['masuk']?['date'] == null
                                    ? "-"
                                    : "Jam : ${DateFormat.Hm().format(DateTime.parse(data['masuk']!['date']))}",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                "Keluar",
                                style: GoogleFonts.lato(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                data['keluar']?['date'] == null
                                    ? "-"
                                    : "Jam : ${DateFormat.Hm().format(DateTime.parse(data['keluar']!['date']))}",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff190482),
        onPressed: () async {
          DateTimeRange? selectedDateRange = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2000),
            lastDate: DateTime(3000),
            locale: const Locale("id"),
          );

          if (selectedDateRange != null) {
            DateTime startDate = selectedDateRange.start;
            DateTime endDate = selectedDateRange.end;
            // String formattedStartDate =
            //     DateFormat('dd MMMM yyyy').format(startDate);
            // String formattedEndDate =
            //     DateFormat('dd MMMM yyyy').format(endDate);
            controller.pickDate(startDate, endDate);
            // Get.dialog(
            //   Dialog(
            //     child: Container(
            //       padding: const EdgeInsets.all(20),
            //       height: 75,
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text("Start Date: $formattedStartDate"),
            //           Text("End Date: $formattedEndDate"),
            //         ],
            //       ),
            //     ),
            //   ),
            // );
          }
        },
        child: const Icon(Icons.search_rounded),
      ),
    );
  }
}
