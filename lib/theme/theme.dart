import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';

ThemeData lightMode = ThemeData(
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      background: Colors.white,
      primary: primaryColor,
      secondary: secondaryColor,
    ));
ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.grey.shade600,
    primary: primaryColor,
    secondary: const Color.fromARGB(255, 204, 125, 6),
  ),
);
