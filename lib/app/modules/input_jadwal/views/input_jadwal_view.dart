import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/input_jadwal_controller.dart';

class InputJadwalView extends GetView<InputJadwalController> {
  const InputJadwalView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedJenjang = Rx<String?>(null);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Input Jadwal',
          style: GoogleFonts.lato(color: const Color(0xff190482)),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xff190482)),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          DropdownSearch<String>(
            clearButtonProps: const ClearButtonProps(
              isVisible: true,
            ),
            popupProps: const PopupProps.menu(
              fit: FlexFit.loose,
              showSelectedItems: true,
            ),
            items: const ["TK", "SD", "SMP", "SMA"],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                border: InputBorder.none,
                label: Text(
                  "Jenjang Sekolah",
                  style: GoogleFonts.lato(
                    color: const Color(0xff190482),
                    fontSize: 18,
                  ),
                ),
                fillColor: const Color(0xffF6F7FA),
                filled: true,
                hintText: "PIlih jenjang sekolah",
              ),
            ),
            onChanged: (value) {
              selectedJenjang.value = value;
              controller.jenjangSekolahC.value = value.toString();
              // print(selectedJenjang.value);
            },
          ),
          const SizedBox(height: 10),
          Obx(() {
            return DropdownSearch<String>(
              clearButtonProps: const ClearButtonProps(
                isVisible: true,
              ),
              popupProps: const PopupProps.menu(
                fit: FlexFit.loose,
                showSelectedItems: true,
              ),
              items: getItemsBasedOnJenjang(selectedJenjang.value),
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                  ),
                  border: InputBorder.none,
                  label: Text(
                    "Kelas",
                    style: GoogleFonts.lato(
                      color: const Color(0xff190482),
                      fontSize: 18,
                    ),
                  ),
                  fillColor: const Color(0xffF6F7FA),
                  filled: true,
                  hintText: selectedJenjang.value,
                ),
              ),
              onChanged: (value) {
                controller.kelasC.value = value.toString();
              },
            );
          }),
          const SizedBox(height: 10),
          DropdownSearch<String>(
            clearButtonProps: const ClearButtonProps(
              isVisible: true,
            ),
            popupProps: const PopupProps.menu(
              fit: FlexFit.loose,
              showSelectedItems: true,
            ),
            items: const ["Senin", "Selasa", "Rabu", "Kamis", "Jumat", "Sabtu"],
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                border: InputBorder.none,
                label: Text(
                  "Hari",
                  style: GoogleFonts.lato(
                    color: const Color(0xff190482),
                    fontSize: 18,
                  ),
                ),
                fillColor: const Color(0xffF6F7FA),
                filled: true,
                hintText: "Pilih hari",
              ),
            ),
            onChanged: (value) {
              // print(value);
              controller.hariC.value = value.toString();
            },
          ),
          const SizedBox(height: 10),
          TextField(
            style: GoogleFonts.lato(fontSize: 20),
            controller: controller.mataPelajaranC,
            cursorColor: const Color(0xff190482),
            decoration: InputDecoration(
              label: Text(
                "Mata Pelajaran",
                style: GoogleFonts.lato(
                  color: const Color(0xff190482),
                  fontSize: 18,
                ),
              ),
              fillColor: const Color(0xffF6F7FA),
              filled: true,
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.selectStartTime();
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      focusColor: Color(0xff190482),
                      labelText: "Jam Awal",
                      fillColor: Color(0xffF6F7FA),
                      filled: true,
                      border: InputBorder.none,
                    ),
                    child: Obx(() {
                      return Text(
                        controller.selectedStartTime.value?.format(context) ??
                            'Pilih Jam Awal',
                        style: GoogleFonts.lato(
                          color: const Color(0xff190482),
                          fontSize: 18,
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 16), // Spasi antara kedua input
              Expanded(
                child: InkWell(
                  onTap: () {
                    controller.selectEndTime();
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      focusColor: Color(0xff190482),
                      labelText: "Jam Akhir",
                      fillColor: Color(0xffF6F7FA),
                      filled: true,
                      border: InputBorder.none,
                    ),
                    child: Obx(() {
                      return Text(
                        controller.selectedEndTime.value?.format(context) ??
                            'Pilih Jam Akhir',
                        style: GoogleFonts.lato(
                          color: const Color(0xff190482),
                          fontSize: 18,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Obx(() {
            return SizedBox(
              width: Get.width,
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: Text(
                        "Apakah jadwal yang akan diinput sudah benar?",
                        style: GoogleFonts.lato(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Periksa lagi",
                            style: GoogleFonts.lato(
                              color: const Color(0xff190482),
                              fontSize: 18,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF190482)),
                          onPressed: () async {
                            Navigator.pop(context);
                            controller.inputjadwal();
                          },
                          child: Text(
                            "Input Jadwal",
                            style: GoogleFonts.lato(
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFF7752FE),
                  padding: const EdgeInsets.symmetric(
                    vertical: 18,
                  ),
                ),
                child: controller.isLoading.isTrue
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        "Tambah Jadwal",
                        style: GoogleFonts.lato(
                          fontSize: 20,
                        ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

List<String> getItemsBasedOnJenjang(String? jenjang) {
  if (jenjang == "TK") {
    return ["A", "B"];
  } else if (jenjang == "SD") {
    return ["1", "2", "3", "4", "5", "6"];
  } else if (jenjang == "SMP" || jenjang == "SMA") {
    return ["1", "2", "3"];
  } else {
    return [];
  }
}
