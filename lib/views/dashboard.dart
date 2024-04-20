import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/dashboardcontroller.dart';
import 'package:BUSINESS_MANAGER/controllers/notificationscontroler.dart';
import 'package:BUSINESS_MANAGER/models/notificationsmodel.dart';
import 'package:BUSINESS_MANAGER/theme/themeprovider.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

DashBoardController dashBoardController = Get.put(DashBoardController());
NotificationsController notificationsController =
    Get.put(NotificationsController());

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  var isLoading = true.obs;
  var dashboardDataList = dashBoardController.dataList;

  @override
  void initState() {
    super.initState();
    getData();
    fetchNotifications();
  }

  Future<void> getData() async {
    try {
      http.Response response;
      response = await http.get(Uri.parse(
          "https://technestsolutions.co.ke/business_manager/dashboard.php"));
      if (response.statusCode == 200) {
        isLoading.value = false;
        var serverResponse = json.decode(response.body);
        dashBoardController.salesData['today_sales'] =
            serverResponse['today_sales'];
        dashBoardController.expenseData['today_expenses'] =
            serverResponse['today_expenses'];
        dashBoardController.incomeData['today_income'] =
            serverResponse['today_income'];
        dashBoardController.monthlyData['monthly_income'] =
            serverResponse['monthly_income'];
      } else {
        Get.defaultDialog(middleText: response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> fetchNotifications() async {
    try {
      final response = await http.get(Uri.parse(
          'https://technestsolutions.co.ke/business_manager/notifications.php'));

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        var dataResponse = serverResponse['data'];
        var dataList = dataResponse
            .map((data) => NotificationsModel.fromJson(data))
            .toList();
        notificationsController.updateDataList(dataList);
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      Get.defaultDialog(
          title: "Failed", middleText: 'Error fetching stock data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: CustomText(
          label: "My Shop",
          fontSize: 20,
          fontWeight: FontWeight.bold,
          labelColor: Theme.of(context).colorScheme.secondary,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) => IconButton(
              onPressed: () {
                var mode = themeProvider.getThemeMode() == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
                themeProvider.setThemeMode(mode);
              },
              icon: Icon(themeProvider.getThemeMode() == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
            ),
          ),
          GestureDetector(
            onTap: () => Get.offAndToNamed("/login"),
            child: const CustomText(
              label: "LogOut",
              fontSize: 20,
              labelColor: secondaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    isLoading.value ? shimmerLoadingContainer() : salesWidget(),
                    const SizedBox(height: 20),
                    isLoading.value
                        ? shimmerLoadingContainer()
                        : expensesWidget(),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    isLoading.value
                        ? shimmerLoadingContainer()
                        : incomeWidget(),
                    const SizedBox(height: 20),
                    isLoading.value
                        ? shimmerLoadingContainer()
                        : monthlyIncomeWidget(),
                  ],
                ),
                const SizedBox(height: 30),
                isLoading.value
                    ? shimmerLoadingContainer(
                        width: MediaQuery.of(context).size.width * .9)
                    : notificationsWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget salesWidget() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.shopping_cart, color: Colors.white, size: 35.0),
          const Text("Today's sales", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text(
            "Ksh:${dashBoardController.salesData['today_sales'].toString()}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget expensesWidget() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.payments_rounded, color: Colors.white, size: 35.0),
          const Text('Expenses', style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text(
            "Ksh:${dashBoardController.expenseData['today_expenses'].toString()}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget incomeWidget() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monetization_on_rounded,
              color: Colors.white, size: 35.0),
          const Text("Today's income", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          Text(
            "Ksh:${dashBoardController.incomeData['today_income'].toString()}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget monthlyIncomeWidget() {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.monetization_on_rounded,
              color: Colors.white, size: 35.0),
          Text(
            "${DateFormat('MMMM').format(DateTime.now())} Income",
            style: const TextStyle(fontSize: 17),
          ),
          const SizedBox(height: 10),
          Text(
            "Ksh: ${dashBoardController.monthlyData['monthly_income'].toString()}",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget notificationsWidget() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.notifications,
                        color: Theme.of(context).colorScheme.secondary,
                        size: 35.0),
                    const CustomText(
                      label: "NOTIFICATIONS",
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      centerText: true,
                      labelColor: appWhite,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const CustomText(
                  label: "The following items need restocking:",
                  labelColor: appWhite,
                ),
              ],
            ),
          ),
          Obx(() {
            var notificationsDataList = notificationsController.dataList;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text("Name")),
                  DataColumn(label: Text("Description")),
                  DataColumn(label: Text("Quantity Remaining")),
                ],
                rows: notificationsDataList
                    .map(
                      (notificationsData) => DataRow(
                        cells: [
                          DataCell(Text(notificationsData.name)),
                          DataCell(Text(notificationsData.description)),
                          DataCell(Text(notificationsData.quantity.toString())),
                        ],
                      ),
                    )
                    .toList(),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget shimmerLoadingContainer({double width = 150.0}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: 150,
        width: width,
        decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
    );
  }
}
