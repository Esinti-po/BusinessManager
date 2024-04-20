import 'package:BUSINESS_MANAGER/views/home.dart';
import 'package:BUSINESS_MANAGER/views/login.dart';
import 'package:BUSINESS_MANAGER/views/passwordrecovery.dart';
import 'package:BUSINESS_MANAGER/views/registration.dart';
import 'package:BUSINESS_MANAGER/views/userhome.dart';
import 'package:get/get.dart';

class Routes {
  static var routes = [
    GetPage(name: "/login", page: () => const Login()),
    GetPage(name: "/recover", page: () => const PasswordRecoverScreen()),
    GetPage(name: "/userHome", page: () => const UserHome()),
    GetPage(name: "/home", page: () => const Home()),
    GetPage(name: "/registration", page: () => const RegistrationPage()),
  ];
}
