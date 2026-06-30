import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/profile/home_server_provider.dart';
import '../../providers/profile/user_local_data_sync_provider.dart';
import 'user_local_data_sync_preferences.dart';

/// Отложенная отправка локальных данных на сервер после изменений.
class UserLocalDataAutoSync {
  UserLocalDataAutoSync._();

  static Timer? _timer;
  static WidgetRef? _boundRef;

  /// Привязка ref из shell для auto-push community prefs без провайдера.
  static void bind(WidgetRef ref) => _boundRef = ref;

  static void schedulePush(Ref ref) {
    if (!UserLocalDataSyncPreferences.autoPushOnChange) return;

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () async {
      final auth = ref.read(homeServerProvider).auth;
      if (!auth.isLoggedIn) return;
      if (!await UserLocalDataSyncPreferences.canAutoSync()) return;
      await ref.read(userLocalDataSyncProvider.notifier).pushToServer();
    });
  }

  static void onCommunityPrefsChanged() {
    final ref = _boundRef;
    if (ref == null) return;
    if (!UserLocalDataSyncPreferences.autoPushOnChange) return;

    _timer?.cancel();
    _timer = Timer(const Duration(seconds: 2), () async {
      final auth = ref.read(homeServerProvider).auth;
      if (!auth.isLoggedIn) return;
      if (!await UserLocalDataSyncPreferences.canAutoSync()) return;
      await ref.read(userLocalDataSyncProvider.notifier).pushToServer();
    });
  }
}
