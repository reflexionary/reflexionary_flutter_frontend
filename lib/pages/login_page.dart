import 'package:reflexionary_frontend/models/shared_preferences/shared_preference_model.dart';
import 'package:reflexionary_frontend/pages/login_subPages//forget_password.dart';

import 'package:reflexionary_frontend/pages/login_subPages//register.dart';
import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/custom_button.dart';
import 'package:reflexionary_frontend/components/my_textfield.dart';
import 'package:reflexionary_frontend/pages/main_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // sign user in method
  void signUserIn(BuildContext context) {
    // check the password

    //then navigate the user to home screen
  }

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
            const SizedBox(height: 110),

            // Christ logo
            //Image.asset('lib/images/christ_logo.jpg', height: 80, width: 250),

            const SizedBox(height: 40),

            // LOGIN
            const Center(
              child: Text(
                'LOGIN',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 38,
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

            const SizedBox(height: 10),

            // password textfield
            MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: true,
            ),

            const SizedBox(height: 10),

            // forgot password?
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigate user to change password page
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              forget_password()));
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // sign in button
            CustomButton(
              onTap: () {
                //Check for correct password

                // Set userLogin sharedPref to true
                SharedPreferenceModel().setUserLoginStatus(true);

                //Navigate the user to major screen
                Navigator.of(context).popUntil(
                  // prevent user to enter login page again after a successful session
                  (route) => route.isFirst,
                );
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => const MainPage()));
              },
              buttonData: "Sign in",
            ),

            const SizedBox(height: 75),

            // not a member? register now
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Not a member?',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(width: 4),
                GestureDetector(
                  onTap: () {
                    // Navigate the user to registration page
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (BuildContext context) => Register()));
                  },
                  child: const Text(
                    'Register now',
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
        )
      ),
    );
  }
}
