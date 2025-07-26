import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/pages/lighthouse/insights/insights_screen.dart';
import 'package:reflexionary_frontend/pages/lighthouse/journals/journals_screen.dart';
import 'package:reflexionary_frontend/pages/lighthouse/patterns/patterns_screen.dart';

class AnimatedHome extends StatefulWidget {
  const AnimatedHome({super.key});

  @override
  State<AnimatedHome> createState() => _AnimatedHomeState();
}

class _AnimatedHomeState extends State<AnimatedHome> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle hoverUnderlineStyle = ButtonStyle(
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      textStyle: WidgetStateProperty.resolveWith<TextStyle>(
        (Set<WidgetState> states) {
          const baseStyle = TextStyle(fontFamily: 'Runalto', fontSize: 20);
          if (states.contains(WidgetState.hovered)) {
            return baseStyle.copyWith(
              decoration: TextDecoration.underline,
            );
          }
          return baseStyle;
        },
      ),
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String img = isDark
        ? 'lib/assets/images/wallpaper_darkMode.png'
        : 'lib/assets/images/wallpaper_lighthouse.jpg';

    return Scaffold(
      // Make the AppBar transparent to see the image behind it
      appBar: AppBar(
        title: const Text('LightHouse', style: TextStyle(fontFamily: 'Runalto')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: isDark? Color.fromARGB(255, 0, 0, 0) : Colors.white,
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset(
              img,
              fit: BoxFit.fitHeight,
              height: double.infinity, 
              opacity: isDark? const AlwaysStoppedAnimation(0.3) : const AlwaysStoppedAnimation(.50),
            ),
          ),

          // Journals text button
          Positioned(
            top: 100, 
            left: 50,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const JournalsScreen()));
                },
                style: hoverUnderlineStyle,
                child: const Text('Journals')),
          ),

          // Insights text button
          Positioned(
            top: 130, // Adjusted top padding
            left: 70,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const InsightsScreen()));
                },
                style: hoverUnderlineStyle,
                child: const Text('Insights')),
          ),

          // Patterns text button
          Positioned(
            top: 160, // Adjusted top padding
            left: 90,
            child: TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PatternsScreen()));
                },
                style: hoverUnderlineStyle,
                child: const Text('Patterns')),
          ),
        ],
      ),
    );
  }
}
