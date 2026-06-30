class ArticleTaxonomyCategory {
  const ArticleTaxonomyCategory({required this.id, required this.count});

  final String id;
  final int count;

  factory ArticleTaxonomyCategory.fromJson(Map<String, dynamic> json) {
    return ArticleTaxonomyCategory(
      id: json['id'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

class ArticleTaxonomyTag {
  const ArticleTaxonomyTag({required this.id, required this.count});

  final String id;
  final int count;

  factory ArticleTaxonomyTag.fromJson(Map<String, dynamic> json) {
    return ArticleTaxonomyTag(
      id: json['id'] as String? ?? '',
      count: json['count'] as int? ?? 0,
    );
  }
}

class ArticleTaxonomy {
  const ArticleTaxonomy({
    this.categories = const [],
    this.tags = const [],
  });

  final List<ArticleTaxonomyCategory> categories;
  final List<ArticleTaxonomyTag> tags;

  factory ArticleTaxonomy.fromJson(Map<String, dynamic> json) {
    final cats = json['categories'] as List<dynamic>? ?? [];
    final tags = json['tags'] as List<dynamic>? ?? [];
    return ArticleTaxonomy(
      categories: cats
          .map((e) => ArticleTaxonomyCategory.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
      tags: tags
          .map((e) => ArticleTaxonomyTag.fromJson(
                Map<String, dynamic>.from(e as Map),
              ))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'categories': categories
            .map((c) => {'id': c.id, 'count': c.count})
            .toList(),
        'tags': tags.map((t) => {'id': t.id, 'count': t.count}).toList(),
      };
}
