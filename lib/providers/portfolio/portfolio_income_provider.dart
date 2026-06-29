// =============================================================================
// EcoPulse · lib/providers/portfolio_income_provider.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Календарь дохода бумажного портфеля.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/portfolio_income_calendar.dart';
import '../../data/models/currency_rate.dart';
import 'package:ecopulse/providers/app/app_providers.dart';
import 'package:ecopulse/providers/portfolio/paper_portfolio_provider.dart';

final portfolioIncomeProvider = Provider<PortfolioIncomePlan?>((ref) {
  final portfolio = ref.watch(paperPortfolioProvider);
  if (portfolio.positions.isEmpty) return null;

  if (ref.watch(portfolioSnapshotProvider) == null) return null;

  final crypto = ref.watch(cryptoProvider).valueOrNull?.assets ?? const [];
  final stocks = ref.watch(stocksProvider).valueOrNull ?? const [];
  final bonds = ref.watch(bondsProvider).valueOrNull ?? const [];
  final rates = ref.watch(currencyRatesProvider).valueOrNull ?? const [];
  final usdRub = rates.where((CurrencyRate r) => r.isRub).firstOrNull?.rate;
  if (usdRub == null || usdRub <= 0) return null;

  return buildPortfolioIncomePlan(
    portfolio: portfolio,
    allAssets: [...crypto, ...stocks, ...bonds],
    usdRubRate: usdRub,
  );
});

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) return null;
    return it.current;
  }
}
