// =============================================================================
// EcoPulse · lib/providers/stock_market_provider.dart
// Автор: Цымбал Е. В.
// Дата: 24.05.2026
// Riverpod state: провайдеры и notifiers. Файл: stock_market_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/bond_analytics_deep_link.dart';
import '../../core/utils/market_list_utils.dart';

/// Riverpod-провайдер [stockMarketRegionProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
final stockMarketRegionProvider =
    StateProvider<StockMarketRegion>((ref) => StockMarketRegion.all);

final moexSectorFilterProvider = StateProvider<String?>((ref) => null);

/// Riverpod-провайдер [stocksGroupedListProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
final stocksGroupedListProvider = StateProvider<bool>((ref) => true);

/// Riverpod-провайдер [bondMarketFilterProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
final bondMarketFilterProvider =
    StateProvider<BondMarketFilter>((ref) => BondMarketFilter.all);

/// Riverpod-провайдер [bondsGroupedListProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
final bondsGroupedListProvider = StateProvider<bool>((ref) => true);

/// 0 crypto, 1 stocks, 2 bonds — для deep link из ассистента.
final marketsInitialTabProvider = StateProvider<int?>((ref) => null);

/// Открыть экран аналитики облигаций после загрузки вкладки bonds.
final marketsBondDeepLinkProvider =
    StateProvider<BondAnalyticsDeepLink?>((ref) => null);
