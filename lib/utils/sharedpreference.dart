import 'package:BUSINESS_MANAGER/models/usermodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences {
  Future<void> writeValue(key, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  Future<String> getValue(key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? '';
  }

  Future<void> storeUserDataInSharedPreferences(UserModel userData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Save user data to shared preferences
    // await prefs.setString('userName', userData.name);
    await prefs.setInt('userId', userData.userId);
    await prefs.setString('businessName', userData.businessName);
  }
}

class ThemePreferences {
  static const String themeModeKey = 'themeMode';

  Future<ThemeMode> getThemeMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int themeModeValue = prefs.getInt(themeModeKey) ?? 0;
    return ThemeMode.values[themeModeValue];
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(themeModeKey, themeMode.index);
  }
}
