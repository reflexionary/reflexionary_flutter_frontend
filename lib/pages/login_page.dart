import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/components/custom_button.dart';
import 'package:reflexionary_frontend/components/my_textfield.dart';
import 'package:reflexionary_frontend/models/shared_preferences/shared_preference_model.dart';
import 'package:reflexionary_frontend/pages/appTheme/theme_provider.dart';
import 'package:reflexionary_frontend/pages/login_subPages/forget_password.dart';
import 'package:reflexionary_frontend/pages/login_subPages/register.dart';
import 'package:reflexionary_frontend/pages/main_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void signUserIn(BuildContext context) {
    // Auth logic placeholder
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = 600.0; // max content width
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final boxColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double availableWidth = constraints.maxWidth;
          double containerWidth = availableWidth > maxWidth
              ? maxWidth
              : availableWidth * 0.9; // use 90% of screen on small screens

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
                  const SizedBox(height: 110),
                  const Text(
                    'LOGIN',
                    style: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 25),

                  // Email
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    obscureText: false,
                  ),
                  const SizedBox(height: 10),

                  // Password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),

                  // Forgot password?
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => forget_password()));
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),

                  // Sign in
                  CustomButton(
                    onTap: () {
                      SharedPreferenceModel().setUserLoginStatus(true);

                      Navigator.of(context).popUntil((route) => route.isFirst);
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const MainPage()),
                      );
                    },
                    buttonData: "Sign in",
                  ),

                  const SizedBox(height: 75),

                  // Register now
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Not a member?', style: TextStyle(color: Colors.grey[700])),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Register()));
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