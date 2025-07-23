import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'target_page.dart';

class AnimatedHome extends StatefulWidget {
  const AnimatedHome({super.key});

  @override
  State<AnimatedHome> createState() => _AnimatedHomeState();
}

class _AnimatedHomeState extends State<AnimatedHome> {
  final Random _random = Random();
  final List<Offset> _positions = List.generate(3, (_) => Offset.zero);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _randomizePositions();
    _startFloating();
  }

  void _startFloating() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _randomizePositions();
    });
  }

  void _randomizePositions() {
    setState(() {
      for (int i = 0; i < _positions.length; i++) {
        _positions[i] = Offset(
          50.0 + _random.nextDouble() * 250,
          100.0 + _random.nextDouble() * 400,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _navigateToPage(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TargetPage(index: index),
      ),
    );
  }

  Widget _buildFloatingButton(int index, Color color) {
    return AnimatedPositioned(
      duration: const Duration(seconds: 4),
      curve: Curves.easeInOut,
      left: _positions[index].dx,
      top: _positions[index].dy,
      child: GestureDetector(
        onTap: () => _navigateToPage(index),
        child: Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.5),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Center(
            child: Icon(Icons.explore, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F7),
      body: Stack(
        children: [
          const Center(
            child: Text(
              "Reflexionary Buttons 🧠✨",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          _buildFloatingButton(0, Colors.teal),
          _buildFloatingButton(1, Colors.amber),
          _buildFloatingButton(2, Colors.deepPurple),
        ],
      ),
    );
  }
}
