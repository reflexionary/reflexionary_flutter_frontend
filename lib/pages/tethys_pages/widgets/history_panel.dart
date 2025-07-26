import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/models/chat_models.dart';
import 'package:reflexionary_frontend/pages/tethys_pages/tethys_screen.dart';
import 'package:reflexionary_frontend/services/chat_history_service.dart';

class HistoryPanel extends StatelessWidget {
  final List<ChatSession> chatSessions;
  final ChatHistoryService historyService;
  final VoidCallback onSessionsUpdated;

  const HistoryPanel({
    super.key,
    required this.chatSessions,
    required this.historyService,
    required this.onSessionsUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const DrawerHeader(
          child: Text('Chat History', style: TextStyle(fontFamily: 'Runalto', fontSize: 24)),
        ),
        Expanded(
          child: chatSessions.isEmpty
              ? const Center(child: Text('Feels empty here...', style: TextStyle(fontStyle: FontStyle.italic)))
              : ListView.builder(
                  itemCount: chatSessions.length,
                  itemBuilder: (context, index) {
                    final session = chatSessions[index];
                    return PopupMenuTheme(
                      data: PopupMenuTheme.of(context).copyWith(position: PopupMenuPosition.under),
                      child: ListTile(
                        leading: session.isFavourite
                            ? const Icon(Icons.star, color: Colors.amber)
                            : const Icon(Icons.chat_bubble_outline),
                        title: Text(session.title, overflow: TextOverflow.ellipsis),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) async {
                            if (value == 'favourite') {
                              session.isFavourite = !session.isFavourite;
                              await historyService.saveChatSession(session);
                              onSessionsUpdated();
                            } else if (value == 'delete') {
                              await historyService.deleteSession(session.id);
                              onSessionsUpdated();
                            } else if (value == 'export') {
                              // Add export logic here
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'favourite',
                              child: Text(session.isFavourite
                                  ? 'Unmark as favourite'
                                  : 'Mark as favourite'),
                            ),
                            const PopupMenuItem(value: 'export', child: Text('Export Chat')),
                            const PopupMenuItem(value: 'delete', child: Text('Delete')),
                          ],
                        ),
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => TethysScreen(session: session),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}