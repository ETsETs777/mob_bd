// =============================================================================
// EcoPulse · lib/core/content/course_chapter_map.dart
// Автор: Цымбал Е. В.
// Дата: 15.06.2026
// Обучающие курсы и маппинг глав. Файл: course_chapter_map.
// =============================================================================

/// Связь FAQ-тем ассистента с главами курса (0-based index).
int? courseChapterIndexForTopic(String topic) => switch (topic) {
      'inflation' => 15,
      'keyRate' => 15,
      'fearGreed' => 16,
      'correlation' => 11,
      'portfolio' => 10,
      'alerts' => 20,
      'bonds' => 6,
      _ => null,
    };

/// Индексы последних глав каждой части (квиз после них).
const coursePartEndChapterIndices = [4, 9, 14, 19, 24];

/// Функция [partIndexForChapter] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
int? partIndexForChapter(int chapterIndex) {
  for (var i = 0; i < coursePartEndChapterIndices.length; i++) {
    if (chapterIndex == coursePartEndChapterIndices[i]) return i;
  }
  return null;
}

/// Функция [partQuizId] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
String partQuizId(int partIndex) => 'part${partIndex + 1}';
