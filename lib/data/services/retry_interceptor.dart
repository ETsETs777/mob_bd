// =============================================================================
// EcoPulse · lib/data/services/retry_interceptor.dart
// Автор: Цымбал Е. В.
// Дата: 12.05.2026
// HTTP-клиент (Dio), Hive-кэш. Файл: retry_interceptor.
// =============================================================================

import 'package:dio/dio.dart';

/// Класс [RetryInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
class RetryInterceptor extends Interceptor {
/// Создаёт [RetryInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  RetryInterceptor({this.maxRetries = 3});

/// Поле [maxRetries] класса [RetryInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  final int maxRetries;

/// Метод [onError] класса [RetryInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.05.2026
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final shouldRetry = _shouldRetry(err);
    final attempt = err.requestOptions.extra['retry_attempt'] as int? ?? 0;

    if (!shouldRetry || attempt >= maxRetries) {
      return handler.next(err);
    }

    final delay = Duration(milliseconds: 400 * (1 << attempt));
    await Future<void>.delayed(delay);

    err.requestOptions.extra['retry_attempt'] = attempt + 1;

    try {
      final dio = Dio(
        BaseOptions(
          connectTimeout: err.requestOptions.connectTimeout,
          receiveTimeout: err.requestOptions.receiveTimeout,
        ),
      );
      final response = await dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      if (e is DioException) return handler.next(e);
      return handler.next(err);
    }
  }

/// Приватный метод [_shouldRetry] класса [RetryInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError ||
        err.response?.statusCode == 429 ||
        (err.response?.statusCode ?? 0) >= 500;
  }
}
