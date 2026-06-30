import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/motion/app_motion.dart';
import '../../core/theme/app_palette.dart';
import '../../core/utils/article_bookmark_share.dart';
import '../../core/utils/article_bookmark_storage.dart';
import '../../core/utils/article_read_tracker.dart';
import '../../data/models/user_article.dart';
import '../assistant/assistant_fab_layout.dart';
import '../../core/utils/home_server_error_message.dart';
import '../../core/utils/markdown_utils.dart';
import '../../core/utils/share_article_chat.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/articles_provider.dart';
import '../../providers/home_server_provider.dart';
import '../articles/article_detail_screen.dart';
import '../articles/article_editor_sheet.dart';

/// Лента и «мои статьи» без собственного [Scaffold] — для вкладки «Сообщество».
class ArticlesTab extends ConsumerStatefulWidget {
  const ArticlesTab({super.key});

  @override
  ConsumerState<ArticlesTab> createState() => ArticlesTabState();
}

class ArticlesTabState extends ConsumerState<ArticlesTab>
    with SingleTickerProviderStateMixin {
  late final TabController _feedTabs;
  final _searchController = TextEditingController();
  String _query = '';
  UserArticleStatus? _statusFilter;
  bool _newestFirst = true;
  String? _authorFilter;
  bool _savedOnly = false;
  bool _unreadOnly = false;
  int _bookmarkTick = 0;
  int _readTick = 0;

  @override
  void initState() {
    super.initState();
    _feedTabs = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) => refresh());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _feedTabs.dispose();
    super.dispose();
  }

  List<UserArticle> _filter(List<UserArticle> articles) {
    final q = _query.trim().toLowerCase();
    var result = articles;
    if (q.isNotEmpty) {
      result = result.where((a) {
        return a.title.toLowerCase().contains(q) ||
            a.body.toLowerCase().contains(q) ||
            a.authorName.toLowerCase().contains(q) ||
            a.authorLogin.toLowerCase().contains(q);
      }).toList();
    }
    return _sorted(result);
  }

  List<UserArticle> _filterFeed(List<UserArticle> articles) {
    var result = _filter(articles);
    if (_authorFilter != null && _authorFilter!.isNotEmpty) {
      final author = _authorFilter!.toLowerCase();
      result = result
          .where(
            (a) =>
                a.authorLogin.toLowerCase() == author ||
                a.authorName.toLowerCase() == author,
          )
          .toList();
    }
    if (_savedOnly) {
      final bookmarks = ArticleBookmarkStorage.load();
      result = result.where((a) => bookmarks.contains(a.id)).toList();
    }
    if (_unreadOnly) {
      result = result
          .where((a) => ArticleReadTracker.isUnread(a.id, a.updatedAt))
          .toList();
    }
    return result;
  }

  List<UserArticle> _filterMine(List<UserArticle> articles) {
    var result = _filter(articles);
    if (_statusFilter != null) {
      result = result.where((a) => a.status == _statusFilter).toList();
    }
    return result;
  }

  List<UserArticle> _sorted(List<UserArticle> articles) {
    final copy = [...articles];
    copy.sort(
      (a, b) => _newestFirst
          ? b.updatedAt.compareTo(a.updatedAt)
          : a.updatedAt.compareTo(b.updatedAt),
    );
    return copy;
  }

  Future<void> refresh() async {
    await ref.read(articlesProvider.notifier).refreshAll();
  }

  void refreshReadState() {
    setState(() => _readTick++);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final auth = ref.watch(homeServerProvider).auth;
    final articles = ref.watch(articlesProvider);

    if (!auth.isLoggedIn) {
      return _NotConnected(palette: palette, l10n: l10n);
    }

    return Column(
      children: [
        if (articles.error.isNotEmpty &&
            (articles.published.isNotEmpty || articles.mine.isNotEmpty))
          MaterialBanner(
            content: Text(l10n.userArticlesStaleCache),
            leading: Icon(Iconsax.cloud, color: palette.textSecondary),
            actions: [
              TextButton(onPressed: refresh, child: Text(l10n.retry)),
            ],
          )
        else if (articles.error.isNotEmpty)
          MaterialBanner(
            content: Text(homeServerErrorMessage(l10n, articles.error)),
            leading: Icon(Iconsax.warning_2, color: palette.negative),
            actions: [
              TextButton(onPressed: refresh, child: Text(l10n.retry)),
            ],
          ),
        Material(
          color: Theme.of(context).appBarTheme.backgroundColor ??
              Theme.of(context).colorScheme.surface,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n.userArticlesSearchHint,
                    prefixIcon: const Icon(Iconsax.search_normal_1, size: 20),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() => _query = value),
                ),
              ),
              TabBar(
                controller: _feedTabs,
                tabs: [
                  Tab(text: l10n.userArticlesFeedTab),
                  Tab(text: l10n.userArticlesMineTab),
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                child: Row(
                  children: [
                    Text(
                      l10n.userArticlesSortLabel,
                      style: TextStyle(
                        color: palette.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const Gap(8),
                    FilterChip(
                      label: Text(l10n.userArticlesSortNewest),
                      selected: _newestFirst,
                      onSelected: (_) => setState(() => _newestFirst = true),
                    ),
                    const Gap(6),
                    FilterChip(
                      label: Text(l10n.userArticlesSortOldest),
                      selected: !_newestFirst,
                      onSelected: (_) => setState(() => _newestFirst = false),
                    ),
                  ],
                ),
              ),
              AnimatedBuilder(
                animation: _feedTabs,
                builder: (context, _) {
                  if (_feedTabs.index != 0) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        FilterChip(
                          label: Text(l10n.userArticlesSavedOnly),
                          selected: _savedOnly,
                          onSelected: (v) => setState(() {
                            _savedOnly = v;
                            if (v) _unreadOnly = false;
                          }),
                        ),
                        FilterChip(
                          label: Text(l10n.userArticlesUnreadOnly),
                          selected: _unreadOnly,
                          onSelected: (v) => setState(() {
                            _unreadOnly = v;
                            if (v) _savedOnly = false;
                          }),
                        ),
                        if (_authorFilter != null)
                          InputChip(
                            label: Text(
                              l10n.userArticlesAuthorFilter(_authorFilter!),
                            ),
                            onDeleted: () =>
                                setState(() => _authorFilter = null),
                          ),
                        if (ArticleBookmarkStorage.load().isNotEmpty)
                          IconButton(
                            icon: const Icon(Iconsax.export_3, size: 20),
                            tooltip: l10n.userArticlesShareBookmarks,
                            onPressed: () {
                              final text = buildBookmarkedArticlesShareText(
                                articles.published,
                              );
                              if (text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      l10n.userArticlesShareBookmarksEmpty,
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }
                              Share.share(text);
                            },
                          ),
                      ],
                    ),
                  );
                },
              ),
              AnimatedBuilder(
                animation: _feedTabs,
                builder: (context, _) {
                  if (_feedTabs.index != 1) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        FilterChip(
                          label: Text(l10n.userArticlesFilterAll),
                          selected: _statusFilter == null,
                          onSelected: (_) =>
                              setState(() => _statusFilter = null),
                        ),
                        FilterChip(
                          label: Text(l10n.userArticlesStatusPending),
                          selected:
                              _statusFilter == UserArticleStatus.pending,
                          onSelected: (_) => setState(
                            () => _statusFilter = UserArticleStatus.pending,
                          ),
                        ),
                        FilterChip(
                          label: Text(l10n.userArticlesStatusApproved),
                          selected:
                              _statusFilter == UserArticleStatus.approved,
                          onSelected: (_) => setState(
                            () => _statusFilter = UserArticleStatus.approved,
                          ),
                        ),
                        FilterChip(
                          label: Text(l10n.userArticlesStatusRejected),
                          selected:
                              _statusFilter == UserArticleStatus.rejected,
                          onSelected: (_) => setState(
                            () => _statusFilter = UserArticleStatus.rejected,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _feedTabs,
            children: [
              _ArticleList(
                articles: _filterFeed(articles.published),
                emptyText: _query.isEmpty &&
                        !_savedOnly &&
                        !_unreadOnly &&
                        _authorFilter == null
                    ? l10n.userArticlesFeedEmpty
                    : l10n.userArticlesSearchEmpty,
                onRefresh: refresh,
                loading: articles.loading,
                bookmarkTick: _bookmarkTick,
                readTick: _readTick,
                hasMore: articles.publishedHasMore &&
                    _query.isEmpty &&
                    !_savedOnly &&
                    !_unreadOnly &&
                    _authorFilter == null,
                loadingMore: articles.loadingMore,
                onLoadMore: () =>
                    ref.read(articlesProvider.notifier).loadMorePublished(),
                onAuthorTap: (login) =>
                    setState(() => _authorFilter = login),
                onBookmarkChanged: () =>
                    setState(() {
                      _bookmarkTick++;
                      _readTick++;
                    }),
              ),
              _ArticleList(
                articles: _filterMine(articles.mine),
                emptyText: _query.isEmpty && _statusFilter == null
                    ? l10n.userArticlesMineEmpty
                    : l10n.userArticlesSearchEmpty,
                onRefresh: refresh,
                loading: articles.loading,
                showStatus: true,
                onEdit: (article) async {
                  if (!article.isPending) return;
                  final ok = await showArticleEditorSheet(
                    context,
                    articleId: article.id,
                    initialTitle: article.title,
                    initialBody: article.body,
                  );
                  if (ok == true) await refresh();
                },
                onDelete: (article) async {
                  if (article.isApproved) return;
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text(l10n.userArticlesDelete),
                      content: Text(l10n.userArticlesDeleteConfirm),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx, false),
                          child: Text(
                            MaterialLocalizations.of(context).cancelButtonLabel,
                          ),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(ctx, true),
                          child: Text(l10n.userArticlesDelete),
                        ),
                      ],
                    ),
                  );
                  if (confirmed != true) return;
                  final ok = await ref
                      .read(articlesProvider.notifier)
                      .delete(article.id);
                  if (!context.mounted) return;
                  if (ok) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(l10n.userArticlesDeleted),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    await refresh();
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
                onResubmit: (article) async {
                  final ok = await showArticleEditorSheet(
                    context,
                    initialTitle: article.title,
                    initialBody: article.body,
                  );
                  if (ok == true) await refresh();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NotConnected extends StatelessWidget {
  const _NotConnected({required this.palette, required this.l10n});

  final AppPalette palette;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Iconsax.cloud_connection, size: 48, color: palette.textSecondary),
            const Gap(12),
            Text(
              l10n.userArticlesNeedLogin,
              textAlign: TextAlign.center,
              style: TextStyle(color: palette.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArticleList extends ConsumerWidget {
  const _ArticleList({
    required this.articles,
    required this.emptyText,
    required this.onRefresh,
    required this.loading,
    this.showStatus = false,
    this.onEdit,
    this.onDelete,
    this.onResubmit,
    this.onAuthorTap,
    this.onBookmarkChanged,
    this.bookmarkTick = 0,
    this.readTick = 0,
    this.hasMore = false,
    this.loadingMore = false,
    this.onLoadMore,
  });

  final List<UserArticle> articles;
  final String emptyText;
  final Future<void> Function() onRefresh;
  final bool loading;
  final bool showStatus;
  final Future<void> Function(UserArticle article)? onEdit;
  final Future<void> Function(UserArticle article)? onDelete;
  final Future<void> Function(UserArticle article)? onResubmit;
  final void Function(String authorLogin)? onAuthorTap;
  final VoidCallback? onBookmarkChanged;
  final int bookmarkTick;
  final int readTick;
  final bool hasMore;
  final bool loadingMore;
  final VoidCallback? onLoadMore;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    // ignore: unused_local_variable
    final _ = bookmarkTick + readTick;

    if (loading && articles.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: articles.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.35,
                  child: Center(
                    child: Text(
                      emptyText,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ),
                ),
              ],
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + AssistantFabLayout.scrollBottomPadding(context),
              ),
              itemCount: articles.length + (hasMore ? 1 : 0),
              separatorBuilder: (_, __) => const Gap(8),
              itemBuilder: (context, index) {
                if (hasMore && index == articles.length) {
                  return Center(
                    child: loadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(16),
                            child: CircularProgressIndicator(),
                          )
                        : TextButton(
                            onPressed: onLoadMore,
                            child: Text(l10n.userArticlesLoadMore),
                          ),
                  );
                }
                final article = articles[index];
                final bookmarked = ArticleBookmarkStorage.isBookmarked(article.id);
                final unread = ArticleReadTracker.isUnread(
                  article.id,
                  article.updatedAt,
                );
                return Card(
                  child: ListTile(
                    title: Row(
                      children: [
                        if (unread) ...[
                          Container(
                            width: 8,
                            height: 8,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: palette.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                        Expanded(
                          child: Text(
                            article.title,
                            style: TextStyle(
                              fontWeight:
                                  unread ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (article.body.trim().isNotEmpty) ...[
                          Text(
                            MarkdownUtils.previewExcerpt(article.body),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                          const Gap(4),
                        ],
                        InkWell(
                          onTap: onAuthorTap != null
                              ? () => onAuthorTap!(article.authorLogin)
                              : null,
                          child: Text(
                            '${article.authorName.isNotEmpty ? article.authorName : article.authorLogin} · '
                            '${DateFormat.yMMMd(locale).format(article.updatedAt)} · '
                            '${l10n.userArticlesReadingTime(MarkdownUtils.readingTimeMinutes(article.body))}',
                            style: TextStyle(
                              color: onAuthorTap != null
                                  ? palette.accent
                                  : palette.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        if (showStatus) ...[
                          const Gap(4),
                          _StatusChip(status: article.status, l10n: l10n),
                        ],
                        if (showStatus &&
                            article.isPending &&
                            onEdit != null) ...[
                          const Gap(4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => onEdit!(article),
                              icon: const Icon(Iconsax.edit, size: 16),
                              label: Text(l10n.userArticlesEdit),
                            ),
                          ),
                        ],
                        if (showStatus &&
                            !article.isApproved &&
                            onDelete != null) ...[
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => onDelete!(article),
                              icon: Icon(
                                Iconsax.trash,
                                size: 16,
                                color: palette.negative,
                              ),
                              label: Text(
                                l10n.userArticlesDelete,
                                style: TextStyle(color: palette.negative),
                              ),
                            ),
                          ),
                        ],
                        if (showStatus &&
                            article.isRejected &&
                            onResubmit != null) ...[
                          const Gap(4),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () => onResubmit!(article),
                              icon: const Icon(Iconsax.edit_2, size: 16),
                              label: Text(l10n.userArticlesResubmit),
                            ),
                          ),
                        ],
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            bookmarked ? Iconsax.star_1 : Iconsax.star,
                            size: 20,
                            color: bookmarked ? palette.accent : null,
                          ),
                          tooltip: l10n.userArticlesBookmark,
                          onPressed: () async {
                            await ArticleBookmarkStorage.toggle(article.id);
                            onBookmarkChanged?.call();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Iconsax.export_3, size: 20),
                          tooltip: l10n.userArticlesShare,
                          onPressed: () {
                            final excerpt = MarkdownUtils.previewExcerpt(
                              article.body,
                              maxLength: 400,
                            );
                            Share.share('${article.title}\n\n$excerpt');
                          },
                        ),
                        const Icon(Iconsax.arrow_right_3, size: 18),
                      ],
                    ),
                    onTap: () async {
                      await openAppPage(
                        context,
                        ArticleDetailScreen(articleId: article.id),
                      );
                      await ArticleReadTracker.markRead(
                        article.id,
                        updatedAt: article.updatedAt.toIso8601String(),
                      );
                      onBookmarkChanged?.call();
                    },
                    onLongPress: showStatus
                        ? null
                        : () => _showArticleMenu(
                              context,
                              ref,
                              l10n,
                              article,
                              bookmarked,
                              onBookmarkChanged,
                            ),
                  ),
                );
              },
            ),
    );
  }
}

Future<void> _showArticleMenu(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
  UserArticle article,
  bool bookmarked,
  VoidCallback? onBookmarkChanged,
) async {
  final isUnread = ArticleReadTracker.isUnread(
    article.id,
    article.updatedAt,
  );
  final action = await showModalBottomSheet<String>(
    context: context,
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUnread)
            ListTile(
              leading: const Icon(Iconsax.tick_circle),
              title: Text(l10n.userArticlesMarkRead),
              onTap: () => Navigator.pop(ctx, 'read'),
            )
          else
            ListTile(
              leading: const Icon(Iconsax.notification),
              title: Text(l10n.userArticlesMarkUnread),
              onTap: () => Navigator.pop(ctx, 'unread'),
            ),
          ListTile(
            leading: Icon(
              bookmarked ? Iconsax.star_1 : Iconsax.star,
            ),
            title: Text(l10n.userArticlesBookmark),
            onTap: () => Navigator.pop(ctx, 'bookmark'),
          ),
          ListTile(
            leading: const Icon(Iconsax.export_3),
            title: Text(l10n.userArticlesShare),
            onTap: () => Navigator.pop(ctx, 'share'),
          ),
          ListTile(
            leading: const Icon(Iconsax.message),
            title: Text(l10n.userArticlesShareToChat),
            onTap: () => Navigator.pop(ctx, 'chat'),
          ),
          ListTile(
            leading: const Icon(Iconsax.copy),
            title: Text(l10n.userArticlesCopy),
            onTap: () => Navigator.pop(ctx, 'copy'),
          ),
        ],
      ),
    ),
  );

  if (!context.mounted || action == null) return;
  switch (action) {
    case 'read':
      await ArticleReadTracker.markRead(
        article.id,
        updatedAt: article.updatedAt.toIso8601String(),
      );
      onBookmarkChanged?.call();
    case 'unread':
      await ArticleReadTracker.markUnread(article.id);
      onBookmarkChanged?.call();
    case 'bookmark':
      await ArticleBookmarkStorage.toggle(article.id);
      onBookmarkChanged?.call();
    case 'share':
      final excerpt = MarkdownUtils.previewExcerpt(
        article.body,
        maxLength: 400,
      );
      await Share.share('${article.title}\n\n$excerpt');
    case 'chat':
      final ok = await shareArticleToSelfChat(
        ref,
        title: article.title,
        body: article.body,
        articleId: article.id,
      );
      if (context.mounted) {
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
      }
    case 'copy':
      final excerpt = MarkdownUtils.previewExcerpt(
        article.body,
        maxLength: 400,
      );
      await Clipboard.setData(
        ClipboardData(text: '${article.title}\n\n$excerpt'),
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.userArticlesCopied),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status, required this.l10n});

  final UserArticleStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      UserArticleStatus.pending => (l10n.userArticlesStatusPending, Colors.orange),
      UserArticleStatus.approved => (l10n.userArticlesStatusApproved, Colors.green),
      UserArticleStatus.rejected => (l10n.userArticlesStatusRejected, Colors.red),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}
