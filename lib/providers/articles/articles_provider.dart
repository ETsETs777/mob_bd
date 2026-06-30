import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/article_status_notifications.dart';
import '../../core/utils/article_read_tracker.dart';
import '../../data/models/user_article.dart';
import '../../data/services/cache_service.dart';
import '../../data/services/home_server_client.dart';
import '../profile/home_server_provider.dart';

class ArticlesState {
  const ArticlesState({
    this.published = const [],
    this.mine = const [],
    this.pending = const [],
    this.loading = false,
    this.loadingMore = false,
    this.publishedHasMore = true,
    this.error = '',
  });

  final List<UserArticle> published;
  final List<UserArticle> mine;
  final List<UserArticle> pending;
  final bool loading;
  final bool loadingMore;
  final bool publishedHasMore;
  final String error;

  ArticlesState copyWith({
    List<UserArticle>? published,
    List<UserArticle>? mine,
    List<UserArticle>? pending,
    bool? loading,
    bool? loadingMore,
    bool? publishedHasMore,
    String? error,
  }) {
    return ArticlesState(
      published: published ?? this.published,
      mine: mine ?? this.mine,
      pending: pending ?? this.pending,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      publishedHasMore: publishedHasMore ?? this.publishedHasMore,
      error: error ?? this.error,
    );
  }
}

final articlesProvider =
    NotifierProvider<ArticlesNotifier, ArticlesState>(ArticlesNotifier.new);

class ArticlesNotifier extends Notifier<ArticlesState> {
  static const publishedCacheKey = 'user_articles_published_cache';
  static const publishedPageSize = 30;

  @override
  ArticlesState build() {
    final cached = _loadPublishedCache();
    return ArticlesState(published: cached);
  }

  List<UserArticle> _loadPublishedCache() {
    final raw = CacheService.instance.getString(publishedCacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => UserArticle.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> _cachePublished(List<UserArticle> articles) async {
    await CacheService.instance.putString(
      publishedCacheKey,
      jsonEncode(articles.map((a) => {
            'id': a.id,
            'title': a.title,
            'body': a.body,
            'status': a.status.name,
            'authorId': a.authorId,
            'authorName': a.authorName,
            'authorLogin': a.authorLogin,
            'createdAt': a.createdAt.toIso8601String(),
            'updatedAt': a.updatedAt.toIso8601String(),
          }).toList()),
    );
  }

  HomeServerClient get _client => ref.read(homeServerClientProvider);

  Future<void> refreshAll() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return;
    }

    state = state.copyWith(loading: true, error: '');
    try {
      final published = await _client.fetchPublishedArticles(
        auth,
        limit: publishedPageSize,
        offset: 0,
      );
      final mine = await _client.fetchMyArticles(auth);
      List<UserArticle> pending = [];
      if (auth.isAdmin) {
        pending = await _client.fetchPendingArticles(auth);
      }
      await _cachePublished(published);
      await ArticleStatusNotifications.handleMineList(mine);
      state = state.copyWith(
        published: published,
        mine: mine,
        pending: pending,
        loading: false,
        publishedHasMore: published.length >= publishedPageSize,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: _client.mapError(e).code,
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

    state = state.copyWith(loadingMore: true, error: '');
    try {
      final more = await _client.fetchPublishedArticles(
        auth,
        limit: publishedPageSize,
        offset: state.published.length,
      );
      final merged = [...state.published, ...more];
      await _cachePublished(merged);
      state = state.copyWith(
        published: merged,
        loadingMore: false,
        publishedHasMore: more.length >= publishedPageSize,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        loadingMore: false,
        error: _client.mapError(e).code,
      );
    }
  }

  Future<UserArticle?> submit({
    required String title,
    required String body,
  }) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return null;
    }
    try {
      final article = await _client.submitArticle(
        auth,
        title: title,
        body: body,
      );
      state = state.copyWith(mine: [article, ...state.mine]);
      await ArticleStatusNotifications.recordSubmitted(article);
      return article;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return null;
    }
  }

  Future<UserArticle?> update({
    required String id,
    required String title,
    required String body,
  }) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return null;
    }
    try {
      final article = await _client.updateArticle(
        auth,
        id,
        title: title,
        body: body,
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
      return article;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return null;
    }
  }

  Future<bool> delete(String id) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(error: 'not_logged_in');
      return false;
    }
    try {
      await _client.deleteArticle(auth, id);
      state = state.copyWith(
        mine: state.mine.where((a) => a.id != id).toList(),
        pending: state.pending.where((a) => a.id != id).toList(),
        published: state.published.where((a) => a.id != id).toList(),
      );
      await _cachePublished(state.published);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return false;
    }
  }

  Future<bool> approve(String id) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isAdmin) return false;
    try {
      final article = await _client.approveArticle(auth, id);
      state = state.copyWith(
        pending: state.pending.where((a) => a.id != id).toList(),
        published: [article, ...state.published],
      );
      await _cachePublished(state.published);
      return true;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return false;
    }
  }

  Future<bool> reject(String id, {String? reason}) async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isAdmin) return false;
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

final pendingArticlesCountProvider = Provider<int>((ref) {
  final auth = ref.watch(homeServerProvider).auth;
  if (!auth.isAdmin) return 0;
  return ref.watch(articlesProvider).pending.length;
});

final unreadArticlesCountProvider = Provider<int>((ref) {
  final published = ref.watch(articlesProvider).published;
  return ArticleReadTracker.unreadCount(published);
});
