enum UserArticleStatus { pending, approved, rejected }

UserArticleStatus userArticleStatusFromString(String? value) {
  return UserArticleStatus.values.firstWhere(
    (s) => s.name == value,
    orElse: () => UserArticleStatus.pending,
  );
}

class UserArticle {
  const UserArticle({
    required this.id,
    required this.title,
    required this.body,
    required this.status,
    required this.authorId,
    required this.authorName,
    required this.authorLogin,
    required this.createdAt,
    required this.updatedAt,
    this.rejectReason,
    this.moderatedAt,
    this.coverUrl,
    this.publishAt,
    this.category = 'other',
    this.tags = const [],
    this.featured = false,
  });

  final String id;
  final String title;
  final String body;
  final UserArticleStatus status;
  final String authorId;
  final String authorName;
  final String authorLogin;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? rejectReason;
  final DateTime? moderatedAt;
  final String? coverUrl;
  final DateTime? publishAt;
  final String category;
  final List<String> tags;
  final bool featured;

  bool get isPending => status == UserArticleStatus.pending;
  bool get isApproved => status == UserArticleStatus.approved;
  bool get isRejected => status == UserArticleStatus.rejected;
  bool get isScheduled =>
      publishAt != null && publishAt!.isAfter(DateTime.now().toUtc());

  factory UserArticle.fromJson(Map<String, dynamic> json) {
    return UserArticle(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      status: userArticleStatusFromString(json['status'] as String?),
      authorId: json['authorId'] as String? ?? '',
      authorName: json['authorName'] as String? ?? '',
      authorLogin: json['authorLogin'] as String? ?? '',
      rejectReason: json['rejectReason'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now().toUtc(),
      moderatedAt: json['moderatedAt'] != null
          ? DateTime.tryParse(json['moderatedAt'] as String)
          : null,
      coverUrl: json['coverUrl'] as String?,
      publishAt: json['publishAt'] != null
          ? DateTime.tryParse(json['publishAt'] as String)
          : null,
      category: json['category'] as String? ?? 'other',
      tags: json['tags'] is List
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : const [],
      featured: json['featured'] == true,
    );
  }
}
