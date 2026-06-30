import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/home_server_auth.dart';
import '../../data/services/home_server_client.dart';
import '../../data/services/cache_service.dart';
import 'package:ecopulse/providers/profile/user_profile_provider.dart';
import 'package:ecopulse/providers/messages/message_push_provider.dart';
import 'package:ecopulse/providers/profile/user_local_data_sync_provider.dart';

enum HomeServerOnlineStatus { unknown, online, offline }

class HomeServerState {
  const HomeServerState({
    this.auth = const HomeServerAuth(),
    this.online = HomeServerOnlineStatus.unknown,
    this.busy = false,
    this.lastError = '',
  });

  final HomeServerAuth auth;
  final HomeServerOnlineStatus online;
  final bool busy;
  final String lastError;

  HomeServerState copyWith({
    HomeServerAuth? auth,
    HomeServerOnlineStatus? online,
    bool? busy,
    String? lastError,
  }) {
    return HomeServerState(
      auth: auth ?? this.auth,
      online: online ?? this.online,
      busy: busy ?? this.busy,
      lastError: lastError ?? this.lastError,
    );
  }
}

final homeServerClientProvider = Provider<HomeServerClient>((ref) {
  return HomeServerClient();
});

final homeServerProvider =
    NotifierProvider<HomeServerNotifier, HomeServerState>(HomeServerNotifier.new);

class HomeServerNotifier extends Notifier<HomeServerState> {
  static const cacheKey = 'home_server_auth';

