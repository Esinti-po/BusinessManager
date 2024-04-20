import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/controllers/logincontroller.dart';
import 'package:get/get.dart';

LoginController loginController = Get.put(LoginController());

class CustomtextField extends StatelessWidget {
  final String? hint;
  final IconData? icon;
  final IconData? prefIcon;
  final bool isPassword;
  final bool isHidden;
  final TextEditingController? controller;
  final String? label;

  const CustomtextField({
    super.key,
    this.hint,
    this.icon,
    this.prefIcon,
    this.isPassword = false,
    this.isHidden = false,
    this.controller,
    this.label,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? (isHidden ? true : false) : false,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? GestureDetector(
                child: Obx(() => Icon(
                      loginController.isHidden.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    )),
                onTap: () => loginController.toggleHide(),
              )
            : const SizedBox(),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintStyle: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.background,
      ),
    );
  }
}
