import 'package:intl/intl.dart';

import '../../data/models/user_customization.dart';
import '../../providers/base_currency_provider.dart';
import 'customization_defaults.dart';
import 'data_display_customization_resolver.dart';

/// Форматирование чисел, валют и времени по [ResolvedDataDisplay].
class DisplayFormatters {
  DisplayFormatters(this.config);

  final ResolvedDataDisplay config;

  factory DisplayFormatters.defaults() => DisplayFormatters(
        DataDisplayCustomizationResolver.resolve(
          CustomizationDefaults.create().dataDisplay,
        ),
      );

  String get _numberLocale => 'en_US';

  String get _dateLocale => config.appLocale.code;

  int fractionDigitsFor(double value) {
    return switch (config.decimalPlaces) {
      DecimalPlacesMode.fixed0 => 0,
      DecimalPlacesMode.fixed2 => 2,
      DecimalPlacesMode.fixed4 => 4,
      DecimalPlacesMode.auto => value >= 1000
          ? 2
          : value < 1
              ? 4
              : 2,
    };
  }

  NumberFormat _numberFormat(int fractionDigits) {
    final pattern = fractionDigits == 0
        ? '#,##0'
        : '#,##0.${'0' * fractionDigits}';
    return NumberFormat(pattern, _numberLocale);
  }

  String _formatLargeNumber(double value, NumberFormat standard) {
    if (config.largeNumberFormat == LargeNumberFormatId.short &&
        value.abs() >= 10000) {
      return NumberFormat.compact(locale: _numberLocale).format(value);
    }
    return standard.format(value);
  }

  String price(double value, {String symbol = '\$'}) {
    final digits = fractionDigitsFor(value);
    final formatted = _formatLargeNumber(value, _numberFormat(digits));
    if (config.showCurrencyCode && symbol == '\$') {
      return 'USD $formatted';
    }
    return '$symbol$formatted';
  }

  String rub(double value) {
    final digits = fractionDigitsFor(value);
    final formatted = _formatLargeNumber(value, _numberFormat(digits));
    if (config.showCurrencyCode) {
      return 'RUB $formatted';
    }
    return '$formatted ₽';
  }

  String percent(double? value) {
    if (value == null) return '—';
    final digits = switch (config.decimalPlaces) {
      DecimalPlacesMode.fixed0 => 0,
      DecimalPlacesMode.fixed2 => 2,
      DecimalPlacesMode.fixed4 => 4,
      DecimalPlacesMode.auto => null,
    };
    final formatter = digits == null
        ? NumberFormat('#,##0.##', _numberLocale)
        : _numberFormat(digits);
    final sign = value >= 0 ? '+' : '';
    return '$sign${formatter.format(value)}%';
  }

  String bondPrice(double price) {
    final formatter = NumberFormat('#,##0.##', _numberLocale);
    return '${formatter.format(price)}%';
  }

  String bondYield(double? yield) {
    if (yield == null) return '—';
    final formatter = NumberFormat('#,##0.##', _numberLocale);
    return '${formatter.format(yield)}% YTM';
  }

  String compact(double value) {
    if (config.largeNumberFormat == LargeNumberFormatId.short) {
      return NumberFormat.compact(locale: _numberLocale).format(value);
    }
    return _numberFormat(fractionDigitsFor(value)).format(value);
  }

  String date(DateTime date) =>
      DateFormat('dd MMM yyyy', _dateLocale).format(date);

  String timePattern({bool includeDate = true}) {
    if (config.use24HourTime) {
      return includeDate ? 'HH:mm, dd MMM' : 'HH:mm';
    }
    return includeDate ? 'h:mm a, dd MMM' : 'h:mm a';
  }

  String formatDateTime(DateTime value, {bool includeDate = true}) =>
      DateFormat(timePattern(includeDate: includeDate), _dateLocale)
          .format(value);

  String formatJournalPreview(DateTime value) => DateFormat(
        config.use24HourTime ? 'd MMM · HH:mm' : 'd MMM · h:mm a',
        _dateLocale,
      ).format(value);

  String formatJournalFull(DateTime value) => DateFormat(
        config.use24HourTime ? 'd MMM yyyy · HH:mm' : 'd MMM yyyy · h:mm a',
        _dateLocale,
      ).format(value);

  String baseCurrencyPrice(double value) =>
      price(value, symbol: config.baseCurrency.symbol);
}
