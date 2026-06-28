class ChatThread {
  const ChatThread({
    required this.id,
    required this.type,
    required this.title,
    this.peerProfileId,
    this.lastText,
    this.lastAt,
    this.createdAt,
  });

  final String id;
  final String type;
  final String title;
  final String? peerProfileId;
  final String? lastText;
  final String? lastAt;
  final String? createdAt;

  bool get isSelf => type == 'self';

  ChatThread copyWith({
    String? id,
    String? type,
    String? title,
    String? peerProfileId,
    String? lastText,
    String? lastAt,
    String? createdAt,
  }) {
    return ChatThread(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      peerProfileId: peerProfileId ?? this.peerProfileId,
      lastText: lastText ?? this.lastText,
      lastAt: lastAt ?? this.lastAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory ChatThread.fromJson(Map<String, dynamic> json) => ChatThread(
        id: json['id'] as String? ?? '',
        type: json['type'] as String? ?? 'direct',
        title: json['title'] as String? ?? '',
        peerProfileId: json['peerProfileId'] as String?,
        lastText: json['lastText'] as String?,
        lastAt: json['lastAt'] as String?,
        createdAt: json['createdAt'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'title': title,
        'peerProfileId': peerProfileId,
        'lastText': lastText,
        'lastAt': lastAt,
        'createdAt': createdAt,
      };
}
