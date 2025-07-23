import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/components/custom_button.dart';
import 'package:reflexionary_frontend/components/my_textfield.dart';
import 'package:reflexionary_frontend/pages/appTheme/theme_provider.dart';
import 'package:reflexionary_frontend/pages/login_page.dart';
import 'package:reflexionary_frontend/pages/login_subPages/verify_password.dart';

class forget_password extends StatelessWidget {
  forget_password({super.key});

  final emailController = TextEditingController();
  final OTPController = TextEditingController();

  void verifyOTP() {}

  @override
  Widget build(BuildContext context) {
    final maxWidth = 600.0;
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final boxColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          double containerWidth = availableWidth > maxWidth
              ? maxWidth
              : availableWidth * 0.9;

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
                  const SizedBox(height: 80),

                  const Center(
                    child: Text(
                      'Reset Password',
                      style: TextStyle(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  const Center(
                    child: Text(
                      'Please enter your email address',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Email
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  CustomButton(
                    buttonData: "Send OTP",
                    onTap: () {
                      // Handle OTP sending here
                    },
                  ),

                  const SizedBox(height: 60),

                  const Center(
                    child: Text(
                      'Please enter the OTP',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  MyTextField(
                    controller: OTPController,
                    hintText: 'Enter OTP',
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  CustomButton(
                    buttonData: "Verify OTP",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => verifyPassword()),
                      );
                    },
                  ),

                  const SizedBox(height: 35),

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()),
                          );
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
        },
      ),
    );
  }
}
