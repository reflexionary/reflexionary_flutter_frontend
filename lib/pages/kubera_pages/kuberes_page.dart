import 'package:flutter/material.dart';

class KuberesScreen extends StatelessWidget{
  const KuberesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kubera'),
      ),
      body: const Center(
        child: Text('Welcome to Kubera!'),
      ),
    );
  }

}