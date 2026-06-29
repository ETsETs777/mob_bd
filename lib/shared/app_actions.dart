// =============================================================================
// EcoPulse · lib/shared/app_actions.dart
// Автор: Цымбал Е. В.
// Дата: 30.05.2026
// Общие виджеты и действия приложения. Файл: app_actions.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/theme/app_palette.dart';
import '../providers/app_providers.dart';
import '../core/services/home_widget_service.dart';
import '../core/services/morning_digest_service.dart';
import '../providers/commodities_provider.dart';
import '../providers/correlation_provider.dart';
import '../providers/morning_digest_provider.dart';
import '../providers/news_provider.dart';
import '../providers/indices_provider.dart';
import '../providers/paper_portfolio_provider.dart';
import '../providers/price_alerts_provider.dart';
import '../providers/watchlist_provider.dart';
import '../core/services/bond_coupon_reminder_service.dart';
import '../providers/widget_customization_provider.dart';

/// Значение enum [cbr].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
/// Значение enum [markets].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
/// Значение enum [inflation].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
/// Значение enum [currency].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
/// Значение enum [global].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
/// Enum [RefreshScope] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
/// Значение enum [cbr].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
/// Значение enum [markets].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
/// Значение enum [inflation].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
/// Значение enum [currency].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
/// Значение enum [global].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
enum RefreshScope { global, currency, inflation, markets, cbr }

/// Riverpod-провайдер [refreshTimeProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
final refreshTimeProvider =
    StateProvider.family<DateTime?, RefreshScope>((ref, scope) => null);

/// Функция [markRefreshed] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
void markRefreshed(WidgetRef ref, RefreshScope scope) {
  ref.read(refreshTimeProvider(scope).notifier).state = DateTime.now();
}

/// Функция [refreshAllData] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
Future<void> refreshAllData(WidgetRef ref) async {
  HapticFeedback.mediumImpact();
  await Future.wait([
    ref.read(currencyRatesProvider.notifier).refresh(),
    ref.read(inflationProvider.notifier).refresh(),
    ref.read(cryptoProvider.notifier).refresh(),
    ref.read(stocksProvider.notifier).refresh(),
    ref.read(bondsProvider.notifier).refresh(),
    ref.read(keyRateProvider.notifier).refresh(),
    ref.read(commoditiesProvider.notifier).refresh(),
    ref.read(fearGreedProvider.notifier).refresh(),
    ref.read(correlationProvider.notifier).refresh(),
    ref.read(marketNewsProvider.notifier).refresh(),
    ref.read(macroCalendarProvider.notifier).refresh(),
    ref.read(usIndicesProvider.notifier).refresh(),
  ]);
  await evaluatePriceAlerts(ref);

  final bonds = ref.read(bondsProvider).valueOrNull ?? const [];
  final watchlist = ref.read(watchlistProvider);
  final portfolio = ref.read(paperPortfolioProvider);
  final locale = WidgetsBinding.instance.platformDispatcher.locale;
  await evaluateBondReminders(
    bonds: bonds,
    trackedKeys: {
      ...watchlist,
      ...portfolio.positions.map((p) => p.assetKey),
    },
    isRu: locale.languageCode == 'ru',
  );

  final cache = ref.read(cacheServiceProvider);
  await MorningDigestService.instance.cacheSnapshotFromBrief(
    cache: cache,
    rates: ref.read(currencyRatesProvider).valueOrNull,
    keyRate: ref.read(keyRateProvider).valueOrNull,
    crypto: ref.read(cryptoProvider).valueOrNull?.assets,
    stocks: ref.read(stocksProvider).valueOrNull,
    commodities: ref.read(commoditiesProvider).valueOrNull,
    fearGreed: ref.read(fearGreedProvider).valueOrNull,
  );
  await MorningDigestService.instance.maybeSend(
    cache: cache,
    settings: ref.read(morningDigestProvider),
    rates: ref.read(currencyRatesProvider).valueOrNull,
    keyRate: ref.read(keyRateProvider).valueOrNull,
    crypto: ref.read(cryptoProvider).valueOrNull?.assets,
    stocks: ref.read(stocksProvider).valueOrNull,
    commodities: ref.read(commoditiesProvider).valueOrNull,
    fearGreed: ref.read(fearGreedProvider).valueOrNull,
  );
  await HomeWidgetService.update(
    rates: ref.read(currencyRatesProvider).valueOrNull,
    crypto: ref.read(cryptoProvider).valueOrNull?.assets,
    stocks: ref.read(stocksProvider).valueOrNull,
    commodities: ref.read(commoditiesProvider).valueOrNull,
    keyRate: ref.read(keyRateProvider).valueOrNull,
    portfolio: ref.read(portfolioSnapshotProvider),
    inflation: ref.read(inflationProvider).valueOrNull,
    config: ref.read(resolvedWidgetConfigProvider),
  );
  final now = DateTime.now();
  for (final scope in RefreshScope.values) {
    ref.read(refreshTimeProvider(scope).notifier).state = now;
  }
}

// Backward compatibility
/// Riverpod-провайдер [lastRefreshTimeProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
final lastRefreshTimeProvider = refreshTimeProvider(RefreshScope.global);
