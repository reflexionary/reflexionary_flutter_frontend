import 'package:flutter/material.dart';

class AnimatedGradientBox extends StatefulWidget {
  final Widget child;
  final double borderRadius;

  const AnimatedGradientBox({
    super.key,
    required this.child,
    this.borderRadius = 20.0,
  });

  @override
  State<AnimatedGradientBox> createState() => _AnimatedGradientBoxState();
}

class _AnimatedGradientBoxState extends State<AnimatedGradientBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 8))
          ..repeat(reverse: true);
    _animation = CurvedAnimation(parent: _controller, curve: Curves.linear);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> getGradientColors(ColorScheme colorScheme, double value) {
    final colors = [
      colorScheme.primary,
      colorScheme.secondary,
      colorScheme.tertiary, // fallback for web
    ];

    final index = (value * (colors.length - 1)).floor();
    final nextIndex = (index + 1) % colors.length;
    final t = value * (colors.length - 1) - index;

    return [
      Color.lerp(colors[index], colors[nextIndex], t)!,
      Color.lerp(colors[nextIndex], colors[(nextIndex + 1) % colors.length], t)!,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) {
        final gradientColors = getGradientColors(colorScheme, _animation.value);
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: colorScheme.onSurface.withAlpha(102),
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          ),
          child: widget.child,
        );
      },
    );
  }
}
