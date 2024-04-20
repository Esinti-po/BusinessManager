import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/controllers/expensecontroller.dart';
import 'package:BUSINESS_MANAGER/models/expensesmodel.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

final ExpenseController expenseController = Get.put(ExpenseController());

class OwnerExpenses extends StatefulWidget {
  const OwnerExpenses({super.key});

  @override
  State<OwnerExpenses> createState() => _OwnerExpensesState();
}

class _OwnerExpensesState extends State<OwnerExpenses> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());
  Future<void> fetchExpenses() async {
    try {
      final response = await http.get(Uri.parse(
          'https://technestsolutions.co.ke/business_manager/expenses/display_expenses.php'));

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        var dataResponse = serverResponse['data'];
        var dataList =
            dataResponse.map((data) => ExpenseModel.fromJson(data)).toList();
        expenseController.updateDataList(dataList);
      } else {
        throw Exception('Failed to load Expenses');
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error: $e');
    } finally {
      // Set isLoading to false when data fetching completes (success or failure)
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: CustomText(
            label: "Expenses Records",
            labelColor: Theme.of(context).colorScheme.secondary,
            fontSize: 26,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: isLoading
            ? Center(
                child: SpinKitSpinningLines(
                  color: Theme.of(context).colorScheme.primary,
                  size: 100.0,
                ),
              )
            : Obx(() {
                var expenseDataList = expenseController.dataList;
                return ListView(
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: CustomText(label: "Date")),
                            DataColumn(
                                label: CustomText(label: "Expense Type")),
                            DataColumn(label: CustomText(label: "Price")),
                          ],
                          rows: expenseDataList
                              .map((expenseData) => DataRow(cells: [
                                    DataCell(Text(expenseData.date)),
                                    DataCell(Text(expenseData.name)),
                                    DataCell(
                                        Text(expenseData.price.toString())),
                                  ]))
                              .toList(),
                        ),
                      ),
                    ),
                  ],
                );
              }));
  }
}
