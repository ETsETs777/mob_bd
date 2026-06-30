// =============================================================================
// EcoPulse · lib/core/errors/api_exception.dart
// Автор: Цымбал Е. В.
// Дата: 30.04.2026
// Модуль EcoPulse. Файл: api_exception.
// =============================================================================

import 'package:dio/dio.dart';

/// Enum [ApiErrorType] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
enum ApiErrorType {
/// Значение enum [network].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  network,
/// Значение enum [timeout].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  timeout,
/// Значение enum [server].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  server,
/// Значение enum [notFound].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  notFound,
/// Значение enum [rateLimit].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  rateLimit,
/// Значение enum [parse].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  parse,
/// Значение enum [unknown].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  unknown,
}

/// Класс [ApiException].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
class ApiException implements Exception {
/// Создаёт [ApiException].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  const ApiException({
    required this.message,
    required this.type,
    this.statusCode,
    this.cause,
  });

/// Поле [message] класса [ApiException].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  final String message;
/// Поле [type] класса [ApiException].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
  final ApiErrorType type;
/// Поле [statusCode] класса [ApiException].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.05.2026
  final int? statusCode;
/// Поле [cause] класса [ApiException].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.05.2026
  final Object? cause;

/// Создаёт [ApiException] (fromDio).
///
/// Автор: Цымбал Е. В.
/// Дата: 30.04.2026
  factory ApiException.fromDio(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          message: 'Превышено время ожидания',
          type: ApiErrorType.timeout,
          cause: error,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'Нет подключения к сети',
          type: ApiErrorType.network,
          cause: error,
        );
      case DioExceptionType.badResponse:
        final code = error.response?.statusCode;
        if (code == 404) {
          return ApiException(
            message: 'Данные не найдены',
            type: ApiErrorType.notFound,
            statusCode: code,
            cause: error,
          );
        }
        if (code == 429) {
          return ApiException(
            message: 'Слишком много запросов',
            type: ApiErrorType.rateLimit,
            statusCode: code,
            cause: error,
          );
        }
        if (code != null && code >= 500) {
          return ApiException(
            message: 'Ошибка сервера ($code)',
            type: ApiErrorType.server,
            statusCode: code,
            cause: error,
          );
        }
        return ApiException(
          message: 'Ошибка запроса${code != null ? ' ($code)' : ''}',
          type: ApiErrorType.unknown,
          statusCode: code,
          cause: error,
        );
      default:
        final msg = error.message ?? '';
        if (msg.contains('XMLHttpRequest') ||
            msg.toLowerCase().contains('connection error') ||
            msg.toLowerCase().contains('network')) {
          return ApiException(
            message: 'Нет подключения к сети',
            type: ApiErrorType.network,
            cause: error,
          );
        }
        return ApiException(
          message: 'Не удалось выполнить запрос',
          type: ApiErrorType.unknown,
          cause: error,
        );
    }
  }

/// Getter [userMessage] класса [ApiException].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.05.2026
  String get userMessage => switch (type) {
        ApiErrorType.network => '$message · проверьте интернет',
        ApiErrorType.timeout => '$message · попробуйте позже',
        ApiErrorType.rateLimit => '$message · подождите минуту',
        _ => message,
      };

  @override
  String toString() => 'ApiException($type): $message';
}

/// Функция [guardApi] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 02.05.2026
Future<T> guardApi<T>(Future<T> Function() call) async {
  try {
    return await call();
  } on DioException catch (e) {
    throw ApiException.fromDio(e);
  }
}
