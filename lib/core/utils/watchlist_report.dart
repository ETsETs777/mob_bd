import '../../data/models/commodity_quote.dart';
import '../../data/models/currency_rate.dart';
import '../../data/models/market_asset.dart';
import '../../features/home/economic_brief.dart';

/// Функция [buildWeeklyReport] — построение данных или UI.
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
String buildWeeklyReport({
  required List<String> watchlistKeys,
  required List<MarketAsset> allAssets,
  required List<CurrencyRate>? rates,
  required List<MarketAsset>? crypto,
  required List<MarketAsset>? stocks,
  required List<CommodityQuote>? commodities,
  required List<BriefLine> briefLines,
  required String locale,
}) {
  final buffer = StringBuffer('EcoPulse · ${locale.startsWith('ru') ? 'Отчёт' : 'Report'}\n');
  buffer.writeln('${DateTime.now().day.toString().padLeft(2, '0')}.${DateTime.now().month.toString().padLeft(2, '0')}.${DateTime.now().year}');
  buffer.writeln('—');

  if (briefLines.isNotEmpty) {
    buffer.writeln(locale.startsWith('ru') ? 'Сводка:' : 'Brief:');
    for (final line in briefLines) {
      buffer.writeln('• ${line.text}');
    }
    buffer.writeln('—');
  }

  if (watchlistKeys.isNotEmpty) {
    buffer.writeln(locale.startsWith('ru') ? 'Избранное:' : 'Watchlist:');
    for (final key in watchlistKeys) {
      final asset = allAssets.where((a) => '${a.type.name}:${a.id}' == key).firstOrNull;
      if (asset == null) continue;
      final sign = asset.changePercent >= 0 ? '+' : '';
      buffer.writeln(
        '• ${asset.symbol} ${asset.price.toStringAsFixed(2)} ${asset.currency} ($sign${asset.changePercent.toStringAsFixed(2)}%)',
      );
    }
    buffer.writeln('—');
  }

  if (rates != null && rates.isNotEmpty) {
    buffer.writeln(locale.startsWith('ru') ? 'Валюты:' : 'FX:');
    for (final r in rates.take(5)) {
      buffer.writeln('• ${r.code}/${r.base} ${r.rate.toStringAsFixed(4)}');
    }
  }

  if (commodities != null && commodities.isNotEmpty) {
    buffer.writeln('—');
    buffer.writeln(locale.startsWith('ru') ? 'Сырьё:' : 'Commodities:');
    for (final c in commodities) {
      buffer.writeln('• ${c.name} ${c.price.toStringAsFixed(2)} ${c.unit}');
    }
  }

  return buffer.toString().trim();
}

/// Extension [_FirstOrNull].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
