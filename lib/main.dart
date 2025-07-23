import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/main_page.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/pages/appTheme/theme_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => ThemeProvider(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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