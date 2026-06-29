import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/home_customization_resolver.dart';
import 'package:ecopulse/core/customization/navigation_customization_resolver.dart';
import 'package:ecopulse/data/models/user_customization.dart';
import 'package:ecopulse/providers/home_layout_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('NavigationCustomizationResolver updateDefaultTabIndex', () {
    final navigation = CustomizationDefaults.create().navigation;
    final updated = NavigationCustomizationResolver.updateDefaultTabIndex(
      navigation,
      3,
    );
    expect(updated.defaultTabIndex, 3);
  });

  test('HomeCustomizationResolver reorderSections', () {
    final home = CustomizationDefaults.create().home;
    final reordered = HomeCustomizationResolver.reorderSections(home, 0, 2);
    final order = HomeCustomizationResolver.resolve(reordered).order;
    expect(order[0], isNot(HomeSectionId.learn));
    expect(order.length, HomeSectionId.values.length);
  });

  test('HomeCustomizationResolver updateSectionVisible', () {
    final home = CustomizationDefaults.create().home;
    final updated = HomeCustomizationResolver.updateSectionVisible(
      home,
      HomeSectionId.news,
      false,
    );
    expect(
      HomeCustomizationResolver.resolve(updated).isVisible(HomeSectionId.news),
      isFalse,
    );
  });
}
