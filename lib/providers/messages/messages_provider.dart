import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/message_read_tracker.dart';
import '../../data/models/chat_thread.dart';
import '../../data/models/user_message.dart';
import '../../data/services/cache_service.dart';
import '../../data/services/home_server_client.dart';
import 'package:ecopulse/providers/profile/home_server_provider.dart';
import 'message_push_provider.dart';

class MessagesState {
  const MessagesState({
    this.threads = const [],
    this.messagesByThread = const {},
    this.messagesHasMore = const {},
    this.loadingOlder = false,
    this.loading = false,
    this.error = '',
    this.activeThreadId = '',
  });

  final List<ChatThread> threads;
  final Map<String, List<UserMessage>> messagesByThread;
  final Map<String, bool> messagesHasMore;
  final bool loadingOlder;
  final bool loading;
  final String error;
  final String activeThreadId;

  MessagesState copyWith({
    List<ChatThread>? threads,
    Map<String, List<UserMessage>>? messagesByThread,
    Map<String, bool>? messagesHasMore,
    bool? loadingOlder,
    bool? loading,
    String? error,
    String? activeThreadId,
  }) {
    return MessagesState(
      threads: threads ?? this.threads,
      messagesByThread: messagesByThread ?? this.messagesByThread,
      messagesHasMore: messagesHasMore ?? this.messagesHasMore,
      loadingOlder: loadingOlder ?? this.loadingOlder,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      activeThreadId: activeThreadId ?? this.activeThreadId,
    );
  }
}

final messagesProvider =
    NotifierProvider<MessagesNotifier, MessagesState>(MessagesNotifier.new);

class MessagesNotifier extends Notifier<MessagesState> {
  static const _threadsCacheKey = 'home_server_threads_cache';
  static const messagesPageSize = 50;
  Timer? _pollTimer;

  @override
  MessagesState build() {
    ref.onDispose(() => _pollTimer?.cancel());
    _loadCache();
    return const MessagesState();
  }

