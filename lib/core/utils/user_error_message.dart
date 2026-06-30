import 'package:dio/dio.dart';

import '../../l10n/app_localizations.dart';
import '../errors/api_exception.dart';

/// Преобразует любую ошибку в короткое сообщение для пользователя (без Dio/stack trace).
String userErrorMessage(
  Object error, {
  AppLocalizations? l10n,
}) {
  final api = _asApiException(error);
  if (api != null) {
    return _localizedApiMessage(api, l10n);
  }

  final raw = error.toString().trim();
  if (_looksTechnical(raw)) {
    return l10n?.errorNetwork ??
        'Не удалось загрузить данные. Проверьте интернет и попробуйте снова.';
  }

  if (raw.length > 160) {
    return '${raw.substring(0, 157)}…';
  }
  return raw;
}

ApiException? _asApiException(Object error) {
  if (error is ApiException) return error;
  if (error is DioException) return ApiException.fromDio(error);
  return null;
}

String _localizedApiMessage(ApiException ex, AppLocalizations? l10n) {
  if (l10n != null) {
    return switch (ex.type) {
      ApiErrorType.network => l10n.errorNetwork,
      ApiErrorType.timeout => l10n.errorTimeout,
      ApiErrorType.server => l10n.errorServer,
      ApiErrorType.notFound => l10n.errorNotFound,
      ApiErrorType.rateLimit => l10n.errorRateLimit,
      ApiErrorType.parse => l10n.errorDataUnavailable,
      ApiErrorType.unknown => l10n.errorDataUnavailable,
    };
  }
  return ex.userMessage;
}

bool _looksTechnical(String raw) {
  if (raw.isEmpty) return true;
  const markers = [
    'DioException',
    'XMLHttpRequest',
    'SocketException',
    'ClientException',
    'HandshakeException',
    'Connection refused',
    'connection error',
    'Failed host lookup',
    'Network is unreachable',
    'Stack trace',
    'package:',
  ];
  for (final marker in markers) {
    if (raw.contains(marker)) return true;
  }
  return raw.length > 180;
}

/// Безопасная строка для сохранения в state провайдера (без l10n).
String userErrorMessageShort(Object error) =>
    userErrorMessage(error);
