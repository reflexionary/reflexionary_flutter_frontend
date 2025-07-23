import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/components/custom_button.dart';
import 'package:reflexionary_frontend/components/my_textfield.dart';
import 'package:reflexionary_frontend/pages/appTheme/theme_provider.dart';
import 'package:reflexionary_frontend/pages/login_page.dart';

// ignore: camel_case_types
class verifyPassword extends StatelessWidget {
  verifyPassword({super.key});

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final maxWidth = 600.0;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final boxColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = constraints.maxWidth;
          double containerWidth =
              screenWidth > maxWidth ? maxWidth : screenWidth * 0.9;

          return Center(
            child: Container(
              width: containerWidth,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: boxColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Enter New Password',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 25),

                  MyTextField(
                    controller: passwordController,
                    hintText: 'New Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  MyTextField(
                    controller: confirmPasswordController,
                    hintText: 'Confirm Password',
                    obscureText: true,
                  ),

                  const SizedBox(height: 20),

                  CustomButton(
                    buttonData: "Create Password",
                    onTap: () {
                      // Do your password checking logic here

                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
