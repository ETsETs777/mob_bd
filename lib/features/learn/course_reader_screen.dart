// =============================================================================
// EcoPulse · lib/features/learn/course_reader_screen.dart
// Автор: Цымбал Е. В.
// Дата: 18.06.2026
// Курсы и читалка глав. Файл: course_reader_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/content/course_chapter_map.dart';
import '../../core/content/courses/investor_basics/quizzes.dart';
import '../../core/content/course_registry.dart';
import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/course.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/course_progress_provider.dart';
import 'course_quiz_screen.dart';
import 'course_reader_shell.dart';

/// Класс [CourseReaderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class CourseReaderScreen extends ConsumerStatefulWidget {
/// Создаёт [CourseReaderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  const CourseReaderScreen({
    super.key,
    required this.courseId,
    required this.isRu,
    this.initialChapterIndex = 0,
  });

/// Поле [courseId] класса [CourseReaderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final String courseId;
/// Поле [isRu] класса [CourseReaderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final bool isRu;
/// Поле [initialChapterIndex] класса [CourseReaderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  final int initialChapterIndex;

/// Создаёт State для [CourseReaderScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  @override
  ConsumerState<CourseReaderScreen> createState() => _CourseReaderScreenState();
}

/// Приватный класс [_CourseReaderScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class _CourseReaderScreenState extends ConsumerState<CourseReaderScreen> {
/// Поле [_chapterIndex] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  late int _chapterIndex;
/// Поле [_scrollController] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  late ScrollController _scrollController;

/// Getter [_book] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  CourseBook get _book =>
      CourseRegistry.find(widget.courseId, isRu: widget.isRu)!;

/// Getter [_chapter] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  CourseChapter get _chapter => _book.chapters[_chapterIndex];

/// Инициализация state [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  void initState() {
    super.initState();
    _chapterIndex = widget.initialChapterIndex.clamp(
      0,
      (_book.chapters.length - 1).clamp(0, 999),
    );
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreScroll();
      ref
          .read(courseProgressProvider.notifier)
          .setLastChapter(widget.courseId, _chapterIndex);
    });
    _scrollController.addListener(_onScroll);
  }

/// Приватный метод [_restoreScroll] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  void _restoreScroll() {
    if (!_scrollController.hasClients) return;
    final offset = ref
        .read(courseProgressProvider)
        .scrollFor(widget.courseId, _chapter.id);
    if (offset > 0) {
      _scrollController.jumpTo(
        offset.clamp(0, _scrollController.position.maxScrollExtent),
      );
    }
  }

/// Приватный метод [_onScroll] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.maxScrollExtent <= 0) return;
    final ratio = pos.pixels / pos.maxScrollExtent;
    if (ratio >= 0.88) {
      final completed = ref
          .read(courseProgressProvider)
          .completedFor(widget.courseId);
      if (!completed.contains(_chapter.id)) {
        ref.read(courseProgressProvider.notifier).markChapterComplete(
              widget.courseId,
              _chapter.id,
            );
      }
    }
  }

/// Приватный метод [_saveScroll] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  void _saveScroll() {
    if (!_scrollController.hasClients) return;
    ref.read(courseProgressProvider.notifier).setScrollOffset(
          widget.courseId,
          _chapter.id,
          _scrollController.offset,
        );
  }

/// Освобождает ресурсы [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  @override
  void dispose() {
    _saveScroll();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

/// Приватный метод [_goToChapter] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  void _goToChapter(int index) {
    _saveScroll();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    setState(() => _chapterIndex = index);
    ref
        .read(courseProgressProvider.notifier)
        .setLastChapter(widget.courseId, index);
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreScroll());
  }

/// Приватный метод [_markRead] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  void _markRead() {
    ref.read(courseProgressProvider.notifier).markChapterComplete(
          widget.courseId,
          _chapter.id,
        );
  }

/// Приватный метод [_advanceChapter] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  Future<void> _advanceChapter() async {
    _markRead();
    final book = _book;
    final partIdx = partIndexForChapter(_chapterIndex);
    if (partIdx != null && widget.courseId == 'investor_basics') {
      final quizId = partQuizId(partIdx);
      final progress = ref.read(courseProgressProvider);
      if (!progress.hasPassedQuiz(widget.courseId, quizId)) {
        final quiz = InvestorBasicsQuizzes.byPartId(
          quizId,
          isRu: widget.isRu,
        );
        if (quiz != null && mounted) {
          await showCourseQuiz(
            context,
            quiz: quiz,
            onPassed: () => ref
                .read(courseProgressProvider.notifier)
                .markQuizPassed(widget.courseId, quizId),
          );
        }
      }
    }

    if (!mounted) return;
    if (_chapterIndex < book.chapters.length - 1) {
      _goToChapter(_chapterIndex + 1);
    } else {
      Navigator.of(context).pop();
    }
  }

