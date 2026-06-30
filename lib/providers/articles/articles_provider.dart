import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/article_detail_cache.dart';
import '../../core/utils/article_moderation_notifications.dart';
import '../../core/utils/article_offline_cache.dart';
import '../../core/utils/article_read_tracker.dart';
import '../../core/utils/article_status_notifications.dart';
import '../../core/utils/article_sync_conflict.dart';
import '../../core/utils/article_sync_outbox.dart';
import '../../data/models/article_taxonomy.dart';
import '../../data/models/home_server_auth.dart';
import '../../data/models/user_article.dart';
import '../../data/services/home_server_client.dart';
import '../profile/home_server_provider.dart';

class ArticleFeedFilters {
  const ArticleFeedFilters({this.category, this.tag});

  final String? category;
  final String? tag;

  ArticleFeedFilters copyWith({
    String? category,
    String? tag,
    bool clearCategory = false,
    bool clearTag = false,
  }) {
    return ArticleFeedFilters(
      category: clearCategory ? null : (category ?? this.category),
      tag: clearTag ? null : (tag ?? this.tag),
    );
  }
}

final articleFeedFiltersProvider =
    StateProvider<ArticleFeedFilters>((ref) => const ArticleFeedFilters());

class ArticlesState {
  const ArticlesState({
    this.published = const [],
    this.mine = const [],
    this.pending = const [],
    this.taxonomy,
    this.loading = false,
    this.loadingMore = false,
    this.publishedHasMore = true,
    this.error = '',
    this.fromCache = false,
    this.pendingSyncCount = 0,
    this.blockedSyncCount = 0,
    this.syncing = false,
  });

  final List<UserArticle> published;
  final List<UserArticle> mine;
  final List<UserArticle> pending;
  final ArticleTaxonomy? taxonomy;
  final bool loading;
  final bool loadingMore;
  final bool publishedHasMore;
  final String error;
  final bool fromCache;
  final int pendingSyncCount;
  final int blockedSyncCount;
  final bool syncing;

  ArticlesState copyWith({
    List<UserArticle>? published,
    List<UserArticle>? mine,
    List<UserArticle>? pending,
    ArticleTaxonomy? taxonomy,
    bool? loading,
    bool? loadingMore,
    bool? publishedHasMore,
    String? error,
    bool? fromCache,
    int? pendingSyncCount,
    int? blockedSyncCount,
    bool? syncing,
  }) {
    return ArticlesState(
      published: published ?? this.published,
      mine: mine ?? this.mine,
      pending: pending ?? this.pending,
      taxonomy: taxonomy ?? this.taxonomy,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      publishedHasMore: publishedHasMore ?? this.publishedHasMore,
      error: error ?? this.error,
      fromCache: fromCache ?? this.fromCache,
      pendingSyncCount: pendingSyncCount ?? this.pendingSyncCount,
      blockedSyncCount: blockedSyncCount ?? this.blockedSyncCount,
      syncing: syncing ?? this.syncing,
    );
  }
}

final articlesProvider =
    NotifierProvider<ArticlesNotifier, ArticlesState>(ArticlesNotifier.new);

class ArticlesNotifier extends Notifier<ArticlesState> {
  static const publishedCacheKey = ArticleOfflineCache.publishedKey;
  static const publishedPageSize = 30;

  @override
  ArticlesState build() {
    final published = ArticleOfflineCache.loadPublished();
    final mine = _mergeMineWithOutbox(
      ArticleOfflineCache.loadMine(),
      ArticleSyncOutbox.load(),
    );
    final outbox = ArticleSyncOutbox.load();
    return ArticlesState(
      published: published,
      mine: mine,
      taxonomy: ArticleTaxonomyCache.load(),
      fromCache: published.isNotEmpty || mine.isNotEmpty,
      pendingSyncCount: outbox.where((o) => !o.blocked).length,
      blockedSyncCount: outbox.where((o) => o.blocked).length,
    );
  }

  HomeServerClient get _client => ref.read(homeServerClientProvider);

