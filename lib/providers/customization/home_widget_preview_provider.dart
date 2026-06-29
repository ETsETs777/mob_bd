// =============================================================================
// EcoPulse · lib/providers/customization/home_widget_preview_provider.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Live payload для превью Android home widget в hub кастомизации.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/home_widget_data.dart';
import '../../providers/app_providers.dart';
import '../../providers/commodities_provider.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/stock_market_provider.dart';
import '../../providers/widget_customization_provider.dart';

/// Снимок слотов виджета с актуальными рыночными данными.
final homeWidgetPreviewProvider = Provider<HomeWidgetPayload>((ref) {
  final config = ref.watch(resolvedWidgetConfigProvider);

  final rates = ref.watch(currencyRatesProvider).valueOrNull;
  final crypto = ref.watch(cryptoProvider).valueOrNull?.assets;
  final stocks = ref.watch(stocksProvider).valueOrNull;
  final commodities = ref.watch(commoditiesProvider).valueOrNull;
  final keyRate = ref.watch(keyRateProvider).valueOrNull;
  final portfolio = ref.watch(portfolioSnapshotProvider);
  final inflation = ref.watch(inflationProvider).valueOrNull;

  final slots = buildHomeWidgetSlots(
    config: config,
    rates: rates,
    crypto: crypto,
    stocks: stocks,
    commodities: commodities,
    keyRate: keyRate,
    portfolio: portfolio,
    inflation: inflation,
  );

  return HomeWidgetPayload(
    layout: config.layout,
    slots: slots,
    updatedAt: DateTime.now(),
  );
});
