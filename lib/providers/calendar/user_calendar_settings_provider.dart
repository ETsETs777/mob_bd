import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_calendar_settings.dart';
import '../../data/services/cache_service.dart';

final userCalendarSettingsProvider =
    NotifierProvider<UserCalendarSettingsNotifier, UserCalendarSettings>(
  UserCalendarSettingsNotifier.new,
);

class UserCalendarSettingsNotifier extends Notifier<UserCalendarSettings> {
  static const cacheKey = 'user_calendar_settings_v1';

  @override
  UserCalendarSettings build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return const UserCalendarSettings();
    try {
      return UserCalendarSettings.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const UserCalendarSettings();
    }
  }

  Future<void> setShowPortfolioEvents(bool value) async {
    state = state.copyWith(showPortfolioEvents: value);
    await _persist();
  }

  Future<void> _persist() async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.toJson()),
    );
  }
}
