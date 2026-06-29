import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/data_display_customization_resolver.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:ecopulse/providers/base_currency_provider.dart';
import 'package:ecopulse/providers/locale_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('DataDisplayCustomizationResolver resolves display flags', () {
    final dataDisplay = CustomizationDefaults.create().dataDisplay.copyWith(
          baseCurrency: 'rub',
          localeCode: 'en',
          decimalPlaces: DecimalPlacesMode.fixed2,
          largeNumberFormat: LargeNumberFormatId.short,
          showCurrencyCode: true,
          use24HourTime: false,
        );

    final resolved = DataDisplayCustomizationResolver.resolve(dataDisplay);

    expect(resolved.baseCurrency, BaseCurrency.rub);
    expect(resolved.appLocale, AppLocale.en);
    expect(resolved.decimalPlaces, DecimalPlacesMode.fixed2);
    expect(resolved.largeNumberFormat, LargeNumberFormatId.short);
    expect(resolved.showCurrencyCode, isTrue);
    expect(resolved.use24HourTime, isFalse);
  });

  test('update helpers mutate config', () {
    final dataDisplay = CustomizationDefaults.create().dataDisplay;
    final withCurrency =
        DataDisplayCustomizationResolver.updateBaseCurrency(
      dataDisplay,
      BaseCurrency.eur,
    );
    expect(withCurrency.baseCurrency, 'eur');

    final withLocale = DataDisplayCustomizationResolver.updateLocale(
      dataDisplay,
      AppLocale.en,
    );
    expect(withLocale.localeCode, 'en');
  });
}
