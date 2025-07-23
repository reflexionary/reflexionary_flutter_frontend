import 'package:reflexionary_frontend/components/custom_button.dart';
import 'package:reflexionary_frontend/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/my_textfield.dart';

class Register extends StatelessWidget {
  Register({super.key});

  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final namecontroller = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // REGISTER
              const Text(
                'Register',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 38,
                    fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 25),

              // name textfield
              MyTextField(
                controller: namecontroller,
                hintText: 'Name',
                obscureText: false,
              ),

              const SizedBox(height: 10),

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

              // confirm password textfield
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'confirm password',
                obscureText: false,
              ),

              const SizedBox(height: 25),

              // register button
              CustomButton(
                buttonData: "Register",
                onTap: () {
                  // Handle the registration here

                  //Navigate the user to Login
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => LoginPage()));
                },
              ),

              const SizedBox(
                height: 50,
              ),

              // already a member? sign in
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: () {
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
      ),
    );
  }
}
