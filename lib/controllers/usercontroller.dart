import 'package:get/get.dart';

class UserController extends GetxController {
  var dataList = [].obs;
  var selectedPage = 0.obs;

  updateDataList(list) {
    dataList.value = list;
  }

  updateSelectedPage(index) {
    selectedPage.value = index;
  }

  var userId = {
    'user_id',
  }.obs;
}
