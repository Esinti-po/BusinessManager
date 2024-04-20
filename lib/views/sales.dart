import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/salescontroller.dart';
import 'package:BUSINESS_MANAGER/models/salesmodel.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:BUSINESS_MANAGER/views/customtextfield.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final SalesController salesController = Get.put(SalesController());

class Sales extends StatefulWidget {
  const Sales({super.key});

  @override
  State<Sales> createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  bool isLoading = true;
  var salesDataList = salesController.dataList;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _modeOfPayment = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchSales();
  }

  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Future<void> fetchSales() async {
    try {
      final response = await http.get(Uri.parse(
          'https://technestsolutions.co.ke/business_manager/sales/display_sales.php'));

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        var dataResponse = serverResponse['data'];
        var dataList =
            dataResponse.map((data) => SalesModel.fromJson(data)).toList();
        salesController.updateDataList(dataList);
      } else {
        throw Exception('Failed to load sales');
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error fetching Sale: $e');
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
          label: "Sales",
          fontSize: 26,
          labelColor: Theme.of(context).colorScheme.secondary,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.toNamed("/login"),
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
              var salesDataList = salesController.dataList;
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text("Date")),
                        DataColumn(label: Text("Product Name")),
                        DataColumn(label: Text("Quantity")),
                        DataColumn(label: Text("Unit Price")),
                        DataColumn(label: Text("Total Price")),
                        DataColumn(label: Text("Mode of Payment")),
                        DataColumn(label: Text("")),
                        DataColumn(label: Text("")),
                      ],
                      rows: salesDataList
                          .map((salesModel) => DataRow(cells: [
                                DataCell(Text(salesModel.date)),
                                DataCell(Text(salesModel.name)),
                                DataCell(Text(salesModel.quantity.toString())),
                                DataCell(Text(salesModel.unitPrice.toString())),
                                DataCell(
                                    Text(salesModel.totalPrice.toString())),
                                DataCell(Text(salesModel.modeOfPayment)),
                                DataCell(
                                  IconButton(
                                      icon: const Icon(Icons.edit),
                                      onPressed: () {
                                        _showUpdateDialog(
                                            context, salesModel.name);
                                      }),
                                ),
                                DataCell(
                                  IconButton(
                                      icon: const Icon(Icons.delete),
                                      onPressed: () {
                                        _confirmDelete(
                                            context, salesModel.name);
                                      }),
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

  void _showUpdateDialog(BuildContext context, String productName) {
    // Initialize controllers with existing stock data
    _productNameController.text =
        productName; // Set initial description value if needed
    _quantityController.text = ''; // Set initial quantity value if needed

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Sale"),
          content: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                children: [
                  CustomtextField(
                    label: "Product Name",
                    controller: _productNameController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomtextField(
                    label: "Quantity",
                    controller: _quantityController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomtextField(
                    label: "Mode of Payment",
                    controller: _modeOfPayment,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: appBlack),
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        updateSales(productName); // Call updateStock function
                      },
                      child: const CustomText(
                        label: "Update",
                        labelColor: appWhite,
                        centerText: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
          content: const Text("Are you sure you want to delete this item?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteSales(name);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateSales(String productName) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/sales/update_sales.php"),
        body: {
          'product_name': productName,
          'quantity': _quantityController.text.trim(),
          'mode_of_payment': _modeOfPayment.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse['success'] == true) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: "Sale Updated Successfully.",
            onConfirm: () {
              fetchSales();
            },
          );
          // Handle success message or update UI
          fetchSales(); // Refresh stock list after update
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Failed to Update Sale.",
            middleText: "${serverResponse['message']}",
            onConfirm: () {
              fetchSales();
            },
          );
        }
      } else {
        throw Exception('Failed to update sale');
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error updating sale: $e');
    }
  }

  Future<void> deleteSales(String productName) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/sales/delete_sales.php"),
        body: {
          'product_name': productName,
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse['success'] == true) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: "Sale Deleted Successfully.",
            onConfirm: () {
              fetchSales();
            },
          );
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Failed to delete Sale",
            middleText: "${serverResponse['message']}",
            onConfirm: () {
              fetchSales();
            },
          );
        }
      } else {
        throw Exception('Failed to delete sale');
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error deleting sale: $e');
    }
  }
}
