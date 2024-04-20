import 'package:get/get.dart';

class SalesController extends GetxController {
  var dataList = [].obs;
  var name = "".obs;
  var quantity = "".obs;
  var unitPrice = "".obs;
  var totalPrice = "".obs;
  var modeOfPayment = "".obs;

  updateDataList(list) {
    dataList.value = list;
  }

  void updatename(var sName) {
    name.value = sName;
  }

  void updatequantity(var sQuantity) {
    quantity.value = sQuantity;
  }

  void updateunitPrice(var sUnitPrice) {
    unitPrice.value = sUnitPrice;
  }

  void updatetotalPrice(var sTotalPrice) {
    totalPrice.value = sTotalPrice;
  }

  void updatemodeOfPayment(var sModeOfPayment) {
    modeOfPayment.value = sModeOfPayment;
  }
}
