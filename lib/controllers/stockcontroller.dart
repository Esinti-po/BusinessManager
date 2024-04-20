import 'package:get/get.dart';

class StockController extends GetxController {
  var name = "".obs;
  var description = "".obs;
  var quantity = "".obs;
  var minQuantity = "".obs;
  var price = "".obs;
  var sPrice = "".obs;
  var dataList = [].obs;

  updateDataList(list) {
    dataList.value = list;
  }

  void updatepName(var pName) {
    name.value = pName;
  }

  void updateDescription(var description) {
    description.value = description;
  }

  void updatepQuantity(var pQuantity) {
    quantity.value = pQuantity;
  }

  void updateminQuantity(var pminQuantity) {
    minQuantity.value = pminQuantity;
  }

  void updateprice(var pPrice) {
    price.value = pPrice;
  }

  void updatesprice(var spPrice) {
    sPrice.value = spPrice;
  }
}
