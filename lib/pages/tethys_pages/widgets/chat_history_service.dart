import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:reflexionary_frontend/models/chat_models.dart';

class ChatHistoryService {
  static const String _sessionsKey = 'chat_sessions';

  Future<List<ChatSession>> loadChatSessions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessionsJson = prefs.getString(_sessionsKey);
      if (sessionsJson == null) {
        return [];
      }
      final List<dynamic> sessionsList = jsonDecode(sessionsJson);
      return sessionsList.map((json) => ChatSession.fromJson(json)).toList();
    } catch (e) {
      print('Error loading chat sessions: $e');
      return [];
    }
  }

  Future<void> saveChatSession(ChatSession session) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessions = await loadChatSessions();
      final existingIndex = sessions.indexWhere((s) => s.id == session.id);
      if (existingIndex != -1) {
        sessions[existingIndex] = session;
      } else {
        sessions.add(session);
      }
      final sessionsJson = jsonEncode(sessions.map((s) => s.toJson()).toList());
      await prefs.setString(_sessionsKey, sessionsJson);
    } catch (e) {
      print('Error saving chat session: $e');
    }
  }

  Future<void> deleteSession(String sessionId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sessions = await loadChatSessions();
      sessions.removeWhere((s) => s.id == sessionId);
      final sessionsJson = jsonEncode(sessions.map((s) => s.toJson()).toList());
      await prefs.setString(_sessionsKey, sessionsJson);
    } catch (e) {
      print('Error deleting chat session: $e');
    }
  }
}