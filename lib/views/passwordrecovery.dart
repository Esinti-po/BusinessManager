import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/configs/constants.dart';
import 'package:BUSINESS_MANAGER/views/custombutton.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';
import 'package:BUSINESS_MANAGER/views/customtextfield.dart';
import 'package:get/get.dart';

class PasswordRecoverScreen extends StatefulWidget {
  const PasswordRecoverScreen({super.key});

  @override
  State<PasswordRecoverScreen> createState() => _PasswordRecoverScreenState();
}

class _PasswordRecoverScreenState extends State<PasswordRecoverScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const CustomText(
            label: "Password Recovery",
            labelColor: secondaryColor,
            fontSize: 20,
          ),
          backgroundColor: primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              const CustomText(label: "Verification will be sent to Email "),
              const CustomText(label: "Under this userName"),
              const SizedBox(
                height: 10,
              ),
              const CustomtextField(
                icon: Icons.email,
                label: "Username",
                hint: "Enter Your Username",
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: SizedBox(
                  width: 125,
                  child: CustomButton(
                    label: "SEND ",
                    action: () {
                      Navigator.pop(context);
                    },
                    buttonColor: primaryColor,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Get.offAndToNamed("/login"),
                child: const CustomText(
                  label: "Go to Login",
                  fontSize: 14,
                  labelColor: secondaryColor,
                ),
              ),
            ],
          ),
        ));
  }
}
