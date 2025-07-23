import 'package:flutter/material.dart';

class JournalsScreen extends StatelessWidget{
  const JournalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journals'),
      ),
      body: const Center(
        child: Text('Journals Screen'),
      ),
    );
  }
}