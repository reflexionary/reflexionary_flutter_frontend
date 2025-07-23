import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reflexionary_frontend/pages/lighthouse/journals/journal_card_entry.dart';
import 'package:reflexionary_frontend/pages/lighthouse/journals/mood_chips.dart';

class JournalsPage extends StatefulWidget {
  const JournalsPage({super.key});

  @override
  State<JournalsPage> createState() => JournalsPageState();
}

class JournalsPageState extends State<JournalsPage> {
  String? selectedMood;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final moods = [
            {'label': 'Joyful', 'emoji': '😊', 'color': Colors.amber},
            {'label': 'Calm', 'emoji': '😌', 'color': Colors.blueAccent},
            {'label': 'Neutral', 'emoji': '😐', 'color': Colors.grey},
            {'label': 'Anxious', 'emoji': '😰', 'color': Colors.orange},
            {'label': 'Sad', 'emoji': '😢', 'color': Colors.indigo},
            {'label': 'Angry', 'emoji': '😡', 'color': Colors.red},
            {'label': 'Focused', 'emoji': '⚡', 'color': Colors.green},
    ];
    
    

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints){
          final isWide = constraints.maxWidth > 900;

          return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
              maxWidth: isWide ? constraints.maxWidth * 0.65 : double.infinity,
            ),

            // rest of the UI
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.bookmark_outline_rounded, size: 40),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "My Journal",
                        style: GoogleFonts.nunitoSans(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Capture your thoughts, emotions, and trading reflections.",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // New Entry Card
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("New Entry",
                          style: theme.textTheme.headlineSmall),
                      const SizedBox(height: 12),
                      TextFormField(
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText:
                              "What moved you today? Reflect on your trades, emotions, and insights...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: moods.map((mood){
                          return MoodChip(
                            label: mood['label'] as String,
                            emoji: mood['emoji'] as String,
                            color: mood['color'] as Color,
                            selected: selectedMood == mood['label'],
                            onTap: () {
                              setState(() {
                                selectedMood = mood['label'] as String;
                              });
                            },
                          );
                        }).toList()),
                        
                      
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "Add tags (e.g. FOMO, Disciplined)",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.add),
                            label: const Text("Add Tag"),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Fluttertoast.showToast(msg: "Entry saved!", toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM); // NOT WORKING ON WEB
                        },
                        icon: const Icon(Icons.send),
                        label: const Text("Save Entry"),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(48),
                          backgroundColor: Colors.teal[200],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),
              const Text(
                "Past Entries",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              const JournalEntryCard(
                title: "Productive Trading Day",
                dateTime: "2024-07-28 at 16:30",
                pnl: "+\$150.25",
                pnlColor: Colors.green,
                mood: "Focused",
                content:
                    "Felt really in the zone today. Executed my plan well...",
                tags: ["Discipline", "BTC", "Scalp"],
              ),

              const JournalEntryCard(
                title: "Missed Opportunity",
                dateTime: "2024-07-27 at 10:15",
                pnl: "-\$50.00",
                pnlColor: Colors.red,
                mood: "Anxious",
                content:
                    "Hesitated on a setup and missed a good entry. Feeling frustrated...",
                tags: ["Hesitation", "ETH", "Swing"],
              ),
            ],
          ),
            ),
          )
        );
        })
      ),
    );
  }
}