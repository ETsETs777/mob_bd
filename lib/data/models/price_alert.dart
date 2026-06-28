// =============================================================================
// EcoPulse · lib/data/models/price_alert.dart
// Автор: Цымбал Е. В.
// Дата: 04.05.2026
// Модели данных (DTO, immutable классы). Файл: price_alert.
// =============================================================================

/// Enum [PriceAlertSymbol] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
enum PriceAlertSymbol {
/// Значение enum [usdRub].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  usdRub('USD/RUB'),
/// Значение enum [eurRub].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  eurRub('EUR/RUB'),
/// Значение enum [btc].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  btc('BTC'),
/// Значение enum [eth].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  eth('ETH'),
/// Значение enum [imoex].
///
/// Автор: Цымбал Е. В.
/// Дата: 28.06.2026
  imoex('IMOEX');

  const PriceAlertSymbol(this.label);
  final String label;
}

/// Enum [AlertCondition] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
enum AlertCondition {
/// Значение enum [above].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  above,
/// Значение enum [below].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  below,
}

/// Enum [AlertKind] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
enum AlertKind {
/// Значение enum [threshold].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  threshold,
/// Значение enum [percentChange].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  percentChange,
}

/// Класс [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
class PriceAlert {
/// Создаёт [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  const PriceAlert({
    required this.id,
    required this.symbol,
    required this.condition,
    required this.threshold,
    this.kind = AlertKind.threshold,
    this.enabled = true,
    this.lastNotifiedAt,
  });

/// Поле [id] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final String id;
/// Поле [symbol] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final PriceAlertSymbol symbol;
/// Поле [condition] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final AlertCondition condition;
/// Поле [threshold] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  final double threshold;
/// Поле [kind] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final AlertKind kind;
/// Поле [enabled] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final bool enabled;
/// Поле [lastNotifiedAt] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final DateTime? lastNotifiedAt;

/// Getter [isAbove] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  bool get isAbove => condition == AlertCondition.above;
/// Getter [isPercentChange] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  bool get isPercentChange => kind == AlertKind.percentChange;

/// Метод [toJson] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  Map<String, dynamic> toJson() => {
        'id': id,
        'symbol': symbol.name,
        'condition': condition.name,
        'threshold': threshold,
        'kind': kind.name,
        'enabled': enabled,
        'lastNotifiedAt': lastNotifiedAt?.toIso8601String(),
      };

/// Создаёт [PriceAlert] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  factory PriceAlert.fromJson(Map<String, dynamic> json) => PriceAlert(
        id: json['id'] as String,
        symbol: PriceAlertSymbol.values.byName(json['symbol'] as String),
        condition: AlertCondition.values.byName(json['condition'] as String),
        threshold: (json['threshold'] as num).toDouble(),
        kind: AlertKind.values.byName(json['kind'] as String? ?? 'threshold'),
        enabled: json['enabled'] as bool? ?? true,
        lastNotifiedAt: json['lastNotifiedAt'] != null
            ? DateTime.parse(json['lastNotifiedAt'] as String)
            : null,
      );

/// Метод [copyWith] класса [PriceAlert].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  PriceAlert copyWith({
    bool? enabled,
    DateTime? lastNotifiedAt,
    bool clearLastNotified = false,
  }) {
    return PriceAlert(
      id: id,
      symbol: symbol,
      condition: condition,
      threshold: threshold,
      kind: kind,
      enabled: enabled ?? this.enabled,
      lastNotifiedAt:
          clearLastNotified ? null : (lastNotifiedAt ?? this.lastNotifiedAt),
    );
  }
}

/// Класс [AlertHistoryEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
class AlertHistoryEntry {
/// Создаёт [AlertHistoryEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  const AlertHistoryEntry({
    required this.alertId,
    required this.symbol,
    required this.message,
    required this.triggeredAt,
  });

/// Поле [alertId] класса [AlertHistoryEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final String alertId;
/// Поле [symbol] класса [AlertHistoryEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  final String symbol;
/// Поле [message] класса [AlertHistoryEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final String message;
/// Поле [triggeredAt] класса [AlertHistoryEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final DateTime triggeredAt;

/// Метод [toJson] класса [AlertHistoryEntry].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  Map<String, dynamic> toJson() => {
        'alertId': alertId,
        'symbol': symbol,
        'message': message,
        'triggeredAt': triggeredAt.toIso8601String(),
      };

/// Создаёт [AlertHistoryEntry] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  factory AlertHistoryEntry.fromJson(Map<String, dynamic> json) =>
      AlertHistoryEntry(
        alertId: json['alertId'] as String,
        symbol: json['symbol'] as String,
        message: json['message'] as String,
        triggeredAt: DateTime.parse(json['triggeredAt'] as String),
      );
}
