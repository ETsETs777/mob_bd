import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';
import '../../providers/calendar/user_calendar_plan_provider.dart';
import '../../providers/calendar/user_calendar_provider.dart';
import '../../providers/calendar/user_calendar_settings_provider.dart';
import '../../providers/commodities_provider.dart';
import '../../providers/customization/widget_customization_provider.dart';
import '../../providers/paper_portfolio_provider.dart';
import '../../providers/portfolio_income_provider.dart';
import '../../providers/stock_market_provider.dart';
import '../utils/home_widget_context_strip.dart';
import 'home_widget_service.dart';

typedef _ProviderRead = T Function<T>(ProviderListenable<T> provider);

/// Централизованное обновление Android home widget (метрики + portfolio + calendar).
class HomeWidgetRefreshPipeline {
  HomeWidgetRefreshPipeline._();

  static Timer? _debounce;
  static const _debounceMs = 600;

  /// Слушает изменения портфеля/календаря/конфига и планирует refresh.
  static void bind(WidgetRef ref) {
    final read = ref.read;
    ref.listen(userCalendarProvider, (_, __) => schedule(read));
    ref.listen(userCalendarSettingsProvider, (_, __) => schedule(read));
    ref.listen(paperPortfolioProvider, (_, __) => schedule(read));
    ref.listen(portfolioIncomeProvider, (_, __) => schedule(read));
    ref.listen(resolvedWidgetConfigProvider, (_, __) => schedule(read));
  }

  static void schedule(_ProviderRead read) {
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: _debounceMs),
      () => refresh(read),
    );
  }

  static Future<void> refresh(_ProviderRead read) async {
    final calendarPlan = read(userCalendarPlanProvider(90));
    final contextStrip = buildHomeWidgetContextStrip(
      portfolio: read(portfolioSnapshotProvider),
      calendarPlan: calendarPlan,
    );

    await HomeWidgetService.update(
      rates: read(currencyRatesProvider).valueOrNull,
      crypto: read(cryptoProvider).valueOrNull?.assets,
      stocks: read(stocksProvider).valueOrNull,
      commodities: read(commoditiesProvider).valueOrNull,
      keyRate: read(keyRateProvider).valueOrNull,
      portfolio: read(portfolioSnapshotProvider),
      inflation: read(inflationProvider).valueOrNull,
      config: read(resolvedWidgetConfigProvider),
      contextStrip: contextStrip,
    );
  }
}
