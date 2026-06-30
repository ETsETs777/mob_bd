import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/navigation_customization_resolver.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NavigationCustomizationResolver orders visible tabs', () {
    final navigation = CustomizationDefaults.create().navigation.copyWith(
          tabOrder: [5, 0, 3, 1, 2, 4],
          visibleTabIndices: [0, 3, 5],
        );

    final resolved = NavigationCustomizationResolver.resolve(navigation);

    expect(resolved.orderedVisibleIndices, [5, 0, 3]);
  });

  test('NavigationCustomizationResolver falls back when none visible', () {
    final resolved = NavigationCustomizationResolver.resolve(
      CustomizationDefaults.create().navigation.copyWith(
            visibleTabIndices: const [],
          ),
    );

    expect(resolved.orderedVisibleIndices, [0]);
    expect(resolved.effectiveDefaultIndex, 0);
  });

  test('NavigationCustomizationResolver picks visible default tab', () {
    final resolved = NavigationCustomizationResolver.resolve(
      CustomizationDefaults.create().navigation.copyWith(
            defaultTabIndex: 2,
            visibleTabIndices: [0, 3],
          ),
    );

    expect(resolved.effectiveDefaultIndex, 0);
  });

  test('bar and screen index mapping', () {
    final resolved = NavigationCustomizationResolver.resolve(
      CustomizationDefaults.create().navigation.copyWith(
            tabOrder: [0, 1, 2, 3, 4, 5],
            visibleTabIndices: [0, 2, 4],
          ),
    );

    expect(resolved.barIndexForScreen(2), 1);
    expect(resolved.screenIndexForBar(1), 2);
    expect(resolved.barIndexForScreen(1), isNull);
  });

  test('bar and screen index mapping with community tab', () {
    final resolved = NavigationCustomizationResolver.resolve(
      CustomizationDefaults.create().navigation.copyWith(
            tabOrder: [0, 1, 2, 3, 4, 5],
            visibleTabIndices: [0, 2, 5],
          ),
    );

    expect(resolved.barIndexForScreen(5), 2);
    expect(resolved.screenIndexForBar(2), 5);
  });

  test('updateVisibleTabs adjusts default tab', () {
    final updated = NavigationCustomizationResolver.updateVisibleTabs(
      CustomizationDefaults.create().navigation.copyWith(defaultTabIndex: 2),
      [0, 4],
    );

    expect(updated.visibleTabIndices, [0, 4]);
    expect(updated.defaultTabIndex, 0);
  });
}
