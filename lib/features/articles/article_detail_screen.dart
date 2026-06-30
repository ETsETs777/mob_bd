import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/share_article_chat.dart';
import '../../core/navigation/app_deep_link.dart';
import '../../core/utils/article_detail_cache.dart';
import '../../core/utils/article_bookmark_storage.dart';
import '../../core/utils/article_read_tracker.dart';
import '../../core/utils/markdown_utils.dart';
import '../../data/models/user_article.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/articles_provider.dart';
import '../../providers/home_server_provider.dart';
import 'article_body_view.dart';
import 'article_editor_sheet.dart';
class ArticleDetailScreen extends ConsumerStatefulWidget {
  const ArticleDetailScreen({super.key, required this.articleId});

  final String articleId;

  @override
  ConsumerState<ArticleDetailScreen> createState() =>
      _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends ConsumerState<ArticleDetailScreen> {
  UserArticle? _article;
  bool _loading = true;
  bool _fromCache = false;
  bool _bookmarked = false;

  @override
  void initState() {
    super.initState();
    _bookmarked = ArticleBookmarkStorage.isBookmarked(widget.articleId);
    _load();
  }

  Future<void> _load() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return;
    setState(() => _loading = true);
    try {
      final client = ref.read(homeServerClientProvider);
      final article = await client.fetchArticle(auth, widget.articleId);
      await ArticleDetailCache.put(article);
      await ArticleReadTracker.markRead(
        article.id,
        updatedAt: article.updatedAt.toIso8601String(),
      );
      if (mounted) {
        setState(() {
          _article = article;
          _loading = false;
          _fromCache = false;
        });
      }
    } catch (_) {
      final cached = ArticleDetailCache.get(widget.articleId) ??
          ArticleDetailCache.fromPublishedList(
            widget.articleId,
            ref.read(articlesProvider).published,
          );
      if (mounted) {
        setState(() {
          _article = cached;
          _loading = false;
          _fromCache = cached != null;
        });
      }
    }
  }

  Future<void> _toggleBookmark() async {
    final now = await ArticleBookmarkStorage.toggle(widget.articleId);
    if (mounted) setState(() => _bookmarked = now);
  }

  Future<void> _handleMenuAction(String action, UserArticle article) async {
    final l10n = AppLocalizations.of(context)!;
    switch (action) {
      case 'read':
        await ArticleReadTracker.markRead(
          article.id,
          updatedAt: article.updatedAt.toIso8601String(),
        );
        if (mounted) setState(() {});
      case 'unread':
        await ArticleReadTracker.markUnread(article.id);
        if (mounted) setState(() {});
      case 'edit':
        final ok = await showArticleEditorSheet(
          context,
          articleId: article.id,
          initialTitle: article.title,
          initialBody: article.body,
          initialCategory: article.category,
          initialTags: article.tags,
        );
        if (ok == true) await _load();
      case 'resubmit':
        final ok = await showArticleEditorSheet(
          context,
          initialTitle: article.title,
          initialBody: article.body,
          initialCategory: article.category,
          initialTags: article.tags,
        );
        if (ok == true) await _load();
      case 'copy':
        final text =
            '${article.title}\n\n${MarkdownUtils.previewExcerpt(article.body, maxLength: 5000)}';
        await Clipboard.setData(ClipboardData(text: text));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.userArticlesCopied),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      case 'chat':
        final ok = await shareArticleToSelfChat(
          ref,
          title: article.title,
          body: article.body,
          articleId: article.id,
        );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ok
                  ? l10n.userArticlesShareToChatDone
                  : l10n.userArticlesShareToChatFailed,
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );
      case 'share':
        final excerpt = MarkdownUtils.previewExcerpt(
          article.body,
          maxLength: 400,
        );
        await Share.share(
          '${article.title}\n\n$excerpt\n${AppDeepLink.article(article.id).shareLink}',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final article = _article;
    final auth = ref.watch(homeServerProvider).auth;
    final isAuthor = article != null && article.authorId == auth.profileId;
    final isUnread = article != null &&
        ArticleReadTracker.isUnread(article.id, article.updatedAt);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.userArticlesDetailTitle),
        actions: [
          if (article != null) ...[
            IconButton(
              icon: Icon(
                _bookmarked ? Iconsax.star_1 : Iconsax.star,
                color: _bookmarked ? palette.accent : null,
              ),
              tooltip: l10n.userArticlesBookmark,
              onPressed: _toggleBookmark,
            ),
            PopupMenuButton<String>(
              tooltip: l10n.userArticlesDetailMenu,
              onSelected: (action) => _handleMenuAction(action, article),
              itemBuilder: (ctx) => [
                if (isUnread)
                  PopupMenuItem(
                    value: 'read',
                    child: ListTile(
                      leading: const Icon(Iconsax.tick_circle),
                      title: Text(l10n.userArticlesMarkRead),
                      contentPadding: EdgeInsets.zero,
                    ),
                  )
                else
                  PopupMenuItem(
                    value: 'unread',
                    child: ListTile(
                      leading: const Icon(Iconsax.notification),
                      title: Text(l10n.userArticlesMarkUnread),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (isAuthor && article.isPending)
                  PopupMenuItem(
                    value: 'edit',
                    child: ListTile(
                      leading: const Icon(Iconsax.edit),
                      title: Text(l10n.userArticlesEdit),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                if (isAuthor && article.isRejected)
                  PopupMenuItem(
                    value: 'resubmit',
                    child: ListTile(
                      leading: const Icon(Iconsax.edit_2),
                      title: Text(l10n.userArticlesResubmit),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                PopupMenuItem(
                  value: 'copy',
                  child: ListTile(
                    leading: const Icon(Iconsax.copy),
                    title: Text(l10n.userArticlesCopy),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'chat',
                  child: ListTile(
                    leading: const Icon(Iconsax.message),
                    title: Text(l10n.userArticlesShareToChat),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                PopupMenuItem(
                  value: 'share',
                  child: ListTile(
                    leading: const Icon(Iconsax.export_3),
                    title: Text(l10n.userArticlesShare),
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : article == null
              ? Center(child: Text(l10n.userArticlesNotFound))
              : Column(
                  children: [
                    if (_fromCache)
                      MaterialBanner(
                        content: Text(l10n.userArticlesDetailStaleCache),
                        leading: Icon(Iconsax.cloud, color: palette.textSecondary),
                        actions: [
                          TextButton(onPressed: _load, child: Text(l10n.retry)),
                        ],
                      ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text(
                            article.title,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const Gap(8),
                          Text(
                            '${article.authorName.isNotEmpty ? article.authorName : article.authorLogin} · '
                            '${DateFormat.yMMMd(locale).format(article.updatedAt)}',
                            style: TextStyle(color: palette.textSecondary),
                          ),
                          if (article.isRejected &&
                              article.rejectReason != null) ...[
                            const Gap(12),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: palette.negative.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${l10n.userArticlesRejectReason}: ${article.rejectReason}',
                                style: TextStyle(color: palette.negative),
                              ),
                            ),
                          ],
                          const Gap(16),
                          ArticleBodyView(body: article.body),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
