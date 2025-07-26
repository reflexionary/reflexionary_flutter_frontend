import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:reflexionary_frontend/models/chat_models.dart';
import 'package:reflexionary_frontend/services/chat_history_service.dart';
import 'package:reflexionary_frontend/pages/tethys_pages/widgets/chat_view.dart';
import 'package:reflexionary_frontend/pages/tethys_pages/widgets/history_panel.dart';
import 'package:reflexionary_frontend/pages/tethys_pages/widgets/prompt_input.dart';

class TethysScreen extends StatefulWidget {
  final ChatSession? session;
  const TethysScreen({super.key, this.session});

  @override
  State<TethysScreen> createState() => _TethysScreenState();
}

class _TethysScreenState extends State<TethysScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isThinking = false;

  late ChatSession _currentSession;
  final ChatHistoryService _historyService = ChatHistoryService();
  List<ChatSession> _chatSessions = [];
  final List<ChatMessage> _displayedMessages = [];
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _currentSession = widget.session ??
        ChatSession(id: 'new_chat', title: 'New Chat', createdAt: DateTime.now(), messages: []);

    if (widget.session != null) {
      _loadMessagesWithAnimation();
    }
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await dotenv.load(fileName: 'lib/assets/.env');
      if (kDebugMode) {
        print('dotenv loaded: ${dotenv.env}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading .env: $e');
      }
    }
    await _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await _historyService.loadChatSessions();
    setState(() => _chatSessions = sessions);
  }

  Future<void> _saveAndRefresh() async {
    await _historyService.saveChatSession(_currentSession);
    await _loadSessions();
  }

  Future<void> _sendMessage() async {
    final text = _promptController.text.trim();
    if (text.isEmpty && _selectedImage == null) return;

    FocusScope.of(context).unfocus();
    _promptController.clear();

    String? base64Image;
    if (_selectedImage != null) {
      final bytes = await _selectedImage!.readAsBytes();
      base64Image = base64Encode(bytes);
    }

    final userMessage = ChatMessage(
      text: text,
      isUser: true,
      contentType: 'text',
      imageBase64: base64Image,
    );

    if (_currentSession.id == 'new_chat') {
      _currentSession = ChatSession(
        id: const Uuid().v4(),
        title: text.length > 30 ? '${text.substring(0, 30)}...' : text.isEmpty ? 'Image Chat' : text,
        createdAt: DateTime.now(),
        messages: [userMessage],
      );
      setState(() {
        _displayedMessages.add(userMessage);
        _chatSessions.insert(0, _currentSession);
      });
    } else {
      setState(() {
        _currentSession.messages.add(userMessage);
        _displayedMessages.add(userMessage);
      });
    }

    setState(() => _isThinking = true);
    _scrollToBottom();

    try {
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      if (kDebugMode) {
        print('API Key: $apiKey');
      }
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('GEMINI_API_KEY not set in .env file');
      }

      final uri = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-pro:generateContent?key=$apiKey');
      final headers = {'Content-Type': 'application/json'};
      final body = jsonEncode({
        'contents': [
          {
            'parts': [
              if (text.isNotEmpty) {'text': text},
              if (base64Image != null) {
                'inlineData': {
                  'mimeType': 'image/jpeg',
                  'data': base64Image,
                },
              },
            ],
          },
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'responseSchema': {
            'type': 'object',
            'properties': {
              'content_type': {'type': 'string', 'enum': ['text', 'code', 'image']},
              'content': {'type': 'string'},
              'language': {'type': 'string', 'nullable': true},
            },
            'required': ['content_type', 'content'],
          },
        },
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final content = jsonDecode(responseData['candidates'][0]['content']['parts'][0]['text']);
        final aiMessage = ChatMessage(
          text: content['content'],
          isUser: false,
          contentType: content['content_type'],
          language: content['language'],
        );
        setState(() {
          _currentSession.messages.add(aiMessage);
          _displayedMessages.add(aiMessage);
          _isThinking = false;
        });
      } else {
        throw Exception('API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      setState(() {
        _displayedMessages.add(ChatMessage(
          text: 'Error: $e',
          isUser: false,
          contentType: 'text',
        ));
        _isThinking = false;
      });
    }

    await _saveAndRefresh();
    _scrollToBottom();
    setState(() => _selectedImage = null);
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _loadMessagesWithAnimation() async {
    for (final message in _currentSession.messages) {
      await Future.delayed(const Duration(milliseconds: 50));
      if (!mounted) return;
      setState(() => _displayedMessages.add(message));
      _scrollToBottom();
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && mounted) {
      setState(() => _selectedImage = pickedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth > 720 ? _buildWideLayout() : _buildNarrowLayout();
      },
    );
  }

  Widget _buildWideLayout() {
    return Scaffold(
      appBar: AppBar(
        leading: Navigator.canPop(context) ? const BackButton() : null,
        title: Text(_currentSession.title, style: const TextStyle(fontFamily: 'Runalto')),
        actions: [
          IconButton(
            tooltip: 'New Chat',
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const TethysScreen()),
              );
            },
          ),
        ],
      ),
      body: Row(
        children: [
          SizedBox(
            width: 320,
            child: HistoryPanel(
              chatSessions: _chatSessions,
              historyService: _historyService,
              onSessionsUpdated: _loadSessions,
            ),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: ChatView(
                    displayedMessages: _displayedMessages,
                    isThinking: _isThinking,
                    scrollController: _scrollController,
                  ),
                ),
                PromptInput(
                  promptController: _promptController,
                  isThinking: _isThinking,
                  onSend: _sendMessage,
                  onPickImage: _pickImage,
                  selectedImage: _selectedImage,
                  onClearImage: () => setState(() => _selectedImage = null),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNarrowLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentSession.title, style: const TextStyle(fontFamily: 'Runalto')),
        actions: [
          IconButton(
            tooltip: 'New Chat',
            icon: const Icon(Icons.add_comment_outlined),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const TethysScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: HistoryPanel(
          chatSessions: _chatSessions,
          historyService: _historyService,
          onSessionsUpdated: _loadSessions,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ChatView(
              displayedMessages: _displayedMessages,
              isThinking: _isThinking,
              scrollController: _scrollController,
            ),
          ),
          PromptInput(
            promptController: _promptController,
            isThinking: _isThinking,
            onSend: _sendMessage,
            onPickImage: _pickImage,
            selectedImage: _selectedImage,
            onClearImage: () => setState(() => _selectedImage = null),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}