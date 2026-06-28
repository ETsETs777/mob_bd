// =============================================================================
// EcoPulse · lib/providers/morning_digest_provider.dart
// Автор: Цымбал Е. В.
// Дата: 22.05.2026
// Riverpod state: провайдеры и notifiers. Файл: morning_digest_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';
import 'app_providers.dart';

/// Класс [MorningDigestSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
class MorningDigestSettings {
/// Создаёт [MorningDigestSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  const MorningDigestSettings({
    this.enabled = false,
    this.hour = 8,
  });

/// Поле [enabled] класса [MorningDigestSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  final bool enabled;
/// Поле [hour] класса [MorningDigestSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  final int hour;

/// Метод [copyWith] класса [MorningDigestSettings].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  MorningDigestSettings copyWith({bool? enabled, int? hour}) {
    return MorningDigestSettings(
      enabled: enabled ?? this.enabled,
      hour: hour ?? this.hour,
    );
  }
}

/// Riverpod-провайдер [morningDigestProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
final morningDigestProvider =
    NotifierProvider<MorningDigestNotifier, MorningDigestSettings>(
  MorningDigestNotifier.new,
);

/// Riverpod AsyncNotifier [MorningDigestNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
class MorningDigestNotifier extends Notifier<MorningDigestSettings> {
/// Поле [enabledKey] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  static const enabledKey = 'morning_digest_enabled';
/// Поле [hourKey] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  static const hourKey = 'morning_digest_hour';
/// Поле [lastSentKey] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  static const lastSentKey = 'morning_digest_last_sent';
/// Поле [snapshotKey] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  static const snapshotKey = 'morning_digest_snapshot';

/// Отрисовывает UI [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  @override
  MorningDigestSettings build() {
    final cache = ref.watch(cacheServiceProvider);
    final enabled = cache.getString(enabledKey) == '1';
    final hourRaw = int.tryParse(cache.getString(hourKey) ?? '') ?? 8;
    return MorningDigestSettings(
      enabled: enabled,
      hour: hourRaw.clamp(6, 11),
    );
  }

/// Метод [setEnabled] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> setEnabled(bool value) async {
    await ref.read(cacheServiceProvider).putString(enabledKey, value ? '1' : '0');
    state = state.copyWith(enabled: value);
  }

/// Метод [setHour] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  Future<void> setHour(int hour) async {
    final clamped = hour.clamp(6, 11);
    await ref.read(cacheServiceProvider).putString(hourKey, clamped.toString());
    state = state.copyWith(hour: clamped);
  }

/// Метод [lastSentDate] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  static DateTime? lastSentDate(CacheService cache) {
    final raw = cache.getString(lastSentKey);
    if (raw == null || raw.isEmpty) return null;
    return DateTime.tryParse(raw);
  }

/// Метод [markSent] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  static Future<void> markSent(CacheService cache) async {
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);
    await cache.putString(lastSentKey, dateOnly.toIso8601String());
  }

/// Метод [saveSnapshot] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  static Future<void> saveSnapshot(CacheService cache, String body) async {
    await cache.putString(snapshotKey, body);
  }

/// Метод [cachedSnapshot] класса [MorningDigestNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  static String? cachedSnapshot(CacheService cache) =>
      cache.getString(snapshotKey);
}
