// =============================================================================
// EcoPulse · lib/core/content/courses/investor_basics/ru_all.dart
// Автор: Цымбал Е. В.
// Дата: 16.06.2026
// Обучающие курсы и маппинг глав. Файл: ru_all.
// =============================================================================

import '../../../../data/models/course.dart';
import 'ru_part1.dart';
import 'ru_part2.dart';
import 'ru_part3.dart';
import 'ru_part4.dart';
import 'ru_part5.dart';

/// Функция [investorBasicsRuChapters] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
List<CourseChapter> get investorBasicsRuChapters => [
      ...ruPart1Chapters,
      ...ruPart2Chapters,
      ...ruPart3Chapters,
      ...ruPart4Chapters,
      ...ruPart5Chapters,
    ];
