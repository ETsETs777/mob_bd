// =============================================================================
// EcoPulse · test/course_chapter_map_test.dart
// Автор: Цымбал Е. В.
// Дата: 24.06.2026
// Unit/widget тест: course_chapter_map_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:ecopulse/core/content/course_chapter_map.dart';
import 'package:ecopulse/core/services/assistant/intent_router.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 25.06.2026
void main() {
  test('explain topics map to course chapters', () {
    expect(courseChapterIndexForTopic('inflation'), 15);
    expect(courseChapterIndexForTopic('portfolio'), 10);
    expect(courseChapterIndexForTopic('bonds'), 6);
    expect(courseChapterIndexForTopic('unknown'), isNull);
  });

  test('part end chapters trigger quizzes', () {
    expect(partIndexForChapter(4), 0);
    expect(partIndexForChapter(9), 1);
    expect(partIndexForChapter(3), isNull);
    expect(partQuizId(2), 'part3');
  });

  test('explain inflation opens course chapter action', () {
    final match = IntentRouter.route('что такое инфляция');
    expect(match.intent, AssistantIntent.explain);
    expect(match.explainTopic, 'inflation');
    expect(courseChapterIndexForTopic(match.explainTopic!), 15);
  });
}
