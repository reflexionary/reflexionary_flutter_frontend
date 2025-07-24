import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TethisScreen extends StatefulWidget {
  const TethisScreen({super.key});

  @override
  State<TethisScreen> createState() => _TethysScreenState();
}

class _TethysScreenState extends State<TethisScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  List<Map<String, dynamic>> chatHistory = [];
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
  }

  Future<void> _loadChatHistory() async {
    prefs = await SharedPreferences.getInstance();
    final String? savedChat = prefs.getString('tethys_chat_history');
    if (savedChat != null) {
      setState(() {
        chatHistory = List<Map<String, dynamic>>.from(json.decode(savedChat));
      });
    }
  }

  Future<void> _saveChatHistory() async {
    await prefs.setString('tethys_chat_history', json.encode(chatHistory));
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      chatHistory.add({"role": "user", "message": text});
      chatHistory.add({"role": "assistant", "message": _generateResponse(text)});
    });
    _controller.clear();
    _saveChatHistory();
    Future.delayed(Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  String _generateResponse(String input) {
    // Replace with your AI logic or API call
    return "Echo: $input";
  }

  Widget _buildChatMessage(Map<String, dynamic> message) {
    final isUser = message['role'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: isUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message['message'],
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildSidePanel() {
    return Container(
      width: 250,
      color: Colors.grey[100],
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tethys Conversations",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: chatHistory.length ~/ 2,
              itemBuilder: (context, index) {
                final userMessage = chatHistory[index * 2]['message'];
                return ListTile(
                  title: Text(
                    userMessage.length > 25 ? userMessage.substring(0, 25) + '...' : userMessage,
                    style: const TextStyle(fontSize: 14),
                  ),
                  onTap: () {
                    // Scroll to message if needed
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          _buildSidePanel(),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: chatHistory.length,
                    itemBuilder: (context, index) {
                      return _buildChatMessage(chatHistory[index]);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: const InputDecoration(
                            hintText: "Ask anything...",
                            border: OutlineInputBorder(),
                          ),
                          onSubmitted: _sendMessage,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _sendMessage(_controller.text),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
