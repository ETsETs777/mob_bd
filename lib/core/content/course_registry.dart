// =============================================================================
// EcoPulse · lib/core/content/course_registry.dart
// Автор: Цымбал Е. В.
// Дата: 16.06.2026
// Обучающие курсы и маппинг глав. Файл: course_registry.
// =============================================================================

import '../../data/models/course.dart';
import 'investor_basics_course.dart';

/// Класс [CourseRegistry].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class CourseRegistry {
/// Метод [books] класса [CourseRegistry].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  static List<CourseBook> books({required bool isRu}) {
    return [
      InvestorBasicsCourse.build(isRu: isRu),
    ];
  }

/// Метод [find] класса [CourseRegistry].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  static CourseBook? find(String id, {required bool isRu}) {
    for (final book in books(isRu: isRu)) {
      if (book.id == id) return book;
    }
    return null;
  }
}
