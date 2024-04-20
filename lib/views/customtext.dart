import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final double fontSize;
  final FontWeight fontWeight;
  final bool mandatory;
  final bool centerText;

  const CustomText({
    super.key,
    required this.label,
    this.labelColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.mandatory = false,
    this.centerText = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color finalLabelColor =
        labelColor ?? Theme.of(context).colorScheme.primary;
    return SingleChildScrollView(
      child: Row(
        mainAxisAlignment:
            centerText ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
          mandatory
              ? Text(
                  "*",
                  style: TextStyle(
                    color: finalLabelColor,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
