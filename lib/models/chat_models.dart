class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
    );
  }
}

class ChatSession {
  final String id;
  String title;
  final DateTime createdAt;
  bool isFavourite;
  List<ChatMessage> messages;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.messages,
    this.isFavourite = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
        'isFavourite': isFavourite,
        'messages': messages.map((m) => m.toJson()).toList(),
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) {
    return ChatSession(
      id: json['id'] as String,
      title: json['title'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isFavourite: json['isFavourite'] as bool? ?? false,
      messages: (json['messages'] as List)
          .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
          .toList(),
    );
  }
}