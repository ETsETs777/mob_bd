// =============================================================================
// EcoPulse · lib/data/models/course_quiz.dart
// Автор: Цымбал Е. В.
// Дата: 02.05.2026
// Модели данных (DTO, immutable классы). Файл: course_quiz.
// =============================================================================

/// Класс [CourseQuizOption].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
class CourseQuizOption {
/// Создаёт [CourseQuizOption].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  const CourseQuizOption({required this.text, required this.isCorrect});

/// Поле [text] класса [CourseQuizOption].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String text;
/// Поле [isCorrect] класса [CourseQuizOption].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final bool isCorrect;
}

/// Класс [CourseQuizQuestion].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
class CourseQuizQuestion {
/// Создаёт [CourseQuizQuestion].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  const CourseQuizQuestion({
    required this.question,
    required this.options,
    this.explanation,
  });

/// Поле [question] класса [CourseQuizQuestion].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String question;
/// Поле [options] класса [CourseQuizQuestion].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final List<CourseQuizOption> options;
/// Поле [explanation] класса [CourseQuizQuestion].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final String? explanation;
}

/// Класс [CoursePartQuiz].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
class CoursePartQuiz {
/// Создаёт [CoursePartQuiz].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  const CoursePartQuiz({
    required this.id,
    required this.title,
    required this.questions,
  });

/// Поле [id] класса [CoursePartQuiz].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String id;
/// Поле [title] класса [CoursePartQuiz].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String title;
/// Поле [questions] класса [CoursePartQuiz].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final List<CourseQuizQuestion> questions;
}
