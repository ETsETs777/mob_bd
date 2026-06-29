/// Цель накопления, привязанная к бумажному портфелю.
class SavingsGoal {
  const SavingsGoal({
    required this.id,
    required this.title,
    required this.targetRub,
    required this.deadline,
    this.linkedAccountId,
    required this.createdAt,
  });

  final String id;
  final String title;
  final double targetRub;
  final DateTime deadline;
  final String? linkedAccountId;
  final DateTime createdAt;

  SavingsGoal copyWith({
    String? title,
    double? targetRub,
    DateTime? deadline,
    String? linkedAccountId,
    bool clearLinkedAccount = false,
  }) {
    return SavingsGoal(
      id: id,
      title: title ?? this.title,
      targetRub: targetRub ?? this.targetRub,
      deadline: deadline ?? this.deadline,
      linkedAccountId:
          clearLinkedAccount ? null : linkedAccountId ?? this.linkedAccountId,
      createdAt: createdAt,
    );
  }

  double progressRatio(double currentRub) {
    if (targetRub <= 0) return 0;
    return (currentRub / targetRub).clamp(0.0, 1.0);
  }

  int daysLeft(DateTime now) {
    final end = DateTime(deadline.year, deadline.month, deadline.day);
    final today = DateTime(now.year, now.month, now.day);
    return end.difference(today).inDays;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'targetRub': targetRub,
        'deadline': deadline.toIso8601String(),
        'linkedAccountId': linkedAccountId,
        'createdAt': createdAt.toIso8601String(),
      };

  factory SavingsGoal.fromJson(Map<String, dynamic> json) {
    return SavingsGoal(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      targetRub: (json['targetRub'] as num?)?.toDouble() ?? 0,
      deadline: DateTime.tryParse(json['deadline'] as String? ?? '') ??
          DateTime.now().toUtc(),
      linkedAccountId: json['linkedAccountId'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
    );
  }
}
