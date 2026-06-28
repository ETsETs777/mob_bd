// =============================================================================
// EcoPulse · lib/core/services/assistant/assistant_context.dart
// Автор: Цымбал Е. В.
// Дата: 26.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: assistant_context.
// =============================================================================

import '../../../data/models/commodity_quote.dart';
import '../../../data/models/currency_rate.dart';
import '../../../data/models/key_rate_point.dart';
import '../../../data/models/market_asset.dart';
import '../../../features/home/economic_brief.dart';
import '../../../core/utils/portfolio_math.dart';
import '../../../data/models/portfolio_position.dart';

/// Класс [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
class AssistantContext {
/// Создаёт [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  const AssistantContext({
    this.usdRub,
    this.eurRub,
    this.btcPrice,
    this.btcChange,
    this.ethPrice,
    this.keyRate,
    this.briefLines = const [],
    this.watchlistCount = 0,
    this.demoMode = false,
    this.portfolioTotalRub,
    this.portfolioPnlPct,
    this.locale = 'ru',
    this.hasGeminiKey = false,
  });

/// Поле [usdRub] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final double? usdRub;
/// Поле [eurRub] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final double? eurRub;
/// Поле [btcPrice] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  final double? btcPrice;
/// Поле [btcChange] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  final double? btcChange;
/// Поле [ethPrice] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final double? ethPrice;
/// Поле [keyRate] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final double? keyRate;
/// Поле [briefLines] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final List<BriefLine> briefLines;
/// Поле [watchlistCount] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  final int watchlistCount;
/// Поле [demoMode] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  final bool demoMode;
/// Поле [portfolioTotalRub] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  final double? portfolioTotalRub;
/// Поле [portfolioPnlPct] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final double? portfolioPnlPct;
/// Поле [locale] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  final String locale;
/// Поле [hasGeminiKey] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
  final bool hasGeminiKey;

/// Getter [isRu] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 27.05.2026
  bool get isRu => locale.startsWith('ru');

/// Метод [toJson] класса [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.05.2026
  Map<String, dynamic> toJson() => {
        'usdRub': usdRub,
        'eurRub': eurRub,
        'btcPrice': btcPrice,
        'btcChange': btcChange,
        'ethPrice': ethPrice,
        'keyRate': keyRate,
        'brief': briefLines.map((l) => l.text).toList(),
        'watchlistCount': watchlistCount,
        'demoMode': demoMode,
        'portfolioTotalRub': portfolioTotalRub,
        'portfolioPnlPct': portfolioPnlPct,
        'locale': locale,
      };

/// Отрисовывает UI [AssistantContext].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  static AssistantContext build({
    required String locale,
    List<CurrencyRate>? rates,
    List<MarketAsset>? crypto,
    KeyRateSnapshot? keyRate,
    List<CommodityQuote>? commodities,
    List<BriefLine>? briefLines,
    List<String>? watchlist,
    bool demoMode = false,
    PaperPortfolio? portfolio,
    List<MarketAsset>? allAssets,
    double usdRubRate = 90,
    bool hasGeminiKey = false,
  }) {
    double? usd;
    double? eur;
    for (final r in rates ?? <CurrencyRate>[]) {
      if (r.isRub && r.code == 'USD') usd = r.rate;
      if (r.base == 'RUB' && r.code == 'EUR') eur = r.rate;
    }

    MarketAsset? btc;
    MarketAsset? eth;
    for (final a in crypto ?? <MarketAsset>[]) {
      if (a.symbol == 'BTC') btc = a;
      if (a.symbol == 'ETH') eth = a;
    }

    double? totalRub;
    double? pnlPct;
    if (portfolio != null && allAssets != null) {
      final snap = buildPortfolioSnapshot(
        portfolio: portfolio,
        allAssets: allAssets,
        usdRubRate: usdRubRate,
      );
      totalRub = snap.totalValueRub;
      pnlPct = snap.pnlPercent;
    }

    return AssistantContext(
      usdRub: usd,
      eurRub: eur,
      btcPrice: btc?.price,
      btcChange: btc?.changePercent,
      ethPrice: eth?.price,
      keyRate: keyRate?.current,
      briefLines: briefLines ?? const [],
      watchlistCount: watchlist?.length ?? 0,
      demoMode: demoMode,
      portfolioTotalRub: totalRub,
      portfolioPnlPct: pnlPct,
      locale: locale,
      hasGeminiKey: hasGeminiKey,
    );
  }
}
