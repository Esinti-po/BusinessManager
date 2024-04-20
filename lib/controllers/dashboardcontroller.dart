import 'package:BUSINESS_MANAGER/models/dashboardmodel.dart';
import 'package:get/get.dart';

class DashBoardController extends GetxController {
  var dataList = <DashboardModel>[].obs;

  void updatedashboardDataList(List<DashboardModel> newDataList) {
    dataList.value = newDataList;
  }

  var salesData = {
    'today_sales': 0,
  }.obs;
  var expenseData = {
    'today_expenses': 0,
  }.obs;
  var incomeData = {
    'today_income': 0,
  }.obs;
  var monthlyData = {
    'monthly_income': 0,
  }.obs;

  var notificationsData = {
    'low_stock_notifications': "",
  }.obs;
}
