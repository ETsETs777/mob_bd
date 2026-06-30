import 'package:ecopulse_server/middleware/rate_limiter.dart';
import 'package:test/test.dart';

void main() {
  test('allows requests under the limit', () {
    final limiter = RateLimiter();
    for (var i = 0; i < 3; i++) {
      final r = limiter.check(
        key: 'auth:127.0.0.1',
        maxAttempts: 3,
        window: const Duration(minutes: 1),
      );
      expect(r.allowed, isTrue);
    }
  });

  test('blocks when limit exceeded', () {
    final limiter = RateLimiter();
    for (var i = 0; i < 2; i++) {
      limiter.check(
        key: 'article:user1',
        maxAttempts: 2,
        window: const Duration(minutes: 5),
      );
    }
    final denied = limiter.check(
      key: 'article:user1',
      maxAttempts: 2,
      window: const Duration(minutes: 5),
    );
    expect(denied.allowed, isFalse);
    expect(denied.retryAfterSeconds, greaterThan(0));
  });

  test('disabled limiter always allows', () {
    final limiter = RateLimiter(enabled: false);
    for (var i = 0; i < 100; i++) {
      final r = limiter.check(
        key: 'x',
        maxAttempts: 1,
        window: const Duration(hours: 1),
      );
      expect(r.allowed, isTrue);
    }
  });
}
