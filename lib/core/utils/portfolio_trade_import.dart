// =============================================================================
// EcoPulse · lib/core/utils/portfolio_trade_import.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Импорт сделок из CSV (EcoPulse export + generic broker).
// =============================================================================

import '../../data/models/market_asset.dart';
import '../../data/models/portfolio_trade.dart';

/// Результат импорта CSV.
class TradeImportResult {
  const TradeImportResult({
    required this.trades,
    required this.skippedRows,
    required this.errors,
  });

  final List<PortfolioTrade> trades;
  final int skippedRows;
  final List<String> errors;

  int get importedCount => trades.length;
  bool get hasErrors => errors.isNotEmpty;
}

/// Парсит CSV журнала сделок.
TradeImportResult parseTradeJournalCsv(
  String csv, {
  required String accountId,
  String Function()? idFactory,
}) {
  final lines = csv
      .split(RegExp(r'\r?\n'))
      .map((l) => l.trim())
      .where((l) => l.isNotEmpty)
      .toList();

  if (lines.isEmpty) {
    return const TradeImportResult(trades: [], skippedRows: 0, errors: ['empty_file']);
  }

  final headerCells = _parseCsvLine(lines.first);
  final headerMap = {
    for (var i = 0; i < headerCells.length; i++)
      _normHeader(headerCells[i]): i,
  };

  final isEcoPulse = headerMap.containsKey('datetime') &&
      headerMap.containsKey('kind') &&
      headerMap.containsKey('symbol');

  final trades = <PortfolioTrade>[];
  final errors = <String>[];
  var skipped = 0;
  var seq = 0;

  for (var row = 1; row < lines.length; row++) {
    final cells = _parseCsvLine(lines[row]);
    if (cells.isEmpty || _isSummaryRow(cells)) {
      skipped++;
      continue;
    }

    try {
      final trade = isEcoPulse
          ? _parseEcoPulseRow(cells, headerMap, accountId, idFactory, seq++)
          : _parseGenericRow(cells, headerMap, accountId, idFactory, seq++);
      if (trade != null) {
        trades.add(trade);
      } else {
        skipped++;
      }
    } catch (e) {
      errors.add('row_${row + 1}: $e');
      skipped++;
    }
  }

  return TradeImportResult(trades: trades, skippedRows: skipped, errors: errors);
}

PortfolioTrade? _parseEcoPulseRow(
  List<String> cells,
  Map<String, int> header,
  String accountId,
  String Function()? idFactory,
  int seq,
) {
  final symbol = _cell(cells, header, 'symbol');
  if (symbol.isEmpty) return null;

  final kindRaw = _cell(cells, header, 'kind').toLowerCase();
  final kind = kindRaw.contains('sell')
      ? PortfolioTradeKind.sell
      : PortfolioTradeKind.buy;

  final assetType = _cell(cells, header, 'type');
  final quantity = _parseDouble(_cell(cells, header, 'quantity'));
  final unitPrice = _parseDouble(_cell(cells, header, 'unit_price'));
  final currency = _cell(cells, header, 'currency').isEmpty
      ? 'RUB'
      : _cell(cells, header, 'currency');
  final amountRub = _parseDouble(_cell(cells, header, 'amount_rub'));
  final pnlRaw = _cell(cells, header, 'pnl_rub');
  final pnl = pnlRaw.isEmpty ? null : _parseDouble(pnlRaw);
  final at = _parseDate(_cell(cells, header, 'datetime'));
  final assetKey = _cell(cells, header, 'assetkey').isNotEmpty
      ? _cell(cells, header, 'assetkey')
      : _buildAssetKey(symbol, assetType);

  return PortfolioTrade(
    id: idFactory?.call() ?? 'import_${at.microsecondsSinceEpoch}_$seq',
    kind: kind,
    symbol: symbol.toUpperCase(),
    assetKey: assetKey,
    assetType: assetType.isEmpty ? _inferAssetType(symbol) : assetType,
    quantity: quantity,
    unitPrice: unitPrice,
    currency: currency,
    amountRub: amountRub > 0 ? amountRub : quantity * unitPrice,
    at: at,
    pnlRub: kind == PortfolioTradeKind.sell ? pnl : null,
    accountId: accountId,
  );
}

