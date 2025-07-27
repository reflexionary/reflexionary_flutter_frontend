import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/pages/login_page.dart';
import 'package:reflexionary_frontend/pages/main_page.dart';
import 'package:reflexionary_frontend/pages/appTheme/theme_provider.dart';
import 'package:reflexionary_frontend/providers/auth_provider.dart' as local_auth; // <-- Local AuthProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => local_auth.AuthProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Reflexionary',
      theme: themeProvider.currentTheme,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<local_auth.AuthProvider>(context);
    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (authProvider.loggedIn) {
      return const MainPage();
    } else {
      return LoginPage();
    }
  }
}
