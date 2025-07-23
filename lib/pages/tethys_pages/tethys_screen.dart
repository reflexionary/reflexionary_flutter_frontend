import 'package:flutter/material.dart';

class TethysScreen extends StatelessWidget{
  const TethysScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kubera'),
      ),
      body: const Center(
        child: Text('Welcome to Tethys!'),
      ),
    );
  }

}