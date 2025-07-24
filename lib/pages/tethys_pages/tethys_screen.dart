import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/lottie_mirror_animation.dart';
import 'package:reflexionary_frontend/components/typewriter_text.dart';

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}

class TethysScreen extends StatefulWidget {
  const TethysScreen({super.key});

  @override
  State<TethysScreen> createState() => _TethysScreenState();
}

class _TethysScreenState extends State<TethysScreen> {
  final TextEditingController _promptController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isThinking = false;

  void _sendMessage() async {
    final text = _promptController.text.trim();
    if (text.isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus(); // Hide keyboard
    _promptController.clear();

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isThinking = true;
    });
    _scrollToBottom();

    // Simulate a 6-second delay for the backend response.
    await Future.delayed(const Duration(seconds: 6));

    if (mounted) {
      const aiResponse =
          'Tethys, in Greek mythology, was a Titan goddess of the primal font of fresh water which nourishes the earth. She was the wife of her brother, the Titan-god of the river Oceanus. In this context, I am your source for drawing insights from the vast ocean of your own reflections.';
      setState(() {
        _messages.add(ChatMessage(text: aiResponse, isUser: false));
        _isThinking = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    // A short delay ensures the list has been built before we scroll.
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tethys', style: TextStyle(fontFamily: 'Runalto')),
      ),
      body: Column(
        children: [
          Expanded(
            child: _messages.isEmpty
                ? const Center(
                    child: Text('Ask me anything about your reflections!'),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      final message = _messages[index];
                      final isLastMessage = index == _messages.length - 1;
                      return _buildMessageBubble(message,
                          isLastMessage: isLastMessage);
                    },
                  ),
          ),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: _isThinking
                ? const LottieMirrorAnimation()
                : const SizedBox.shrink(),
          ),
          _buildPromptInput(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, {bool isLastMessage = false}) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    final textStyle = TextStyle(
        color: isUser
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant);

    // Animate only the most recent AI response after the "thinking" is done.
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
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: animate
            ? TypewriterText(text: message.text, style: textStyle)
            : Text(message.text, style: textStyle),
      ),
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
}