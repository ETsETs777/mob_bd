// =============================================================================
// EcoPulse · lib/providers/commodities_provider.dart
// Автор: Цымбал Е. В.
// Дата: 19.05.2026
// Riverpod state: провайдеры и notifiers. Файл: commodities_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/demo/demo_fixtures.dart';
import '../data/models/commodity_quote.dart';
import '../data/repositories/commodities_repository.dart';
import '../data/services/api_client.dart';
import 'app_providers.dart';
import 'demo_mode_provider.dart';
import '../data/services/cache_service.dart';

/// Riverpod-провайдер [commoditiesRepositoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
final commoditiesRepositoryProvider = Provider<CommoditiesRepository>((ref) {
  return CommoditiesRepository(
    ref.watch(dioProvider),
    ref.watch(cacheServiceProvider),
  );
});

/// Riverpod-провайдер [commoditiesProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final commoditiesProvider =
    AsyncNotifierProvider<CommoditiesNotifier, List<CommodityQuote>>(
  CommoditiesNotifier.new,
);

/// Riverpod AsyncNotifier [CommoditiesNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class CommoditiesNotifier extends AsyncNotifier<List<CommodityQuote>> {
/// Отрисовывает UI [CommoditiesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  @override
  Future<List<CommodityQuote>> build() => _load();

/// Перезагружает данные [CommoditiesNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<List<CommodityQuote>>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [CommoditiesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<List<CommodityQuote>> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.commodities);
    }
    return ref.read(commoditiesRepositoryProvider).fetchCommodities(force: force);
  }
}

/// Riverpod-провайдер [fearGreedProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
final fearGreedProvider =
    AsyncNotifierProvider<FearGreedNotifier, FearGreedIndex?>(
  FearGreedNotifier.new,
);

/// Riverpod AsyncNotifier [FearGreedNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class FearGreedNotifier extends AsyncNotifier<FearGreedIndex?> {
/// Отрисовывает UI [FearGreedNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  @override
  Future<FearGreedIndex?> build() => _load();

/// Перезагружает данные [FearGreedNotifier] с API/кэша.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> refresh({bool force = true}) async {
    final previous = state;
    if (previous.hasValue) {
      state = AsyncValue<FearGreedIndex?>.loading().copyWithPrevious(previous);
    } else {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(() => _load(force: force));
  }

/// Приватный метод [_load] класса [FearGreedNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<FearGreedIndex?> _load({bool force = false}) {
    if (ref.read(demoModeProvider)) {
      return Future.value(DemoFixtures.fearGreed);
    }
    return ref.read(commoditiesRepositoryProvider).fetchFearGreed(force: force);
  }
}

/// Класс [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
class ConversionRecord {
/// Создаёт [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  const ConversionRecord({
    required this.amount,
    required this.from,
    required this.to,
    required this.result,
    required this.at,
  });

/// Поле [amount] класса [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  final double amount;
/// Поле [from] класса [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  final String from;
/// Поле [to] класса [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  final String to;
/// Поле [result] класса [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  final double result;
/// Поле [at] класса [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  final DateTime at;

/// Метод [toJson] класса [ConversionRecord].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  Map<String, dynamic> toJson() => {
        'amount': amount,
        'from': from,
        'to': to,
        'result': result,
        'at': at.toIso8601String(),
      };

/// Создаёт [ConversionRecord] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  factory ConversionRecord.fromJson(Map<String, dynamic> json) =>
      ConversionRecord(
        amount: (json['amount'] as num).toDouble(),
        from: json['from'] as String,
        to: json['to'] as String,
        result: (json['result'] as num).toDouble(),
        at: DateTime.parse(json['at'] as String),
      );
}

/// Riverpod-провайдер [conversionHistoryProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
final conversionHistoryProvider =
    NotifierProvider<ConversionHistoryNotifier, List<ConversionRecord>>(
  ConversionHistoryNotifier.new,
);

/// Riverpod AsyncNotifier [ConversionHistoryNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
class ConversionHistoryNotifier extends Notifier<List<ConversionRecord>> {
/// Поле [_cacheKey] класса [ConversionHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  static const _cacheKey = 'conversion_history';
/// Поле [_maxItems] класса [ConversionHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  static const _maxItems = 10;

/// Отрисовывает UI [ConversionHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  @override
  List<ConversionRecord> build() {
    final raw = CacheService.instance.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => ConversionRecord.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Метод [add] класса [ConversionHistoryNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<void> add({
    required double amount,
    required String from,
    required String to,
    required double result,
  }) async {
    final record = ConversionRecord(
      amount: amount,
      from: from,
      to: to,
      result: result,
      at: DateTime.now(),
    );
    state = [record, ...state.where((r) => !(r.from == from && r.to == to && r.amount == amount))].take(_maxItems).toList();
    await CacheService.instance.putString(
      _cacheKey,
      jsonEncode(state.map((r) => r.toJson()).toList()),
    );
  }
}

/// Парсит «100 USD в EUR» или «50 usd rub».
({double amount, String from, String to})? parseQuickConvert(String input) {
  final normalized = input.trim().replaceAll(',', '.');
  final match = RegExp(
    r'^([\d.]+)\s*([A-Za-z]{3})\s*(?:в|to|->|/)\s*([A-Za-z]{3})$',
    caseSensitive: false,
  ).firstMatch(normalized);
  if (match == null) return null;
  final amount = double.tryParse(match.group(1)!);
  if (amount == null) return null;
  return (
    amount: amount,
    from: match.group(2)!.toUpperCase(),
    to: match.group(3)!.toUpperCase(),
  );
}
