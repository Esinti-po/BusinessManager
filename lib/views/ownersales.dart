import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/controllers/salescontroller.dart';
import 'package:BUSINESS_MANAGER/models/salesmodel.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

final SalesController salesController = Get.put(SalesController());

class OwnerSales extends StatefulWidget {
  const OwnerSales({super.key});

  @override
  State<OwnerSales> createState() => _OwnerSalesState();
}

class _OwnerSalesState extends State<OwnerSales> {
  bool isLoading = true;

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
          label: "Sales Records",
          fontSize: 26,
          labelColor: Theme.of(context).colorScheme.secondary,
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
                      ],
                      rows: salesDataList
                          .map((saleData) => DataRow(cells: [
                                DataCell(Text(saleData.date)),
                                DataCell(Text(saleData.name)),
                                DataCell(Text(saleData.quantity.toString())),
                                DataCell(Text(saleData.unitPrice.toString())),
                                DataCell(Text(saleData.totalPrice.toString())),
                                DataCell(Text(saleData.modeOfPayment)),
                              ]))
                          .toList(),
                    ),
                  ),
                ],
              );
            }),
    );
  }
}
