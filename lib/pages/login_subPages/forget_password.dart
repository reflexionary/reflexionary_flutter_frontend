import 'package:reflexionary_frontend/components/custom_button.dart';
import 'package:reflexionary_frontend/pages/login_page.dart';
import 'package:reflexionary_frontend/pages/login_subPages/verify_password.dart';
import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/my_textfield.dart';

// ignore: camel_case_types
class forget_password extends StatelessWidget {
  forget_password({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  // ignore: non_constant_identifier_names
  final OTPController = TextEditingController();

  // sign user in method
  void verifyOTP() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            const SizedBox(height: 80),

            // Reset password
            const Center(
              child: Text(
                'Reset Password',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 40),

            // LOGIN
            const Center(
              child: Text(
                'Please enter your email address',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 25),

            // emailID textfield
            MyTextField(
              controller: emailController,
              hintText: 'Email',
              obscureText: false,
            ),

            const SizedBox(
              height: 10,
            ),

            // send OTP button
            CustomButton(
                buttonData: "Send OTP",
                onTap: () {
                  // Handle the sending OTP here
                }),

            const SizedBox(height: 60),

            // enter OTP
            const Center(
              child: Text(
                'Please enter the OTP',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            // enter OTP textfield
            MyTextField(
              controller: OTPController,
              hintText: 'enter OTP',
              obscureText: false,
            ),

            const SizedBox(height: 10),

            // verify OTP
            CustomButton(
                buttonData: "Verify OTP",
                onTap: () {
                  // Handle the OTP verification here

                  // Then navigate the user to enter new password page
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => verifyPassword()));
                }),

            const SizedBox(height: 35),

            // Sign in
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Go to login?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    // Take the user back to login page
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => LoginPage()));
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
