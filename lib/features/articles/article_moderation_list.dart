import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/home_server_error_message.dart';
import '../../data/models/user_article.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/articles_provider.dart';
import '../../providers/home_server_provider.dart';
import '../articles/article_detail_screen.dart';

/// Список статей на модерации (admin panel + отдельный экран).
class ArticleModerationList extends ConsumerWidget {
  const ArticleModerationList({super.key, this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final auth = ref.watch(homeServerProvider).auth;
    final articles = ref.watch(articlesProvider);
    final locale = Localizations.localeOf(context).languageCode;

    if (!auth.isLoggedIn) {
      return Text(
        l10n.userArticlesModerationNeedLogin,
        style: TextStyle(color: palette.textSecondary),
      );
    }
    if (!auth.canModerateArticles) {
      return Text(
        l10n.userArticlesModerationNotAdmin,
        style: TextStyle(color: palette.textSecondary),
      );
    }

    if (articles.loading && articles.pending.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (articles.pending.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            l10n.userArticlesModerationEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(articlesProvider.notifier).refreshAll(),
      child: ListView.separated(
        padding: EdgeInsets.all(compact ? 0 : 16),
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: articles.pending.length + 1,
        separatorBuilder: (_, __) => const Gap(8),
        itemBuilder: (context, index) {
          if (index == articles.pending.length) {
            return Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () =>
                    ref.read(articlesProvider.notifier).refreshAll(),
                icon: const Icon(Iconsax.refresh, size: 18),
                label: Text(l10n.adminReloadStatus),
              ),
            );
          }

          final article = articles.pending[index];
          return _PendingArticleCard(
            article: article,
            locale: locale,
            l10n: l10n,
            palette: palette,
            onApprove: () async {
              final ok = await ref
                  .read(articlesProvider.notifier)
                  .approve(article.id);
              if (!context.mounted) return;
              if (ok) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.userArticlesModerationApproved),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else {
                final err = ref.read(articlesProvider).error;
                if (err.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(homeServerErrorMessage(l10n, err)),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
            onReject: () => _reject(context, ref, article, l10n),
          );
        },
      ),
    );
  }

  Future<void> _reject(
    BuildContext context,
    WidgetRef ref,
    UserArticle article,
    AppLocalizations l10n,
  ) async {
    final reasonController = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.userArticlesModerationReject),
        content: TextField(
          controller: reasonController,
          decoration: InputDecoration(
            labelText: l10n.userArticlesRejectReason,
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, reasonController.text.trim()),
            child: Text(l10n.userArticlesModerationReject),
          ),
        ],
      ),
    );
    reasonController.dispose();
    if (reason == null) return;

    final ok = await ref.read(articlesProvider.notifier).reject(
          article.id,
          reason: reason.isEmpty ? null : reason,
        );
    if (!context.mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.userArticlesModerationRejected),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } else {
      final err = ref.read(articlesProvider).error;
      if (err.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(homeServerErrorMessage(l10n, err)),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}

class _PendingArticleCard extends StatelessWidget {
  const _PendingArticleCard({
    required this.article,
    required this.locale,
    required this.l10n,
    required this.palette,
    required this.onApprove,
    required this.onReject,
  });

  final UserArticle article;
  final String locale;
  final AppLocalizations l10n;
  final AppPalette palette;
  final VoidCallback onApprove;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            const Gap(4),
            Text(
              '${article.authorLogin} · ${DateFormat.yMMMd(locale).format(article.createdAt)}',
              style: TextStyle(color: palette.textSecondary, fontSize: 12),
            ),
            const Gap(8),
            Text(
              article.body,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
            const Gap(12),
            Row(
              children: [
                TextButton(
                  onPressed: () => openAppPage(
                    context,
                    ArticleDetailScreen(articleId: article.id),
                  ),
                  child: Text(l10n.userArticlesModerationOpen),
                ),
                const Spacer(),
                OutlinedButton(
                  onPressed: onReject,
                  child: Text(l10n.userArticlesModerationReject),
                ),
                const Gap(8),
                FilledButton(
                  onPressed: onApprove,
                  child: Text(l10n.userArticlesModerationApprove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
