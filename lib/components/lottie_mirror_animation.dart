import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieMirrorAnimation extends StatelessWidget {
  const LottieMirrorAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final animation = Lottie.asset(
      'lib/assets/animations/space_purple.json', // Make sure it's added in pubspec.yaml
      repeat: true,
      fit: BoxFit.contain,
      height: 350,
    );
    
    // A decorative glow that only appears in dark mode to improve visibility.
    final backgroundGlow = isDarkMode
        ? Container(
            height: 350,
            width: 350,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.purple.withOpacity(0.25),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.7], // Center the glow
              ),
            ),
          )
        : const SizedBox.shrink();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            backgroundGlow,
            animation,
          ],
        ),
        const SizedBox(height: 10),
        //mirrored,
      ],
    );
  }
}