  void _loadCache() {
    final raw = CacheService.instance.getString(_threadsCacheKey);
    if (raw == null || raw.isEmpty) return;
    try {
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => ChatThread.fromJson(e as Map<String, dynamic>))
          .toList();
      state = state.copyWith(threads: list);
    } catch (_) {}
  }

  Future<void> _persistThreads(List<ChatThread> threads) async {
    await CacheService.instance.putString(
      _threadsCacheKey,
      jsonEncode(threads.map((t) => t.toJson()).toList()),
    );
  }

  HomeServerClient get _client => ref.read(homeServerClientProvider);

  bool get _canSync => ref.read(homeServerProvider).auth.isLoggedIn;

  Future<void> refreshThreads() async {
    if (!_canSync) return;
    final auth = ref.read(homeServerProvider).auth;
    final previous = state.threads;
    state = state.copyWith(loading: true, error: '');
    try {
      final threads = await _client.fetchThreads(auth);
      state = state.copyWith(threads: threads, loading: false);
      await _persistThreads(threads);
      await ref.read(messagePushProvider.notifier).notifyNewThreads(
            previous: previous,
            current: threads,
            activeThreadId: state.activeThreadId,
          );
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: _client.mapError(e).code,
      );
    }
  }

  Future<void> ensureSelfThread() async {
    if (!_canSync) return;
    final auth = ref.read(homeServerProvider).auth;
    try {
      await _client.createDirect(auth, self: true);
      await refreshThreads();
    } catch (_) {}
  }

  Future<ChatThread?> openDirect({String? targetProfileId, bool self = false}) async {
    if (!_canSync) return null;
    final auth = ref.read(homeServerProvider).auth;
    try {
      final thread = await _client.createDirect(
        auth,
        targetProfileId: targetProfileId,
        self: self,
      );
      await refreshThreads();
      return thread;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return null;
    }
  }

  Future<void> loadMessages(String threadId) async {
    if (!_canSync) return;
    final auth = ref.read(homeServerProvider).auth;
    state = state.copyWith(activeThreadId: threadId, loading: true, error: '');
    try {
      final fetched = await _client.fetchMessages(
        auth,
        threadId,
        limit: messagesPageSize,
      );
      final map = Map<String, List<UserMessage>>.from(state.messagesByThread);
      final existing = map[threadId] ?? [];
      map[threadId] = _mergeMessages(existing, fetched);
      final hasMore = Map<String, bool>.from(state.messagesHasMore);
      hasMore[threadId] = fetched.length >= messagesPageSize;
      state = state.copyWith(
        messagesByThread: map,
        messagesHasMore: hasMore,
        loading: false,
      );
      await _markThreadRead(threadId);
    } on DioException catch (e) {
      state = state.copyWith(
        loading: false,
        error: _client.mapError(e).code,
      );
    }
  }

  Future<void> loadOlderMessages(String threadId) async {
    if (!_canSync || state.loadingOlder) return;
    final existing = state.messagesByThread[threadId] ?? [];
    if (existing.isEmpty) return;
    if (state.messagesHasMore[threadId] == false) return;

    final auth = ref.read(homeServerProvider).auth;
    state = state.copyWith(loadingOlder: true, error: '');
    try {
      final older = await _client.fetchMessages(
        auth,
        threadId,
        limit: messagesPageSize,
        before: existing.first.createdAt,
      );
      if (older.isEmpty) {
        final hasMore = Map<String, bool>.from(state.messagesHasMore);
        hasMore[threadId] = false;
        state = state.copyWith(messagesHasMore: hasMore, loadingOlder: false);
        return;
      }
      final map = Map<String, List<UserMessage>>.from(state.messagesByThread);
      map[threadId] = _mergeMessages(older, existing);
      final hasMore = Map<String, bool>.from(state.messagesHasMore);
      hasMore[threadId] = older.length >= messagesPageSize;
      state = state.copyWith(
        messagesByThread: map,
        messagesHasMore: hasMore,
        loadingOlder: false,
      );
    } on DioException catch (e) {
      state = state.copyWith(
        loadingOlder: false,
        error: _client.mapError(e).code,
      );
    }
  }

  List<UserMessage> _mergeMessages(
    List<UserMessage> first,
    List<UserMessage> second,
  ) {
    final byId = <String, UserMessage>{};
    for (final message in [...first, ...second]) {
      byId[message.id] = message;
    }
    final merged = byId.values.toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return merged;
  }

  Future<void> _markThreadRead(String threadId) async {
    ChatThread? thread;
    for (final t in state.threads) {
      if (t.id == threadId) {
        thread = t;
        break;
      }
    }
    if (thread != null) {
      await MessageReadTracker.markRead(threadId, lastAt: thread.lastAt);
    }
  }

  Future<bool> sendMessage(String threadId, String text) async {
    if (!_canSync) return false;
    final auth = ref.read(homeServerProvider).auth;
    try {
      final message = await _client.sendMessage(auth, threadId, text);
      final map = Map<String, List<UserMessage>>.from(state.messagesByThread);
      final list = List<UserMessage>.from(map[threadId] ?? [])..add(message);
      map[threadId] = list;
      state = state.copyWith(messagesByThread: map);
      await refreshThreads();
      return true;
    } on DioException catch (e) {
      state = state.copyWith(error: _client.mapError(e).code);
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    if (!_canSync) return [];
    final auth = ref.read(homeServerProvider).auth;
    try {
      return await _client.searchUsers(auth, query);
    } catch (_) {
      return [];
    }
  }

  void startPolling(String threadId) {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      loadMessages(threadId);
      refreshThreads();
    });
  }

  void stopPolling() {
    _pollTimer?.cancel();
    _pollTimer = null;
  }

  void clearOnLogout() {
    stopPolling();
    state = const MessagesState();
    CacheService.instance.deleteKey(_threadsCacheKey);
  }
}

final unreadMessagesCountProvider = Provider<int>((ref) {
  ref.watch(messagesProvider);
  return MessageReadTracker.unreadCount(ref.read(messagesProvider).threads);
});
