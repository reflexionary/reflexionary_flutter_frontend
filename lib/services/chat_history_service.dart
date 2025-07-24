import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:reflexionary_frontend/models/chat_models.dart';

class ChatHistoryService {
  static const _fileName = 'chat_history.json';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$_fileName');
  }

  Future<List<ChatSession>> loadChatSessions() async {
    try {
      final file = await _localFile;
      if (!await file.exists()) {
        return [];
      }
      final contents = await file.readAsString();
      if (contents.isEmpty) {
        return [];
      }
      final List<dynamic> jsonList = json.decode(contents);
      return jsonList.map((json) => ChatSession.fromJson(json)).toList();
    } catch (e) {
      // In a real app, you might want to log this error
      return [];
    }
  }

  Future<void> saveChatSession(ChatSession session) async {
    final sessions = await loadChatSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index != -1) {
      sessions[index] = session;
    } else {
      sessions.insert(0, session); // Add new chats to the top
    }
    final file = await _localFile;
    await file.writeAsString(json.encode(sessions.map((s) => s.toJson()).toList()));
  }

  Future<void> deleteSession(String sessionId) async {
    final sessions = await loadChatSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    final file = await _localFile;
    await file.writeAsString(json.encode(sessions.map((s) => s.toJson()).toList()));
  }
}