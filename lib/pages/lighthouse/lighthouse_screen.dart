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
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const JournalsScreen()));
                },
                style: hoverUnderlineStyle,
                child: const Text('Journals')),
          ),

          // Insights text button
          Positioned(
            top: 80,
            left: 70,
            child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const InsightsScreen()));
                },
                style: hoverUnderlineStyle,
                child: const Text('Insights')),
          ),

          // Patterns text button
          Positioned(
            top: 110,
            left: 90,
            child: TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const PatternsScreen()));
                },
                style: hoverUnderlineStyle,
                child: const Text('Patterns')),
          ),
        ],
      ),
    );
  }
}
