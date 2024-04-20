import 'package:get/get.dart';

class NotificationsController extends GetxController {
  var dataList = [].obs;

  updateDataList(list) {
    dataList.value = list;
  }
}
