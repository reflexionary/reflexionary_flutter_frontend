import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reflexionary_frontend/components/lottie_mirror_animation.dart';
import 'package:reflexionary_frontend/components/typewriter_text.dart';
import 'package:reflexionary_frontend/models/chat_models.dart';
import 'package:reflexionary_frontend/services/chat_history_service.dart';
import 'package:uuid/uuid.dart';

class TethysScreen extends StatefulWidget {
  final ChatSession? session;
  const TethysScreen({super.key, this.session});

  @override
  State<TethysScreen> createState() => _TethysScreenState();
}

class _TethysScreenState extends State<TethysScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  WebSocketChannel? _channel;
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
    _loadSessions();
    _connectWebSocket();
  }

  void _connectWebSocket() {
    _channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8000/ws/tethys'));
    _channel!.stream.listen(
      (data) {
        if (!mounted) return;
        final response = jsonDecode(data);
        final message = ChatMessage(
          text: response['content'],
          isUser: false,
          contentType: response['content_type'],
          language: response['language'],
        );
        setState(() {
          _currentSession.messages.add(message);
          _displayedMessages.add(message);
          _isThinking = false;
        });
        _saveAndRefresh();
        _scrollToBottom();
      },
      onError: (error) {
        setState(() {
          _displayedMessages.add(ChatMessage(
            text: 'Error: $error',
            isUser: false,
            contentType: 'text',
          ));
          _isThinking = false;
        });
      },
      onDone: () => _reconnectWebSocket(),
    );
  }

  void _reconnectWebSocket() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _connectWebSocket();
    });
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

    // Send prompt to backend
    _channel?.sink.add(jsonEncode({
      'prompt': text,
      'image': base64Image,
    }));

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
          SizedBox(width: 320, child: _buildHistoryPanel()),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: _buildChatView()),
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
      drawer: Drawer(child: _buildHistoryPanel()),
      body: _buildChatView(),
    );
  }

  Widget _buildHistoryPanel() {
    return Column(
      children: [
        const DrawerHeader(
          child: Text('Chat History', style: TextStyle(fontFamily: 'Runalto', fontSize: 24)),
        ),
        Expanded(
          child: _chatSessions.isEmpty
              ? const Center(child: Text('Feels empty here...', style: TextStyle(fontStyle: FontStyle.italic)))
              : ListView.builder(
                  itemCount: _chatSessions.length,
                  itemBuilder: (context, index) {
                    final session = _chatSessions[index];
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
                              await _historyService.saveChatSession(session);
                              await _loadSessions();
                            } else if (value == 'delete') {
                              await _historyService.deleteSession(session.id);
                              await _loadSessions();
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

  Widget _buildChatView() {
    return Column(
      children: [
        Expanded(
          child: _displayedMessages.isEmpty && !_isThinking
              ? const Center(child: Text('Ask me anything about your reflections!'))
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: _displayedMessages.length,
                  itemBuilder: (context, index) {
                    final message = _displayedMessages[index];
                    final isLastMessage = index == _displayedMessages.length - 1;
                    return _buildMessageBubble(message, isLastMessage: isLastMessage);
                  },
                ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: _isThinking ? const LottieMirrorAnimation() : const SizedBox.shrink(),
        ),
        _buildPromptInput(),
      ],
    );
  }

  Widget _buildPromptInput() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(30.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                  color: Theme.of(context).colorScheme.primary,
                ),
                if (_selectedImage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(
                      label: Text(_selectedImage!.name),
                      onDeleted: () => setState(() => _selectedImage = null),
                    ),
                  ),
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    decoration: const InputDecoration(
                      hintText: 'Enter a prompt...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: Icon(_isThinking ? Icons.hourglass_empty : Icons.send),
                  onPressed: _isThinking ? null : _sendMessage,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, {bool isLastMessage = false}) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      color: isUser
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
    );

    final bool animate = !isUser && isLastMessage && !_isThinking;

    Widget contentWidget;
    if (message.contentType == 'text') {
      contentWidget = animate
          ? TypewriterText(text: message.text, style: textStyle)
          : Text(message.text, style: textStyle);
    } else if (message.contentType == 'code') {
      contentWidget = HighlightView(
        message.text,
        language: message.language ?? 'plaintext',
        theme: Map<String, TextStyle>.from({
          'root': textStyle,
          'keyword': textStyle.copyWith(color: Colors.blue),
          'string': textStyle.copyWith(color: Colors.green),
          'comment': textStyle.copyWith(color: Colors.grey),
        }),
        padding: const EdgeInsets.all(8.0),
      );
    } else if (message.contentType == 'image') {
      contentWidget = message.imageBase64 != null
          ? Image.memory(
              base64Decode(message.imageBase64!),
              width: 200,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Text('Error loading image', style: textStyle),
            )
          : Text('No image data', style: textStyle);
    } else {
      contentWidget = Text('Unsupported content type', style: textStyle);
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isUser
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: contentWidget,
      ),
    );
  }

  @override
  void dispose() {
    _channel?.sink.close();
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}