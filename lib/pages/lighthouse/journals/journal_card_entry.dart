import 'package:flutter/material.dart';

class JournalEntryCard extends StatelessWidget {
  final String title;
  final String dateTime;
  final String pnl;
  final Color pnlColor;
  final String mood;
  final String content;
  final List<String> tags;

  const JournalEntryCard({
    super.key,
    required this.title,
    required this.dateTime,
    required this.pnl,
    required this.pnlColor,
    required this.mood,
    required this.content,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.schedule, size: 16),
                const SizedBox(width: 6),
                Text(dateTime),
                const Spacer(),
                Text(
                  "P&L: $pnl",
                  style: TextStyle(color: pnlColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(content),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: tags
                  .map((tag) => Chip(label: Text(tag), backgroundColor: Colors.grey[200]))
                  .toList(),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: const [
                Icon(Icons.edit_note),
                SizedBox(width: 10),
                Icon(Icons.delete_outline),
              ],
            )
          ],
        ),
      ),
    );
  }
}
