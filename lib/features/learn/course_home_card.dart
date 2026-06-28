// =============================================================================
// EcoPulse · lib/features/learn/course_home_card.dart
// Автор: Цымбал Е. В.
// Дата: 17.06.2026
// Курсы и читалка глав. Файл: course_home_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/content/course_registry.dart';
import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/course_progress_provider.dart';
import 'course_library_screen.dart';

/// Класс [CourseHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
class CourseHomeCard extends ConsumerWidget {
/// Создаёт [CourseHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  const CourseHomeCard({super.key});

/// Отрисовывает UI [CourseHomeCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final isRu = l10n.localeName.startsWith('ru');
    final books = CourseRegistry.books(isRu: isRu);
    if (books.isEmpty) return const SizedBox.shrink();

    final book = books.first;
    final progress = ref.watch(courseProgressProvider);
    final pct = (progress.progressFor(book.id, book.chapters.length) * 100).round();

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => openCourseLibrary(context),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      palette.accent.withValues(alpha: 0.2),
                      palette.chartGradientStart.withValues(alpha: 0.25),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Iconsax.book_1, color: palette.accent, size: 28),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.courseHomeCardTitle,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const Gap(4),
                    Text(
                      book.title,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      l10n.coursePagesCount(book.estimatedPages),
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    if (pct > 0) ...[
                      const Gap(8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress.progressFor(book.id, book.chapters.length),
                          minHeight: 4,
                          backgroundColor: palette.border,
                          color: palette.accent,
                        ),
                      ),
                      const Gap(4),
                      Text(
                        l10n.courseProgressPercent(pct),
                        style: TextStyle(
                          fontSize: 11,
                          color: palette.accent,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Iconsax.arrow_right_3, color: palette.textSecondary, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
