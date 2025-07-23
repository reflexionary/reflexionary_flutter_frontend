import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/lighthouse/insights/insights_screen.dart';
import 'package:reflexionary_frontend/pages/lighthouse/journals/journals_screen.dart';
import 'package:reflexionary_frontend/pages/lighthouse/patterns_screen.dart';

class TargetPage extends StatelessWidget {
  final int index;
  const TargetPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return switch(index) {
      0 => const JournalsScreen(),
      1 => const InsightsScreen(),
      2 => const PatternsScreen(),
      _ => throw Exception(),
    };
  }
}
