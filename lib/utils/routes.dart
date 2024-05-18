import 'package:BUSINESS_MANAGER/views/home.dart';
import 'package:BUSINESS_MANAGER/views/login.dart';
import 'package:BUSINESS_MANAGER/views/passwordrecovery.dart';
import 'package:BUSINESS_MANAGER/views/registration.dart';
import 'package:BUSINESS_MANAGER/views/userhome.dart';
import 'package:get/get.dart';

class Routes {
  static var routes = [
    GetPage(
      name: "/login",
      page: () => const Login(),
    ),
    GetPage(
      name: "/recover",
      page: () => const PasswordRecoverScreen(),
    ),
    GetPage(
      name: "/userHome",
      page: ({arguments}) => UserHome(
        userId: arguments['userId'],
        storeId: arguments['storeId'],
      ),
    ),
    GetPage(
      name: "/home",
      page: ({arguments}) => Home(
        userId: arguments['userId'],
        storeId: arguments['storeId'],
      ),
    ),
    GetPage(
      name: "/registration",
      page: () => const RegistrationPage(),
    ),
  ];
}
