import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/cache_service.dart';

/// Идентификаторы feature tour (Community, календарь, Home Server).
abstract final class FeatureTourId {
  static const community = 'community';
  static const calendar = 'calendar';
  static const homeServer = 'home_server';
}

/// Сохранение факта прохождения guided tour по экранам.
final featureTourCompletedProvider =
    NotifierProvider.family<FeatureTourNotifier, bool, String>(
  FeatureTourNotifier.new,
);

class FeatureTourNotifier extends FamilyNotifier<bool, String> {
  String _cacheKey(String tourId) => 'feature_tour_$tourId';

  @override
  bool build(String tourId) {
    return CacheService.instance.getString(_cacheKey(tourId)) == 'true';
  }

  Future<void> complete() async {
    state = true;
    await CacheService.instance.putString(_cacheKey(arg), 'true');
  }

  Future<void> reset() async {
    state = false;
    await CacheService.instance.deleteKey(_cacheKey(arg));
  }
}
