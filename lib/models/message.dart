class Message {
  String? msgId; // Nullable for new messages
  String senderId;
  String content;
  DateTime msgCreatedAt;

  Message({
    this.msgId,
    required this.senderId,
    required this.content,
    required this.msgCreatedAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      msgId: json['msgId'],
      senderId: json['senderId'],
      content: json['content'],
      msgCreatedAt: DateTime.parse(json['msgCreatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'msgId': msgId,
      'senderId': senderId,
      'content': content,
      'msgCreatedAt': msgCreatedAt.toIso8601String(),
    };
  }
}
