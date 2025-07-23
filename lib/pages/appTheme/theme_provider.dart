import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get currentTheme => _isDarkMode ? darkTheme : lightTheme;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  ThemeData get lightTheme => ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF9F6),
        fontFamily: 'Casanova',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Runalto', fontSize: 40),
          bodyMedium: TextStyle(fontFamily: 'Casanova'),
        ),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFAEC6CF), // primaryAccent
          secondary: Color(0xFFF7CAC9), // secondaryAccent
          surface: Color(0xFFFAF9F6), // background
        ),
      );

  ThemeData get darkTheme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1C),
        fontFamily: 'Casanova',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Runalto', fontSize: 40, color: Colors.white),
          bodyMedium: TextStyle(fontFamily: 'Casanova', color: Colors.white),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFAEC6CF), // primaryAccent
          secondary: Color(0xFFF7CAC9), // secondaryAccent
          surface: Color(0xFF121212),
        ),
      );
}
