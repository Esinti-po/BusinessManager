import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/usercontroller.dart';
import 'package:BUSINESS_MANAGER/views/expenses.dart';
import 'package:BUSINESS_MANAGER/views/sales.dart';
import 'package:BUSINESS_MANAGER/views/userstock.dart';
import 'package:get/get.dart';

final UserController userController = Get.put(UserController());

class UserHome extends StatefulWidget {
  final int userId;
  final int storeId;

  const UserHome({super.key, required this.userId, required this.storeId});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  int selectedIndex = 0;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      Sales(userId: widget.userId),
      Expenses(userId: widget.userId),
      UserStock(userId: widget.userId),
    ];
  }

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
