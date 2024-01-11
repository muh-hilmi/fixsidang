// ignore_for_file: constant_identifier_names

part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const SPLASHSCREEN = _Paths.SPLASHSCREEN;
  static const WELCOME = _Paths.WELCOME;
  static const ASK_GURUMURID = _Paths.ASK_GURUMURID;
  static const LOGIN = _Paths.LOGIN;
  static const SIGNUP = _Paths.SIGNUP;
  static const PROFILE = _Paths.PROFILE;
  static const HOME_ALARM = _Paths.HOME_ALARM;
  static const CHANGE_PROFILE = _Paths.CHANGE_PROFILE;
  static const CHANGE_PASSWORD = _Paths.CHANGE_PASSWORD;
  static const INPUT_JADWAL = _Paths.INPUT_JADWAL;
  static const INPUT_USER = _Paths.INPUT_USER;
  static const HOME_ABSENSI = _Paths.HOME_ABSENSI;
  static const DETAIL_ABSENSI = _Paths.DETAIL_ABSENSI;
  static const ALL_ABSENSI = _Paths.ALL_ABSENSI;
  static const ALL_JADWAL = _Paths.ALL_JADWAL;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const SPLASHSCREEN = '/splashscreen';
  static const WELCOME = '/welcome';
  static const ASK_GURUMURID = '/ask-gurumurid';
  static const LOGIN = '/login';
  static const SIGNUP = '/signup';
  static const PROFILE = '/profile';
  static const HOME_ALARM = '/home-alarm';
  static const CHANGE_PROFILE = '/change-profile';
  static const CHANGE_PASSWORD = '/change-password';
  static const INPUT_JADWAL = '/input-jadwal';
  static const INPUT_USER = '/input-user';
  static const HOME_ABSENSI = '/home-absensi';
  static const DETAIL_ABSENSI = '/detail-absensi';
  static const ALL_ABSENSI = '/all-absensi';
  static const ALL_JADWAL = '/all-jadwal';
}
