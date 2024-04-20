import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/theme/theme.dart';
import 'package:BUSINESS_MANAGER/theme/themeprovider.dart';
import 'package:BUSINESS_MANAGER/utils/routes.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ThemeProvider themeProvider = ThemeProvider();
  await themeProvider.loadThemeMode();

  runApp(ChangeNotifierProvider.value(
    value: themeProvider,
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: Builder(
        builder: (context) {
          return GetMaterialApp(
            theme: Provider.of<ThemeProvider>(context).getTheme(),
            darkTheme: darkMode,
            themeMode: Provider.of<ThemeProvider>(context).getThemeMode(),
            initialRoute: "/login",
            getPages: Routes.routes,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
