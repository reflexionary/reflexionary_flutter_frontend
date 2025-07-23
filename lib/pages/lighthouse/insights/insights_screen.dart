import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/lighthouse/insights/insights_page.dart';

class InsightsScreen extends StatelessWidget{
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
      ),
      body: InsightsPage()
    );
  }

}