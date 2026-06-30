import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/user_local_data_sync_preferences.dart';
import 'package:ecopulse/data/services/cache_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    if (!CacheService.instance.isInitialized) {
      await CacheService.instance.initForTests();
    }
    await CacheService.instance.resetForTests();
  });

  test('autoPushOnChange defaults to true', () {
    expect(UserLocalDataSyncPreferences.autoPushOnChange, isTrue);
  });

  test('setAutoPushOnChange persists value', () async {
    await UserLocalDataSyncPreferences.setAutoPushOnChange(false);
    expect(UserLocalDataSyncPreferences.autoPushOnChange, isFalse);

    await UserLocalDataSyncPreferences.setAutoPushOnChange(true);
    expect(UserLocalDataSyncPreferences.autoPushOnChange, isTrue);
  });
}
