import 'package:flutter/material.dart';

class TargetPage extends StatelessWidget {
  final int index;
  const TargetPage({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Target Page ${index + 1}"),
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
          label: const Text("Go Back"),
        ),
      ),
    );
  }
}
