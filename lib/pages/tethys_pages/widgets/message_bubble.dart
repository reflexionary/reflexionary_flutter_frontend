import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_highlighter/flutter_highlighter.dart';
import 'package:reflexionary_frontend/components/typewriter_text.dart';
import 'package:reflexionary_frontend/models/chat_models.dart';

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLastMessage;
  final bool isThinking;

  const MessageBubble({
    super.key,
    required this.message,
    required this.isLastMessage,
    required this.isThinking,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final theme = Theme.of(context);
    final textStyle = TextStyle(
      color: isUser
          ? theme.colorScheme.onPrimaryContainer
          : theme.colorScheme.onSurfaceVariant,
    );

    final bool animate = !isUser && isLastMessage && !isThinking;

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
      contentWidget = message.text.isNotEmpty
          ? Image.memory(
              base64Decode(message.text),
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
              : Colors.grey[800], // Darker shade for AI responses
          border: Border.all(
            color: isUser
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurfaceVariant,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: contentWidget,
      ),
    );
  }
}