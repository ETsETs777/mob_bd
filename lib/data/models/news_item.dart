// =============================================================================
// EcoPulse · lib/data/models/news_item.dart
// Автор: Цымбал Е. В.
// Дата: 04.05.2026
// Модели данных (DTO, immutable классы). Файл: news_item.
// =============================================================================

/// Класс [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
class NewsItem {
/// Создаёт [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  const NewsItem({
    required this.id,
    required this.headline,
    required this.summary,
    required this.source,
    required this.url,
    required this.publishedAt,
    this.imageUrl,
  });

/// Поле [id] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final int id;
/// Поле [headline] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final String headline;
/// Поле [summary] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String summary;
/// Поле [source] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String source;
/// Поле [url] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String url;
/// Поле [publishedAt] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final DateTime publishedAt;
/// Поле [imageUrl] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final String? imageUrl;

/// Метод [toJson] класса [NewsItem].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  Map<String, dynamic> toJson() => {
        'id': id,
        'headline': headline,
        'summary': summary,
        'source': source,
        'url': url,
        'publishedAt': publishedAt.toIso8601String(),
        'imageUrl': imageUrl,
      };

/// Создаёт [NewsItem] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  factory NewsItem.fromJson(Map<String, dynamic> json) => NewsItem(
        id: json['id'] as int? ?? 0,
        headline: json['headline'] as String? ?? '',
        summary: json['summary'] as String? ?? '',
        source: json['source'] as String? ?? '',
        url: json['url'] as String? ?? '',
        publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(
              ((json['datetime'] as num?) ?? 0).toInt() * 1000,
            ),
        imageUrl: json['imageUrl'] as String? ?? json['image'] as String?,
      );
}
