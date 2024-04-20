import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/models/userstockmodel.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';

class AddToSalesDialog extends StatefulWidget {
  final UserStockModel product;
  final int userId;

  const AddToSalesDialog(
      {super.key, required this.product, required this.userId});

  @override
  _AddToSalesDialogState createState() => _AddToSalesDialogState();
}

class _AddToSalesDialogState extends State<AddToSalesDialog> {
  int _quantitySold = 0;
  String _modeOfPayment = 'Mpesa';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const CustomText(
        label: 'Add to Sales',
        labelColor: secondaryColor,
        centerText: true,
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(label: 'Product: ${widget.product.name}'),
            CustomText(
                label: 'Price: Ksh${widget.product.sellingPrice.toString()}'),
            CustomText(label: 'Quantity in Stock: ${widget.product.quantity}'),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Quantity Sold'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter quantity';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _quantitySold = int.tryParse(value) ?? 0;
                });
              },
            ),
            const SizedBox(height: 16),
            const CustomText(
              label: 'Mode of Payment',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            RadioListTile<String>(
              title: const CustomText(label: 'Cash'),
              value: 'Cash',
              groupValue: _modeOfPayment,
              onChanged: (value) {
                setState(() {
                  _modeOfPayment = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: const CustomText(label: 'Mpesa'),
              value: 'Mpesa',
              groupValue: _modeOfPayment,
              onChanged: (value) {
                setState(() {
                  _modeOfPayment = value!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            if (_quantitySold > 0) {
              recordSales();
              Navigator.of(context).pop();
            } else {
              Get.defaultDialog(
                title: 'Invalid Quantity',
                middleText: 'Please enter a valid quantity',
                buttonColor: primaryColor,
              );
            }
          },
          child: const CustomText(label: 'Add to Sales'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const CustomText(label: 'Cancel', labelColor: Colors.red),
        ),
      ],
    );
  }

  Future<void> recordSales() async {
    try {
      var quantity = _quantitySold.toDouble();
      var unitPrice = widget.product.sellingPrice;
      var totalPrice = quantity * unitPrice;

      var body = {
        'name': widget.product.name,
        'quantity': quantity.toString(),
        'unit_price': unitPrice.toString(),
        'total_price': totalPrice.toString(),
        'mode_of_payment': _modeOfPayment,
        'user_id': widget.userId.toString(),
      };

      final response = await http.post(
        Uri.parse(
            'https://technestsolutions.co.ke/business_manager/sales/record_sales.php'),
        body: body,
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        bool registered = serverResponse['success'] ?? false;
        if (registered) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            middleText: 'Sale recorded successfully.',
          );
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: 'Failed to record sale.',
            middleText: 'Server error: ${serverResponse['message']}',
          );
        }
      } else {
        throw Exception(
            'Failed to communicate with the server. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      Get.defaultDialog(
        buttonColor: primaryColor,
        middleText: 'Error recording sales: $e',
      );
    }
  }
}
