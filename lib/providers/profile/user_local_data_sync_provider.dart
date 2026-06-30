import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/user_local_data_bundle.dart';
import '../../core/utils/user_local_data_sync_preferences.dart';
import '../../data/services/cache_service.dart';
import '../profile/home_server_provider.dart';
import '../profile/user_profile_provider.dart';
import '../user_calendar_provider.dart';

class UserLocalDataSyncState {
  const UserLocalDataSyncState({
    this.busy = false,
    this.lastError = '',
    this.remoteFingerprint,
    this.remoteUpdatedAt,
    this.lastSyncedAt,
  });

  final bool busy;
  final String lastError;
  final String? remoteFingerprint;
  final DateTime? remoteUpdatedAt;
  final DateTime? lastSyncedAt;

  UserLocalDataSyncState copyWith({
    bool? busy,
    String? lastError,
    String? remoteFingerprint,
    DateTime? remoteUpdatedAt,
    DateTime? lastSyncedAt,
    bool clearRemote = false,
  }) {
    return UserLocalDataSyncState(
      busy: busy ?? this.busy,
      lastError: lastError ?? this.lastError,
      remoteFingerprint:
          clearRemote ? null : remoteFingerprint ?? this.remoteFingerprint,
      remoteUpdatedAt:
          clearRemote ? null : remoteUpdatedAt ?? this.remoteUpdatedAt,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
    );
  }
}

final userLocalDataSyncProvider =
    NotifierProvider<UserLocalDataSyncNotifier, UserLocalDataSyncState>(
  UserLocalDataSyncNotifier.new,
);

class UserLocalDataSyncNotifier extends Notifier<UserLocalDataSyncState> {
  static const cacheKey = 'user_local_data_sync_meta_v1';

  @override
  UserLocalDataSyncState build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return const UserLocalDataSyncState();
    try {
      final at = DateTime.tryParse(raw);
      return UserLocalDataSyncState(lastSyncedAt: at);
    } catch (_) {
      return const UserLocalDataSyncState();
    }
  }

  Map<String, dynamic> _localPayload() {
    final profile = ref.read(userProfileProvider);
    final events = ref.read(userCalendarProvider);
    final settings = ref.read(userCalendarSettingsProvider);
    return UserLocalDataBundle.build(
      events: events,
      calendarSettingsJson: jsonEncode(settings.toJson()),
      useCustomAvatar: profile.useCustomAvatar,
    );
  }

  Future<void> refreshRemote() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) {
      state = state.copyWith(clearRemote: true, lastError: 'not_logged_in');
      return;
    }

    state = state.copyWith(busy: true, lastError: '');
    try {
      final remote = await ref.read(homeServerClientProvider).fetchLocalData(auth);
      if (remote == null) {
        state = state.copyWith(busy: false, clearRemote: true);
        return;
      }
      state = state.copyWith(
        busy: false,
        remoteFingerprint: remote['fingerprint'] as String?,
        remoteUpdatedAt: DateTime.tryParse(remote['updatedAt'] as String? ?? ''),
      );
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
    } catch (_) {
      state = state.copyWith(busy: false, lastError: 'network_error');
    }
  }

  Future<bool> pushToServer() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return false;

    final payload = _localPayload();
    state = state.copyWith(busy: true, lastError: '');
    try {
      final result =
          await ref.read(homeServerClientProvider).putLocalData(auth, payload);
      final now = DateTime.now();
      await _persist(now);
      final updatedRaw = result['updatedAt'] as String?;
      state = state.copyWith(
        busy: false,
        remoteFingerprint: payload['fingerprint'] as String?,
        remoteUpdatedAt: updatedRaw == null
            ? now
            : DateTime.tryParse(updatedRaw),
        lastSyncedAt: now,
      );
      return true;
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
      return false;
    } catch (_) {
      state = state.copyWith(busy: false, lastError: 'network_error');
      return false;
    }
  }

  Future<bool> pullFromServer() async {
    final auth = ref.read(homeServerProvider).auth;
    if (!auth.isLoggedIn) return false;

    state = state.copyWith(busy: true, lastError: '');
    try {
      final remote = await ref.read(homeServerClientProvider).fetchLocalData(auth);
      if (remote == null) {
        state = state.copyWith(busy: false, lastError: 'not_found');
        return false;
      }
      await UserLocalDataBundle.apply(remote);
      ref.invalidate(userCalendarProvider);
      ref.invalidate(userCalendarSettingsProvider);
      ref.invalidate(userProfileProvider);

      final now = DateTime.now();
      await _persist(now);
      state = state.copyWith(
        busy: false,
        remoteFingerprint: remote['fingerprint'] as String?,
        remoteUpdatedAt: DateTime.tryParse(remote['updatedAt'] as String? ?? ''),
        lastSyncedAt: now,
      );
      return true;
    } on DioException catch (e) {
      final err = ref.read(homeServerClientProvider).mapError(e);
      state = state.copyWith(busy: false, lastError: err.code);
      return false;
    } catch (_) {
      state = state.copyWith(busy: false, lastError: 'network_error');
      return false;
    }
  }

  Future<bool> smartSyncAuto() async {
    if (!await UserLocalDataSyncPreferences.canAutoSync()) {
      return false;
    }
    final ready = await prepareSync();
    if (!ready) return false;
    return _resolveSync();
  }

  bool get isConflict {
    final remoteFp = state.remoteFingerprint;
    if (remoteFp == null) return false;
    final localFp = _localPayload()['fingerprint'] as String?;
    return localFp != null && localFp != remoteFp;
  }

  Future<bool> prepareSync() => refreshRemote().then((_) => state.lastError.isEmpty);

  Future<bool> smartSync({String? conflictResolution}) async {
    final ready = await prepareSync();
    if (!ready) return false;
    return applySyncChoice(conflictResolution: conflictResolution);
  }

  Future<bool> applySyncChoice({String? conflictResolution}) =>
      _resolveSync(conflictResolution: conflictResolution);

  Future<bool> _resolveSync({String? conflictResolution}) async {
    final local = _localPayload();
    final localFp = local['fingerprint'] as String?;
    final remoteFp = state.remoteFingerprint;

    if (remoteFp == null) {
      return pushToServer();
    }
    if (remoteFp == localFp) {
      return true;
    }

    if (conflictResolution == 'local') {
      return pushToServer();
    }
    if (conflictResolution == 'remote') {
      return pullFromServer();
    }

    final remoteAt =
        state.remoteUpdatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final localAt = DateTime.tryParse(local['updatedAt'] as String? ?? '') ??
        DateTime.now();
    if (localAt.isAfter(remoteAt)) {
      return pushToServer();
    }
    return pullFromServer();
  }

  Future<void> _persist(DateTime when) async {
    await CacheService.instance.putString(cacheKey, when.toIso8601String());
  }
}
