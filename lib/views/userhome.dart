import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/usercontroller.dart';
import 'package:BUSINESS_MANAGER/views/expenses.dart';
import 'package:BUSINESS_MANAGER/views/sales.dart';
import 'package:BUSINESS_MANAGER/views/userstock.dart';
import 'package:get/get.dart';

var screens = [
  const Sales(),
  const Expenses(),
  const UserStock(),
];

final UserController userController = Get.put(UserController());

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Center(
          child: screens[userController.selectedPage.value],
        ),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemBackgroundColor: Theme.of(context).colorScheme.background,
          selectedItemIconColor: Theme.of(context).colorScheme.secondary,
          selectedItemLabelColor: appBlack,
          unselectedItemIconColor: appWhite,
          unselectedItemLabelColor: appBlack,
          selectedItemBorderColor: Theme.of(context).colorScheme.primary,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
            userController.updateSelectedPage(index);
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.local_grocery_store,
            label: 'Sales',
          ),
          FFNavigationBarItem(
            iconData: Icons.money_off_outlined,
            label: 'Expenses',
          ),
          FFNavigationBarItem(
            iconData: Icons.monetization_on,
            label: 'Stock',
          ),
        ],
      ),
    );
  }
}
