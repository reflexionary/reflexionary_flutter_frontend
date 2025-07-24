import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieMirrorAnimation extends StatelessWidget {
  const LottieMirrorAnimation({super.key});

  @override
  Widget build(BuildContext context) {
    final animation = Lottie.asset(
      'lib/assets/animations/space_purple.json', // Make sure it's added in pubspec.yaml
      repeat: true,
      fit: BoxFit.contain,
      height: 350,
    );

    final mirrored = Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationX(pi),
      child: Opacity(
        opacity: 0.3,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: animation,
          ),
        ),
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        animation,
        const SizedBox(height: 10),
        mirrored,
      ],
    );
  }
}
