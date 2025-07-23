import 'package:flutter/material.dart';

class MoodChip extends StatelessWidget {
  final String label;
  final String emoji;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const MoodChip({
    super.key,
    required this.label,
    required this.emoji,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      avatar: Text(emoji),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: color.withOpacity(0.3),
      backgroundColor: color.withOpacity(0.15),
      shape: StadiumBorder(
        side: BorderSide(color: color),
      ),
      labelStyle: TextStyle(
        color: selected ? Colors.black : Colors.black87,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
