import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/stockcontroller.dart';
import 'package:BUSINESS_MANAGER/models/stockmodel.dart';
import 'package:BUSINESS_MANAGER/views/custombutton.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:BUSINESS_MANAGER/views/customtextfield.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

final StockController stockController = Get.put(StockController());

class Stock extends StatefulWidget {
  final int userId;
  final int storeId;
  const Stock({super.key, required this.userId, required this.storeId});

  @override
  State<Stock> createState() => _StockState();
}

class _StockState extends State<Stock> {
  late int userId;
  late int storeId;
  bool isLoading = true;
  var stockDataList = stockController.dataList;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _minQuantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _spriceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    userId = widget.userId;
    storeId = widget.storeId;
    fetchStock();
  }

  String date = DateFormat('dd-MM-yyyy').format(DateTime.now());

  Future<void> fetchStock() async {
    try {
      final response = await http.get(Uri.parse(
          'https://technestsolutions.co.ke/business_manager/stock/owner_stock_display.php'));

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        var dataResponse = serverResponse['data'];
        var dataList =
            dataResponse.map((data) => StockModel.fromJson(data)).toList();
        stockController.updateDataList(dataList);
      } else {
        throw Exception('Failed to load stock');
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error fetching stock: $e');
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
            label: "Stock",
            labelColor: Theme.of(context).colorScheme.secondary,
            fontSize: 26,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        floatingActionButton: Align(
          alignment: Alignment.bottomCenter,
          child: FloatingActionButton(
            onPressed: () {
              _showFormDialog(context);
            },
            backgroundColor: primaryColor,
            child: const Icon(Icons.add),
          ),
        ),
        body: isLoading
            ? Center(
                child: SpinKitSpinningLines(
                  color: Theme.of(context).colorScheme.primary,
                  size: 100.0,
                ),
              )
            : Obx(() {
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: CustomText(label: "Date")),
                          DataColumn(label: CustomText(label: "Name")),
                          DataColumn(label: CustomText(label: "Description")),
                          DataColumn(label: CustomText(label: "Quantity")),
                          DataColumn(label: CustomText(label: "Buying Price")),
                          DataColumn(label: CustomText(label: "Selling Price")),
                          DataColumn(label: CustomText(label: "")),
                          DataColumn(label: CustomText(label: "")),
                        ],
                        rows: stockDataList
                            .map((stockData) => DataRow(
                                  cells: [
                                    DataCell(Text(stockData.createdAt)),
                                    DataCell(Text(stockData.name)),
                                    DataCell(Text(stockData.description)),
                                    DataCell(
                                        Text(stockData.quantity.toString())),
                                    DataCell(
                                        Text(stockData.buyingPrice.toString())),
                                    DataCell(Text(
                                        stockData.sellingPrice.toString())),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _showUpdateDialog(
                                            context, stockData.name),
                                      ),
                                    ),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => _confirmDelete(
                                            context, stockData.name),
                                      ),
                                    ),
                                  ],
                                ))
                            .toList(),
                      ),
                    ),
                  ],
                );
              }));
  }

  void _showFormDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomText(
            label: "Add Stock",
            labelColor: secondaryColor,
          ),
          content: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CustomtextField(
                    label: "Product Name",
                    controller: _productNameController,
                  ),
                  const SizedBox(height: 20),
                  CustomtextField(
                    label: "Description",
                    controller: _descriptionController,
                  ),
                  const SizedBox(height: 20),
                  CustomtextField(
                    label: "Quantity",
                    controller: _quantityController,
                  ),
                  const SizedBox(height: 20),
                  CustomtextField(
                    label: "Minimum Quantity(Optional)",
                    controller: _minQuantityController,
                  ),
                  const SizedBox(height: 20),
                  CustomtextField(
                    label: "Buying Price",
                    controller: _priceController,
                  ),
                  const SizedBox(height: 20),
                  CustomtextField(
                    label: "Selling Price",
                    controller: _spriceController,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: CustomButton(
                      label: "Add",
                      action: () {
                        recordStock();
                        Navigator.pop(context);
                      },
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

  void _showUpdateDialog(BuildContext context, String productName) {
    _productNameController.text = productName;
    _descriptionController.text = '';
    _quantityController.text = '';
    _minQuantityController.text = '';
    _priceController.text = '';
    _spriceController.text = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Update Stock"),
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
                    label: "Description",
                    controller: _descriptionController,
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
                    label: "Minimum Quantity",
                    controller: _minQuantityController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomtextField(
                    label: "Buying Price",
                    controller: _priceController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CustomtextField(
                    label: "Selling Price",
                    controller: _spriceController,
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
                        Navigator.of(context).pop();
                        updateStock(productName);
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
          content:
              const Text("Are you sure you want to delete this stock item?"),
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
                deleteStock(name);
              },
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  Future<void> deleteStock(String productName) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/stock/delete_stock.php"),
        body: {
          'product_name': productName,
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse['success'] == true) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: "Stock Deleted Successfully.",
            onConfirm: () {
              fetchStock();
            },
          );
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Failed to delete Stock",
            middleText: "${serverResponse['message']}",
            onConfirm: () {
              fetchStock();
              Navigator.of(context).pop();
            },
          );
        }
      } else {
        throw Exception('Failed to delete stock');
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error deleting stock: $e');
    }
  }

  Future<void> recordStock() async {
    try {
      http.Response response;
      var body = {
        'product_name': _productNameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'quantity': _quantityController.text.trim(),
        'min_quantity': _minQuantityController.text.trim(),
        'buying_price': _priceController.text.trim(),
        'selling_price': _spriceController.text.trim(),
        'user_id': userId.toString(),
        'store_id': storeId.toString(),
      };
      response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/stock/record_stock.php"),
        body: body,
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        int registered = serverResponse['success'];
        if (registered == 1) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: "Stock has been recorded Successfully.",
            onConfirm: () {
              fetchStock();
              Navigator.of(context).pop();
            },
          );
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Failed to Record Stock.",
            middleText: "${serverResponse['message']}",
            onConfirm: () {
              fetchStock();
              Navigator.of(context).pop();
            },
          );
        }
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error Recording stock: $e');
    }
  }

  Future<void> updateStock(String productName) async {
    try {
      final response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/stock/update_stock.php"),
        body: {
          'product_name': productName,
          'description': _descriptionController.text.trim(),
          'quantity': _quantityController.text.trim(),
          'min_quantity': _minQuantityController.text.trim(),
          'buying_price': _priceController.text.trim(),
          'selling_price': _spriceController.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        if (serverResponse['success'] == true) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: "Stock Updated Successfully.",
            onConfirm: () {
              fetchStock();
            },
          );

          fetchStock();
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Failed to Update Stock.",
            middleText: "${serverResponse['message']}",
            onConfirm: () {
              fetchStock();
            },
          );
        }
      } else {
        throw Exception('Failed to update stock');
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Error updating stock: $e');
    }
  }
}
