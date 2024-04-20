import 'package:flutter/material.dart';
import 'package:BUSINESS_MANAGER/views/custombutton.dart';
import 'package:BUSINESS_MANAGER/views/customtext.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _businessNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: CustomText(
          label: "Profile",
          labelColor: Theme.of(context).colorScheme.secondary,
          fontSize: 26,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.secondary,
              child: const Icon(
                Icons.person,
                size: 100,
              ),
            ),
            const SizedBox(height: 10),
            const CustomText(
              label: "USERNAME NAME",
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 20),
            buildDetailRow("Email:", _emailController.text),
            const SizedBox(
              height: 20,
            ),
            buildDetailRow("Phone:", _phoneController.text),
            const SizedBox(
              height: 20,
            ),
            buildDetailRow("Bussines Name:", _businessNameController.text),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: CustomButton(
                label: "Edit Profile",
                buttonColor: Theme.of(context).colorScheme.primary,
                action: () {
                  _showEditProfileDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomText(
          label: label,
          fontSize: 16,
        ),
        CustomText(
          label: value,
          fontSize: 16,
        ),
      ],
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    TextEditingController newEmailController = TextEditingController();
    TextEditingController newPhoneController = TextEditingController();
    TextEditingController newBusinessNameController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const CustomText(
            label: 'Edit Profile',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: newEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newPhoneController,
                  decoration: const InputDecoration(
                    labelText: 'Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: newBusinessNameController,
                  decoration: const InputDecoration(
                    labelText: 'Business Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const CustomText(
                label: 'Cancel',
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const SizedBox(
                width: 100,
                child: CustomText(
                  label: 'Save',
                  centerText: true,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> displayUserInfo() async {}
}
