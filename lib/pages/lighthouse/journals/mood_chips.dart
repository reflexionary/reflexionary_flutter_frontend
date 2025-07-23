import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;

  const MoodChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Text(emoji),
      label: Text(label),
      backgroundColor: color.withOpacity(0.15),
      shape: StadiumBorder(
        side: BorderSide(color: color),
      ),
    );
  }
}
