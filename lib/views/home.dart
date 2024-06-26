import 'package:flutter/material.dart';
import 'package:ff_navigation_bar_plus/ff_navigation_bar_plus.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/controllers/homecontroller.dart';
import 'package:BUSINESS_MANAGER/views/dashboard.dart';
import 'package:BUSINESS_MANAGER/views/ownerexpenses.dart';
import 'package:BUSINESS_MANAGER/views/ownersales.dart';
import 'package:BUSINESS_MANAGER/views/stock.dart';
import 'package:get/get.dart';

HomeController homeController = Get.put(HomeController());

class Home extends StatefulWidget {
  final int userId;
  final int storeId;

  const Home({super.key, required this.userId, required this.storeId});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      const DashBoard(),
      const OwnerSales(),
      const OwnerExpenses(),
      Stock(
        userId: widget.userId,
        storeId: widget.storeId,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Center(
          child: screens[homeController.selectedPage.value],
        ),
      ),
      bottomNavigationBar: FFNavigationBar(
        theme: FFNavigationBarTheme(
          barBackgroundColor: Theme.of(context).colorScheme.primary,
          selectedItemBackgroundColor: Theme.of(context).colorScheme.background,
          selectedItemIconColor: Theme.of(context).colorScheme.secondary,
          selectedItemLabelColor: Theme.of(context).colorScheme.secondary,
          unselectedItemIconColor: appWhite,
          unselectedItemLabelColor: appBlack,
          selectedItemBorderColor: Theme.of(context).colorScheme.primary,
        ),
        selectedIndex: selectedIndex,
        onSelectTab: (index) {
          setState(() {
            selectedIndex = index;
            homeController.updateSelectedPage(index);
          });
        },
        items: [
          FFNavigationBarItem(
            iconData: Icons.house,
            label: 'Home',
          ),
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