  List<UserArticle> _mergeMineWithOutbox(
    List<UserArticle> mine,
    List<ArticleSyncOperation> outbox,
  ) {
    if (outbox.isEmpty) return mine;

    final byId = {for (final a in mine) a.id: a};
    for (final op in outbox) {
      switch (op.kind) {
        case ArticleSyncOpKind.delete:
          final id = op.articleId;
          if (id != null) byId.remove(id);
          if (op.tempArticleId != null) byId.remove(op.tempArticleId);
          break;
        case ArticleSyncOpKind.submit:
          final tempId = op.tempArticleId;
          if (tempId != null) byId[tempId] = op.toOptimisticArticle();
          break;
        case ArticleSyncOpKind.update:
          final id = op.articleId;
          if (id != null) {
            final existing = byId[id];
            byId[id] = UserArticle(
              id: id,
              title: op.title,
              body: op.body,
              status: existing?.status ?? UserArticleStatus.pending,
              authorId: op.authorId,
              authorName: op.authorName,
              authorLogin: op.authorLogin,
              rejectReason: existing?.rejectReason,
              createdAt: existing?.createdAt ?? op.queuedAt,
              updatedAt: op.queuedAt,
              category: op.category,
              tags: op.tags,
            );
          }
          break;
      }
    }
    final merged = byId.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return merged;
  }

  void _refreshOutboxCounts() {
    final outbox = ArticleSyncOutbox.load();
    state = state.copyWith(
      pendingSyncCount: outbox.where((o) => !o.blocked).length,
      blockedSyncCount: outbox.where((o) => o.blocked).length,
    );
  }

  Future<void> _persistMine(List<UserArticle> mine) async {
    final serverMine = mine.where((a) => !a.id.startsWith('local-')).toList();
    await ArticleOfflineCache.saveMine(serverMine);
  }

