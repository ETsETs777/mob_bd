class BrokerAccount {
  const BrokerAccount({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final String type;

  factory BrokerAccount.fromJson(Map<String, dynamic> json) => BrokerAccount(
        id: json['id'] as String? ?? '',
        name: json['name'] as String? ?? '',
        type: json['type'] as String? ?? '',
      );
}

class BrokerPosition {
  const BrokerPosition({
    required this.figi,
    required this.ticker,
    required this.instrumentType,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.currency,
    required this.expectedYield,
  });

  final String figi;
  final String ticker;
  final String instrumentType;
  final double quantity;
  final double averagePrice;
  final double currentPrice;
  final String currency;
  final double expectedYield;

  double get marketValue => quantity * currentPrice;

  factory BrokerPosition.fromPortfolioJson(Map<String, dynamic> json) {
    final figi = json['figi'] as String? ?? '';
    final tickerRaw = json['ticker'] as String?;
    return BrokerPosition(
      figi: figi,
      ticker: tickerRaw?.isNotEmpty == true
          ? tickerRaw!
          : (figi.length >= 6 ? figi.substring(figi.length - 6) : figi),
      instrumentType: json['instrumentType'] as String? ?? '',
      quantity: _parseQty(json['quantity']),
      averagePrice: _parseMoney(json['averagePositionPrice']),
      currentPrice: _parseMoney(json['currentPrice']),
      currency: (json['currentPrice'] as Map<String, dynamic>?)?['currency']
              as String? ??
          'rub',
      expectedYield: _parseMoney(json['expectedYield']),
    );
  }

  static double _parseQty(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final units = int.tryParse(raw['units']?.toString() ?? '0') ?? 0;
      final nano = int.tryParse(raw['nano']?.toString() ?? '0') ?? 0;
      return units + nano / 1e9;
    }
    return 0;
  }

  static double _parseMoney(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      final units = int.tryParse(raw['units']?.toString() ?? '0') ?? 0;
      final nano = int.tryParse(raw['nano']?.toString() ?? '0') ?? 0;
      return units + nano / 1e9;
    }
    return 0;
  }
}

class BrokerPortfolioSnapshot {
  const BrokerPortfolioSnapshot({
    required this.accountId,
    required this.accountName,
    required this.positions,
    required this.totalAmountRub,
    required this.syncedAt,
  });

  final String accountId;
  final String accountName;
  final List<BrokerPosition> positions;
  final double totalAmountRub;
  final DateTime syncedAt;
}
