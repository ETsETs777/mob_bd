// =============================================================================
// EcoPulse · test/backup_test.dart
// Автор: Цымбал Е. В.
// Дата: 22.06.2026
// Unit/widget тест: backup_test.
// =============================================================================

import 'package:ecopulse/core/services/backup_service.dart';
import 'package:ecopulse/data/models/user_profile.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
void main() {
  test('BackupPayload roundtrip', () {
    final payload = BackupPayload(
      version: 1,
      exportedAt: DateTime(2026, 6, 28),
      data: {
        'user_profile':
            '{"displayName":"Test","avatarEmoji":"📈","countryCode":"RU"}',
        'watchlist': '["crypto:btc"]',
      },
    );
    final json = payload.toJson();
    final restored = BackupPayload.fromJson(json);
    expect(restored.version, 1);
    expect(restored.data['watchlist'], '["crypto:btc"]');
  });

  test('UserProfile json', () {
    const profile = UserProfile(displayName: 'Alex', countryCode: 'US');
    final restored = UserProfile.fromJson(profile.toJson());
    expect(restored.displayName, 'Alex');
    expect(restored.countryCode, 'US');
  });
}
