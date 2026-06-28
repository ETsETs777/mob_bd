// =============================================================================
// EcoPulse · lib/providers/course_reader_prefs_provider.dart
// Автор: Цымбал Е. В.
// Дата: 21.05.2026
// Riverpod state: провайдеры и notifiers. Файл: course_reader_prefs_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

/// Значение enum [dark].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
/// Значение enum [sepia].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
/// Значение enum [system].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
/// Enum [CourseReadingTheme] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
/// Значение enum [dark].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
/// Значение enum [sepia].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
/// Значение enum [system].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
enum CourseReadingTheme { system, sepia, dark }

/// Класс [CourseReaderPrefs].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
class CourseReaderPrefs {
/// Создаёт [CourseReaderPrefs].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  const CourseReaderPrefs({
    this.fontScale = 1.0,
    this.theme = CourseReadingTheme.system,
  });

/// Поле [fontScale] класса [CourseReaderPrefs].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  final double fontScale;
/// Поле [theme] класса [CourseReaderPrefs].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  final CourseReadingTheme theme;

/// Метод [copyWith] класса [CourseReaderPrefs].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  CourseReaderPrefs copyWith({
    double? fontScale,
    CourseReadingTheme? theme,
  }) =>
      CourseReaderPrefs(
        fontScale: fontScale ?? this.fontScale,
        theme: theme ?? this.theme,
      );
}

/// Riverpod-провайдер [courseReaderPrefsProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
final courseReaderPrefsProvider =
    NotifierProvider<CourseReaderPrefsNotifier, CourseReaderPrefs>(
  CourseReaderPrefsNotifier.new,
);

/// Riverpod AsyncNotifier [CourseReaderPrefsNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
class CourseReaderPrefsNotifier extends Notifier<CourseReaderPrefs> {
/// Поле [_scaleKey] класса [CourseReaderPrefsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  static const _scaleKey = 'course_reader_font_scale';
/// Поле [_themeKey] класса [CourseReaderPrefsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  static const _themeKey = 'course_reader_theme';

/// Отрисовывает UI [CourseReaderPrefsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  @override
  CourseReaderPrefs build() {
    final cache = ref.read(cacheServiceProvider);
    final scale = double.tryParse(cache.getString(_scaleKey) ?? '') ?? 1.0;
    final themeIdx = int.tryParse(cache.getString(_themeKey) ?? '') ?? 0;
    return CourseReaderPrefs(
      fontScale: scale.clamp(0.85, 1.35),
      theme: CourseReadingTheme.values[themeIdx.clamp(0, 2)],
    );
  }

/// Метод [setFontScale] класса [CourseReaderPrefsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  Future<void> setFontScale(double scale) async {
    final v = scale.clamp(0.85, 1.35);
    await ref.read(cacheServiceProvider).putString(_scaleKey, v.toString());
    state = state.copyWith(fontScale: v);
  }

/// Метод [setTheme] класса [CourseReaderPrefsNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> setTheme(CourseReadingTheme theme) async {
    await ref
        .read(cacheServiceProvider)
        .putString(_themeKey, theme.index.toString());
    state = state.copyWith(theme: theme);
  }
}
