// This class contains the theme accent color of the app
import 'package:flutter/material.dart';

class ThemeClass {
  final Color primaryAccent = const Color.fromARGB(255, 14, 203, 51);
  final Color secondaryAccent = const Color.fromARGB(255, 4, 56, 15);

  // Additional pastel colors
  final Color pastelGreen = const Color(0xFFB2D8B2);
  final Color mintGreen = const Color(0xFF98FF98);
  final Color lightGreen = const Color(0xFFCCFFCC);
  final Color paleGreen = const Color(0xFF98FB98);
  final Color pastelPurple = const Color(0xFFDABFFF);
  final Color pastelBlue = const Color(0xFFAEC6CF);
  final Color pastelPink = const Color(0xFFF4C2C2);
  final Color peach = const Color(0xFFFFDAB9);
  final Color primary = const Color(0xFF8EACCD);
  final Color secondary = const Color(0xFF8EACCD);
  final Color darkMaroon = const Color(0xFF3D0F1A); // Dark maroon
  final Color offWhite = const Color(0xFFF9F3CC); // Off white

  final List<Color> pastelColors = [
    const Color(0xFFF4C2C2), // Pastel Pink
    const Color(0xFFDABFFF), // Pastel Purple
    const Color(0xFFAEC6CF), // Pastel Blue
    const Color(0xFFB2D8B2), // Pastel Green
    // Add more colors as needed
  ];

  // custom pastel colors
  final Color cremeGreen = const Color.fromARGB(255, 228, 253, 225);
  final Color fernGreen = const Color.fromARGB(255, 83, 123, 47);
  final Color broccoli = const Color.fromARGB(255, 20, 138, 57);
  final Color tealGreen = const Color.fromARGB(255, 14, 103, 85);
  final Color grasshopper = const Color.fromARGB(255, 74, 104, 30);
  final Color shamRock = const Color.fromARGB(255, 3, 120, 63);
  final Color jadeGreen = const Color.fromARGB(255, 29, 169, 108);
  final Color lawnGreen = const Color.fromARGB(255, 111, 182, 42);

  late TextStyle headStyle = TextStyle(
      color: primaryAccent,
      fontWeight: FontWeight.w600,
      fontSize: 35,
      fontFamily: 'leagueSpartanBold');

  late TextStyle contentStyle = TextStyle(
      color: secondaryAccent,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      fontFamily: 'IBMPlexSansBold');
}
