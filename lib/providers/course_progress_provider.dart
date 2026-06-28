// =============================================================================
// EcoPulse · lib/providers/course_progress_provider.dart
// Автор: Цымбал Е. В.
// Дата: 20.05.2026
// Riverpod state: провайдеры и notifiers. Файл: course_progress_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

/// Riverpod-провайдер [courseProgressProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final courseProgressProvider =
    NotifierProvider<CourseProgressNotifier, CourseProgressState>(
  CourseProgressNotifier.new,
);

/// Класс [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class CourseProgressState {
/// Создаёт [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  const CourseProgressState({
    this.lastChapterIndex = const {},
    this.completedChapters = const {},
    this.scrollOffsets = const {},
    this.passedQuizzes = const {},
  });

/// Поле [lastChapterIndex] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  final Map<String, int> lastChapterIndex;
/// Поле [completedChapters] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  final Map<String, Set<String>> completedChapters;
/// Поле [scrollOffsets] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  final Map<String, double> scrollOffsets;
/// Поле [passedQuizzes] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  final Map<String, Set<String>> passedQuizzes;

/// Метод [copyWith] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  CourseProgressState copyWith({
    Map<String, int>? lastChapterIndex,
    Map<String, Set<String>>? completedChapters,
    Map<String, double>? scrollOffsets,
    Map<String, Set<String>>? passedQuizzes,
  }) =>
      CourseProgressState(
        lastChapterIndex: lastChapterIndex ?? this.lastChapterIndex,
        completedChapters: completedChapters ?? this.completedChapters,
        scrollOffsets: scrollOffsets ?? this.scrollOffsets,
        passedQuizzes: passedQuizzes ?? this.passedQuizzes,
      );

/// Метод [lastIndexFor] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  int lastIndexFor(String courseId) => lastChapterIndex[courseId] ?? 0;

/// Метод [completedFor] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Set<String> completedFor(String courseId) =>
      completedChapters[courseId] ?? const {};

/// Метод [passedQuizzesFor] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Set<String> passedQuizzesFor(String courseId) =>
      passedQuizzes[courseId] ?? const {};

/// Метод [hasPassedQuiz] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  bool hasPassedQuiz(String courseId, String quizId) =>
      passedQuizzesFor(courseId).contains(quizId);

/// Метод [scrollFor] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  double scrollFor(String courseId, String chapterId) =>
      scrollOffsets['$courseId::$chapterId'] ?? 0;

/// Метод [progressFor] класса [CourseProgressState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  double progressFor(String courseId, int totalChapters) {
    if (totalChapters == 0) return 0;
    return completedFor(courseId).length / totalChapters;
  }
}

/// Riverpod AsyncNotifier [CourseProgressNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class CourseProgressNotifier extends Notifier<CourseProgressState> {
/// Поле [_cacheKey] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  static const _cacheKey = 'course_progress_v2';

/// Отрисовывает UI [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  @override
  CourseProgressState build() => _load();

/// Приватный метод [_load] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  CourseProgressState _load() {
    final raw = ref.read(cacheServiceProvider).getString(_cacheKey);
    if (raw == null || raw.isEmpty) return _migrateFromV1();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final last = <String, int>{};
      final completed = <String, Set<String>>{};
      final scroll = <String, double>{};
      final quizzes = <String, Set<String>>{};
      for (final e in (json['last'] as Map<String, dynamic>? ?? {}).entries) {
        last[e.key] = (e.value as num).toInt();
      }
      for (final e
          in (json['completed'] as Map<String, dynamic>? ?? {}).entries) {
        completed[e.key] =
            (e.value as List<dynamic>).map((v) => v as String).toSet();
      }
      for (final e in (json['scroll'] as Map<String, dynamic>? ?? {}).entries) {
        scroll[e.key] = (e.value as num).toDouble();
      }
      for (final e
          in (json['quizzes'] as Map<String, dynamic>? ?? {}).entries) {
        quizzes[e.key] =
            (e.value as List<dynamic>).map((v) => v as String).toSet();
      }
      return CourseProgressState(
        lastChapterIndex: last,
        completedChapters: completed,
        scrollOffsets: scroll,
        passedQuizzes: quizzes,
      );
    } catch (_) {
      return const CourseProgressState();
    }
  }

/// Приватный метод [_migrateFromV1] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  CourseProgressState _migrateFromV1() {
    final raw = ref.read(cacheServiceProvider).getString('course_progress_v1');
    if (raw == null || raw.isEmpty) return const CourseProgressState();
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final last = <String, int>{};
      final completed = <String, Set<String>>{};
      for (final e in (json['last'] as Map<String, dynamic>? ?? {}).entries) {
        last[e.key] = (e.value as num).toInt();
      }
      for (final e
          in (json['completed'] as Map<String, dynamic>? ?? {}).entries) {
        completed[e.key] =
            (e.value as List<dynamic>).map((v) => v as String).toSet();
      }
      return CourseProgressState(
        lastChapterIndex: last,
        completedChapters: completed,
      );
    } catch (_) {
      return const CourseProgressState();
    }
  }

/// Приватный метод [_persist] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<void> _persist() async {
    await ref.read(cacheServiceProvider).putString(
          _cacheKey,
          jsonEncode({
            'last': state.lastChapterIndex,
            'completed': state.completedChapters.map(
              (k, v) => MapEntry(k, v.toList()),
            ),
            'scroll': state.scrollOffsets,
            'quizzes': state.passedQuizzes.map(
              (k, v) => MapEntry(k, v.toList()),
            ),
          }),
        );
  }

/// Метод [setLastChapter] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> setLastChapter(String courseId, int index) async {
    state = state.copyWith(
      lastChapterIndex: {...state.lastChapterIndex, courseId: index},
    );
    await _persist();
  }

/// Метод [setScrollOffset] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> setScrollOffset(
    String courseId,
    String chapterId,
    double offset,
  ) async {
    final key = '$courseId::$chapterId';
    if ((state.scrollOffsets[key] ?? 0) == offset) return;
    state = state.copyWith(
      scrollOffsets: {...state.scrollOffsets, key: offset},
    );
    await _persist();
  }

/// Метод [markChapterComplete] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  Future<void> markChapterComplete(String courseId, String chapterId) async {
    final set = {...state.completedFor(courseId), chapterId};
    state = state.copyWith(
      completedChapters: {...state.completedChapters, courseId: set},
    );
    await _persist();
  }

/// Метод [markQuizPassed] класса [CourseProgressNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<void> markQuizPassed(String courseId, String quizId) async {
    final set = {...state.passedQuizzesFor(courseId), quizId};
    state = state.copyWith(
      passedQuizzes: {...state.passedQuizzes, courseId: set},
    );
    await _persist();
  }
}
