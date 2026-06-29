// =============================================================================
// EcoPulse · test/widget_test.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Unit/widget тест: widget_test.
// =============================================================================

import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/data_display_customization_resolver.dart';
import 'package:ecopulse/core/customization/display_formatters.dart';
import 'package:ecopulse/core/utils/formatters.dart';

void main() {
  setUp(() {
    Formatters.bind(
      DisplayFormatters(
        DataDisplayCustomizationResolver.resolve(
          CustomizationDefaults.create().dataDisplay.copyWith(
                localeCode: 'en',
              ),
        ),
      ),
    );
  });

  test('Formatters.percent adds sign', () {
    expect(Formatters.percent(5.5), '+5.5%');
    expect(Formatters.percent(-2.3), '-2.3%');
  });

  test('Formatters.rub formats currency', () {
    expect(Formatters.rub(79.26), contains('₽'));
  });
}