  @override
  HomeServerState build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return const HomeServerState();
    try {
      final auth = HomeServerAuth.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      return HomeServerState(auth: auth);
    } catch (_) {
      return const HomeServerState();
    }
  }

  Future<void> _persist(HomeServerAuth auth) async {
    await CacheService.instance.putString(cacheKey, jsonEncode(auth.toJson()));
  }

  Future<void> setServerUrl(String url) async {
    final auth = state.auth.copyWith(serverUrl: url.trim());
    state = state.copyWith(auth: auth, lastError: '');
    await _persist(auth);
  }

  Future<bool> checkHealth() async {
    final url = state.auth.serverUrl.trim();
    if (url.isEmpty) {
      state = state.copyWith(
        online: HomeServerOnlineStatus.offline,
        lastError: 'no_url',
      );
      return false;
    }

    state = state.copyWith(busy: true, lastError: '');
    try {
      final client = ref.read(homeServerClientProvider);
      final data = await client.health(url);
      final auth = state.auth.copyWith(
        minAppVersion: data['minAppVersion']?.toString() ?? '',
        serverVersion: data['serverVersion']?.toString() ?? '',
        apiVersion: data['apiVersion']?.toString() ?? '1',
      );
      state = state.copyWith(
        auth: auth,
        online: HomeServerOnlineStatus.online,
        busy: false,
      );
      await _persist(auth);
      return true;
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(
        online: HomeServerOnlineStatus.offline,
        busy: false,
        lastError: err.code,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        online: HomeServerOnlineStatus.offline,
        busy: false,
        lastError: 'network_error',
      );
      return false;
    }
  }

  Future<bool> register({
    required String login,
    required String password,
    String displayName = '',
    String avatarEmoji = '📈',
  }) async {
    final url = state.auth.serverUrl.trim();
    if (url.isEmpty) return false;

    state = state.copyWith(busy: true, lastError: '');
    try {
      final client = ref.read(homeServerClientProvider);
      final auth = await client.register(
        serverUrl: url,
        login: login,
        password: password,
        displayName: displayName,
        avatarEmoji: avatarEmoji,
      );
      state = state.copyWith(
        auth: auth,
        online: HomeServerOnlineStatus.online,
        busy: false,
      );
      await _persist(auth);
      await _syncLocalProfile(auth);
      await refreshSession();
      ref.read(userLocalDataSyncProvider.notifier).smartSyncAuto();
      await ref.read(messagePushProvider.notifier).syncPushToken();
      return true;
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
      return false;
    } on HomeServerException catch (e) {
      state = state.copyWith(busy: false, lastError: e.code);
      return false;
    }
  }

  Future<bool> login({
    required String login,
    required String password,
  }) async {
    final url = state.auth.serverUrl.trim();
    if (url.isEmpty) return false;

    state = state.copyWith(busy: true, lastError: '');
    try {
      final client = ref.read(homeServerClientProvider);
      final auth = await client.login(
        serverUrl: url,
        login: login,
        password: password,
      );
      state = state.copyWith(
        auth: auth,
        online: HomeServerOnlineStatus.online,
        busy: false,
      );
      await _persist(auth);
      await _syncLocalProfile(auth);
      await refreshSession();
      ref.read(userLocalDataSyncProvider.notifier).smartSyncAuto();
      await ref.read(messagePushProvider.notifier).syncPushToken();
      return true;
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
      return false;
    } on HomeServerException catch (e) {
      state = state.copyWith(busy: false, lastError: e.code);
      return false;
    }
  }

  Future<void> logout() async {
    await ref.read(messagePushProvider.notifier).unregisterPushToken();
    final auth = state.auth;
    if (auth.isLoggedIn) {
      await ref.read(homeServerClientProvider).logout(auth);
    }
    final cleared = auth.copyWith(clearToken: true);
    state = state.copyWith(auth: cleared, lastError: '');
    await _persist(cleared);
  }

  Future<bool> syncProfileToServer({
    String? displayName,
    String? avatarEmoji,
  }) async {
    final auth = state.auth;
    if (!auth.isLoggedIn) return false;

    try {
      final client = ref.read(homeServerClientProvider);
      final data = await client.updateProfile(
        auth,
        displayName: displayName,
        avatarEmoji: avatarEmoji,
      );
      final updated = auth.copyWith(
        displayName: data['displayName'] as String? ?? auth.displayName,
        avatarEmoji: data['avatarEmoji'] as String? ?? auth.avatarEmoji,
      );
      state = state.copyWith(auth: updated);
      await _persist(updated);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> loadFromJson(Map<String, dynamic> json) async {
    final auth = HomeServerAuth.fromJson(json);
    state = state.copyWith(auth: auth);
    await _persist(auth);
  }

  /// Обновляет профиль и права (isAdmin) с сервера без перелогина.
  Future<void> refreshSession() async {
    final auth = state.auth;
    if (!auth.isLoggedIn) return;

    try {
      final data = await ref.read(homeServerClientProvider).fetchProfile(auth);
      final updated = auth.copyWith(
        displayName: data['displayName'] as String? ?? auth.displayName,
        avatarEmoji: data['avatarEmoji'] as String? ?? auth.avatarEmoji,
        role: data['role'] as String? ?? auth.role,
        isAdmin: data['isAdmin'] as bool? ?? auth.isAdmin,
        canModerate: data['canModerate'] as bool? ?? auth.canModerate,
        canEditContent: data['canEditContent'] as bool? ?? auth.canEditContent,
        isStaff: data['isStaff'] as bool? ?? auth.isStaff,
      );
      if (updated.displayName != auth.displayName ||
          updated.avatarEmoji != auth.avatarEmoji ||
          updated.role != auth.role ||
          updated.isAdmin != auth.isAdmin ||
          updated.canModerate != auth.canModerate ||
          updated.canEditContent != auth.canEditContent ||
          updated.isStaff != auth.isStaff) {
        state = state.copyWith(auth: updated);
        await _persist(updated);
        await _syncLocalProfile(updated);
      }
    } catch (_) {
      // ignore transient network errors
    }
  }

  Future<void> _syncLocalProfile(HomeServerAuth auth) async {
    await ref.read(userProfileProvider.notifier).update(
          ref.read(userProfileProvider).copyWith(
                profileId: auth.profileId,
                displayName: auth.displayName.isNotEmpty
                    ? auth.displayName
                    : ref.read(userProfileProvider).displayName,
                avatarEmoji: auth.avatarEmoji,
              ),
        );
  }
}
