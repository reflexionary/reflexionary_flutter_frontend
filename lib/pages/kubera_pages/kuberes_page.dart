import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/kubera_pages/quberes_screen.dart';

class KuberesScreen extends StatelessWidget{
  const KuberesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kubera'),
      ),
      body: QuberaScreen(),
    );
  }
}