/// Отрисовывает UI [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final book = _book;
    final chapter = _chapter;
    final progress = ref.watch(courseProgressProvider);
    final completed = progress.completedFor(widget.courseId).contains(chapter.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.courseChapterShort(_chapterIndex + 1, book.chapters.length),
          style: const TextStyle(fontSize: 15),
        ),
        actions: [
          IconButton(
            icon: Icon(Iconsax.search_normal_1, color: palette.accent),
            tooltip: l10n.courseSearch,
            onPressed: () => _searchInBook(context, book),
          ),
          IconButton(
            icon: Icon(Iconsax.setting_4, color: palette.accent),
            tooltip: l10n.courseReaderSettings,
            onPressed: () => showCourseReaderSettings(context, ref),
          ),
          IconButton(
            icon: Icon(Iconsax.book, color: palette.accent),
            tooltip: l10n.courseTableOfContents,
            onPressed: () => _showChapterList(context, book),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 6),
            child: Row(
              children: [
                Text(
                  l10n.coursePagesCount(book.estimatedPages),
                  style: TextStyle(color: palette.textSecondary, fontSize: 11),
                ),
                const Gap(8),
                Text('·', style: TextStyle(color: palette.textSecondary)),
                const Gap(8),
                Expanded(
                  child: Text(
                    chapter.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ),
                if (completed)
                  Icon(Icons.check_circle, size: 14, color: palette.positive),
              ],
            ),
          ),
          LinearProgressIndicator(
            value: (_chapterIndex + 1) / book.chapters.length,
            minHeight: 3,
            backgroundColor: palette.border,
            color: palette.accent,
          ),
          Expanded(
            child: AnimatedSwitcher(
              duration: AppMotion.duration(context, AppMotion.normal),
              switchInCurve: AppMotion.curve,
              switchOutCurve: AppMotion.curve,
              child: CourseReaderShell(
                key: ValueKey(chapter.id),
                chapter: chapter,
                scrollController: _scrollController,
                onScrollEnd: _saveScroll,
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
              child: Row(
                children: [
                  OutlinedButton(
                    onPressed:
                        _chapterIndex > 0 ? () => _goToChapter(_chapterIndex - 1) : null,
                    child: const Icon(Iconsax.arrow_left_2, size: 18),
                  ),
                  const Gap(8),
                  if (!completed)
                    TextButton(
                      onPressed: () {
                        _markRead();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.courseMarkedRead)),
                        );
                      },
                      child: Text(l10n.courseMarkRead),
                    ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: _advanceChapter,
                    icon: Icon(
                      _chapterIndex < book.chapters.length - 1
                          ? Iconsax.arrow_right_3
                          : Iconsax.tick_circle,
                      size: 18,
                    ),
                    label: Text(
                      _chapterIndex < book.chapters.length - 1
                          ? l10n.courseNextChapter
                          : l10n.courseFinish,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

/// Приватный метод [_searchInBook] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  void _searchInBook(BuildContext context, CourseBook book) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final queryController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (ctx) {
        var query = '';
        final results = <(CourseChapter, CourseSection, String)>[];

        void runSearch(String q) {
          query = q.trim().toLowerCase();
          results.clear();
          if (query.length < 2) return;
          for (final ch in book.chapters) {
            for (final sec in ch.sections) {
              final hay = '${sec.heading ?? ''} ${sec.body}'.toLowerCase();
              if (hay.contains(query)) {
                results.add((ch, sec, sec.heading ?? ch.title));
              }
            }
          }
        }

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(l10n.courseSearch),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: queryController,
                    autofocus: true,
                    decoration: InputDecoration(
                      hintText: l10n.courseSearchHint,
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => runSearch(v)),
                  ),
                  const Gap(12),
                  if (query.length >= 2 && results.isEmpty)
                    Text(l10n.courseSearchEmpty,
                        style: TextStyle(color: palette.textSecondary)),
                  if (results.isNotEmpty)
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: results.length.clamp(0, 20),
                        itemBuilder: (_, i) {
                          final (ch, _, label) = results[i];
                          final idx = book.chapters.indexOf(ch);
                          return ListTile(
                            dense: true,
                            title: Text(label, style: const TextStyle(fontSize: 13)),
                            subtitle: Text(ch.title,
                                style: TextStyle(
                                    fontSize: 11,
                                    color: palette.textSecondary)),
                            onTap: () {
                              Navigator.pop(ctx);
                              _goToChapter(idx);
                            },
                          );
                        },
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(l10n.courseSearchClose),
              ),
            ],
          ),
        );
      },
    );
  }

/// Приватный метод [_showChapterList] класса [_CourseReaderScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  void _showChapterList(BuildContext context, CourseBook book) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final completed = ref.read(courseProgressProvider).completedFor(widget.courseId);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.65,
        minChildSize: 0.35,
        maxChildSize: 0.92,
        builder: (_, scroll) {
          String? currentPart;
          final tiles = <Widget>[];
          for (var i = 0; i < book.chapters.length; i++) {
            final ch = book.chapters[i];
            if (ch.partTitle != null && ch.partTitle != currentPart) {
              currentPart = ch.partTitle;
              tiles.add(Padding(
                padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
                child: Text(
                  currentPart!,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: palette.accent,
                    fontSize: 13,
                  ),
                ),
              ));
            }
            tiles.add(ListTile(
              dense: true,
              leading: CircleAvatar(
                radius: 13,
                backgroundColor: i == _chapterIndex
                    ? palette.accent
                    : palette.surfaceLight,
                child: Text(
                  '${i + 1}',
                  style: TextStyle(
                    fontSize: 11,
                    color: i == _chapterIndex
                        ? Colors.white
                        : palette.textSecondary,
                  ),
                ),
              ),
              title: Text(
                ch.title.replaceFirst(RegExp(r'^Глава \d+\.\s*|^Chapter \d+\.\s*'), ''),
                style: TextStyle(
                  fontWeight:
                      i == _chapterIndex ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 13,
                ),
              ),
              trailing: completed.contains(ch.id)
                  ? Icon(Icons.check, color: palette.positive, size: 16)
                  : Text(
                      l10n.courseReadMinutes(ch.effectiveReadMinutes),
                      style: TextStyle(fontSize: 10, color: palette.textSecondary),
                    ),
              onTap: () {
                Navigator.pop(ctx);
                _goToChapter(i);
              },
            ));
          }
          return ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: palette.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(16),
              Text(
                l10n.courseTableOfContents,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                l10n.courseChaptersCount(book.chapters.length),
                style: TextStyle(color: palette.textSecondary, fontSize: 12),
              ),
              ...tiles,
            ],
          );
        },
      ),
    );
  }
}
