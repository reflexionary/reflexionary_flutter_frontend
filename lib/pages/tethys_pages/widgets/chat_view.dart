import 'package:flutter/material.dart';
import 'package:reflexionary_frontend/components/lottie_mirror_animation.dart';
import 'package:reflexionary_frontend/models/chat_models.dart';
import 'package:reflexionary_frontend/pages/tethys_pages/widgets/message_bubble.dart';

class ChatView extends StatelessWidget {
  final List<ChatMessage> displayedMessages;
  final bool isThinking;
  final ScrollController scrollController;

  const ChatView({
    super.key,
    required this.displayedMessages,
    required this.isThinking,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: displayedMessages.isEmpty && !isThinking
              ? const Center(child: Text('Ask me anything about your reflections!'))
              : ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: displayedMessages.length,
                  itemBuilder: (context, index) {
                    final message = displayedMessages[index];
                    final isLastMessage = index == displayedMessages.length - 1;
                    return MessageBubble(
                      message: message,
                      isLastMessage: isLastMessage,
                      isThinking: isThinking,
                    );
                  },
                ),
        ),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
          child: isThinking ? const LottieMirrorAnimation() : const SizedBox.shrink(),
        ),
      ],
    );
  }
}