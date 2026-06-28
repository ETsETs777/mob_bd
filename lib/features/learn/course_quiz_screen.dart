// =============================================================================
// EcoPulse · lib/features/learn/course_quiz_screen.dart
// Автор: Цымбал Е. В.
// Дата: 18.06.2026
// Курсы и читалка глав. Файл: course_quiz_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/course_quiz.dart';
import '../../l10n/app_localizations.dart';

/// StatefulWidget [CourseQuizScreen] — экран или виджет с локальным state.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class CourseQuizScreen extends StatefulWidget {
/// Создаёт [CourseQuizScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  const CourseQuizScreen({
    super.key,
    required this.quiz,
    required this.onPassed,
  });

/// Поле [quiz] класса [CourseQuizScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final CoursePartQuiz quiz;
/// Поле [onPassed] класса [CourseQuizScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final VoidCallback onPassed;

/// Создаёт State для [CourseQuizScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  @override
  State<CourseQuizScreen> createState() => _CourseQuizScreenState();
}

/// Приватный класс [_CourseQuizScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class _CourseQuizScreenState extends State<CourseQuizScreen> {
/// Поле [_index] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  var _index = 0;
/// Поле [_selected] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  int? _selected;
/// Поле [_correct] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  var _correct = 0;
/// Поле [_finished] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  var _finished = false;

/// Getter [_q] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  CourseQuizQuestion get _q => widget.quiz.questions[_index];

/// Приватный метод [_submit] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  void _submit() {
    if (_selected == null) return;
    final ok = _q.options[_selected!].isCorrect;
    if (ok) _correct++;

    if (_index >= widget.quiz.questions.length - 1) {
      setState(() => _finished = true);
      if (_correct >= _passThreshold) widget.onPassed();
      return;
    }

    setState(() {
      _index++;
      _selected = null;
    });
  }

/// Getter [_passThreshold] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  int get _passThreshold => (widget.quiz.questions.length * 0.75).ceil();

/// Getter [_passed] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  bool get _passed => _correct >= _passThreshold;

/// Отрисовывает UI [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: _finished ? _result(l10n, palette) : _question(l10n, palette),
      ),
    );
  }

/// Приватный метод [_question] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  Widget _question(AppLocalizations l10n, AppPalette palette) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.courseQuizProgress(_index + 1, widget.quiz.questions.length),
          style: TextStyle(color: palette.textSecondary, fontSize: 12),
        ),
        const Gap(8),
        LinearProgressIndicator(
          value: (_index + 1) / widget.quiz.questions.length,
          backgroundColor: palette.border,
          color: palette.accent,
        ),
        const Gap(24),
        Text(
          _q.question,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
            height: 1.35,
          ),
        ),
        const Gap(20),
        Expanded(
          child: ListView.separated(
            itemCount: _q.options.length,
            separatorBuilder: (_, __) => const Gap(10),
            itemBuilder: (context, i) {
              final opt = _q.options[i];
              final selected = _selected == i;
              return AnimatedContainer(
                duration: AppMotion.duration(context, AppMotion.fast),
                curve: AppMotion.curve,
                child: Material(
                  color: selected
                      ? palette.accent.withValues(alpha: 0.12)
                      : palette.surfaceLight,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _selected = i),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Iconsax.tick_circle
                                : Iconsax.record_circle,
                            size: 20,
                            color: selected
                                ? palette.accent
                                : palette.textSecondary,
                          ),
                          const Gap(12),
                          Expanded(
                            child: Text(
                              opt.text,
                              style: TextStyle(color: palette.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        FilledButton(
          onPressed: _selected == null ? null : _submit,
          child: Text(l10n.courseQuizNext),
        ),
      ],
    );
  }

/// Приватный метод [_result] класса [_CourseQuizScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  Widget _result(AppLocalizations l10n, AppPalette palette) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          _passed ? Iconsax.medal_star : Iconsax.book,
          size: 64,
          color: _passed ? palette.positive : palette.accent,
        ),
        const Gap(16),
        Text(
          _passed ? l10n.courseQuizPassed : l10n.courseQuizRetry,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        const Gap(8),
        Text(
          l10n.courseQuizScore(_correct, widget.quiz.questions.length),
          style: TextStyle(color: palette.textSecondary),
        ),
        const Gap(24),
        if (_passed)
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.courseQuizContinue),
          )
        else
          OutlinedButton(
            onPressed: () => setState(() {
              _index = 0;
              _selected = null;
              _correct = 0;
              _finished = false;
            }),
            child: Text(l10n.courseQuizTryAgain),
          ),
      ],
    );
  }
}

/// Функция [showCourseQuiz] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
Future<bool?> showCourseQuiz(
  BuildContext context, {
  required CoursePartQuiz quiz,
  required VoidCallback onPassed,
}) {
  return Navigator.of(context).push<bool>(
    AppPageRoute<bool>(
      builder: (_) => CourseQuizScreen(quiz: quiz, onPassed: onPassed),
    ),
  );
}
