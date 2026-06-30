import 'package:dio/dio.dart';

import '../models/article_taxonomy.dart';
import '../models/chat_thread.dart';
import '../models/home_server_auth.dart';
import '../models/user_article.dart';
import '../models/user_message.dart';

const homeServerAppVersion = '1.0.58';
const homeServerApiVersion = '1';

class HomeServerException implements Exception {
  HomeServerException(this.code, {this.statusCode, this.minAppVersion});

  final String code;
  final int? statusCode;
  final String? minAppVersion;

  @override
  String toString() => code;
}

class HomeServerClient {
  HomeServerClient({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Map<String, String> _headers({String? token}) => {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-App-Version': homeServerAppVersion,
        'X-Api-Version': homeServerApiVersion,
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      };

  String _base(String url) {
    var u = url.trim();
    if (u.endsWith('/')) u = u.substring(0, u.length - 1);
    return u;
  }

  Future<Map<String, dynamic>> health(String serverUrl) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(serverUrl)}/v1/health',
      options: Options(headers: _headers()),
    );
    return response.data ?? {};
  }

  Future<HomeServerAuth> register({
    required String serverUrl,
    required String login,
    required String password,
    String displayName = '',
    String avatarEmoji = '📈',
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_base(serverUrl)}/v1/auth/register',
      data: {
        'login': login,
        'password': password,
        'displayName': displayName,
        'avatarEmoji': avatarEmoji,
        'deviceName': 'EcoPulse Android',
      },
      options: Options(headers: _headers()),
    );
    return _authFromResponse(serverUrl, response.data ?? {});
  }

  Future<HomeServerAuth> login({
    required String serverUrl,
    required String login,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_base(serverUrl)}/v1/auth/login',
      data: {
        'login': login,
        'password': password,
        'deviceName': 'EcoPulse Android',
      },
      options: Options(headers: _headers()),
    );
    return _authFromResponse(serverUrl, response.data ?? {});
  }

  Future<void> logout(HomeServerAuth auth) async {
    if (!auth.isLoggedIn) return;
    try {
      await _dio.post<void>(
        '${_base(auth.serverUrl)}/v1/auth/logout',
        options: Options(headers: _headers(token: auth.token)),
      );
    } on DioException {
      // ignore network errors on logout
    }
  }

  Future<Map<String, dynamic>> fetchProfile(HomeServerAuth auth) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/profile/me',
      options: Options(headers: _headers(token: auth.token)),
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>> updateProfile(
    HomeServerAuth auth, {
    String? displayName,
    String? avatarEmoji,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/profile/me',
      data: {
        if (displayName != null) 'displayName': displayName,
        if (avatarEmoji != null) 'avatarEmoji': avatarEmoji,
      },
      options: Options(headers: _headers(token: auth.token)),
    );
    return response.data ?? {};
  }

  Future<List<ChatThread>> fetchThreads(HomeServerAuth auth) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/threads',
      options: Options(headers: _headers(token: auth.token)),
    );
    final list = response.data?['threads'] as List<dynamic>? ?? [];
    return list
        .map((e) => ChatThread.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<ChatThread> createDirect(
    HomeServerAuth auth, {
    String? targetProfileId,
    bool self = false,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/threads/direct',
      data: {
        if (self) 'self': true,
        if (targetProfileId != null) 'targetProfileId': targetProfileId,
      },
      options: Options(headers: _headers(token: auth.token)),
    );
    final thread = response.data?['thread'] as Map<String, dynamic>? ?? {};
    return ChatThread.fromJson(thread);
  }

  Future<List<UserMessage>> fetchMessages(
    HomeServerAuth auth,
    String threadId, {
    int limit = 50,
    String? before,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/threads/$threadId/messages',
      queryParameters: {
        'limit': limit,
        if (before != null) 'before': before,
      },
      options: Options(headers: _headers(token: auth.token)),
    );
    final list = response.data?['messages'] as List<dynamic>? ?? [];
    return list
        .map((e) => UserMessage.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<UserMessage> sendMessage(
    HomeServerAuth auth,
    String threadId,
    String text,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/threads/$threadId/messages',
      data: {'text': text},
      options: Options(headers: _headers(token: auth.token)),
    );
    final msg = response.data?['message'] as Map<String, dynamic>? ?? {};
    return UserMessage.fromJson(msg);
  }

  Future<Map<String, dynamic>?> fetchCustomization(HomeServerAuth auth) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${_base(auth.serverUrl)}/v1/profile/customization',
        options: Options(headers: _headers(token: auth.token)),
      );
      return response.data?['customization'] as Map<String, dynamic>?;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> putCustomization(
    HomeServerAuth auth,
    Map<String, dynamic> customization,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/profile/customization',
      data: {'customization': customization},
      options: Options(headers: _headers(token: auth.token)),
    );
    return response.data ?? {};
  }

  Future<Map<String, dynamic>?> fetchLocalData(HomeServerAuth auth) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${_base(auth.serverUrl)}/v1/profile/local-data',
        options: Options(headers: _headers(token: auth.token)),
      );
      return response.data?['localData'] as Map<String, dynamic>?;
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      rethrow;
    }
  }

  Future<Map<String, dynamic>> putLocalData(
    HomeServerAuth auth,
    Map<String, dynamic> localData,
  ) async {
    final response = await _dio.put<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/profile/local-data',
      data: {'localData': localData},
      options: Options(headers: _headers(token: auth.token)),
    );
    return response.data ?? {};
  }

  Future<List<Map<String, dynamic>>> searchUsers(
    HomeServerAuth auth,
    String query,
  ) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/users/search',
      queryParameters: {'q': query},
      options: Options(headers: _headers(token: auth.token)),
    );
    final list = response.data?['users'] as List<dynamic>? ?? [];
    return list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
  }

  Future<void> registerPushToken(
    HomeServerAuth auth, {
    required String token,
    required String platform,
  }) async {
    await _dio.put<void>(
      '${_base(auth.serverUrl)}/v1/profile/push-token',
      data: {'token': token, 'platform': platform},
      options: Options(headers: _headers(token: auth.token)),
    );
  }

  Future<void> unregisterPushToken(
    HomeServerAuth auth,
    String token,
  ) async {
    await _dio.delete<void>(
      '${_base(auth.serverUrl)}/v1/profile/push-token',
      queryParameters: {'token': token},
      options: Options(headers: _headers(token: auth.token)),
    );
  }

  Future<List<UserArticle>> fetchPublishedArticles(
    HomeServerAuth auth, {
    int limit = 50,
    int offset = 0,
    String? category,
    String? tag,
  }) async {
    final query = <String, dynamic>{
      'limit': limit,
      'offset': offset,
    };
    if (category != null && category.isNotEmpty) {
      query['category'] = category;
    }
    if (tag != null && tag.isNotEmpty) {
      query['tag'] = tag;
    }
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles',
      queryParameters: query,
      options: Options(headers: _headers(token: auth.token)),
    );
    final list = response.data?['articles'] as List<dynamic>? ?? [];
    return list
        .map((e) => UserArticle.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<List<UserArticle>> fetchFeaturedArticles(
    HomeServerAuth auth, {
    int limit = 5,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles/featured',
      queryParameters: {'limit': limit},
      options: Options(headers: _headers(token: auth.token)),
    );
    final list = response.data?['articles'] as List<dynamic>? ?? [];
    return list
        .map((e) => UserArticle.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<ArticleTaxonomy> fetchArticlesTaxonomy(HomeServerAuth auth) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles/taxonomy',
      options: Options(headers: _headers(token: auth.token)),
    );
    return ArticleTaxonomy.fromJson(response.data ?? {});
  }

  Future<List<UserArticle>> fetchMyArticles(HomeServerAuth auth) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles/mine',
      options: Options(headers: _headers(token: auth.token)),
    );
    final list = response.data?['articles'] as List<dynamic>? ?? [];
    return list
        .map((e) => UserArticle.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<UserArticle> submitArticle(
    HomeServerAuth auth, {
    required String title,
    required String body,
    String? category,
    List<String>? tags,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles',
      data: {
        'title': title,
        'body': body,
        if (category != null) 'category': category,
        if (tags != null && tags.isNotEmpty) 'tags': tags,
      },
      options: Options(headers: _headers(token: auth.token)),
    );
    final data = response.data?['article'] as Map<String, dynamic>? ?? {};
    return UserArticle.fromJson(data);
  }

  Future<UserArticle> fetchArticle(HomeServerAuth auth, String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles/$id',
      options: Options(headers: _headers(token: auth.token)),
    );
    final data = response.data?['article'] as Map<String, dynamic>? ?? {};
    return UserArticle.fromJson(data);
  }

  Future<List<UserArticle>> fetchPendingArticles(HomeServerAuth auth) async {
    final response = await _dio.get<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/admin/articles/pending',
      options: Options(headers: _headers(token: auth.token)),
    );
    final list = response.data?['articles'] as List<dynamic>? ?? [];
    return list
        .map((e) => UserArticle.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();
  }

  Future<UserArticle> approveArticle(HomeServerAuth auth, String id) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/admin/articles/$id/approve',
      options: Options(headers: _headers(token: auth.token)),
    );
    final data = response.data?['article'] as Map<String, dynamic>? ?? {};
    return UserArticle.fromJson(data);
  }

  Future<UserArticle> rejectArticle(
    HomeServerAuth auth,
    String id, {
    String? reason,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/admin/articles/$id/reject',
      data: {'reason': reason},
      options: Options(headers: _headers(token: auth.token)),
    );
    final data = response.data?['article'] as Map<String, dynamic>? ?? {};
    return UserArticle.fromJson(data);
  }

  Future<UserArticle> updateArticle(
    HomeServerAuth auth,
    String id, {
    required String title,
    required String body,
    String? category,
    List<String>? tags,
  }) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles/$id',
      data: {
        'title': title,
        'body': body,
        if (category != null) 'category': category,
        if (tags != null) 'tags': tags,
      },
      options: Options(headers: _headers(token: auth.token)),
    );
    final data = response.data?['article'] as Map<String, dynamic>? ?? {};
    return UserArticle.fromJson(data);
  }

  Future<void> deleteArticle(HomeServerAuth auth, String id) async {
    await _dio.delete<Map<String, dynamic>>(
      '${_base(auth.serverUrl)}/v1/articles/$id',
      options: Options(headers: _headers(token: auth.token)),
    );
  }

  HomeServerAuth _authFromResponse(String serverUrl, Map<String, dynamic> data) {
    if (data.containsKey('error')) {
      throw HomeServerException(data['error'] as String? ?? 'unknown');
    }
    return HomeServerAuth(
      serverUrl: serverUrl,
      token: data['token'] as String? ?? '',
      profileId: data['profileId'] as String? ?? '',
      login: data['login'] as String? ?? '',
      displayName: data['displayName'] as String? ?? '',
      avatarEmoji: data['avatarEmoji'] as String? ?? '📈',
      role: data['role'] as String? ?? '',
      isAdmin: data['isAdmin'] as bool? ?? false,
      canModerate: data['canModerate'] as bool? ?? false,
      canEditContent: data['canEditContent'] as bool? ?? false,
      isStaff: data['isStaff'] as bool? ?? false,
    );
  }

  HomeServerException mapError(DioException e) {
    final status = e.response?.statusCode;
    final data = e.response?.data;
    if (status == 401) {
      return HomeServerException('unauthorized', statusCode: status);
    }
    if (status == 403) {
      return HomeServerException('forbidden', statusCode: status);
    }
    if (data is Map<String, dynamic>) {
      if (status == 426) {
        return HomeServerException(
          data['error'] as String? ?? 'upgrade_required',
          statusCode: status,
          minAppVersion: data['minAppVersion'] as String?,
        );
      }
      return HomeServerException(
        data['error'] as String? ?? 'network_error',
        statusCode: status,
      );
    }
    return HomeServerException('network_error', statusCode: status);
  }
}
