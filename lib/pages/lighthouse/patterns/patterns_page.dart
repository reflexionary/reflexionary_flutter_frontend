import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class Pattern {
  final String id;
  final String name;
  final String sequence;
  final String type;
  final String insights;

  Pattern({
    required this.id,
    required this.name,
    required this.sequence,
    required this.type,
    required this.insights,
  });
}

final samplePatterns = [
  Pattern(
    id: '1',
    name: "Overconfidence Loop",
    sequence:
        "Successful Trade → Increased Confidence → Larger Position Size → Risky Trade → Loss → Frustration",
    type: "Caution",
    insights:
        "High confidence after wins may lead to abandoning risk management rules.",
  ),
  Pattern(
    id: '2',
    name: "FOMO Cycle",
    sequence:
        "Market Rally → Fear of Missing Out → Impulsive Entry → Poor Setup → Loss → Regret",
    type: "Warning",
    insights:
        "Chasing price movements without proper analysis is a recurring issue.",
  ),
  Pattern(
    id: '3',
    name: "Hesitation Trap",
    sequence:
        "Identified Good Setup → Hesitation/Doubt → Missed Entry → Frustration → Forcing a Later, Suboptimal Trade",
    type: "Caution",
    insights:
        "Lack of conviction at key moments leads to missed opportunities and subsequent poor decisions.",
  ),
  Pattern(
    id: '4',
    name: "Positive Reinforcement",
    sequence:
        "Sticking to Plan → Disciplined Execution → Profitable Outcome → Calm Satisfaction",
    type: "Positive",
    insights:
        "Following your trading plan consistently yields positive emotional and financial results.",
  ),
];

class PatternsPage extends StatefulWidget {
  const PatternsPage({super.key});

  @override
  State<PatternsPage> createState() => _PatternsScreenState();
}

class _PatternsScreenState extends State<PatternsPage> {
  List<Pattern> detectedPatterns = samplePatterns;
  bool isLoading = false;

  void fetchPatterns() async {
    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 2)); // simulate loading

    Fluttertoast.showToast(msg: "Patterns Updated: ${detectedPatterns.length} detected.");

    setState(() => isLoading = false);
  }

  Color getTypeColor(String type) {
    switch (type) {
      case 'Caution':
        return Colors.amber.shade100;
      case 'Warning':
        return Colors.red.shade100;
      case 'Positive':
        return Colors.green.shade100;
      default:
        return Colors.grey.shade200;
    }
  }

  IconData getTypeIcon(String type) {
    switch (type) {
      case 'Caution':
        return LucideIcons.triangleAlert;
      case 'Warning':
        return LucideIcons.zap;
      case 'Positive':
        return LucideIcons.lightbulb;
      default:
        return LucideIcons.workflow;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final containerWidth = width > 900 ? width * 0.65 : width * 0.9;

    return Center(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: containerWidth,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(LucideIcons.workflow, size: 32),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text("Behavioral Patterns", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,)),
                      Text("Understand recurring emotional and behavioral loops in your trading.", style: TextStyle(color: Colors.grey))
                    ],
                  )
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: isLoading ? null : fetchPatterns,
                icon: isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(LucideIcons.zap),
                label: Text(isLoading ? "Analyzing Patterns..." : "Run AI Pattern Detection"),
              ),
              const SizedBox(height: 24),
              if (detectedPatterns.isEmpty && !isLoading)
                const Center(
                  child: Text(
                    "No Patterns Detected Yet. Click the button above to analyze.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ...detectedPatterns.asMap().entries.map((entry) {
                final index = entry.key;
                final pattern = entry.value;
                final icon = getTypeIcon(pattern.type);
                final bgColor = getTypeColor(pattern.type);

                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: bgColor.withOpacity(0.5), width: 1.5),
                  ),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(icon, color: Colors.black54),
                        title: Text(pattern.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                        subtitle: Text("${pattern.type} Pattern", style: const TextStyle(color: Colors.grey),),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Sequence:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 8),
                            Wrap(
                              children: pattern.sequence
                                  .split('→')
                                  .map((step) => Padding(
                                        padding: const EdgeInsets.only(right: 6.0),
                                        child: Text(step.trim(), style: const TextStyle(fontSize: 14, color: Colors.grey)),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 12),
                            const Text("Insights:", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                            const SizedBox(height: 6),
                            Text(pattern.insights, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              })
            ],
          ),
        ),
      )
    );
  }
}
