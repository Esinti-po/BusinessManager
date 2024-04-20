import 'package:get/get.dart';

class ExpenseController extends GetxController {
  var name = "".obs;
  var amount = "".obs;
  var dataList = [].obs;

  void updatenewName(var newName) {
    name.value = newName;
  }

  void updatenewAmount(var newAmount) {
    amount.value = newAmount;
  }

  updateDataList(list) {
    dataList.value = list;
  }
}
