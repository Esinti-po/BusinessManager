import 'package:get/get.dart';

class RegistrationController extends GetxController {
  var isHidden = true.obs;
  toggleHide() {
    isHidden.value = !isHidden.value;
  }
}