  Future<void> syncPendingChanges() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn || state.syncing) return;

    var outbox = ArticleSyncOutbox.load();
    if (outbox.isEmpty) return;

    state = state.copyWith(syncing: true, error: '');
    var changed = false;

    for (var i = 0; i < outbox.length; i++) {
      final op = outbox[i];
      if (op.blocked) continue;

      try {
        switch (op.kind) {
          case ArticleSyncOpKind.submit:
            final article = await _client.submitArticle(
              auth,
              title: op.title,
              body: op.body,
              category: op.category,
              tags: op.tags,
            );
            outbox.removeAt(i);
            i--;
            changed = true;
            if (op.tempArticleId != null) {
              state = state.copyWith(
                mine: [
                  article,
                  ...state.mine.where(
                    (a) => a.id != op.tempArticleId && a.id != article.id,
                  ),
                ],
              );
            }
            await ArticleStatusNotifications.recordSubmitted(article);
            break;
          case ArticleSyncOpKind.update:
            final articleId = op.articleId;
            if (articleId == null) continue;
            final server = await _client.fetchArticle(auth, articleId);
            if (ArticleSyncConflict.detect(
              baseUpdatedAt: op.baseUpdatedAt,
              pendingTitle: op.title,
              pendingBody: op.body,
              server: server,
            )) {
              outbox[i] = op.copyWith(
                blocked: true,
                serverTitle: server.title,
                serverBody: server.body,
                serverUpdatedAt: server.updatedAt,
              );
              changed = true;
              continue;
            }
            final article = await _client.updateArticle(
              auth,
              articleId,
              title: op.title,
              body: op.body,
              category: op.category,
              tags: op.tags,
            );
            outbox.removeAt(i);
            i--;
            changed = true;
            state = state.copyWith(
              mine: [
                for (final a in state.mine)
                  if (a.id == articleId) article else a,
              ],
            );
            await ArticleDetailCache.put(article);
            break;
          case ArticleSyncOpKind.delete:
            final articleId = op.articleId;
            if (articleId == null) continue;
            await _client.deleteArticle(auth, articleId);
            outbox.removeAt(i);
            i--;
            changed = true;
            state = state.copyWith(
              mine: state.mine.where((a) => a.id != articleId).toList(),
              published: state.published.where((a) => a.id != articleId).toList(),
            );
            break;
        }
      } on DioException catch (e) {
        if (isDioNetworkError(e)) break;
        final code = _client.mapError(e).code;
        if (code == 'not_found' || code == 'forbidden') {
          outbox.removeAt(i);
          i--;
          changed = true;
        } else {
          state = state.copyWith(error: code);
          break;
        }
      }
    }

    if (changed) {
      await ArticleSyncOutbox.replaceAll(outbox);
      await _persistMine(state.mine);
    }

    state = state.copyWith(
      syncing: false,
      mine: _mergeMineWithOutbox(
        state.mine.where((a) => !a.id.startsWith('local-')).toList(),
        outbox,
      ),
    );
    _refreshOutboxCounts();
  }

  Future<bool> resolveSyncConflict({
    required String queueId,
    required String resolution,
  }) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return false;

    final outbox = ArticleSyncOutbox.load();
    final index = outbox.indexWhere((o) => o.queueId == queueId);
    if (index < 0) return false;
    final op = outbox[index];
    if (!op.blocked || op.articleId == null) return false;

    if (resolution == 'remote') {
      try {
        final server = await _client.fetchArticle(auth, op.articleId!);
        outbox.removeAt(index);
        await ArticleSyncOutbox.replaceAll(outbox);
        state = state.copyWith(
          mine: [
            for (final a in state.mine)
              if (a.id == op.articleId) server else a,
          ],
        );
        await _persistMine(state.mine);
        await ArticleDetailCache.put(server);
        _refreshOutboxCounts();
        return true;
      } on DioException catch (e) {
        state = state.copyWith(error: _client.mapError(e).code);
        return false;
      }
    }

    outbox[index] = op.copyWith(blocked: false);
    await ArticleSyncOutbox.replaceAll(outbox);
    _refreshOutboxCounts();
    await syncPendingChanges();
    return true;
  }

  ArticleSyncOperation? blockedOperation(String queueId) {
    for (final op in ArticleSyncOutbox.load()) {
      if (op.queueId == queueId && op.blocked) return op;
    }
    return null;
  }

  List<ArticleSyncOperation> get blockedOperations =>
      ArticleSyncOutbox.load().where((o) => o.blocked).toList();

  Future<void> refreshAll() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return;
    }

    await syncPendingChanges();

    state = state.copyWith(loading: true, error: '');
    try {
      final filters = ref.read(articleFeedFiltersProvider);
      final published = await _client.fetchPublishedArticles(
        auth,
        limit: publishedPageSize,
        offset: 0,
        category: filters.category,
        tag: filters.tag,
      );
      final mine = await _client.fetchMyArticles(auth);
      ArticleTaxonomy? taxonomy;
      try {
        taxonomy = await _client.fetchArticlesTaxonomy(auth);
        await ArticleTaxonomyCache.save(taxonomy);
      } catch (_) {
        taxonomy = state.taxonomy ?? ArticleTaxonomyCache.load();
      }
      List<UserArticle> pending = [];
      if (auth.canModerateArticles) {
        pending = await _client.fetchPendingArticles(auth);
      }
      if (filters.category == null && filters.tag == null) {
        await ArticleOfflineCache.savePublished(published);
      }
      await _persistMine(mine);
      await ArticleStatusNotifications.handleMineList(mine);
      if (auth.canModerateArticles) {
        await ArticleModerationNotifications.handlePendingList(pending);
      }
      final mergedMine = _mergeMineWithOutbox(mine, ArticleSyncOutbox.load());
      state = state.copyWith(
        published: published,
        mine: mergedMine,
        pending: pending,
        taxonomy: taxonomy,
        loading: false,
        publishedHasMore: published.length >= publishedPageSize,
        fromCache: false,
      );
      ref.invalidate(featuredArticlesProvider);
    } on DioException catch (e) {
      final code = _client.mapError(e).code;
      final network = isDioNetworkError(e);
      state = state.copyWith(
        loading: false,
        error: network ? 'network_error' : code,
        fromCache: network &&
            (state.published.isNotEmpty || state.mine.isNotEmpty),
      );
    }
  }

  Future<void> setFeedFilters({String? category, String? tag}) async {
    ref.read(articleFeedFiltersProvider.notifier).state = ArticleFeedFilters(
      category: category,
      tag: tag,
    );
    await refreshPublishedFeed();
  }

  Future<void> refreshPublishedFeed() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return;

    state = state.copyWith(loading: true, error: '');
    try {
      final filters = ref.read(articleFeedFiltersProvider);
      final published = await _client.fetchPublishedArticles(
        auth,
        limit: publishedPageSize,
        offset: 0,
        category: filters.category,
        tag: filters.tag,
      );
      ArticleTaxonomy? taxonomy;
      try {
        taxonomy = await _client.fetchArticlesTaxonomy(auth);
        await ArticleTaxonomyCache.save(taxonomy);
      } catch (_) {
        taxonomy = state.taxonomy ?? ArticleTaxonomyCache.load();
      }
      if (filters.category == null && filters.tag == null) {
        await ArticleOfflineCache.savePublished(published);
      }
      state = state.copyWith(
        published: published,
        taxonomy: taxonomy,
        loading: false,
        publishedHasMore: published.length >= publishedPageSize,
        fromCache: false,
      );
    } on DioException catch (e) {
      final network = isDioNetworkError(e);
      state = state.copyWith(
        loading: false,
        error: network ? 'network_error' : _client.mapError(e).code,
        fromCache: network && state.published.isNotEmpty,
      );
    }
  }

  Future<void> loadMorePublished() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn ||
        state.loadingMore ||
        !state.publishedHasMore ||
        state.loading) {
      return;
    }

    final filters = ref.read(articleFeedFiltersProvider);
    state = state.copyWith(loadingMore: true, error: '');
    try {
      final more = await _client.fetchPublishedArticles(
        auth,
        limit: publishedPageSize,
        offset: state.published.length,
        category: filters.category,
        tag: filters.tag,
      );
      final merged = [...state.published, ...more];
      if (filters.category == null && filters.tag == null) {
        await ArticleOfflineCache.savePublished(merged);
      }
      state = state.copyWith(
        published: merged,
        loadingMore: false,
        publishedHasMore: more.length >= publishedPageSize,
        fromCache: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        loadingMore: false,
        error: isDioNetworkError(e)
            ? 'network_error'
            : _client.mapError(e).code,
      );
    }
  }

  Future<SubmitArticleResult> submit({
    required String title,
    required String body,
    String? category,
    List<String>? tags,
  }) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return const SubmitArticleResult.failed('not_logged_in');
    }
    try {
      final article = await _client.submitArticle(
        auth,
        title: title,
        body: body,
        category: category,
        tags: tags,
      );
      state = state.copyWith(mine: [article, ...state.mine]);
      await _persistMine(state.mine);
      await ArticleStatusNotifications.recordSubmitted(article);
      return SubmitArticleResult.ok(article);
    } on DioException catch (e) {
      if (!isDioNetworkError(e)) {
        final code = _client.mapError(e).code;
        state = state.copyWith(error: code);
        return SubmitArticleResult.failed(code);
      }
      return _queueSubmit(
        auth: auth,
        title: title,
        body: body,
        category: category,
        tags: tags,
      );
    }
  }

  Future<SubmitArticleResult> _queueSubmit({
    required HomeServerAuth auth,
    required String title,
    required String body,
    String? category,
    List<String>? tags,
  }) async {
    final tempId = ArticleSyncOutbox.newTempArticleId();
    final op = ArticleSyncOperation(
      queueId: ArticleSyncOutbox.newQueueId(),
      kind: ArticleSyncOpKind.submit,
      tempArticleId: tempId,
      title: title,
      body: body,
      category: category ?? 'other',
      tags: tags ?? const [],
      queuedAt: DateTime.now().toUtc(),
      authorId: auth.profileId,
      authorName: auth.displayName,
      authorLogin: auth.login,
    );
    await ArticleSyncOutbox.enqueue(op);
    final optimistic = op.toOptimisticArticle();
    state = state.copyWith(
      mine: [optimistic, ...state.mine],
      error: '',
    );
    _refreshOutboxCounts();
    return SubmitArticleResult.queued(optimistic);
  }

  Future<SubmitArticleResult> update({
    required String id,
    required String title,
    required String body,
    String? category,
    List<String>? tags,
    DateTime? baseUpdatedAt,
  }) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return const SubmitArticleResult.failed('not_logged_in');
    }
    try {
      final article = await _client.updateArticle(
        auth,
        id,
        title: title,
        body: body,
        category: category,
        tags: tags,
      );
      state = state.copyWith(
        mine: [
          for (final a in state.mine)
            if (a.id == id) article else a,
        ],
        pending: [
          for (final a in state.pending)
            if (a.id == id) article else a,
        ],
      );
      await _persistMine(state.mine);
      await ArticleDetailCache.put(article);
      return SubmitArticleResult.ok(article);
    } on DioException catch (e) {
      if (!isDioNetworkError(e)) {
        final code = _client.mapError(e).code;
        state = state.copyWith(error: code);
        return SubmitArticleResult.failed(code);
      }
      return _queueUpdate(
        auth: auth,
        id: id,
        title: title,
        body: body,
        category: category,
        tags: tags,
        baseUpdatedAt: baseUpdatedAt,
      );
    }
  }

  Future<SubmitArticleResult> _queueUpdate({
    required HomeServerAuth auth,
    required String id,
    required String title,
    required String body,
    String? category,
    List<String>? tags,
    DateTime? baseUpdatedAt,
  }) async {
    final existing = state.mine.where((a) => a.id == id).firstOrNull;
    final op = ArticleSyncOperation(
      queueId: ArticleSyncOutbox.newQueueId(),
      kind: ArticleSyncOpKind.update,
      articleId: id,
      title: title,
      body: body,
      category: category ?? existing?.category ?? 'other',
      tags: tags ?? existing?.tags ?? const [],
      baseUpdatedAt: baseUpdatedAt ?? existing?.updatedAt,
      queuedAt: DateTime.now().toUtc(),
      authorId: auth.profileId,
      authorName: auth.displayName,
      authorLogin: auth.login,
    );
    await ArticleSyncOutbox.enqueue(op);
    state = state.copyWith(
      mine: _mergeMineWithOutbox(state.mine, ArticleSyncOutbox.load()),
      error: '',
    );
    _refreshOutboxCounts();
    final updated = state.mine.firstWhere((a) => a.id == id);
    return SubmitArticleResult.queued(updated);
  }

  Future<bool> delete(String id) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return false;
    }
    if (id.startsWith('local-')) {
      final outbox = ArticleSyncOutbox.load()
        ..removeWhere((o) => o.tempArticleId == id);
      await ArticleSyncOutbox.replaceAll(outbox);
      state = state.copyWith(
        mine: state.mine.where((a) => a.id != id).toList(),
      );
      _refreshOutboxCounts();
      return true;
    }
    try {
      await _client.deleteArticle(auth, id);
      state = state.copyWith(
        mine: state.mine.where((a) => a.id != id).toList(),
        pending: state.pending.where((a) => a.id != id).toList(),
        published: state.published.where((a) => a.id != id).toList(),
      );
      await ArticleOfflineCache.savePublished(state.published);
      await _persistMine(state.mine);
      ref.invalidate(featuredArticlesProvider);
      return true;
    } on DioException catch (e) {
      if (!isDioNetworkError(e)) {
        state = state.copyWith(error: _client.mapError(e).code);
        return false;
      }
      await ArticleSyncOutbox.enqueue(
        ArticleSyncOperation(
          queueId: ArticleSyncOutbox.newQueueId(),
          kind: ArticleSyncOpKind.delete,
          articleId: id,
          queuedAt: DateTime.now().toUtc(),
          authorId: auth.profileId,
          authorName: auth.displayName,
          authorLogin: auth.login,
        ),
      );
      state = state.copyWith(
        mine: state.mine.where((a) => a.id != id).toList(),
        pending: state.pending.where((a) => a.id != id).toList(),
      );
      _refreshOutboxCounts();
      return true;
    }
  }

  Future<bool> approve(String id) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.canModerateArticles) return false;
    try {
      final article = await _client.approveArticle(auth, id);
      state = state.copyWith(
        pending: state.pending.where((a) => a.id != id).toList(),
        published: [article, ...state.published],
      );
      await ArticleOfflineCache.savePublished(state.published);
      ref.invalidate(featuredArticlesProvider);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return false;
    }
  }

  Future<bool> reject(String id, {String? reason}) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.canModerateArticles) return false;
    try {
      await _client.rejectArticle(auth, id, reason: reason);
      state = state.copyWith(
        pending: state.pending.where((a) => a.id != id).toList(),
      );
      return true;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return false;
    }
  }
}

