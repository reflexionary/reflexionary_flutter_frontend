import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reflexionary_frontend/pages/appTheme/theme_provider.dart';

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
    final isDark = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDark ? (selected ? Colors.white : Colors.white70) : (selected ? Colors.black : Colors.black87);

    return ChoiceChip(
      avatar: Text(emoji),
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
      selectedColor: color.withAlpha((0.3 * 255).round()),
      backgroundColor: color.withAlpha((0.15 * 255).round()),
      shape: StadiumBorder(
        side: BorderSide(color: color),
      ),
      labelStyle: TextStyle(
        color: textColor,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
    );
  }
}
