import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixsidang/app/controllers/page_index_controller.dart';
import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:fixsidang/app/services/notif_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lottie/lottie.dart';
import '../controllers/home_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);

  String getCurrentTimeInBahasa() {
    initializeDateFormatting('id_ID', null);

    final dateFormat = DateFormat.yMMMMEEEEd('id_ID');
    final formattedDate = dateFormat.format(DateTime.now());

    return formattedDate;
  }

  final pageC = Get.find<PageIndexController>();
  final String role = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffC2D9FF),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;
            List<String> roleParts = user['role'].split(' ');
            String role = roleParts.isNotEmpty ? roleParts.last : '';
            // bool isAdmin = role == 'Admin';
            // print(isAdmin);
            // print(role);
            return RefreshIndicator(
              onRefresh: () async {
                await controller.streamJadwal(role);
              },
              child: SafeArea(
                child: Column(
                  children: [
                    Container(
                      // color: Colors.blueAccent,
                      width: Get.width,
                      height: Get.height * 0.09,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Row(
                          children: [
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Selamat datang",
                                    style: GoogleFonts.lato(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Text(
                                    "${user['role']} - ${user['nama']}",
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: const Color(0xff190482),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await NotificationService.initializeNotif();
                                Get.toNamed(Routes.HOME_ALARM);
                              },
                              icon: const Icon(
                                Icons.alarm,
                                size: 35,
                                color: Color(0xff190482),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        children: [
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  getCurrentTimeInBahasa(),
                                  style: GoogleFonts.lato(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff190482),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: controller.streamJadwal(role),
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Text(
                                    'Terjadi kesalahan: ${snapshot.error}');
                              } else if (!snapshot.hasData ||
                                  snapshot.data == null ||
                                  snapshot.data!.docs.isEmpty) {
                                return Container(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 50),
                                  alignment: Alignment.center,
                                  child: Column(
                                    children: [
                                      Lottie.asset(
                                        "assets/lotties/no_jadwal.json",
                                        height: 150,
                                        repeat: true,
                                        animate: true,
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        'Jadwal hari ini tidak tersedia 😓',
                                        style: GoogleFonts.lato(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                final documents = snapshot.data!.docs;

                                // Kelompokkan jadwal berdasarkan kriteria yang sama.
                                final groupedJadwal = <String, List<Jadwal>>{};

                                for (final doc in documents) {
                                  final data = doc.data();
                                  final key =
                                      '${data['jenjangSekolah']}-${data['kelas']}-${data['hari']}';

                                  if (!groupedJadwal.containsKey(key)) {
                                    groupedJadwal[key] = [];
                                  }

                                  groupedJadwal[key]!.add(Jadwal(
                                    mataPelajaran: data['mataPelajaran'],
                                    waktuKeluar: data['waktuKeluar'],
                                    waktuMasuk: data['waktuMasuk'],
                                  ));
                                }

                                // Buat CarouselJadwal untuk setiap kelompok jadwal.
                                final jadwalWidgets = groupedJadwal.entries.map(
                                  (entry) {
                                    final keyParts = entry.key.split('-');
                                    final jenjangSekolah = keyParts[0];
                                    final kelas = keyParts[1];
                                    final hari = keyParts[2];
                                    final schedules = entry.value;

                                    return CarouselJadwal(
                                      jenjangSekolah: jenjangSekolah,
                                      kelas: kelas,
                                      hari: hari,
                                      schedules: schedules,
                                    );
                                  },
                                ).toList();

                                return CarouselSlider(
                                  items: jadwalWidgets,
                                  options: CarouselOptions(
                                    autoPlay: jadwalWidgets.length > 1,
                                    autoPlayInterval:
                                        const Duration(seconds: 10),
                                    aspectRatio: 16 / 10,
                                    enlargeCenterPage: true,
                                    scrollPhysics: jadwalWidgets.length > 1
                                        ? const BouncingScrollPhysics()
                                        : const NeverScrollableScrollPhysics(),
                                    viewportFraction: 1,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          if (user['role'] != "Orang Tua")
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color(0xffC2D9FF)),
                              child: Column(
                                children: [
                                  Text(
                                    user["address"] != null
                                        ? "${user["address"]}"
                                        : "Belum ada Lokasi",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    "Anda pada lingkungan sekolah",
                                    style: GoogleFonts.lato(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  StreamBuilder<
                                          DocumentSnapshot<
                                              Map<String, dynamic>>>(
                                      stream: controller.todayAbsen(),
                                      builder: (context, snapToday) {
                                        if (snapToday.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        Map<String, dynamic>? dataToday =
                                            snapToday.data?.data();
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Masuk",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  dataToday?['masuk'] == null
                                                      ? "-"
                                                      : "${DateFormat.Hm().format(DateTime.parse(dataToday!['masuk']['date']))}",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              width: 1,
                                              height: 40,
                                              color: Colors.white,
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                  "Keluar",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  dataToday?['keluar'] == null
                                                      ? "-"
                                                      : "${DateFormat.Hm().format(DateTime.parse(dataToday!['keluar']['date']))}",
                                                  style: GoogleFonts.lato(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        );
                                      }),
                                ],
                              ),
                            ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: const Color(0xffC2D9FF)),
                            child: Column(
                              children: [
                                Text(
                                  "Status Bencana",
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Kebakaran",
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Text("Aman"),
                                      ],
                                    ),
                                    Container(
                                      width: 1,
                                      height: 40,
                                      color: Colors.white,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Gempa Bumi",
                                          style: GoogleFonts.lato(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const Text("Aman"),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 15),
                          Container(
                            height: 1,
                            color: const Color(0xffC2D9FF),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                "Absensi 5 hari terakhir",
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                            stream: controller.streamLast5Absen(),
                            builder: (context, snapAbsen) {
                              if (snapAbsen.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapAbsen.data?.docs.length == 0 ||
                                  snapAbsen.data == null) {
                                return SizedBox(
                                  height: 200,
                                  child: Center(
                                    child: Text(
                                      "Tidak ada data Absensi",
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 18),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapAbsen.data!.docs.length,
                                itemBuilder: (context, index) {
                                  Map<String, dynamic> data =
                                      snapAbsen.data!.docs[index].data();

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 5),
                                    child: Material(
                                      color: const Color(0xff8E8FFA),
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        onTap: () => Get.toNamed(
                                            Routes.DETAIL_ABSENSI,
                                            arguments: data),
                                        borderRadius: BorderRadius.circular(20),
                                        child: Container(
                                          padding: const EdgeInsets.all(16),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Masuk",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "${DateFormat.yMMMMEEEEd('id_ID').format(DateTime.parse(data["date"]))}",
                                                    style: GoogleFonts.lato(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
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
                                                    fontWeight:
                                                        FontWeight.bold),
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
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Tidak dapat memuat data user"),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixed,
        color: const Color(0xff190482),
        backgroundColor: Colors.white,
        activeColor: const Color(0xff190482),
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
        items: const [
          TabItem(icon: Icons.home, title: 'Beranda', fontFamily: "Lato"),
          TabItem(icon: Icons.gps_fixed, title: 'Absensi', fontFamily: "Lato"),
          TabItem(icon: Icons.person, title: 'Profile', fontFamily: "Lato"),
        ],
      ),
    );
  }
}

class Jadwal extends StatelessWidget {
  const Jadwal({
    Key? key,
    required this.mataPelajaran,
    required this.waktuMasuk,
    required this.waktuKeluar,
  }) : super(key: key);
  final String mataPelajaran;
  final String waktuMasuk;
  final String waktuKeluar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                waktuMasuk,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
              Text(
                waktuKeluar,
                style: GoogleFonts.lato(
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Text(
            mataPelajaran,
            style: GoogleFonts.lato(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ]),
        const SizedBox(height: 5),
      ],
    );
  }
}

class CarouselJadwal extends StatelessWidget {
  const CarouselJadwal({
    Key? key,
    required this.jenjangSekolah,
    required this.kelas,
    required this.hari,
    required this.schedules,
  }) : super(key: key);

  final String jenjangSekolah;
  final String kelas;
  final String hari;
  final List<Jadwal> schedules;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff8E8FFA),
      ),
      padding: const EdgeInsets.all(15),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hari,
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "$jenjangSekolah - $kelas",
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const Divider(
              thickness: 0.7,
              color: Colors.white,
            ),
            ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(vertical: 5),
              shrinkWrap: true,
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final jadwal = schedules[index];
                return Column(
                  children: [
                    Jadwal(
                      mataPelajaran: jadwal.mataPelajaran,
                      waktuMasuk: jadwal.waktuMasuk,
                      waktuKeluar: jadwal.waktuKeluar,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
