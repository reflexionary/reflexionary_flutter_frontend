import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class ThinkingAnimation extends StatefulWidget {
  const ThinkingAnimation({super.key});

  @override
  State<ThinkingAnimation> createState() => _ThinkingAnimationState();
}

class _ThinkingAnimationState extends State<ThinkingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(200, 200),
          painter: _GoogleSpherePainter(_controller.value),
        );
      },
    );
  }
}

class _GoogleSpherePainter extends CustomPainter {
  final double progress; // The animation progress from 0.0 to 1.0
  final List<Color> colors = const [
    Color(0xFF4285F4), // Blue
    Color(0xFFDB4437), // Red
    Color(0xFFF4B400), // Yellow
    Color(0xFF0F9D58), // Green
    Color(0xFF4285F4), // Blue
    Color(0xFFDB4437), // Red
    Color(0xFFF4B400), // Yellow
    Color(0xFF0F9D58), // Green
  ];

  _GoogleSpherePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final orbitRadius = size.width / 2.5;
    const particleMaxRadius = 12.0;
    const particleMinRadius = 4.0;

    final particles = <_ParticleInfo>[];

    for (int i = 0; i < colors.length; i++) {
      // Calculate angles for spherical coordinates to make particles orbit
      final theta = 2 * pi * progress * (1.0 + i * 0.3) + i * pi;
      final phi = pi / 2 + sin(2 * pi * progress * 1.5 + i * pi / 2) * (pi / 4);

      // Convert spherical to 3D Cartesian coordinates
      final x = orbitRadius * sin(phi) * cos(theta);
      final y = orbitRadius * sin(phi) * sin(theta);
      final z = orbitRadius * cos(phi);

      // Project 3D point to 2D canvas
      final displayPosition = Offset(center.dx + x, center.dy + y);

      // Normalize z-index to control size and opacity (from -orbitRadius to +orbitRadius -> 0 to 1)
      final zNormalized = (z + orbitRadius) / (2 * orbitRadius);
      final radius = lerpDouble(particleMinRadius, particleMaxRadius, zNormalized)!;
      final opacity = lerpDouble(0.3, 1.0, zNormalized)!;

      particles.add(_ParticleInfo(
        position: displayPosition,
        radius: radius,
        color: colors[i].withOpacity(opacity),
        zIndex: z,
      ));
    }

    // Sort particles by z-index to draw them from back to front, creating a 3D effect
    particles.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    // Draw each particle
    for (final particle in particles) {
      final paint = Paint()..color = particle.color;
      canvas.drawCircle(particle.position, particle.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// A helper class to store particle data for sorting and drawing
class _ParticleInfo {
  final Offset position;
  final double radius;
  final Color color;
  final double zIndex;

  _ParticleInfo({
    required this.position,
    required this.radius,
    required this.color,
    required this.zIndex,
  });
}