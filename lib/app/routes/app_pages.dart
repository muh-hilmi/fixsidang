import 'package:get/get.dart';

import '../modules/all_absensi/bindings/all_absensi_binding.dart';
import '../modules/all_absensi/views/all_absensi_view.dart';
import '../modules/all_jadwal/bindings/all_jadwal_binding.dart';
import '../modules/all_jadwal/views/all_jadwal_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/change_profile/bindings/change_profile_binding.dart';
import '../modules/change_profile/views/change_profile_view.dart';
import '../modules/detail_absensi/bindings/detail_absensi_binding.dart';
import '../modules/detail_absensi/views/detail_absensi_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/home_alarm/bindings/home_alarm_binding.dart';
import '../modules/home_alarm/views/home_alarm_view.dart';
import '../modules/input_jadwal/bindings/input_jadwal_binding.dart';
import '../modules/input_jadwal/views/input_jadwal_view.dart';
import '../modules/input_user/bindings/input_user_binding.dart';
import '../modules/input_user/views/input_user_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/signup/bindings/signup_binding.dart';
import '../modules/signup/views/signup_view.dart';
import '../views/views/ask_gurumurid_view.dart';
import '../views/views/splashscreen_view.dart';
import '../views/views/welcome_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
    ),
    GetPage(
      name: _Paths.WELCOME,
      page: () => const WelcomeView(),
    ),
    GetPage(
      name: _Paths.ASK_GURUMURID,
      page: () => const AskGurumuridView(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGNUP,
      page: () => SignupView(),
      binding: SignupBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.HOME_ALARM,
      page: () => HomeAlarmView(),
      binding: HomeAlarmBinding(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: _Paths.CHANGE_PROFILE,
      page: () => ChangeProfileView(),
      binding: ChangeProfileBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.INPUT_JADWAL,
      page: () => const InputJadwalView(),
      binding: InputJadwalBinding(),
    ),
    GetPage(
      name: _Paths.INPUT_USER,
      page: () => const InputUserView(),
      binding: InputUserBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_ABSENSI,
      page: () => DetailAbsensiView(),
      binding: DetailAbsensiBinding(),
    ),
    GetPage(
      name: _Paths.ALL_ABSENSI,
      page: () => const AllAbsensiView(),
      binding: AllAbsensiBinding(),
    ),
    GetPage(
      name: _Paths.ALL_JADWAL,
      page: () => AllJadwalView(),
      binding: AllJadwalBinding(),
    ),
  ];
}
