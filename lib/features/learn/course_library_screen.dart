// =============================================================================
// EcoPulse · lib/features/learn/course_library_screen.dart
// Автор: Цымбал Е. В.
// Дата: 17.06.2026
// Курсы и читалка глав. Файл: course_library_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../data/models/course.dart';
import '../../core/motion/app_motion.dart';
import '../../core/content/course_registry.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/course_progress_provider.dart';
import 'course_reader_screen.dart';

/// Класс [CourseLibraryScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
class CourseLibraryScreen extends ConsumerWidget {
/// Создаёт [CourseLibraryScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  const CourseLibraryScreen({super.key});

/// Отрисовывает UI [CourseLibraryScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final isRu = l10n.localeName.startsWith('ru');
    final books = CourseRegistry.books(isRu: isRu);
    final progress = ref.watch(courseProgressProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.courseLibraryTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            l10n.courseLibrarySubtitle,
            style: TextStyle(color: palette.textSecondary, height: 1.4),
          ),
          const Gap(8),
          Text(
            l10n.courseDisclaimer,
            style: TextStyle(
              color: palette.textSecondary,
              fontSize: 12,
              fontStyle: FontStyle.italic,
            ),
          ),
          const Gap(20),
          for (final book in books)
            _BookCard(
              book: book,
              progress: progress.progressFor(book.id, book.chapters.length),
              lastChapter: progress.lastIndexFor(book.id),
              onOpen: () => openCourseReader(context, isRu: isRu, courseId: book.id),
              onContinue: () => openCourseReader(
                context,
                isRu: isRu,
                courseId: book.id,
                chapterIndex: progress.lastIndexFor(book.id),
              ),
            ),
        ],
      ),
    );
  }
}

/// Функция [openCourseLibrary] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
void openCourseLibrary(BuildContext context) {
  openAppPage(context, const CourseLibraryScreen());
}

/// Функция [openCourseReader] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
void openCourseReader(
  BuildContext context, {
  required bool isRu,
  String courseId = 'investor_basics',
  int chapterIndex = 0,
}) {
  openAppPage(
    context,
    CourseReaderScreen(
      courseId: courseId,
      initialChapterIndex: chapterIndex,
      isRu: isRu,
    ),
  );
}

/// Приватный класс [_BookCard] — карточка секции.
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
class _BookCard extends StatelessWidget {
/// Создаёт [_BookCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  const _BookCard({
    required this.book,
    required this.progress,
    required this.lastChapter,
    required this.onOpen,
    required this.onContinue,
  });

/// Поле [book] класса [_BookCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final CourseBook book;
/// Поле [progress] класса [_BookCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final double progress;
/// Поле [lastChapter] класса [_BookCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  final int lastChapter;
/// Поле [onOpen] класса [_BookCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  final VoidCallback onOpen;
/// Поле [onContinue] класса [_BookCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  final VoidCallback onContinue;

/// Отрисовывает UI [_BookCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final pct = (progress * 100).round();

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    palette.accent.withValues(alpha: 0.85),
                    palette.chartGradientStart.withValues(alpha: 0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Iconsax.book_1,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Gap(4),
                        Text(
                          book.subtitle,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                        const Gap(8),
                        Text(
                          l10n.courseChaptersCount(book.chapters.length),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.75),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.description,
                    style: TextStyle(
                      color: palette.textSecondary,
                      height: 1.45,
                      fontSize: 13,
                    ),
                  ),
                  const Gap(12),
                  Row(
                    children: [
                      Icon(Iconsax.clock, size: 14, color: palette.textSecondary),
                      const Gap(4),
                      Text(
                        l10n.coursePagesCount(book.estimatedPages),
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        l10n.courseReadMinutes(book.totalReadMinutes),
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (progress > 0) ...[
                    const Gap(12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: palette.border,
                        color: palette.accent,
                      ),
                    ),
                    const Gap(6),
                    Text(
                      l10n.courseProgressPercent(pct),
                      style: TextStyle(
                        fontSize: 12,
                        color: palette.accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const Gap(12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onOpen,
                          icon: const Icon(Iconsax.book, size: 18),
                          label: Text(
                            progress > 0
                                ? l10n.courseReadFromStart
                                : l10n.courseStartReading,
                          ),
                        ),
                      ),
                      if (progress > 0 && lastChapter > 0) ...[
                        const Gap(8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: onContinue,
                            icon: const Icon(Iconsax.arrow_right_3, size: 18),
                            label: Text(l10n.courseContinue),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
