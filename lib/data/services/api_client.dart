// =============================================================================
// EcoPulse · lib/data/services/api_client.dart
// Автор: Цымбал Е. В.
// Дата: 11.05.2026
// HTTP-клиент (Dio), Hive-кэш. Файл: api_client.
// =============================================================================

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/api_keys_store.dart';
import '../../core/utils/async_refresh.dart';
import 'http_log_store.dart';
import 'retry_interceptor.dart';

/// Riverpod-провайдер [dioProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Accept': 'application/json'},
    ),
  );
  dio.interceptors.add(RetryInterceptor());
  dio.interceptors.add(_LogInterceptor());
  return dio;
});

/// Функция [coinGeckoHeaders] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
Map<String, String> coinGeckoHeaders() {
  final key = ApiKeysStore.instance.coingeckoKey;
  if (key.isEmpty) return {};
  return {'x-cg-demo-api-key': key};
}

/// Приватный класс [_LogInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
class _LogInterceptor extends Interceptor {
/// Метод [onRequest] класса [_LogInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final msg = 'HTTP ${options.method} ${options.uri}';
    debugLog(msg);
    HttpLogStore.instance.add(msg);
    handler.next(options);
  }

/// Метод [onError] класса [_LogInterceptor].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final msg = 'HTTP ERR ${err.response?.statusCode} ${err.requestOptions.uri}';
    debugLog(msg);
    HttpLogStore.instance.add(msg, isError: true);
    handler.next(err);
  }
}
