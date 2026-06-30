/// In-memory fixed-window rate limiter for abuse protection.
class RateLimiter {
  RateLimiter({this.enabled = true});

  final bool enabled;
  final _windows = <String, _Window>{};

  RateLimitResult check({
    required String key,
    required int maxAttempts,
    required Duration window,
  }) {
    if (!enabled || maxAttempts <= 0) {
      return const RateLimitResult.allowed();
    }

    final now = DateTime.now().toUtc();
    final existing = _windows[key];

    if (existing == null || now.difference(existing.start) >= window) {
      _windows[key] = _Window(start: now, count: 1);
      _maybeCleanup(now, window);
      return const RateLimitResult.allowed();
    }

    if (existing.count >= maxAttempts) {
      final elapsed = now.difference(existing.start);
      final retryAfter = window - elapsed;
      return RateLimitResult.denied(
        retryAfterSeconds: retryAfter.inSeconds.clamp(1, window.inSeconds),
      );
    }

    existing.count += 1;
    return const RateLimitResult.allowed();
  }

  void _maybeCleanup(DateTime now, Duration window) {
    if (_windows.length < 5000) return;
    _windows.removeWhere(
      (_, entry) => now.difference(entry.start) >= window,
    );
  }
}

class RateLimitResult {
  const RateLimitResult._({
    required this.allowed,
    required this.retryAfterSeconds,
  });

  const RateLimitResult.allowed()
      : allowed = true,
        retryAfterSeconds = 0;

  factory RateLimitResult.denied({required int retryAfterSeconds}) =>
      RateLimitResult._(allowed: false, retryAfterSeconds: retryAfterSeconds);

  final bool allowed;
  final int retryAfterSeconds;
}

class _Window {
  _Window({required this.start, required this.count});

  final DateTime start;
  int count;
}
