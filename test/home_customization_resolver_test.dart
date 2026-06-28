import 'package:ecopulse/core/customization/customization_defaults.dart';
import 'package:ecopulse/core/customization/home_customization_resolver.dart';
import 'package:ecopulse/providers/home_layout_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('HomeCustomizationResolver preserves section order', () {
    final home = CustomizationDefaults.create().home.copyWith(
          sectionOrder: [
            'bonds',
            'news',
            'learn',
          ],
        );

    final resolved = HomeCustomizationResolver.resolve(home);

    expect(resolved.order.take(3).map((s) => s.name).toList(), [
      'bonds',
      'news',
      'learn',
    ]);
    expect(resolved.order.length, HomeSectionId.values.length);
  });

  test('HomeCustomizationResolver applies section visibility', () {
    final home = CustomizationDefaults.create().home.copyWith(
          sectionVisibility: {'news': false, 'radar': false},
        );

    final resolved = HomeCustomizationResolver.resolve(home);

    expect(resolved.isVisible(HomeSectionId.news), isFalse);
    expect(resolved.isVisible(HomeSectionId.radar), isFalse);
    expect(resolved.isVisible(HomeSectionId.learn), isTrue);
    expect(resolved.visibleInOrder, isNot(contains(HomeSectionId.news)));
  });

  test('HomeCustomizationResolver clamps news count', () {
    final resolved = HomeCustomizationResolver.resolve(
      CustomizationDefaults.create().home.copyWith(newsCount: 99),
    );

    expect(resolved.newsCount, 10);
  });

  test('homeSparklineData respects enabled flag', () {
    expect(
      homeSparklineData([1, 2, 3], enabled: false),
      isNull,
    );
    expect(
      homeSparklineData([1, 2, 3], enabled: true),
      [1, 2, 3],
    );
    expect(
      homeSparklineData([1], enabled: true),
      isNull,
    );
  });

  test('HomeCustomizationResolver update helpers mutate config', () {
    final home = CustomizationDefaults.create().home;
    final hidden = HomeCustomizationResolver.updateSectionVisible(
      home,
      HomeSectionId.news,
      false,
    );
    expect(hidden.sectionVisibility['news'], isFalse);

    final reordered = HomeCustomizationResolver.updateSectionOrder(
      home,
      ['portfolio', 'learn'],
    );
    expect(reordered.sectionOrder, ['portfolio', 'learn']);
  });
}
