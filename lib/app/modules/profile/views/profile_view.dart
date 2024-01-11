import 'package:fixsidang/app/controllers/page_index_controller.dart';
import 'package:fixsidang/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import "package:google_fonts/google_fonts.dart";
import 'package:get/get.dart';
import 'package:random_avatar/random_avatar.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  ProfileView({Key? key}) : super(key: key);

  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profil Saya',
          style: GoogleFonts.lato(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xff190482)),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;

            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 75,
                        height: 75,
                        child: RandomAvatar(user['nama']),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  '${user['nama'].toString().toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  '${user['nip'].toString().toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 20),
                ),
                const SizedBox(height: 10),
                Text(
                  '${user['email']}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(fontSize: 16),
                ),
                const SizedBox(height: 20),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  onTap: () {
                    Get.toNamed(
                      Routes.CHANGE_PROFILE,
                      arguments: user,
                    );
                  },
                  leading: const Icon(
                    Icons.person_2_outlined,
                    color: Color(0xff190482),
                  ),
                  title: Text(
                    "Ubah Profile",
                    style: GoogleFonts.lato(
                      color: const Color(0xff190482),
                    ),
                  ),
                ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  onTap: () {
                    Get.toNamed(Routes.CHANGE_PASSWORD);
                  },
                  leading: const Icon(
                    Icons.key_outlined,
                    color: Color(0xff190482),
                  ),
                  title: Text(
                    "Ganti Password",
                    style: GoogleFonts.lato(
                      color: const Color(0xff190482),
                    ),
                  ),
                ),
                if (user["role"] != "Orang Tua")
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    onTap: () {
                      Get.toNamed(Routes.ALL_ABSENSI);
                    },
                    leading: const Icon(
                      Icons.person_search_outlined,
                      color: Color(0xff190482),
                    ),
                    title: Text(
                      "Riwayat Absensi",
                      style: GoogleFonts.lato(
                        color: const Color(0xff190482),
                      ),
                    ),
                  ),
                if (user["role"] != "Orang Tua")
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    onTap: () {
                      Get.toNamed(Routes.ALL_JADWAL);
                    },
                    leading: const Icon(
                      Icons.calendar_month,
                      color: Color(0xff190482),
                    ),
                    title: Text(
                      "Semua Jadwal",
                      style: GoogleFonts.lato(
                        color: const Color(0xff190482),
                      ),
                    ),
                  ),
                if (user["role"] == "Admin")
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    onTap: () {
                      Get.toNamed(Routes.INPUT_USER);
                    },
                    leading: const Icon(
                      Icons.book_outlined,
                      color: Color(0xff190482),
                    ),
                    title: Text(
                      "Input User",
                      style: GoogleFonts.lato(
                        color: const Color(0xff190482),
                      ),
                    ),
                  ),
                if (user["role"] != "Orang Tua")
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 5),
                    onTap: () {
                      Get.toNamed(Routes.INPUT_JADWAL);
                    },
                    leading: const Icon(
                      Icons.schedule_outlined,
                      color: Color(0xff190482),
                    ),
                    title: Text(
                      "Input Jadwal",
                      style: GoogleFonts.lato(
                        color: const Color(0xff190482),
                      ),
                    ),
                  ),
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                  onTap: () {
                    Get.defaultDialog(
                      title: "Keluar",
                      content: const Column(
                        children: [
                          Text(
                            'Apakah Anda ingin keluar?',
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff190482)),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Get.offAllNamed(Routes.LOGIN);
                          },
                          child: Text(
                            "Ya",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Tidak",
                            style: GoogleFonts.lato(
                              color: const Color(0xff190482),
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                  leading: const Icon(
                    Icons.logout_outlined,
                    color: Color(0xff190482),
                  ),
                  title: Text(
                    "Keluar",
                    style: GoogleFonts.lato(
                      color: const Color(0xff190482),
                    ),
                  ),
                ),
              ],
            );
          } else {
            return const Center(
                // child: Text("Tidak dapat memuat data"),
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