class SubmitArticleResult {
  const SubmitArticleResult._({
    required this.status,
    this.article,
    this.error = '',
  });

  final SubmitArticleStatus status;
  final UserArticle? article;
  final String error;

  const SubmitArticleResult.ok(UserArticle article)
      : this._(status: SubmitArticleStatus.ok, article: article);

  const SubmitArticleResult.queued(UserArticle article)
      : this._(status: SubmitArticleStatus.queued, article: article);

  const SubmitArticleResult.failed(String code)
      : this._(status: SubmitArticleStatus.failed, error: code);
}

enum SubmitArticleStatus { ok, queued, failed }

final featuredArticlesProvider = FutureProvider<List<UserArticle>>((ref) async {
  final auth = ref.watch(homeServerProvider).auth;
  if (!auth.isLoggedIn) return [];
  final client = ref.watch(homeServerClientProvider);
  try {
    return await client.fetchFeaturedArticles(auth, limit: 5);
  } on DioException {
    return ArticleOfflineCache.loadPublished().where((a) => a.featured).take(5).toList();
  }
});

final pendingArticlesCountProvider = Provider<int>((ref) {
  final auth = ref.watch(homeServerProvider).auth;
  if (!auth.canModerateArticles) return 0;
  return ref.watch(articlesProvider).pending.length;
});

final unreadArticlesCountProvider = Provider<int>((ref) {
  final published = ref.watch(articlesProvider).published;
  return ArticleReadTracker.unreadCount(published);
});

final articlePendingSyncCountProvider = Provider<int>((ref) {
  return ref.watch(articlesProvider).pendingSyncCount;
});

final articleBlockedSyncCountProvider = Provider<int>((ref) {
  return ref.watch(articlesProvider).blockedSyncCount;
});
