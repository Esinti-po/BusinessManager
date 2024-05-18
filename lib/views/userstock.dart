import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/stockcontroller.dart';
import 'package:BUSINESS_MANAGER/models/userstockmodel.dart';
import 'package:BUSINESS_MANAGER/views/addtosales.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';

final StockController stockController = Get.put(StockController());

class UserStock extends StatefulWidget {
  final int userId;
  const UserStock({super.key, required this.userId});

  @override
  State<UserStock> createState() => _UserStockState();
}

class _UserStockState extends State<UserStock> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
    fetchStock();
  }

  Future<void> fetchStock() async {
    try {
      final response = await http.get(Uri.parse(
          'https://technestsolutions.co.ke/business_manager/stock/user_stock_display.php'));

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        var dataResponse = serverResponse['data'];
        var dataList =
            dataResponse.map((data) => UserStockModel.fromJson(data)).toList();
        stockController.updateDataList(dataList);
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      Get.defaultDialog(
          title: "Failed", middleText: 'Error fetching stock data: $e');
    } finally {
      // Set isLoading to false when data fetching completes (success or failure)
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showAddToSalesDialog(
    UserStockModel product,
  ) {
    showDialog(
      context: context,
      builder: (context) => AddToSalesDialog(
        product: product,
        userId: widget.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          label: "Stock",
          labelColor: secondaryColor,
          fontSize: 26,
        ),
        backgroundColor: primaryColor,
      ),
      body: isLoading
          ? Center(
              child: SpinKitSpinningLines(
                color: Theme.of(context).colorScheme.primary,
                size: 100.0,
              ),
            )
          : Obx(() {
              var stockDataList = stockController.dataList;
              return ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: CustomText(label: "Name")),
                        DataColumn(label: CustomText(label: "Description")),
                        DataColumn(label: CustomText(label: "Quantity")),
                        DataColumn(label: CustomText(label: "Price")),
                      ],
                      rows: stockDataList
                          .map((stockData) => DataRow(
                                cells: [
                                  DataCell(Text(stockData.name)),
                                  DataCell(Text(stockData.description)),
                                  DataCell(Text(stockData.quantity.toString())),
                                  DataCell(
                                      Text(stockData.sellingPrice.toString())),
                                ],
                                onLongPress: () {
                                  _showAddToSalesDialog(stockData);
                                },
                                onSelectChanged: (selected) {
                                  if (selected != null) {
                                    _showAddToSalesDialog(stockData);
                                  }
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ],
              );
            }),
    );
  }
}
