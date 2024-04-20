import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/utils/sharedpreference.dart';
import 'package:BUSINESS_MANAGER/views/custombutton.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:BUSINESS_MANAGER/views/customtextfield.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

MySharedPreferences myPres = MySharedPreferences();
final TextEditingController username = TextEditingController();
final TextEditingController password = TextEditingController();

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top +
            MediaQuery.of(context).padding.bottom);
    myPres.getValue("username").then((value) {
      username.text = value;
    });

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          const Color.fromARGB(255, 3, 76, 105),
          const Color.fromARGB(255, 4, 120, 155),
          Theme.of(context).colorScheme.background,
        ])),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Login",
                      style: TextStyle(
                        color: appWhite,
                        fontSize: 40,
                        shadows: [
                          Shadow(
                            color: Colors.black,
                            offset: Offset(5, 5),
                            blurRadius: 10.0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.background,
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(60))),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      const SizedBox(
                        height: 60,
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: const [
                              BoxShadow(
                                  color: Color.fromRGBO(16, 143, 216, 0.992),
                                  blurRadius: 20,
                                  offset: Offset(0, 10)),
                            ]),
                        height: 180,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 0.0),
                            child: SingleChildScrollView(
                              child: SizedBox(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CustomtextField(
                                      label: "UserName",
                                      hint: "Enter your phone number",
                                      icon: Icons.account_box_rounded,
                                      controller: username,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Obx(
                                      () => CustomtextField(
                                        label: "Password",
                                        hint: "Enter your password",
                                        icon: Icons.lock,
                                        prefIcon: Icons.visibility,
                                        isPassword: true,
                                        isHidden:
                                            loginController.isHidden.value,
                                        controller: password,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                              onTap: () => Get.offAndToNamed("/recover"),
                              child: const CustomText(
                                label: "Forgot Password?",
                                fontSize: 14,
                                labelColor: secondaryColor,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width / 3,
                          child: CustomButton(
                            label: "Login",
                            action: () => serverLogin(),
                            buttonColor: primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const CustomText(
                            label: "Don't Have an account?",
                            fontSize: 14,
                            labelColor: appGrey,
                          ),
                          GestureDetector(
                            onTap: () => Get.offAndToNamed("/registration"),
                            child: const CustomText(
                              label: "Sign Up",
                              fontSize: 14,
                              labelColor: secondaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> serverLogin() async {
    try {
      final url = Uri.parse(
          "https://technestsolutions.co.ke/business_manager/users/login.php");
      final response = await http.post(
        url,
        body: {
          'username': username.text.trim(),
          'password': password.text.trim(),
        },
      );

      if (response.statusCode == 200) {
        var serverResponse = json.decode(response.body);
        var loggedIn = serverResponse['success'];

        if (loggedIn == 1) {
          String role = serverResponse["role"];
          int userId = serverResponse['user_id'];
          myPres.getValue("Username").then((value) {
            username.text = value;
          });

          if (role == "Business Owner") {
            await Get.offAndToNamed("/home", arguments: userId);
          } else if (role == "Sales Person") {
            Get.offAndToNamed("/userHome", arguments: userId);
          } else {
            Get.defaultDialog(
              middleText: "Unknown role: $role",
            );
          }
        } else {
          Get.defaultDialog(
            buttonColor: primaryColor,
            title: "Unable to Log In",
            middleText: serverResponse['message'],
          );
        }
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      Get.defaultDialog(
        buttonColor: primaryColor,
        title: "Network Error",
        middleText: "Internet connection failed. Please try again later.",
      );
    }
  }
}
