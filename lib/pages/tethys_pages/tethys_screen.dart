import 'package:flutter/material.dart';
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
  bool _isThinking = false;

  late ChatSession _currentSession;
  final ChatHistoryService _historyService = ChatHistoryService();
  List<ChatSession> _chatSessions = [];

  final List<ChatMessage> _displayedMessages = [];

  @override
  void initState() {
    super.initState();
    _currentSession = widget.session ??
        ChatSession(id: 'new_chat', title: 'New Chat', createdAt: DateTime.now(), messages: []);

    if (widget.session != null) {
      _loadMessagesWithAnimation();
    }
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final sessions = await _historyService.loadChatSessions();
    setState(() => _chatSessions = sessions);
  }

  Future<void> _saveAndRefresh() async {
    await _historyService.saveChatSession(_currentSession);
    await _loadSessions();
  }

  void _sendMessage() async {
    final text = _promptController.text.trim();
    if (text.isEmpty) return;

    FocusScope.of(context).unfocus();
    _promptController.clear();

    if (_currentSession.id == 'new_chat') {
      _currentSession = ChatSession(
        id: const Uuid().v4(),
        title: text.length > 30 ? '${text.substring(0, 30)}...' : text,
        createdAt: DateTime.now(),
        messages: [ChatMessage(text: text, isUser: true)],
      );
      setState(() {
        _displayedMessages.add(_currentSession.messages.first);
        _chatSessions.insert(0, _currentSession); // Add new session to history
      });
    } else {
      setState(() {
        _currentSession.messages.add(ChatMessage(text: text, isUser: true));
        _displayedMessages.add(_currentSession.messages.last);
      });
    }

    setState(() => _isThinking = true);
    _scrollToBottom();

    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      const aiResponse = 'Here’s a Tethys insight for your journey 🌊';
      setState(() {
        final aiMessage = ChatMessage(text: aiResponse, isUser: false);
        _currentSession.messages.add(aiMessage);
        _displayedMessages.add(aiMessage);
        _isThinking = false;
      });
      await _saveAndRefresh();
      _scrollToBottom();
    }
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
                              // Add your export logic here
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
              : theme.colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: animate
            ? TypewriterText(text: message.text, style: textStyle)
            : Text(message.text, style: textStyle),
      ),
    );
  }
}