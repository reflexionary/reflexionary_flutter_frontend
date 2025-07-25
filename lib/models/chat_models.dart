class ChatMessage {
  final String text;
  final bool isUser;
  final String contentType;
  final String? language;
  final String? imageBase64;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.contentType = 'text',
    this.language,
    this.imageBase64,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'contentType': contentType,
        'language': language,
        'imageBase64': imageBase64,
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'],
        isUser: json['isUser'],
        contentType: json['contentType'] ?? 'text',
        language: json['language'],
        imageBase64: json['imageBase64'],
      );
}

class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final List<ChatMessage> messages;
  bool isFavourite;

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
        'messages': messages.map((m) => m.toJson()).toList(),
        'isFavourite': isFavourite,
      };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
        id: json['id'],
        title: json['title'],
        createdAt: DateTime.parse(json['createdAt']),
        messages: (json['messages'] as List)
            .map((m) => ChatMessage.fromJson(m))
            .toList(),
        isFavourite: json['isFavourite'] ?? false,
      );
}