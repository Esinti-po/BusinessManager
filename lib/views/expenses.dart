import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/expensecontroller.dart';
import 'package:BUSINESS_MANAGER/models/expensesmodel.dart';
import 'package:BUSINESS_MANAGER/views/custombutton.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:BUSINESS_MANAGER/views/customtextfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

final ExpenseController expenseController = Get.put(ExpenseController());

class Expenses extends StatefulWidget {
  final int userId;
  const Expenses({super.key, required this.userId});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  bool isLoading = true;
  var expenseDataList = expenseController.dataList;
  final TextEditingController _expenseTypeController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

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
        throw Exception('Failed to load expenses');
      }
    } catch (e) {
      throw Exception(e);
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
          label: "Expenses",
          labelColor: Theme.of(context).colorScheme.secondary,
          fontSize: 26,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showFormDialog(context);
        },
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.add),
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
                scrollDirection: Axis.horizontal,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: CustomText(label: "Date")),
                        DataColumn(label: CustomText(label: "Expense Type")),
                        DataColumn(label: CustomText(label: "Price")),
                        DataColumn(label: CustomText(label: "")),
                        DataColumn(label: CustomText(label: "")),
                      ],
                      rows: expenseDataList
                          .map((expenseModel) => DataRow(cells: [
                                DataCell(Text(expenseModel.date)),
                                DataCell(Text(expenseModel.name)),
                                DataCell(Text(expenseModel.price.toString())),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () => _showUpdateDialog(
                                        context, expenseModel.name),
                                  ),
                                ),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => _confirmDelete(
                                        context, expenseModel.name),
                                  ),
                                ),
                              ]))
                          .toList(),
                    ),
                  ),
                ],
              );
            }),
    );
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomText(
            label: "Record Expense",
            labelColor: secondaryColor,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomtextField(
                label: "Expense Type",
                controller: _expenseTypeController,
              ),
              const SizedBox(height: 20),
              CustomtextField(
                label: "Amount",
                controller: _amountController,
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: "Add",
                action: () {
                  recordExpense();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUpdateDialog(BuildContext context, String expenseName) {
    _expenseTypeController.text = expenseName;
    _amountController.text = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Expense"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomtextField(
                label: "Expense Type",
                controller: _expenseTypeController,
              ),
              CustomtextField(
                label: "Amount",
                controller: _amountController,
              ),
              const SizedBox(height: 20),
              CustomButton(
                label: "Update",
                action: () {
                  updateExpense(expenseName);
                  Navigator.pop(context); // Close dialog
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Delete"),
          content: const Text("Are you sure you want to delete this expense?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                deleteExpense(name);
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateExpense(String expenseName) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/expenses/update_expense.php"),
        body: {
          'name': expenseName,
          'price': _amountController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse['success'] == true) {
          // Update successful, refresh expense list
          fetchExpenses();
          // Show success message using GetX dialog or Snackbar
          Get.snackbar('Success', 'Expense updated successfully');
        } else {
          // Show error message using GetX dialog or Snackbar
          Get.snackbar('Error', 'Failed to update expense');
        }
      } else {
        throw Exception('Failed to update expense');
      }
    } catch (e) {
      Get.defaultDialog(middleText: "UnExpected error occured");
    }
  }

  Future<void> deleteExpense(String expenseName) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/expenses/delete_expense.php"),
        body: {
          'name': expenseName,
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse['success'] == true) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: "Stock Deleted Successfully.",
            onConfirm: () {
              fetchExpenses();
            },
          );
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: 'Error',
            middleText: "Failed to delete Expense.",
          );
        }
      } else {
        Get.defaultDialog(
          middleText: "Failed to delete expense, Please try again later",
        );
      }
    } catch (e) {
      Get.defaultDialog(
          middleText: "Unexpected Error occured, please try again later");
    }
  }

  Future<void> recordExpense() async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/expenses/record_expenses.php"),
        body: {
          'name': _expenseTypeController.text.trim(),
          'price': _amountController.text.trim(),
          'user_id': widget.userId.toString(),
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse['success'] == true) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: "Expense has been recorded Successfully.",
            onConfirm: () {
              fetchExpenses();
            },
          );
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Unable to record Expense.",
            middleText: 'Server Error: ${response.statusCode}',
            onConfirm: () {
              fetchExpenses();
            },
          );
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
