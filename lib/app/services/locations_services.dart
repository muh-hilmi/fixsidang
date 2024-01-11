import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  static Future<void> updatePosition(Position position, String addrres) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    String uid = await auth.currentUser!.uid;

    await firestore.collection('user').doc(uid).update({
      'position': {
        "lat": position.latitude,
        "long": position.longitude,
      },
      'address': addrres,
    });
  }

  static Future<Map<String, dynamic>> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      await Geolocator.openLocationSettings();
      // return Future.error('Location services are disabled.');
      return {
        "message": "Tidak dapat mengakses GPS",
        "error": true,
      };
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return {
          "message": "Izin GPS ditolak, tidak dapat mendapatkan lokasi",
          "error": true,
        };
        // Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return {
        "message":
            "Anda tidak mengizinkan device untuk mengakses lokasi, Ubah di pengaturan lokasi Anda",
        "error": true,
      };
      // Future.error(
      // 'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position position = await Geolocator.getCurrentPosition();
    return {
      "position": position,
      "message": "Berhasil mendapatkan posisi device",
      "error": false,
    };
  }
}
