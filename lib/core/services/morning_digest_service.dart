import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/key_rate_point.dart';
import '../../data/models/market_asset.dart';
import '../../data/services/cache_service.dart';
import '../../features/home/economic_brief.dart';
import '../../providers/morning_digest_provider.dart';
import '../utils/digest_text.dart';
import 'notification_service.dart';

/// Сервис [MorningDigestService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
class MorningDigestService {
/// Создаёт [MorningDigestService] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  MorningDigestService._();
/// Поле [instance] класса [MorningDigestService].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static final instance = MorningDigestService._();

/// Метод [cacheSnapshotFromBrief] класса [MorningDigestService].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  Future<void> cacheSnapshotFromBrief({
    required CacheService cache,
    List<CurrencyRate>? rates,
    KeyRateSnapshot? keyRate,
    List<MarketAsset>? crypto,
    List<MarketAsset>? stocks,
    List<CommodityQuote>? commodities,
    FearGreedIndex? fearGreed,
  }) async {
    final lines = buildEconomicBrief(
      rates: rates,
      keyRate: keyRate,
      crypto: crypto,
      stocks: stocks,
      commodities: commodities,
      fearGreed: fearGreed,
    );
    if (lines.isEmpty) return;
    await MorningDigestNotifier.saveSnapshot(
      cache,
      formatDigestBody(lines),
    );
  }

/// Метод [maybeSend] класса [MorningDigestService].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  Future<void> maybeSend({
    required CacheService cache,
    required MorningDigestSettings settings,
    List<CurrencyRate>? rates,
    KeyRateSnapshot? keyRate,
    List<MarketAsset>? crypto,
    List<MarketAsset>? stocks,
    List<CommodityQuote>? commodities,
    FearGreedIndex? fearGreed,
  }) async {
    if (!settings.enabled) return;

    final now = DateTime.now();
    if (now.hour != settings.hour) return;

    final lastSent = MorningDigestNotifier.lastSentDate(cache);
    if (lastSent != null &&
        lastSent.year == now.year &&
        lastSent.month == now.month &&
        lastSent.day == now.day) {
      return;
    }

    var body = MorningDigestNotifier.cachedSnapshot(cache);
    if (body == null || body.isEmpty) {
      final lines = buildEconomicBrief(
        rates: rates,
        keyRate: keyRate,
        crypto: crypto,
        stocks: stocks,
        commodities: commodities,
        fearGreed: fearGreed,
      );
      body = formatDigestBody(lines);
    }

    await NotificationService.instance.showMorningDigest(
      title: 'EcoPulse · Сводка',
      body: body,
    );
    await MorningDigestNotifier.markSent(cache);
  }
}
