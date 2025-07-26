// main.dart

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/pages/appTheme/theme_provider.dart';
import 'package:reflexionary_frontend/providers/auth_provider.dart'; // <-- Import AuthProvider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()), // <-- Add AuthProvider
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
      home: MainPage(),
    );
  }
}
