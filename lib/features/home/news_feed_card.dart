// =============================================================================
// EcoPulse · lib/features/home/news_feed_card.dart
// Автор: Цымбал Е. В.
// Дата: 05.06.2026
// Главный экран и виджеты секций. Файл: news_feed_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/constants/api_config.dart';
import '../../core/theme/app_palette.dart';
import '../../core/theme/app_tokens.dart';
import '../../data/models/news_item.dart';
import '../../l10n/app_localizations.dart';
import '../shared/widgets/app_card.dart';
import '../shared/widgets/loading_skeleton.dart';

/// StatelessWidget [NewsFeedCard] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class NewsFeedCard extends StatelessWidget {
/// Создаёт [NewsFeedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const NewsFeedCard({
    super.key,
    required this.news,
    this.maxItems = 5,
    this.onOpenCalendar,
    this.onOpenMacroWeek,
  });

/// Поле [news] класса [NewsFeedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final AsyncValue<List<NewsItem>> news;
  final int maxItems;
/// Поле [onOpenCalendar] класса [NewsFeedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final VoidCallback? onOpenCalendar;
  final VoidCallback? onOpenMacroWeek;

/// Отрисовывает UI [NewsFeedCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final hasKey = ApiConfig.finnhubKey.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                l10n.newsSectionTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            if (onOpenMacroWeek != null)
              TextButton.icon(
                onPressed: onOpenMacroWeek,
                icon: Icon(Iconsax.calendar_1, size: 16, color: palette.accent),
                label: Text(l10n.macroWeekTitle),
              ),
            if (onOpenCalendar != null)
              TextButton.icon(
                onPressed: onOpenCalendar,
                icon: Icon(Iconsax.calendar, size: 16, color: palette.accent),
                label: Text(l10n.macroCalendarTitle),
              ),
          ],
        ),
        const Gap(AppSpacing.sm),
        if (!hasKey)
          AppCard(
            child: Row(
              children: [
                Icon(Iconsax.key, color: palette.textSecondary, size: 20),
                const Gap(AppSpacing.md),
                Expanded(
                  child: Text(
                    l10n.newsFinnhubHint,
                    style: TextStyle(
                      color: palette.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          news.when(
            data: (items) {
              if (items.isEmpty) {
                return AppCard(
                  child: Text(
                    l10n.newsEmpty,
                    style: TextStyle(color: palette.textSecondary),
                  ),
                );
              }
              return Column(
                children: items
                    .take(maxItems)
                    .map(
                      (item) => _NewsTile(
                        item: item,
                        palette: palette,
                      ),
                    )
                    .toList(),
              );
            },
            loading: () => const ShimmerCard(),
            error: (_, __) => AppCard(
              child: Text(
                l10n.newsLoadError,
                style: TextStyle(color: palette.negative),
              ),
            ),
          ),
      ],
    )
        .animate()
        .fadeIn(duration: 300.ms)
        .slideY(begin: 0.03, end: 0);
  }
}

/// Приватный класс [_NewsTile] — плитка списка.
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class _NewsTile extends StatelessWidget {
/// Создаёт [_NewsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  const _NewsTile({required this.item, required this.palette});

/// Поле [item] класса [_NewsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  final NewsItem item;
/// Поле [palette] класса [_NewsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final AppPalette palette;

/// Отрисовывает UI [_NewsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  Widget build(BuildContext context) {
    final time = _formatTime(item.publishedAt);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: AppCard(
        onTap: () => _showArticle(context),
        padding: const EdgeInsets.all(AppSpacing.md - 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.headline,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
                fontSize: 14,
              ),
            ),
            const Gap(6),
            Text(
              '$time · ${item.source}',
              style: TextStyle(
                color: palette.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

/// Приватный метод [_showArticle] класса [_NewsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  void _showArticle(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        final palette = AppPalette.of(context);
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.55,
          minChildSize: 0.35,
          maxChildSize: 0.9,
          builder: (_, scroll) => Padding(
            padding: const EdgeInsets.fromLTRB(AppSpacing.page, 12, AppSpacing.page, AppSpacing.lg),
            child: ListView(
              controller: scroll,
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
                  item.headline,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const Gap(8),
                Text(
                  '${item.source} · ${_formatTime(item.publishedAt)}',
                  style: TextStyle(color: palette.textSecondary, fontSize: 13),
                ),
                const Gap(16),
                if (item.summary.isNotEmpty)
                  Text(
                    item.summary,
                    style: TextStyle(
                      color: palette.textPrimary,
                      height: 1.45,
                    ),
                  ),
                const Gap(16),
                SelectableText(
                  item.url,
                  style: TextStyle(color: palette.accent, fontSize: 13),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

/// Приватный метод [_formatTime] класса [_NewsTile].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    return '${dt.day}.${dt.month.toString().padLeft(2, '0')}';
  }
}
