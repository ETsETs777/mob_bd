import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/data_display_customization_resolver.dart';
import 'package:ecopulse/core/customization/display_formatters.dart';
import 'package:ecopulse/core/utils/formatters.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('ru');
    await initializeDateFormatting('en');
  });

  setUp(() {
    Formatters.bind(DisplayFormatters.defaults());
  });

  test('DisplayFormatters uses currency code when enabled', () {
    final formatters = DisplayFormatters(
      DataDisplayCustomizationResolver.resolve(
        CustomizationDefaults.create().dataDisplay.copyWith(
              showCurrencyCode: true,
            ),
      ),
    );

    expect(formatters.rub(1234.5), 'RUB 1,234.50');
    expect(formatters.price(99.1), 'USD 99.10');
  });

  test('DisplayFormatters respects fixed decimal places', () {
    final formatters = DisplayFormatters(
      DataDisplayCustomizationResolver.resolve(
        CustomizationDefaults.create().dataDisplay.copyWith(
              decimalPlaces: DecimalPlacesMode.fixed0,
            ),
      ),
    );

    expect(formatters.percent(5.678), '+6%');
  });

  test('DisplayFormatters switches time pattern', () {
    final formatters24 = DisplayFormatters(
      DataDisplayCustomizationResolver.resolve(
        CustomizationDefaults.create().dataDisplay,
      ),
    );
    final formatters12 = DisplayFormatters(
      DataDisplayCustomizationResolver.resolve(
        CustomizationDefaults.create().dataDisplay.copyWith(
              use24HourTime: false,
            ),
      ),
    );

    final dt = DateTime(2026, 6, 28, 15, 30);
    expect(formatters24.formatDateTime(dt), contains('15:30'));
    expect(formatters12.formatDateTime(dt).toLowerCase(), contains('pm'));
  });

  test('Formatters delegates to bound engine', () {
    Formatters.bind(
      DisplayFormatters(
        DataDisplayCustomizationResolver.resolve(
          CustomizationDefaults.create().dataDisplay.copyWith(
                showCurrencyCode: true,
              ),
        ),
      ),
    );

    expect(Formatters.rub(10), contains('RUB'));
  });
}
