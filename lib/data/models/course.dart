// =============================================================================
// EcoPulse · lib/data/models/course.dart
// Автор: Цымбал Е. В.
// Дата: 02.05.2026
// Модели данных (DTO, immutable классы). Файл: course.
// =============================================================================

/// Класс [CourseSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class CourseSection {
/// Создаёт [CourseSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const CourseSection({
    this.heading,
    required this.body,
  });

/// Поле [heading] класса [CourseSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String? heading;
/// Поле [body] класса [CourseSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String body;

/// Getter [wordCount] класса [CourseSection].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  int get wordCount =>
      body.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
}

/// Класс [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class CourseChapter {
/// Создаёт [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const CourseChapter({
    required this.id,
    required this.title,
    required this.summary,
    required this.sections,
    this.partTitle,
    this.readMinutes = 0,
  });

/// Поле [id] класса [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String id;
/// Поле [title] класса [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String title;
/// Поле [summary] класса [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final String summary;
/// Поле [sections] класса [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final List<CourseSection> sections;
/// Поле [partTitle] класса [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String? partTitle;

  /// Если 0 — вычисляется из объёма (~200 слов/мин).
  final int readMinutes;

/// Getter [wordCount] класса [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  int get wordCount =>
      sections.fold(0, (sum, s) => sum + s.wordCount);

/// Getter [effectiveReadMinutes] класса [CourseChapter].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  int get effectiveReadMinutes {
    if (readMinutes > 0) return readMinutes;
    return (wordCount / 200).ceil().clamp(3, 30);
  }
}

/// Класс [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
class CourseBook {
/// Создаёт [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  const CourseBook({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.chapters,
  });

/// Поле [id] класса [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String id;
/// Поле [title] класса [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String title;
/// Поле [subtitle] класса [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String subtitle;
/// Поле [description] класса [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final String description;
/// Поле [chapters] класса [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final List<CourseChapter> chapters;

/// Getter [totalReadMinutes] класса [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  int get totalReadMinutes =>
      chapters.fold(0, (sum, c) => sum + c.effectiveReadMinutes);

/// Getter [wordCount] класса [CourseBook].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  int get wordCount =>
      chapters.fold(0, (sum, c) => sum + c.wordCount);

  /// ~200 слов = одна «страница» в читалке.
  int get estimatedPages => (wordCount / 200).ceil().clamp(1, 999);
}
