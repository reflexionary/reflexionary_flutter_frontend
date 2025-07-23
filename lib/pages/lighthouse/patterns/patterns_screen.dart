import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/lighthouse/patterns/patterns_page.dart';

class PatternsScreen extends  StatelessWidget{
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patterns'),
      ),
      body: PatternsPage()
    );
  }

}