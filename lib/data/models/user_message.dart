class UserMessage {
  const UserMessage({
    required this.id,
    required this.threadId,
    required this.senderId,
    required this.text,
    required this.createdAt,
    this.senderLogin,
    this.senderName,
    this.isMine = false,
  });

  final String id;
  final String threadId;
  final String senderId;
  final String text;
  final String createdAt;
  final String? senderLogin;
  final String? senderName;
  final bool isMine;

  factory UserMessage.fromJson(Map<String, dynamic> json) => UserMessage(
        id: json['id'] as String? ?? '',
        threadId: json['threadId'] as String? ?? '',
        senderId: json['senderId'] as String? ?? '',
        text: json['text'] as String? ?? '',
        createdAt: json['createdAt'] as String? ?? '',
        senderLogin: json['senderLogin'] as String?,
        senderName: json['senderName'] as String?,
        isMine: json['isMine'] as bool? ?? false,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'threadId': threadId,
        'senderId': senderId,
        'text': text,
        'createdAt': createdAt,
        'senderLogin': senderLogin,
        'senderName': senderName,
        'isMine': isMine,
      };
}
