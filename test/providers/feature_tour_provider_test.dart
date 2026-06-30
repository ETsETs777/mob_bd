import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:ecopulse/data/services/cache_service.dart';
import 'package:ecopulse/providers/app/feature_tour_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    await CacheService.instance.initForTests();
    await CacheService.instance.deleteKey('feature_tour_community');
  });

  test('featureTourCompletedProvider tracks completion per tour id', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(
      container.read(featureTourCompletedProvider(FeatureTourId.community)),
      isFalse,
    );

    await container
        .read(featureTourCompletedProvider(FeatureTourId.community).notifier)
        .complete();

    expect(
      container.read(featureTourCompletedProvider(FeatureTourId.community)),
      isTrue,
    );
    expect(
      container.read(featureTourCompletedProvider(FeatureTourId.calendar)),
      isFalse,
    );
  });
}
