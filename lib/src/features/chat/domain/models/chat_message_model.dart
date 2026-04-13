/// Chat message model
class ChatMessageModel {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isQuestion;

  ChatMessageModel({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isQuestion = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'isQuestion': isQuestion,
    };
  }

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      content: json['content'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isQuestion: json['isQuestion'] as bool? ?? false,
    );
  }
}