PortfolioTrade? _parseGenericRow(
  List<String> cells,
  Map<String, int> header,
  String accountId,
  String Function()? idFactory,
  int seq,
) {
  final symbol = _firstCell(cells, header, [
    'symbol',
    'ticker',
    'secid',
    'instrument',
    'figi',
    'name',
  ]);
  if (symbol.isEmpty) return null;

  final kindRaw = _firstCell(cells, header, [
    'kind',
    'side',
    'operation',
    'type',
    'direction',
    'операция',
  ]).toLowerCase();

  if (kindRaw.contains('див') ||
      kindRaw.contains('dividend') ||
      kindRaw.contains('coupon') ||
      kindRaw.contains('комис') ||
      kindRaw.contains('fee')) {
    return null;
  }

  final kind = kindRaw.contains('sell') ||
          kindRaw.contains('прод') ||
          kindRaw.contains('short')
      ? PortfolioTradeKind.sell
      : PortfolioTradeKind.buy;

  final quantity = _parseDouble(_firstCell(cells, header, [
    'quantity',
    'qty',
    'amount',
    'количество',
    'кол',
  ]));
  if (quantity <= 0) return null;

  final unitPrice = _parseDouble(_firstCell(cells, header, [
    'unit_price',
    'price',
    'цена',
    'rate',
  ]));

  final currency = _firstCell(cells, header, ['currency', 'валюта']).isEmpty
      ? 'RUB'
      : _firstCell(cells, header, ['currency', 'валюта']);

  final total = _parseDouble(_firstCell(cells, header, [
    'amount_rub',
    'total',
    'sum',
    'сумма',
    'payment',
  ]));

  final amountRub = total > 0 ? total : quantity * unitPrice;
  final at = _parseDate(_firstCell(cells, header, [
    'datetime',
    'date',
    'time',
    'дата',
    'timestamp',
  ]));

  final assetTypeRaw = _firstCell(cells, header, ['asset_type', 'assettype']);
  final assetType =
      assetTypeRaw.isEmpty ? _inferAssetType(symbol) : assetTypeRaw;

  return PortfolioTrade(
    id: idFactory?.call() ?? 'import_${at.microsecondsSinceEpoch}_$seq',
    kind: kind,
    symbol: _cleanSymbol(symbol),
    assetKey: _buildAssetKey(_cleanSymbol(symbol), assetType),
    assetType: assetType,
    quantity: quantity,
    unitPrice: unitPrice,
    currency: currency.toUpperCase(),
    amountRub: amountRub,
    at: at,
    accountId: accountId,
  );
}

bool _isSummaryRow(List<String> cells) {
  final first = cells.first.toUpperCase();
  return first == 'TOTAL' ||
      first == 'CASH_RUB' ||
      first == 'SUMMARY' ||
      first.startsWith('#');
}

String _normHeader(String raw) =>
    raw.toLowerCase().replaceAll(RegExp(r'[^a-z0-9а-яё]'), '');

String _cell(List<String> cells, Map<String, int> header, String key) {
  final idx = header[_normHeader(key)];
  if (idx == null || idx >= cells.length) return '';
  return cells[idx].trim();
}

String _firstCell(List<String> cells, Map<String, int> header, List<String> keys) {
  for (final key in keys) {
    final value = _cell(cells, header, _normHeader(key));
    if (value.isNotEmpty) return value;
  }
  return '';
}

double _parseDouble(String raw) {
  final cleaned = raw
      .replaceAll('\u00a0', '')
      .replaceAll(' ', '')
      .replaceAll(',', '.')
      .replaceAll(RegExp(r'[^\d.\-]'), '');
  return double.tryParse(cleaned) ?? 0;
}

DateTime _parseDate(String raw) {
  if (raw.isEmpty) return DateTime.now();
  final iso = DateTime.tryParse(raw);
  if (iso != null) return iso;

  final dmY = RegExp(r'^(\d{1,2})[./](\d{1,2})[./](\d{2,4})');
  final m1 = dmY.firstMatch(raw);
  if (m1 != null) {
    var year = int.parse(m1.group(3)!);
    if (year < 100) year += 2000;
    return DateTime(
      year,
      int.parse(m1.group(2)!),
      int.parse(m1.group(1)!),
    );
  }

  return DateTime.now();
}

String _cleanSymbol(String raw) {
  final s = raw.trim().toUpperCase();
  if (s.contains(':')) return s.split(':').last;
  return s;
}

String _inferAssetType(String symbol) {
  final s = symbol.toLowerCase();
  if (s == 'btc' ||
      s == 'eth' ||
      s.endsWith('usdt') ||
      s.length > 6 && s.contains(RegExp(r'^[a-z0-9]+$'))) {
    return AssetType.crypto.name;
  }
  if (RegExp(r'^[A-Z]{1,5}$').hasMatch(symbol.toUpperCase()) &&
      symbol.length <= 5) {
    return AssetType.stockUs.name;
  }
  return AssetType.stockRu.name;
}

String _buildAssetKey(String symbol, String assetType) {
  final type = AssetType.values.asNameMap()[assetType] ?? AssetType.stockRu;
  final key = type == AssetType.crypto ? symbol.toLowerCase() : symbol;
  return '${type.name}:$key';
}

List<String> _parseCsvLine(String line) {
  final result = <String>[];
  final buf = StringBuffer();
  var inQuotes = false;

  for (var i = 0; i < line.length; i++) {
    final ch = line[i];
    if (ch == '"') {
      if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
        buf.write('"');
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (ch == ',' && !inQuotes) {
      result.add(buf.toString());
      buf.clear();
    } else {
      buf.write(ch);
    }
  }
  result.add(buf.toString());
  return result;
}
