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

  Widget _buildFloatingButton(int index, Color color, String label) {
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
            color: color.withAlpha(80),
            border: Border.all(color: color, width: 2),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withAlpha(122),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ],
          ),
          child: Center(
            child: Text(label, style: TextStyle(shadows: [
              Shadow(
                color: Colors.black.withAlpha(122),
                offset: const Offset(1, 1),
                blurRadius: 2)
              ]),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle hoverUnderlineStyle = ButtonStyle(
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      textStyle: MaterialStateProperty.resolveWith<TextStyle>(
        (Set<MaterialState> states) {
          const baseStyle = TextStyle(fontFamily: 'Runalto', fontSize: 20);
          if (states.contains(MaterialState.hovered)) {
            return baseStyle.copyWith(
              decoration: TextDecoration.underline,
            );
          }
          return baseStyle;
        },
      ),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String img = isDark? 'lib/assets/images/wallpaper_lighthouse_dark.jpg' : 'lib/assets/images/wallpaper_lighthouse.jpg';

    return Scaffold(
      // backgroundColor: const Color(0xFFEEF2F7),
      appBar: AppBar(
        title: const Text('LightHouse', style: TextStyle(fontFamily: 'Runalto')),
      ),
      body: Stack(
        children: [
          // add image wallpaper for lighthouse
          Image.asset(
            img,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
            alignment: Alignment.center,
            opacity: const AlwaysStoppedAnimation(.50),
          ),

          // Journals text button
          Positioned(
            top: 50,
            left: 50,
            child: TextButton(
                onPressed: () {},
                style: hoverUnderlineStyle,
                child: const Text('Journals')),
          ),

          // Insights text button
          Positioned(
            top: 80,
            left: 70,
            child: TextButton(
                onPressed: () {},
                style: hoverUnderlineStyle,
                child: const Text('Insights')),
          ),

          // Patterns text button
          Positioned(
            top: 110,
            left: 90,
            child: TextButton(
                onPressed: () {},
                style: hoverUnderlineStyle,
                child: const Text('Patterns')),
          ),
        ],
      ),
    );
  }
}
