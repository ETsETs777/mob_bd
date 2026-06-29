// =============================================================================
// EcoPulse · lib/data/models/portfolio_trade.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Запись журнала сделок бумажного портфеля.
// =============================================================================

/// Тип операции в журнале.
enum PortfolioTradeKind { buy, sell }

/// Одна сделка (покупка или продажа).
class PortfolioTrade {
  const PortfolioTrade({
    required this.id,
    required this.kind,
    required this.symbol,
    required this.assetKey,
    required this.assetType,
    required this.quantity,
    required this.unitPrice,
    required this.currency,
    required this.amountRub,
    required this.at,
    this.pnlRub,
    this.accountId = 'main',
  });

  final String id;
  final PortfolioTradeKind kind;
  final String symbol;
  final String assetKey;
  final String assetType;
  final double quantity;
  final double unitPrice;
  final String currency;
  final double amountRub;
  final DateTime at;
  final double? pnlRub;
  final String accountId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'symbol': symbol,
        'assetKey': assetKey,
        'assetType': assetType,
        'quantity': quantity,
        'unitPrice': unitPrice,
        'currency': currency,
        'amountRub': amountRub,
        'at': at.toIso8601String(),
        'pnlRub': pnlRub,
        'accountId': accountId,
      };

  factory PortfolioTrade.fromJson(Map<String, dynamic> json) {
    return PortfolioTrade(
      id: json['id'] as String? ?? '',
      kind: PortfolioTradeKind.values.byName(json['kind'] as String? ?? 'buy'),
      symbol: json['symbol'] as String? ?? '',
      assetKey: json['assetKey'] as String? ?? '',
      assetType: json['assetType'] as String? ?? '',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      currency: json['currency'] as String? ?? 'RUB',
      amountRub: (json['amountRub'] as num?)?.toDouble() ?? 0,
      at: DateTime.tryParse(json['at'] as String? ?? '') ?? DateTime.now(),
      pnlRub: (json['pnlRub'] as num?)?.toDouble(),
      accountId: json['accountId'] as String? ?? 'main',
    );
  }
}
