import 'dart:ui';
import 'package:flutter/material.dart';

class GlassMorphicBox extends StatelessWidget {
  final Widget child;
  final double blur;
  final double borderRadius;
  final double opacity;
  final Color borderColor;

  const GlassMorphicBox({
    super.key,
    required this.child,
    this.blur = 15.0,
    this.borderRadius = 12.0,
    this.opacity = 0.2,
    this.borderColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withAlpha((opacity * 255).round()), // Semi-glass white
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor.withAlpha(102),
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
