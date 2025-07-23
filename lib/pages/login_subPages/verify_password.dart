import 'package:reflexionary_frontend/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/custom_button.dart';
import 'package:reflexionary_frontend/components/my_textfield.dart';

// ignore: camel_case_types
class verifyPassword extends StatelessWidget {
  verifyPassword({super.key});

  // text editing controllers
  final passwordController = TextEditingController();
  final conformPasswordController = TextEditingController();

  // send OTP method
  void sendOTP() {}

  // sign user in method
  void verifyOTP() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(12),
          
            ),
            padding: EdgeInsets.all(15),
          width: MediaQuery.sizeOf(context).width * 0.4,
          child: Column(
          mainAxisSize: MainAxisSize.min,
            children: [
              // Reset password
              const Text(
                'Enter new Password',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              // Enter new password textfield
              MyTextField(
                controller: passwordController,
                hintText: 'password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // Re-enter new textfield
              MyTextField(
                controller: conformPasswordController,
                hintText: 'confirm password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              CustomButton(
                  buttonData: "Create password",
                  onTap: () {
                    // Handle password update here

                    // Then navigate the user to login screen
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
