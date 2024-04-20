import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback? action;
  final Color? buttonColor;
  final double? width;
  const CustomButton({
    super.key,
    required this.label,
    this.action,
    this.buttonColor = primaryColor,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: action,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        child: CustomText(
          label: label,
          centerText: true,
          labelColor: appBlack,
        ));
  }
}
