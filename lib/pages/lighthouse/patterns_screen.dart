import 'package:flutter/material.dart';

class PatternsScreen extends  StatelessWidget{
  const PatternsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patterns'),
      ),
      body: const Center(
        child: Text('Patterns Screen'),
      ),
    );
  }

}