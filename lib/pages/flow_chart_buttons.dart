// Add this to your Flutter project to render Tethys, Lighthouse, Qubera buttons with dotted connector paths like the image you shared.

import 'package:flutter/material.dart';
import 'package:dotted_line/dotted_line.dart';

class FlowChartButtons extends StatelessWidget {
  final VoidCallback onTethysTap;
  final VoidCallback onLighthouseTap;
  final VoidCallback onQuberaTap;

  const FlowChartButtons({
    super.key,
    required this.onTethysTap,
    required this.onLighthouseTap,
    required this.onQuberaTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 350,
      height: 350,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Tethys - Top center
          Positioned(
            top: 20,
            left: 100,
            child: Column(
              children: [
                _pageButton(onTethysTap, 'Tethys', theme),
                const SizedBox(height: 5),
                const DottedLine(direction: Axis.vertical, lineLength: 40, dashColor: Colors.grey),
              ],
            ),
          ),

          // Lighthouse - Top right
          Positioned(
            top: 90,
            right: 0,
            child: Column(
              children: [
                _pageButton(onLighthouseTap, 'Lighthouse', theme),
                const SizedBox(height: 5),
                const DottedLine(direction: Axis.vertical, lineLength: 70, dashColor: Colors.grey),
              ],
            ),
          ),

          // Connector from Tethys to Qubera
          Positioned(
            top: 100,
            left: 120,
            child: Transform.rotate(
              angle: -0.8,
              child: const DottedLine(direction: Axis.horizontal, lineLength: 80, dashColor: Colors.grey),
            ),
          ),

          // Qubera - Bottom left
          Positioned(
            bottom: 30,
            left: 0,
            child: _pageButton(onQuberaTap, 'Qubera', theme),
          ),
        ],
      ),
    );
  }

  Widget _pageButton(VoidCallback onTap, String label, ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        backgroundColor: theme.colorScheme.primary.withAlpha(25),
        foregroundColor: isDark ? Colors.white : Colors.black,
        side: BorderSide(color: theme.colorScheme.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
      child: Text(label,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
