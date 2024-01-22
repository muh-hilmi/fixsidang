import 'package:fixsidang/app/controllers/page_index_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../controllers/home_alarm_controller.dart';

class HomeAlarmView extends GetView<HomeAlarmController> {
  HomeAlarmView({Key? key}) : super(key: key);

  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    String statusText = controller.isDisaster
        ? 'Ada bencana! Jangan panik 👍'
        : 'Aman 🎉, Tidak ada tanda-tanda bahaya!';
    String lottieAlarm = controller.isDisaster
        ? "assets/lotties/red_notice.json"
        : "assets/lotties/smile.json";
    Color colorDisaster =
        controller.isDisaster ? Colors.red : const Color(0xff190482);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Alarm',
          style: GoogleFonts.lato(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorDisaster,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: ListView(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Lottie.asset(lottieAlarm,
                    height: 200, repeat: controller.isDisaster ? true : false),
                Obx(
                  () => Text(
                    controller.currentTime.value,
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                Text(
                  statusText,
                  style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colorDisaster),
                ),
                const SizedBox(height: 20),
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
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                const SizedBox(height: 20),
                Obx(() {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xff8E8FFA),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Sensor Suhu-Lembap",
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Sensor Gas",
                              style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decorationThickness: 50,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              // color: Colors.amberAccent,
                              width: Get.width * 0.45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Device 1 : \nSuhu : ${controller.device1temperature} C | Kelembapan : ${controller.device1humid}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 2 : \nSuhu : ${controller.device2temperature} | Kelembapan :  ${controller.device2humid}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 3 : \nSuhu : 30 C | Kelembapan : 40",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 4 : \nSuhu : 30 C | Kelembapan : 40",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Device 1: \nGas : ${controller.device1gas}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 2: \nGas : ${controller.device2gas}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 3: \nGas : 600",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 4: \nGas : 600",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Sensor Api",
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Sensor Gempa",
                              style: GoogleFonts.lato(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  decorationThickness: 50,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              // color: Colors.amberAccent,
                              width: Get.width * 0.45,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Device 1 : \nApi2 : ${controller.device1flame2} | Api2 : ${controller.device1flame3} | Api3 : ${controller.device1flame4}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 2 : \nApi1 : ${controller.device2flame2} | Api2 : ${controller.device2flame3} | Api3 : ${controller.device2flame4}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 3 : \nApi1 : 90 | Api2 : 90 | Api3 : 90",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 4 : \nApi1 : 90 | Api2 : 90 | Api3 : 90",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: Get.width * 0.45,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Device 1: \nMagnitude : ${controller.device1magnitude.toStringAsFixed(3)}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 2: \nMagnitude : ${controller.device2magnitude.toStringAsFixed(3)}",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 3: \nX : 0.1 | Y : 0.1 | Z : 0.1",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "Device 4: \nX : 0.1 | Y : 0.1 | Z : 0.1",
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 15),
                const Divider(height: 1, color: Color(0xff7752FE)),
                const SizedBox(height: 15),
                Text(
                  "Atur Manual Lampu",
                  style: GoogleFonts.lato(
                    color: const Color(0xff190482),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffC2D9FF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lampu Istirahat",
                        style: GoogleFonts.lato(
                          color: const Color(0xff190482),
                          fontSize: 18,
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isIstirahatOn.value,
                          activeColor: const Color(0xff190482),
                          onChanged: (value) {
                            if (!value || !controller.isMasukOn.value) {
                              controller.isIstirahatOn.value = value;
                              HapticFeedback.heavyImpact();
                              controller.istirahat();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(5),
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xffC2D9FF),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Lampu Masuk",
                        style: GoogleFonts.lato(
                          color: const Color(0xff190482),
                          fontSize: 18,
                        ),
                      ),
                      Obx(
                        () => Switch(
                          value: controller.isMasukOn.value,
                          activeColor: const Color(0xff190482),
                          onChanged: (value) {
                            if (!value || !controller.isIstirahatOn.value) {
                              controller.isMasukOn.value = value;
                              HapticFeedback.heavyImpact();
                              controller.masuk();
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
