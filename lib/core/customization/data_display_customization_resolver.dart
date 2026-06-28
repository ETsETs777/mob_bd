import '../../data/models/user_customization.dart';
import '../../providers/base_currency_provider.dart';
import '../../providers/locale_provider.dart';

/// Эффективные настройки отображения данных из [DataDisplayCustomization].
class ResolvedDataDisplay {
  const ResolvedDataDisplay({
    required this.baseCurrency,
    required this.appLocale,
    required this.decimalPlaces,
    required this.largeNumberFormat,
    required this.showCurrencyCode,
    required this.use24HourTime,
  });

  final BaseCurrency baseCurrency;
  final AppLocale appLocale;
  final DecimalPlacesMode decimalPlaces;
  final LargeNumberFormatId largeNumberFormat;
  final bool showCurrencyCode;
  final bool use24HourTime;
}

/// Резолвер настроек отображения данных EcoPulse.
class DataDisplayCustomizationResolver {
  DataDisplayCustomizationResolver._();

  static ResolvedDataDisplay resolve(DataDisplayCustomization dataDisplay) {
    return ResolvedDataDisplay(
      baseCurrency: BaseCurrencyX.fromString(dataDisplay.baseCurrency),
      appLocale: AppLocale.fromCode(dataDisplay.localeCode),
      decimalPlaces: dataDisplay.decimalPlaces,
      largeNumberFormat: dataDisplay.largeNumberFormat,
      showCurrencyCode: dataDisplay.showCurrencyCode,
      use24HourTime: dataDisplay.use24HourTime,
    );
  }

  static DataDisplayCustomization updateBaseCurrency(
    DataDisplayCustomization dataDisplay,
    BaseCurrency currency,
  ) =>
      dataDisplay.copyWith(baseCurrency: currency.name);

  static DataDisplayCustomization updateLocale(
    DataDisplayCustomization dataDisplay,
    AppLocale locale,
  ) =>
      dataDisplay.copyWith(localeCode: locale.code);

  static DataDisplayCustomization updateLargeNumberFormat(
    DataDisplayCustomization dataDisplay,
    LargeNumberFormatId format,
  ) =>
      dataDisplay.copyWith(largeNumberFormat: format);
}
