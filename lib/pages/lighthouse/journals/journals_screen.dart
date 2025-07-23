import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/lighthouse/journals/journals_page.dart';

class JournalsScreen extends StatelessWidget{
  const JournalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journals'),
      ),
      body: JournalsPage(),
    );
  }
}