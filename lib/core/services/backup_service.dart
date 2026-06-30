// =============================================================================
// EcoPulse · lib/core/services/backup_service.dart
// Автор: Цымбал Е. В.
// Дата: 25.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: backup_service.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/calendar_attachment_storage.dart';
import '../utils/avatar_storage.dart';
import '../../data/services/cache_service.dart';
import '../../data/models/user_calendar_event.dart';
import '../../providers/accent_provider.dart';
import '../../providers/asset_notes_provider.dart';
import '../../providers/background_provider.dart';
import '../../providers/base_currency_provider.dart';
import '../../providers/commodities_provider.dart';
import '../../providers/compact_home_provider.dart';
import '../../providers/default_tab_provider.dart';
import '../../providers/feature_flags_provider.dart';
import '../../providers/locale_provider.dart';
import '../../providers/price_alerts_provider.dart';
import '../../providers/theme_provider.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/portfolio_trade_journal_provider.dart';
import '../../providers/user_profile_provider.dart';
import '../../providers/watchlist_provider.dart';
import '../../providers/cloud_sync_provider.dart';
import '../../providers/home_server_provider.dart';
import '../../providers/customization_provider.dart';
import '../../providers/customization_presets_provider.dart';
import '../../providers/portfolio/savings_goals_provider.dart';
import '../../providers/user_calendar_provider.dart';

/// Ключи пользовательских данных для backup (без PIN и API-ключей).
const backupDataKeys = [
  'user_profile',
  AvatarStorage.cacheKey,
  'home_server_auth',
  'customization_config',
  'customization_presets_v1',
  'watchlist',
  'price_alerts',
  'paper_portfolio',
  'paper_portfolio_accounts',
  'savings_goals_v1',
  'user_calendar_events_v1',
  'user_calendar_settings_v1',
  'portfolio_trade_journal',
  'cloud_sync_meta',
  'asset_notes',
  'theme_mode',
  'accent_color',
  'background_preset',
  'app_locale',
  'default_tab',
  'base_currency',
  'compact_home',
  'conversion_history',
  'flag_sector_heatmap',
  'flag_stocks_grouped',
  'flag_verbose_http',
  'morning_digest_enabled',
  'morning_digest_hour',
  'demo_mode_enabled',
  'compare_selection',
  'home_sec_portfolio',
  'home_sec_news',
  'home_sec_radar',
  'home_sec_indices',
  'home_sec_fng',
  'home_sec_currencies',
  'home_sec_keyrate',
  'home_sec_inflation',
  'home_sec_commodities',
  'home_sec_markets',
  'home_sec_bonds',
  'home_sec_watchlist',
  'home_sec_correlation',
];

/// Класс [BackupPayload].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
class BackupPayload {
/// Создаёт [BackupPayload].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  const BackupPayload({
    required this.version,
    required this.exportedAt,
    required this.data,
  });

/// Поле [version] класса [BackupPayload].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final int version;
/// Поле [exportedAt] класса [BackupPayload].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final DateTime exportedAt;
/// Поле [data] класса [BackupPayload].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  final Map<String, String?> data;

/// Метод [toJson] класса [BackupPayload].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  Map<String, dynamic> toJson() => {
        'version': version,
        'exportedAt': exportedAt.toIso8601String(),
        'app': 'EcoPulse',
        'data': data,
      };

/// Создаёт [BackupPayload] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  factory BackupPayload.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'] as Map<String, dynamic>? ?? {};
    return BackupPayload(
      version: json['version'] as int? ?? 1,
      exportedAt: DateTime.tryParse(json['exportedAt'] as String? ?? '') ??
          DateTime.now(),
      data: rawData.map((k, v) => MapEntry(k, v?.toString())),
    );
  }
}

/// Сервис [BackupService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
class BackupService {
/// Создаёт [BackupService] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  BackupService._();
/// Поле [instance] класса [BackupService].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  static final instance = BackupService._();

/// Поле [currentVersion] класса [BackupService].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  static const currentVersion = 2;

/// Метод [exportJson] класса [BackupService].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  String exportJson() {
    final cache = CacheService.instance;
    final data = <String, String?>{};
    for (final key in backupDataKeys) {
      data[key] = cache.getString(key);
    }
    final eventsRaw = cache.getString(UserCalendarNotifier.cacheKey);
    if (eventsRaw != null && eventsRaw.isNotEmpty) {
      try {
        final list = jsonDecode(eventsRaw) as List<dynamic>;
        final events = list
            .map((e) => UserCalendarEvent.fromJson(e as Map<String, dynamic>))
            .toList();
        for (final attachKey in CalendarAttachmentStorage.backupKeysForEvents(
          events,
        )) {
          data[attachKey] = cache.getString(attachKey);
        }
      } catch (_) {}
    }
    final payload = BackupPayload(
      version: currentVersion,
      exportedAt: DateTime.now(),
      data: data,
    );
    return const JsonEncoder.withIndent('  ').convert(payload.toJson());
  }

/// Метод [parseJson] класса [BackupService].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  BackupPayload parseJson(String raw) {
    final decoded = jsonDecode(raw.trim()) as Map<String, dynamic>;
    return BackupPayload.fromJson(decoded);
  }

/// Метод [restore] класса [BackupService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  Future<int> restore(BackupPayload payload) async {
    if (payload.version > currentVersion) {
      throw BackupException('Unsupported backup version');
    }
    final cache = CacheService.instance;
    var restored = 0;
    for (final entry in payload.data.entries) {
      final allowed = backupDataKeys.contains(entry.key) ||
          entry.key.startsWith(CalendarAttachmentStorage.keyPrefix);
      if (!allowed) continue;
      final value = entry.value;
      if (value == null || value.isEmpty) {
        await cache.deleteKey(entry.key);
      } else {
        await cache.putString(entry.key, value);
      }
      restored++;
    }
    return restored;
  }

/// Метод [invalidateProviders] класса [BackupService].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  void invalidateProviders(WidgetRef ref) {
    ref.invalidate(paperPortfolioProvider);
    ref.invalidate(paperPortfolioStoreProvider);
    ref.invalidate(portfolioTradeJournalProvider);
    ref.invalidate(userProfileProvider);
    ref.invalidate(watchlistProvider);
    ref.invalidate(priceAlertsProvider);
    ref.invalidate(assetNotesProvider);
    ref.invalidate(themeModeProvider);
    ref.invalidate(accentColorProvider);
    ref.invalidate(backgroundPresetProvider);
    ref.invalidate(localeProvider);
    ref.invalidate(defaultTabProvider);
    ref.invalidate(baseCurrencyProvider);
    ref.invalidate(compactHomeProvider);
    ref.invalidate(conversionHistoryProvider);
    ref.invalidate(featureFlagsProvider);
    ref.invalidate(cloudSyncProvider);
    ref.invalidate(homeServerProvider);
    ref.invalidate(customizationProvider);
    ref.invalidate(userCustomizationPresetsProvider);
    ref.invalidate(savingsGoalsProvider);
    ref.invalidate(userCalendarProvider);
    ref.invalidate(userCalendarSettingsProvider);
  }
}

/// Класс [BackupException].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
class BackupException implements Exception {
/// Создаёт [BackupException].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  BackupException(this.message);
/// Поле [message] класса [BackupException].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final String message;

  @override
  String toString() => message;
}
