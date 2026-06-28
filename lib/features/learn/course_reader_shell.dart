// =============================================================================
// EcoPulse · lib/features/learn/course_reader_shell.dart
// Автор: Цымбал Е. В.
// Дата: 18.06.2026
// Курсы и читалка глав. Файл: course_reader_shell.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_palette.dart';
import '../../data/models/course.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/course_reader_prefs_provider.dart';

/// Класс [CourseReaderShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class CourseReaderShell extends ConsumerWidget {
/// Создаёт [CourseReaderShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  const CourseReaderShell({
    super.key,
    required this.chapter,
    required this.scrollController,
    required this.onScrollEnd,
  });

/// Поле [chapter] класса [CourseReaderShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final CourseChapter chapter;
/// Поле [scrollController] класса [CourseReaderShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final ScrollController scrollController;
/// Поле [onScrollEnd] класса [CourseReaderShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  final VoidCallback onScrollEnd;

/// Отрисовывает UI [CourseReaderShell].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(courseReaderPrefsProvider);
    final baseSize = 15.0 * prefs.fontScale;

    final bg = switch (prefs.theme) {
      CourseReadingTheme.sepia => const Color(0xFFF5F0E6),
      CourseReadingTheme.dark => const Color(0xFF1A1A1A),
      CourseReadingTheme.system => Theme.of(context).scaffoldBackgroundColor,
    };
    final textColor = switch (prefs.theme) {
      CourseReadingTheme.sepia => const Color(0xFF3D3428),
      CourseReadingTheme.dark => const Color(0xFFE8E8E8),
      CourseReadingTheme.system => palette.textPrimary,
    };
    final headingColor = switch (prefs.theme) {
      CourseReadingTheme.sepia => const Color(0xFF2A2318),
      CourseReadingTheme.dark => Colors.white,
      CourseReadingTheme.system => palette.textPrimary,
    };
    final accentColor = switch (prefs.theme) {
      CourseReadingTheme.sepia => const Color(0xFF8B6914),
      CourseReadingTheme.dark => palette.accent,
      CourseReadingTheme.system => palette.accent,
    };

    return ColoredBox(
      color: bg,
      child: NotificationListener<ScrollNotification>(
        onNotification: (n) {
          if (n is ScrollEndNotification) onScrollEnd();
          return false;
        },
        child: ListView(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(20, 16, 20, 32),
          children: [
            if (chapter.partTitle != null) ...[
              Text(
                chapter.partTitle!,
                style: TextStyle(
                  fontSize: 12 * prefs.fontScale,
                  letterSpacing: 0.6,
                  fontWeight: FontWeight.w600,
                  color: accentColor,
                ),
              ),
              const SizedBox(height: 8),
            ],
            Text(
              chapter.title,
              style: TextStyle(
                fontSize: 22 * prefs.fontScale,
                fontWeight: FontWeight.bold,
                color: headingColor,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              chapter.summary,
              style: TextStyle(
                color: accentColor,
                fontWeight: FontWeight.w500,
                fontSize: 14 * prefs.fontScale,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              l10n.courseReadMinutes(chapter.effectiveReadMinutes),
              style: TextStyle(
                color: textColor.withValues(alpha: 0.55),
                fontSize: 12 * prefs.fontScale,
              ),
            ),
            const SizedBox(height: 24),
            for (final section in chapter.sections) ...[
              if (section.heading != null) ...[
                Text(
                  section.heading!,
                  style: TextStyle(
                    fontSize: 17 * prefs.fontScale,
                    fontWeight: FontWeight.w700,
                    color: headingColor,
                  ),
                ),
                const SizedBox(height: 10),
              ],
              Text(
                section.body,
                style: TextStyle(
                  color: textColor,
                  height: 1.65,
                  fontSize: baseSize,
                ),
              ),
              const SizedBox(height: 22),
            ],
          ],
        ),
      ),
    );
  }
}

/// Функция [showCourseReaderSettings] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
void showCourseReaderSettings(BuildContext context, WidgetRef ref) {
  final l10n = AppLocalizations.of(context)!;
  final palette = AppPalette.of(context);
  final prefs = ref.read(courseReaderPrefsProvider);

  showModalBottomSheet<void>(
    context: context,
    builder: (ctx) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.courseReaderSettings,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 16),
          Text(l10n.courseFontSize, style: TextStyle(color: palette.textSecondary)),
          StatefulBuilder(
            builder: (context, setState) {
              var scale = prefs.fontScale;
              return Slider(
                value: scale,
                min: 0.85,
                max: 1.35,
                divisions: 10,
                label: '${(scale * 100).round()}%',
                onChanged: (v) {
                  setState(() => scale = v);
                  ref.read(courseReaderPrefsProvider.notifier).setFontScale(v);
                },
              );
            },
          ),
          const SizedBox(height: 8),
          Text(l10n.courseReadingTheme, style: TextStyle(color: palette.textSecondary)),
          const SizedBox(height: 8),
          SegmentedButton<CourseReadingTheme>(
            segments: [
              ButtonSegment(
                value: CourseReadingTheme.system,
                label: Text(l10n.courseThemeSystem),
              ),
              ButtonSegment(
                value: CourseReadingTheme.sepia,
                label: Text(l10n.courseThemeSepia),
              ),
              ButtonSegment(
                value: CourseReadingTheme.dark,
                label: Text(l10n.courseThemeDark),
              ),
            ],
            selected: {prefs.theme},
            onSelectionChanged: (s) => ref
                .read(courseReaderPrefsProvider.notifier)
                .setTheme(s.first),
          ),
        ],
      ),
    ),
  );
}
