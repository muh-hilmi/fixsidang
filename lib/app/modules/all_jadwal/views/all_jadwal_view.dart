import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fixsidang/app/modules/all_jadwal/controllers/all_jadwal_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AllJadwalView extends GetView<AllJadwalController> {
  AllJadwalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Semua Jadwal',
          style: GoogleFonts.lato(color: const Color(0xff190482)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;
            List<String> roleParts = user['role'].split(' ');
            String role = roleParts.first;
            String sekolah = roleParts.last;
            print(sekolah);

            return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: controller.streamAllJadwal(sekolah),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data?.docs.length == 0 || snapshot.data == null) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Text(
                        "Tidak ada jadwal 😥",
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
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final documents = snapshot.data!.docs;
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

                      print(groupedJadwal);
                    }
                    final jadwalWidgets = groupedJadwal.entries.map(
                      (entry) {
                        final keyParts = entry.key.split('-');
                        final jenjangSekolah = keyParts[0];
                        final kelas = keyParts[1];
                        final hari = keyParts[2];
                        final schedules = entry.value;

                        return JadwalItem(
                          jenjangSekolah: jenjangSekolah,
                          kelas: kelas,
                          hari: hari,
                          schedules: schedules,
                          role: role,
                        );
                      },
                    ).toList();
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: index < jadwalWidgets.length
                          ? jadwalWidgets[index]
                          : null,
                    );
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text("Tidak dapat memuat data user"),
            );
          }
        },
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
        Row(
          children: [
            Text(
              "$waktuMasuk - $waktuKeluar",
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              mataPelajaran,
              style: GoogleFonts.lato(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
    );
  }
}

class JadwalItem extends StatelessWidget {
  const JadwalItem({
    Key? key,
    required this.jenjangSekolah,
    required this.kelas,
    required this.hari,
    this.role,
    required this.schedules,
  }) : super(key: key);

  final String jenjangSekolah;
  final String kelas;
  final String hari;
  final String? role;
  final List<Jadwal> schedules;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AllJadwalController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xff8E8FFA),
          borderRadius: BorderRadius.circular(20),
        ),
        height: Get.height / 6,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hari, // Use the provided 'hari' parameter
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "$jenjangSekolah - $kelas",
                  style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(vertical: 5),
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
                  ),
                  if (role == "Admin" || role == "Guru")
                    IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Konfirmasi Hapus 🙀',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: const Color(0xff190482),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                'Apakah Anda yakin ingin menghapus jadwal ini?',
                                style: GoogleFonts.lato(
                                  fontSize: 18,
                                  color: const Color(0xff190482),
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: Text(
                                    'Batal',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: const Color(0xff190482),
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xff190482),
                                  ),
                                  onPressed: () {
                                    controller.deleteJadwal(
                                        jenjangSekolah, kelas, hari);
                                    Get.back();
                                  },
                                  child: Text(
                                    'Hapus',
                                    style: GoogleFonts.lato(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete_forever_rounded,
                        color: Colors.redAccent[100],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
