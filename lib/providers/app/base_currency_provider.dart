// =============================================================================
// EcoPulse · lib/providers/base_currency_provider.dart
// Автор: Цымбал Е. В.
// Дата: 19.05.2026
// Riverpod state: провайдеры и notifiers. Файл: base_currency_provider.
// =============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/cache_service.dart';
import 'package:ecopulse/providers/app/app_providers.dart';

/// Значение enum [eur].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
/// Значение enum [rub].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
/// Значение enum [usd].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
/// Enum [BaseCurrency] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
/// Значение enum [eur].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
/// Значение enum [rub].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
/// Значение enum [usd].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
enum BaseCurrency { usd, rub, eur }

/// Extension [BaseCurrencyX].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
extension BaseCurrencyX on BaseCurrency {
  String get code => switch (this) {
        BaseCurrency.usd => 'USD',
        BaseCurrency.rub => 'RUB',
        BaseCurrency.eur => 'EUR',
      };

  String get label => switch (this) {
        BaseCurrency.usd => 'Доллар США',
        BaseCurrency.rub => 'Российский рубль',
        BaseCurrency.eur => 'Евро',
      };

  String get symbol => switch (this) {
        BaseCurrency.usd => '\$',
        BaseCurrency.rub => '₽',
        BaseCurrency.eur => '€',
      };

  static BaseCurrency fromString(String? value) {
    return BaseCurrency.values.firstWhere(
      (c) => c.name == value,
      orElse: () => BaseCurrency.usd,
    );
  }
}

/// Riverpod-провайдер [baseCurrencyProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
final baseCurrencyProvider =
    NotifierProvider<BaseCurrencyNotifier, BaseCurrency>(BaseCurrencyNotifier.new);

/// Riverpod AsyncNotifier [BaseCurrencyNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
class BaseCurrencyNotifier extends Notifier<BaseCurrency> {
/// Поле [_cacheKey] класса [BaseCurrencyNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  static const _cacheKey = 'base_currency';

/// Отрисовывает UI [BaseCurrencyNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  @override
  BaseCurrency build() {
    final stored = CacheService.instance.getString(_cacheKey);
    final currency = BaseCurrencyX.fromString(stored);
    Future.microtask(() {
      ref.read(converterFromProvider.notifier).state = currency.code;
    });
    return currency;
  }

/// Метод [setCurrency] класса [BaseCurrencyNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  Future<void> setCurrency(BaseCurrency currency) async {
    state = currency;
    await CacheService.instance.putString(_cacheKey, currency.name);
    ref.read(converterFromProvider.notifier).state = currency.code;
  }
}
