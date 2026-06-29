/// Парсинг Quotation / MoneyValue из T-Invest Open API.
double parseTinkoffQuotation(Map<String, dynamic>? json) {
  if (json == null) return 0;
  final units = int.tryParse(json['units']?.toString() ?? '0') ?? 0;
  final nano = int.tryParse(json['nano']?.toString() ?? '0') ?? 0;
  return units + nano / 1e9;
}

String? parseTinkoffCurrency(Map<String, dynamic>? json) =>
    json?['currency'] as String?;

/// Сумма MoneyValue в валюте поля (обычно rub).
double parseTinkoffMoney(Map<String, dynamic>? json) => parseTinkoffQuotation(json);

String displayTickerFromFigi(String figi, {String? ticker}) {
  if (ticker != null && ticker.isNotEmpty) return ticker;
  if (figi.length >= 4) return figi.substring(figi.length - 4);
  return figi;
}
