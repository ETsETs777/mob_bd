// =============================================================================
// EcoPulse · lib/providers/user_profile_provider.dart
// Автор: Цымбал Е. В.
// Дата: 25.05.2026
// Riverpod state: провайдеры и notifiers. Файл: user_profile_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_profile.dart';
import '../../data/services/cache_service.dart';

/// Riverpod-провайдер [userProfileProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
final userProfileProvider =
    NotifierProvider<UserProfileNotifier, UserProfile>(UserProfileNotifier.new);

/// Riverpod AsyncNotifier [UserProfileNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
class UserProfileNotifier extends Notifier<UserProfile> {
/// Поле [cacheKey] класса [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  static const cacheKey = 'user_profile';

/// Отрисовывает UI [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  @override
  UserProfile build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return const UserProfile();
    try {
      return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const UserProfile();
    }
  }

/// Метод [update] класса [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> update(UserProfile profile) async {
    state = profile;
    await _persist();
  }

/// Метод [setDisplayName] класса [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  Future<void> setDisplayName(String name) async {
    state = state.copyWith(displayName: name.trim());
    await _persist();
  }

/// Метод [setAvatarEmoji] класса [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  Future<void> setAvatarEmoji(String emoji) async {
    state = state.copyWith(avatarEmoji: emoji);
    await _persist();
  }

/// Метод [setCountryCode] класса [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  Future<void> setCountryCode(String code) async {
    state = state.copyWith(countryCode: code);
    await _persist();
  }

  Future<void> setEmail(String email) async {
    state = state.copyWith(email: email.trim());
    await _persist();
  }

  Future<void> setPhone(String phone) async {
    state = state.copyWith(phone: phone.trim());
    await _persist();
  }

/// Метод [loadFromJson] класса [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  Future<void> loadFromJson(Map<String, dynamic> json) async {
    state = UserProfile.fromJson(json);
    await _persist();
  }

/// Приватный метод [_persist] класса [UserProfileNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> _persist() async {
    await CacheService.instance.putString(
      cacheKey,
      jsonEncode(state.toJson()),
    );
  }
}
