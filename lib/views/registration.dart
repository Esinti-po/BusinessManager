import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/views/custombutton.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:BUSINESS_MANAGER/views/customtextfield.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  String? selectedAccountType;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                const Color.fromARGB(255, 3, 76, 105),
                const Color.fromARGB(255, 4, 120, 155),
                Theme.of(context).colorScheme.background,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  SizedBox(
                    height: height * 0.25,
                    child: const Padding(
                      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Sign Up",
                            style: TextStyle(color: appBlack, fontSize: 40),
                          ),
                          SizedBox(height: 20),
                          Text(
                            "Create Your Account",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    height: height * 0.75,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(60),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 0.0),
                      child: SingleChildScrollView(
                        child: SizedBox(
                          child: Column(
                            children: <Widget>[
                              const SizedBox(height: 20),
                              CustomtextField(
                                hint: "Enter your phone number",
                                icon: Icons.account_box_rounded,
                                label: "UserName",
                                controller: userNameController,
                              ),
                              const SizedBox(height: 20),
                              CustomtextField(
                                hint: "Enter your Email",
                                icon: Icons.email_rounded,
                                label: "Email",
                                controller: emailController,
                              ),
                              const SizedBox(height: 20),
                              CustomtextField(
                                hint: "Enter the Name of your Business",
                                icon: Icons.business,
                                label: "Business Name",
                                controller: businessNameController,
                              ),
                              const SizedBox(height: 20),
                              DropdownButtonFormField<String>(
                                dropdownColor:
                                    Theme.of(context).colorScheme.background,
                                focusColor:
                                    Theme.of(context).colorScheme.background,
                                value: selectedAccountType,
                                hint: const Text("Select Account Type"),
                                onChanged: (value) {
                                  setState(() {
                                    selectedAccountType = value;
                                  });
                                },
                                decoration: InputDecoration(
                                  fillColor:
                                      Theme.of(context).colorScheme.background,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  prefixIcon: const Icon(Icons.account_circle),
                                ),
                                items: ["Business Owner", "Sales Person"]
                                    .map<DropdownMenuItem<String>>(
                                      (String value) =>
                                          DropdownMenuItem<String>(
                                        value: value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: value == "Business Owner" ||
                                                    value == "Sales Person"
                                                ? Colors.grey.withOpacity(0.0)
                                                : null,
                                          ),
                                          child: Text(value),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                              const SizedBox(height: 20),
                              Obx(
                                () => CustomtextField(
                                  hint: "Enter your password",
                                  icon: Icons.lock,
                                  prefIcon: Icons.visibility,
                                  isPassword: true,
                                  isHidden: loginController.isHidden.value,
                                  label: "Password",
                                  controller: passwordController,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Obx(
                                () => CustomtextField(
                                  hint: "Enter your password",
                                  icon: Icons.lock,
                                  prefIcon: Icons.visibility,
                                  isPassword: true,
                                  isHidden: loginController.isHidden.value,
                                  label: "Confirm Password",
                                  controller: confirmPasswordController,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                    child: CustomText(
                                      label: "Already have an account?",
                                      fontSize: 14,
                                      labelColor: Theme.of(context)
                                          .colorScheme
                                          .onBackground,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => Get.offAllNamed("/login"),
                                    child: CustomText(
                                      label: "Login",
                                      fontSize: 14,
                                      labelColor: Theme.of(context)
                                          .colorScheme
                                          .secondary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Center(
                                child: SizedBox(
                                  width: 120,
                                  child: CustomButton(
                                    label: "Sign Up",
                                    action: () => serverRegistration(),
                                    buttonColor:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> serverRegistration() async {
    try {
      http.Response response;

      var body = {
        'username': userNameController.text.trim(),
        'email': emailController.text.trim(),
        'business_name': businessNameController.text.trim(),
        'role': selectedAccountType ?? '',
        'password': passwordController.text.trim(),
        'confirm_password': confirmPasswordController.text.trim(),
      };
      response = await http.post(
        Uri.parse(
            "https://technestsolutions.co.ke/business_manager/users/registration.php"),
        body: body,
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        int registered = serverResponse['success'];
        if (registered == 1) {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Account Created",
            middleText: "Your account has been successfully created.",
            onConfirm: () {
              Get.offNamed("/login");
            },
          );
          Get.offNamed("/login");
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: " Failed to Create Account ",
            middleText: serverResponse['message'],
          );
        }
      }
    } catch (e) {
      Get.defaultDialog(middleText: 'Network Error, please try again!');
    }
  }
}
