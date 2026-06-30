import 'package:dio/dio.dart';

import '../../data/models/user_article.dart';

/// Обнаружение конфликта при синхронизации правок статьи.
class ArticleSyncConflict {
  ArticleSyncConflict._();

  /// Сервер обновил статью после того, как пользователь начал правку.
  static bool detect({
    required DateTime? baseUpdatedAt,
    required String pendingTitle,
    required String pendingBody,
    required UserArticle server,
  }) {
    if (baseUpdatedAt == null) return false;
    if (!server.updatedAt.isAfter(baseUpdatedAt)) return false;
    return pendingTitle.trim() != server.title.trim() ||
        pendingBody.trim() != server.body.trim();
  }
}

bool isDioNetworkError(Object e) =>
    e is DioException &&
    (e.type == DioExceptionType.connectionError ||
        e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.response == null);
