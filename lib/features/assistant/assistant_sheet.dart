// =============================================================================
// EcoPulse · lib/features/assistant/assistant_sheet.dart
// Автор: Цымбал Е. В.
// Дата: 14.06.2026
// AI-ассистент: FAB, sheet, голос. Файл: assistant_sheet.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/services/assistant/intent_router.dart';
import '../../core/services/assistant/local_responder.dart';
import '../../core/theme/app_palette.dart';
import '../../data/models/chat_message.dart';
import '../../l10n/app_localizations.dart';
import '../learn/course_library_screen.dart';
import '../../providers/app_providers.dart';
import '../../providers/assistant_provider.dart';
import '../../providers/stock_market_provider.dart';

/// Класс [AssistantSheet].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
class AssistantSheet extends ConsumerStatefulWidget {
/// Создаёт [AssistantSheet].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  const AssistantSheet({super.key});

/// Создаёт State для [AssistantSheet].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  @override
  ConsumerState<AssistantSheet> createState() => _AssistantSheetState();
}

/// Приватный класс [_AssistantSheetState] — bottom sheet.
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
class _AssistantSheetState extends ConsumerState<AssistantSheet> {
/// Поле [_controller] класса [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final _controller = TextEditingController();
/// Поле [_scrollController] класса [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final _scrollController = ScrollController();

/// Освобождает ресурсы [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

/// Приватный метод [_scrollToBottom] класса [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

/// Приватный метод [_send] класса [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  Future<void> _send([String? text]) async {
    final l10n = AppLocalizations.of(context)!;
    final value = (text ?? _controller.text).trim();
    if (value.isEmpty) return;
    _controller.clear();
    await ref.read(assistantProvider.notifier).sendMessage(
          value,
          locale: l10n.localeName,
        );
    _scrollToBottom();
  }

/// Приватный метод [_handleAssistantAction] класса [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  void _handleAssistantAction(AssistantAction action) {
    ref.read(assistantProvider.notifier).clearPendingAction();
    Navigator.of(context).pop();

    if (action.navigateTo != null) {
      ref.read(navigationIndexProvider.notifier).state =
          _navIndex(action.navigateTo!);
    }
    if (action.openCourseLibrary) {
      openCourseLibrary(context);
    }
    if (action.openCourseChapterIndex != null) {
      openCourseReader(
        context,
        isRu: AppLocalizations.of(context)!.localeName.startsWith('ru'),
        chapterIndex: action.openCourseChapterIndex!,
      );
    }
    if (action.openMarketsTab != null) {
      ref.read(navigationIndexProvider.notifier).state = 3;
      ref.read(marketsInitialTabProvider.notifier).state = action.openMarketsTab;
    }
    if (action.bondDeepLink != null) {
      ref.read(marketsBondDeepLinkProvider.notifier).state = action.bondDeepLink;
    }
  }

/// Приватный метод [_navIndex] класса [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  int _navIndex(NavigationTarget target) => switch (target) {
        NavigationTarget.home => 0,
        NavigationTarget.currency => 1,
        NavigationTarget.inflation => 2,
        NavigationTarget.markets => 3,
        NavigationTarget.settings => 4,
      };

/// Отрисовывает UI [_AssistantSheetState].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final state = ref.watch(assistantProvider);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    ref.listen(assistantProvider, (prev, next) {
      _scrollToBottom();
      final action = next.pendingAction;
      if (action == null || action == prev?.pendingAction) return;
      _handleAssistantAction(action);
    });

    return DraggableScrollableSheet(
      initialChildSize: 0.82,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, dragScrollController) {
        return Container(
          decoration: BoxDecoration(
            color: palette.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              const Gap(8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: palette.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
                child: Row(
                  children: [
                    Icon(Iconsax.cpu, color: palette.accent),
                    const Gap(8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.assistantTitle,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: palette.textPrimary,
                            ),
                          ),
                          Text(
                            l10n.assistantDisclaimer,
                            style: TextStyle(
                              fontSize: 11,
                              color: palette.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      tooltip: l10n.assistantClearHistory,
                      onPressed: () =>
                          ref.read(assistantProvider.notifier).clearHistory(),
                    ),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    _QuickChip(
                      label: l10n.assistantQuickPrice,
                      onTap: () => _send(l10n.assistantQuickPriceQuery),
                    ),
                    _QuickChip(
                      label: l10n.assistantQuickBrief,
                      onTap: () => _send(l10n.assistantQuickBriefQuery),
                    ),
                    _QuickChip(
                      label: l10n.assistantQuickPortfolio,
                      onTap: () => _send(l10n.assistantQuickPortfolioQuery),
                    ),
                    _QuickChip(
                      label: l10n.assistantQuickExplain,
                      onTap: () => _send(l10n.assistantQuickExplainQuery),
                    ),
                    _QuickChip(
                      label: l10n.assistantQuickCourse,
                      onTap: () => _send(l10n.assistantQuickCourseQuery),
                    ),
                  ],
                ),
              ),
              const Gap(8),
              Expanded(
                child: ListView.builder(
                  controller: dragScrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.messages.length + (state.isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (state.isLoading && index == state.messages.length) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          l10n.assistantThinking,
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      );
                    }
                    final msg = state.messages[index];
                    return _MessageBubble(message: msg);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(12, 8, 12, 12 + bottomInset),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        state.isListening ? Icons.mic : Icons.mic_none,
                        color: state.isListening ? palette.negative : palette.accent,
                      ),
                      onPressed: state.isLoading
                          ? null
                          : () => ref.read(assistantProvider.notifier).toggleListening(
                                locale: l10n.localeName,
                                onResult: _send,
                              ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: l10n.assistantHint,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                        ),
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _send(),
                      ),
                    ),
                    const Gap(8),
                    FilledButton(
                      onPressed: state.isLoading ? null : () => _send(),
                      child: const Icon(Icons.send, size: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Приватный класс [_QuickChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class _QuickChip extends StatelessWidget {
/// Создаёт [_QuickChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  const _QuickChip({required this.label, required this.onTap});

/// Поле [label] класса [_QuickChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final String label;
/// Поле [onTap] класса [_QuickChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  final VoidCallback onTap;

/// Отрисовывает UI [_QuickChip].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ActionChip(label: Text(label), onPressed: onTap),
    );
  }
}

/// Приватный класс [_MessageBubble].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class _MessageBubble extends ConsumerWidget {
/// Создаёт [_MessageBubble].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  const _MessageBubble({required this.message});

/// Поле [message] класса [_MessageBubble].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.06.2026
  final ChatMessage message;

/// Отрисовывает UI [_MessageBubble].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.06.2026
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;
    final isUser = message.role == ChatRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.sizeOf(context).width * 0.78,
        ),
        decoration: BoxDecoration(
          color: isUser
              ? palette.accent.withValues(alpha: 0.15)
              : palette.surfaceLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: palette.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(color: palette.textPrimary, height: 1.35),
            ),
            if (!isUser) ...[
              const Gap(6),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    message.source == ChatSource.cloud
                        ? l10n.assistantSourceCloud
                        : l10n.assistantSourceLocal,
                    style: TextStyle(fontSize: 10, color: palette.textSecondary),
                  ),
                  const Gap(8),
                  InkWell(
                    onTap: () => ref.read(assistantProvider.notifier).speak(
                          message.text,
                          locale: l10n.localeName,
                        ),
                    child: Row(
                      children: [
                        Icon(Icons.volume_up, size: 14, color: palette.accent),
                        const Gap(4),
                        Text(
                          l10n.assistantVoiceListen,
                          style: TextStyle(fontSize: 10, color: palette.accent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
