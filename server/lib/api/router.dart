import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../auth/auth_service.dart';
import '../auth/password_service.dart';
import '../auth/staff_role.dart';
import '../config.dart';
import '../db/database.dart';
import '../services/customization_service.dart';
import '../services/local_data_service.dart';
import '../services/thread_service.dart';
import '../services/article_service.dart';
import '../services/admin_service.dart';
import '../services/push_token_service.dart';
import '../services/push_notification_service.dart';
import '../services/backup_service.dart';
import '../services/chat_realtime_hub.dart';
import '../middleware/rate_limiter.dart';
import '../middleware/request_utils.dart';
import 'admin_static.dart';
import 'chat_ws_handler.dart';
import 'openapi_handler.dart';

Handler createHandler({
  required AppDatabase db,
  required ServerConfig config,
  String? webAdminDir,
  String? openapiDir,
  String fcmServerKey = '',
}) {
  final passwords = PasswordService();
  final auth = AuthService(db, config, passwords);
  final threads = ThreadService(db);
  final customization = CustomizationService(db);
  final localData = LocalDataService(db);
  final articles = ArticleService(db, dataDir: config.dataDir);
  final admin = AdminService(db);
  final backups = BackupService(config, db);
  final pushTokens = PushTokenService(db);
  final push = PushNotificationService(
    db: db,
    tokens: pushTokens,
    fcmServerKey: fcmServerKey,
  );
  final chatHub = ChatRealtimeHub();
  final chatWsHandler = createChatWebSocketHandler(
    auth: auth,
    threads: threads,
    hub: chatHub,
  );
  final rateLimiter = RateLimiter(enabled: config.rateLimitEnabled);

  Response jsonOk(Object body, {int status = 200}) => Response(
        status,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

  Response jsonErr(String code, {int status = 400}) =>
      jsonOk({'error': code}, status: status);

  Response jsonRateLimit(int retryAfterSeconds) => Response(
        429,
        body: jsonEncode({
          'error': 'rate_limit_exceeded',
          'retryAfterSeconds': retryAfterSeconds,
        }),
        headers: {
          'Content-Type': 'application/json',
          'Retry-After': retryAfterSeconds.toString(),
          ..._corsHeaders,
        },
      );

  Response? enforceAuthRateLimit(Request request) {
    final result = rateLimiter.check(
      key: 'auth:${clientIp(request)}',
      maxAttempts: config.rateAuthMax,
      window: Duration(minutes: config.rateAuthWindowMinutes),
    );
    if (result.allowed) return null;
    return jsonRateLimit(result.retryAfterSeconds);
  }

  Response? enforceArticleRateLimit(String userId) {
    final result = rateLimiter.check(
      key: 'article:$userId',
      maxAttempts: config.rateArticleMax,
      window: Duration(minutes: config.rateArticleWindowMinutes),
    );
    if (result.allowed) return null;
    return jsonRateLimit(result.retryAfterSeconds);
  }

  Response? enforceMessageRateLimit(String userId) {
    final result = rateLimiter.check(
      key: 'message:$userId',
      maxAttempts: config.rateMessageMax,
      window: Duration(minutes: config.rateMessageWindowMinutes),
    );
    if (result.allowed) return null;
    return jsonRateLimit(result.retryAfterSeconds);
  }

  Future<bool> checkAppVersion(Request request) async {
    final appVersion = request.headers['x-app-version'];
    if (appVersion == null) return true;
    final min = await db.meta('min_app_version', fallback: ServerConfig.minAppVersion);
    return _compareVersion(appVersion, min) >= 0;
  }

  Middleware cors = (Handler inner) {
    return (Request request) async {
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: _corsHeaders);
      }
      final response = await inner(request);
      return response.change(headers: _corsHeaders);
    };
  };

  Middleware versionGate = (Handler inner) {
    return (Request request) async {
      if (!await checkAppVersion(request) &&
          !request.url.path.endsWith('health') &&
          !isOpenApiPublicPath(request.url.path) &&
          !request.url.path.contains('ws/chat')) {
        return jsonOk(
          {
            'error': 'upgrade_required',
            'minAppVersion': await db.meta('min_app_version'),
          },
          status: 426,
        );
      }
      return inner(request);
    };
  };

  Future<Map<String, String>> requireUser(Request request) async {
    final user = await auth.verifyBearer(request.headers['authorization']);
    if (user == null) throw _HttpException(401, 'unauthorized');
    return user;
  }

  Future<Map<String, String>> requireStaff(Request request) async {
    final user = await requireUser(request);
    if (!StaffRole.isStaff(user['role'])) {
      throw _HttpException(403, 'forbidden');
    }
    return user;
  }

  Future<Map<String, String>> requireModerator(Request request) async {
    final user = await requireUser(request);
    if (!StaffRole.canModerate(user['role'])) {
      throw _HttpException(403, 'forbidden');
    }
    return user;
  }

  Future<Map<String, String>> requireEditor(Request request) async {
    final user = await requireUser(request);
    if (!StaffRole.canEditContent(user['role'])) {
      throw _HttpException(403, 'forbidden');
    }
    return user;
  }

  Future<Map<String, String>> requireFullAdmin(Request request) async {
    final user = await requireUser(request);
    if (!StaffRole.canManageSettings(user['role'])) {
      throw _HttpException(403, 'forbidden');
    }
    return user;
  }

  Map<String, dynamic> _profileJson(Map<String, String> user) {
    final role = user['role'] ?? StaffRole.none;
    return {
      'profileId': user['id'],
      'login': user['login'],
      'displayName': user['displayName'],
      'avatarEmoji': user['avatarEmoji'],
      'role': role,
      'isAdmin': StaffRole.isFullAdmin(role),
      'canModerate': StaffRole.canModerate(role),
      'canEditContent': StaffRole.canEditContent(role),
      'isStaff': StaffRole.isStaff(role),
    };
  }

  final router = Router();

  router.get('/v1/health', (Request request) async {
    return jsonOk({
      'ok': true,
      'serverVersion': await db.meta('server_version', fallback: ServerConfig.serverVersion),
      'minAppVersion': await db.meta('min_app_version', fallback: ServerConfig.minAppVersion),
      'apiVersion': ServerConfig.apiVersion,
      'database': config.databaseBackend.name,
      'rateLimit': config.rateLimitEnabled,
    });
  });

  router.post('/v1/auth/register', (Request request) async {
    final limited = enforceAuthRateLimit(request);
    if (limited != null) return limited;
    try {
      final body = parseJsonBody(await request.readAsString());
      final result = await auth.register(
        login: body['login'] as String? ?? '',
        password: body['password'] as String? ?? '',
        displayName: body['displayName'] as String? ?? '',
        avatarEmoji: body['avatarEmoji'] as String? ?? '📈',
        deviceName: body['deviceName'] as String?,
      );
      await threads.ensureSelfThread(result.profileId);
      return jsonOk(_authJson(result));
    } on AuthException catch (e) {
      return jsonErr(e.code, status: 409);
    }
  });

  router.post('/v1/auth/login', (Request request) async {
    final limited = enforceAuthRateLimit(request);
    if (limited != null) return limited;
    try {
      final body = parseJsonBody(await request.readAsString());
      final result = await auth.login(
        login: body['login'] as String? ?? '',
        password: body['password'] as String? ?? '',
        deviceName: body['deviceName'] as String?,
      );
      await threads.ensureSelfThread(result.profileId);
      return jsonOk(_authJson(result));
    } on AuthException catch (e) {
      return jsonErr(e.code, status: 401);
    }
  });

  router.post('/v1/auth/logout', (Request request) async {
    final user = await requireUser(request);
    await auth.logout(user['id']!, request.headers['authorization']);
    return jsonOk({'ok': true});
  });

  router.get('/v1/profile/me', (Request request) async {
    final user = await requireUser(request);
    return jsonOk(_profileJson(user));
  });

  router.patch('/v1/profile/me', (Request request) async {
    final user = await requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    final displayName = body['displayName'] as String?;
    final avatarEmoji = body['avatarEmoji'] as String?;

    if (displayName != null) {
      await db.execute(
        'UPDATE users SET display_name = ? WHERE id = ?',
        [displayName.trim(), user['id']],
      );
    }
    if (avatarEmoji != null) {
      await db.execute(
        'UPDATE users SET avatar_emoji = ? WHERE id = ?',
        [avatarEmoji, user['id']],
      );
    }

    final rows = await db.select(
      'SELECT id, login, display_name, avatar_emoji FROM users WHERE id = ?',
      [user['id']],
    );
    final row = rows.first;
    await db.audit(action: 'update_profile', userId: user['id']);
    return jsonOk(_profileJson({
      'id': row['id'] as String,
      'login': row['login'] as String,
      'displayName': row['display_name'] as String,
      'avatarEmoji': row['avatar_emoji'] as String,
      'role': user['role'] ?? StaffRole.none,
    }));
  });

  router.get('/v1/profile/customization', (Request request) async {
    final user = await requireUser(request);
    final snapshot = await customization.get(user['id']!);
    if (snapshot == null) {
      return jsonErr('not_found', status: 404);
    }
    return jsonOk({'customization': snapshot});
  });

  router.put('/v1/profile/customization', (Request request) async {
    final user = await requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    final raw = body['customization'];
    if (raw is! Map<String, dynamic>) {
      return jsonErr('invalid_payload', status: 400);
    }
    return jsonOk(await customization.put(user['id']!, raw));
  });

  router.get('/v1/profile/local-data', (Request request) async {
    final user = await requireUser(request);
    final snapshot = await localData.get(user['id']!);
    if (snapshot == null) {
      return jsonErr('not_found', status: 404);
    }
    return jsonOk({'localData': snapshot});
  });

  router.put('/v1/profile/local-data', (Request request) async {
    final user = await requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    final raw = body['localData'];
    if (raw is! Map<String, dynamic>) {
      return jsonErr('invalid_payload', status: 400);
    }
    return jsonOk(await localData.put(user['id']!, raw));
  });

  router.put('/v1/profile/push-token', (Request request) async {
    final user = await requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    final token = body['token'] as String? ?? '';
    final platform = body['platform'] as String? ?? 'android';
    if (token.trim().isEmpty) return jsonErr('invalid_payload', status: 400);
    await pushTokens.upsert(
      userId: user['id']!,
      token: token,
      platform: platform,
    );
    await db.audit(action: 'push_token_register', userId: user['id']);
    return jsonOk({'ok': true});
  });

  router.delete('/v1/profile/push-token', (Request request) async {
    final user = await requireUser(request);
    final token = request.url.queryParameters['token'] ?? '';
    if (token.trim().isEmpty) return jsonErr('invalid_payload', status: 400);
    await pushTokens.remove(userId: user['id']!, token: token);
    await db.audit(action: 'push_token_unregister', userId: user['id']);
    return jsonOk({'ok': true});
  });

  router.get('/v1/threads', (Request request) async {
    final user = await requireUser(request);
    await threads.ensureSelfThread(user['id']!);
    return jsonOk({'threads': await threads.listThreads(user['id']!)});
  });

  router.post('/v1/threads/direct', (Request request) async {
    final user = await requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final thread = await threads.createDirect(
        userId: user['id']!,
        targetProfileId: body['targetProfileId'] as String?,
        self: body['self'] == true,
      );
      return jsonOk({'thread': thread});
    } on ThreadException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.get('/v1/threads/<threadId>/messages', (Request request, String threadId) async {
    final user = await requireUser(request);
    final before = request.url.queryParameters['before'];
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 50;
    try {
      return jsonOk({
        'messages': await threads.listMessages(
          threadId,
          user['id']!,
          limit: limit.clamp(1, 100),
          before: before,
        ),
      });
    } on ThreadException catch (e) {
      return jsonErr(e.code, status: 403);
    }
  });

  router.post('/v1/threads/<threadId>/messages', (Request request, String threadId) async {
    final user = await requireUser(request);
    final limited = enforceMessageRateLimit(user['id']!);
    if (limited != null) return limited;
    final body = parseJsonBody(await request.readAsString());
    try {
      final message = await threads.sendMessage(
        threadId: threadId,
        userId: user['id']!,
        text: body['text'] as String? ?? '',
      );
      chatHub.broadcastMessage(
        threadId,
        message,
        memberIds: await threads.memberIds(threadId),
        senderId: user['id'],
      );
      return jsonOk({'message': message});
    } on ThreadException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.get('/v1/users/search', (Request request) async {
    final user = await requireUser(request);
    final q = request.url.queryParameters['q'] ?? '';
    return jsonOk({
      'users': await threads.searchUsers(q, excludeUserId: user['id']),
    });
  });

  router.get('/v1/articles/featured', (Request request) async {
    await requireUser(request);
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 5;
    return jsonOk({'articles': await articles.listFeatured(limit: limit)});
  });

  router.get('/v1/articles/taxonomy', (Request request) async {
    await requireUser(request);
    return jsonOk(await articles.taxonomy());
  });

  router.get('/v1/articles', (Request request) async {
    await requireUser(request);
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 50;
    final offset = int.tryParse(request.url.queryParameters['offset'] ?? '') ?? 0;
    final category = request.url.queryParameters['category'];
    final tag = request.url.queryParameters['tag'];
    return jsonOk({
      'articles': await articles.listPublished(
        limit: limit,
        offset: offset,
        category: category,
        tag: tag,
      ),
    });
  });

  router.get('/v1/articles/mine', (Request request) async {
    final user = await requireUser(request);
    return jsonOk({'articles': await articles.listMine(user['id']!)});
  });

  router.post('/v1/articles', (Request request) async {
    final user = await requireUser(request);
    final limited = enforceArticleRateLimit(user['id']!);
    if (limited != null) return limited;
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = await articles.submit(
        authorId: user['id']!,
        title: body['title'] as String? ?? '',
        body: body['body'] as String? ?? '',
        category: body['category'] as String?,
        tags: body['tags'] is List
            ? (body['tags'] as List).map((e) => e.toString()).toList()
            : null,
      );
      unawaited(
        push.notifyAdminsNewPending(
          articleId: article['id'] as String,
          title: article['title'] as String,
          authorLogin: article['authorLogin'] as String? ?? user['login'] ?? '',
          excludeUserId: user['id'],
        ),
      );
      return jsonOk({'article': article}, status: 201);
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.get('/v1/articles/<articleId>', (Request request, String articleId) async {
    final user = await requireUser(request);
    final isStaff = StaffRole.isStaff(user['role']);
    final article = await articles.get(
      articleId: articleId,
      viewerId: user['id']!,
      isStaff: isStaff,
    );
    if (article == null) return jsonErr('not_found', status: 404);
    return jsonOk({'article': article});
  });

  router.patch('/v1/articles/<articleId>', (Request request, String articleId) async {
    final user = await requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = await articles.update(
        authorId: user['id']!,
        articleId: articleId,
        title: body['title'] as String? ?? '',
        body: body['body'] as String? ?? '',
        category: body['category'] as String?,
        tags: body['tags'] is List
            ? (body['tags'] as List).map((e) => e.toString()).toList()
            : null,
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      final status = e.code == 'not_found'
          ? 404
          : e.code == 'forbidden'
              ? 403
              : 400;
      return jsonErr(e.code, status: status);
    }
  });

  router.delete('/v1/articles/<articleId>', (Request request, String articleId) async {
    final user = await requireUser(request);
    try {
      await articles.delete(authorId: user['id']!, articleId: articleId);
      return jsonOk({'ok': true});
    } on ArticleException catch (e) {
      final status = e.code == 'not_found'
          ? 404
          : e.code == 'forbidden'
              ? 403
              : 400;
      return jsonErr(e.code, status: status);
    }
  });

  router.get('/v1/admin/articles/pending', (Request request) async {
    await requireModerator(request);
    return jsonOk({'articles': await articles.listPending()});
  });

  router.post('/v1/admin/articles/batch/approve', (Request request) async {
    final adminUser = await requireModerator(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final ids = body['ids'] as List<dynamic>? ?? [];
      final result = await articles.batchApprove(
        adminId: adminUser['id']!,
        articleIds: ids.map((e) => e.toString()).toList(),
      );
      for (final item in result['succeeded'] as List<dynamic>) {
        final entry = item as Map<String, dynamic>;
        final article = entry['article'] as Map<String, dynamic>;
        unawaited(
          push.notifyArticleApproved(
            authorId: article['authorId'] as String,
            articleId: entry['id'] as String,
            title: article['title'] as String,
          ),
        );
      }
      return jsonOk(result);
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.post('/v1/admin/articles/batch/reject', (Request request) async {
    final adminUser = await requireModerator(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final ids = body['ids'] as List<dynamic>? ?? [];
      final reason = body['reason'] as String?;
      final result = await articles.batchReject(
        adminId: adminUser['id']!,
        articleIds: ids.map((e) => e.toString()).toList(),
        reason: reason,
      );
      for (final item in result['succeeded'] as List<dynamic>) {
        final entry = item as Map<String, dynamic>;
        final article = entry['article'] as Map<String, dynamic>;
        unawaited(
          push.notifyArticleRejected(
            authorId: article['authorId'] as String,
            articleId: entry['id'] as String,
            title: article['title'] as String,
            reason: reason,
          ),
        );
      }
      return jsonOk(result);
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.post('/v1/admin/articles/batch/delete', (Request request) async {
    final adminUser = await requireEditor(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final ids = body['ids'] as List<dynamic>? ?? [];
      final result = await articles.batchDelete(
        adminId: adminUser['id']!,
        articleIds: ids.map((e) => e.toString()).toList(),
      );
      return jsonOk(result);
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.post('/v1/admin/articles/<articleId>/approve', (
    Request request,
    String articleId,
  ) async {
    final admin = await requireModerator(request);
    try {
      final article = await articles.approve(
        articleId: articleId,
        adminId: admin['id']!,
      );
      unawaited(
        push.notifyArticleApproved(
          authorId: article['authorId'] as String,
          articleId: articleId,
          title: article['title'] as String,
        ),
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.post('/v1/admin/articles/<articleId>/reject', (
    Request request,
    String articleId,
  ) async {
    final adminUser = await requireModerator(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = await articles.reject(
        articleId: articleId,
        adminId: adminUser['id']!,
        reason: body['reason'] as String?,
      );
      unawaited(
        push.notifyArticleRejected(
          authorId: article['authorId'] as String,
          articleId: articleId,
          title: article['title'] as String,
          reason: body['reason'] as String?,
        ),
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.get('/v1/admin/dashboard', (Request request) async {
    await requireStaff(request);
    return jsonOk({'dashboard': await admin.dashboard()});
  });

  router.get('/v1/admin/articles', (Request request) async {
    await requireEditor(request);
    final status = request.url.queryParameters['status'];
    final q = request.url.queryParameters['q'];
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 50;
    final offset = int.tryParse(request.url.queryParameters['offset'] ?? '') ?? 0;
    return jsonOk({
      'articles': await articles.listAll(
        status: status,
        q: q,
        limit: limit,
        offset: offset,
      ),
    });
  });

  router.post('/v1/admin/articles', (Request request) async {
    final adminUser = await requireEditor(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = await articles.adminCreate(
        adminId: adminUser['id']!,
        title: body['title'] as String? ?? '',
        body: body['body'] as String? ?? '',
        publish: body['publish'] != false,
        publishAt: body['publishAt'] as String?,
        coverUrl: body['coverUrl'] as String?,
        category: body['category'] as String?,
        tags: body['tags'] is List
            ? (body['tags'] as List).map((e) => e.toString()).toList()
            : null,
        featured: body['featured'] == true,
      );
      return jsonOk({'article': article}, status: 201);
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.patch('/v1/admin/articles/<articleId>', (
    Request request,
    String articleId,
  ) async {
    final adminUser = await requireEditor(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = await articles.adminUpdate(
        adminId: adminUser['id']!,
        articleId: articleId,
        title: body['title'] as String? ?? '',
        body: body['body'] as String? ?? '',
        status: body['status'] as String?,
        publishAt: body.containsKey('publishAt') ? body['publishAt'] as String? : null,
        clearCover: body['clearCover'] == true,
        category: body['category'] as String?,
        tags: body['tags'] is List
            ? (body['tags'] as List).map((e) => e.toString()).toList()
            : null,
        featured: body.containsKey('featured') ? body['featured'] == true : null,
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      final status = e.code == 'not_found' ? 404 : 400;
      return jsonErr(e.code, status: status);
    }
  });

  router.post('/v1/admin/articles/<articleId>/rollback', (
    Request request,
    String articleId,
  ) async {
    final adminUser = await requireEditor(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final versionId = body['versionId'] as String? ?? '';
      if (versionId.isEmpty) return jsonErr('version_id_required', status: 400);
      final article = await articles.rollback(
        adminId: adminUser['id']!,
        articleId: articleId,
        versionId: versionId,
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      final status = e.code == 'not_found' || e.code == 'version_not_found'
          ? 404
          : 400;
      return jsonErr(e.code, status: status);
    }
  });

  router.get('/v1/admin/articles/<articleId>/versions/<versionId>', (
    Request request,
    String articleId,
    String versionId,
  ) async {
    await requireEditor(request);
    try {
      final version = await articles.getVersion(
        articleId: articleId,
        versionId: versionId,
      );
      return jsonOk({'version': version});
    } on ArticleException catch (e) {
      final status = e.code == 'not_found' || e.code == 'version_not_found'
          ? 404
          : 400;
      return jsonErr(e.code, status: status);
    }
  });

  router.get('/v1/admin/articles/<articleId>/versions', (
    Request request,
    String articleId,
  ) async {
    await requireEditor(request);
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 30;
    final offset = int.tryParse(request.url.queryParameters['offset'] ?? '') ?? 0;
    try {
      return jsonOk({
        'versions': await articles.listVersions(
          articleId: articleId,
          limit: limit,
          offset: offset,
        ),
      });
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.delete('/v1/admin/articles/<articleId>', (
    Request request,
    String articleId,
  ) async {
    final adminUser = await requireEditor(request);
    try {
      await articles.adminDelete(adminId: adminUser['id']!, articleId: articleId);
      return jsonOk({'ok': true});
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.post('/v1/admin/articles/<articleId>/unpublish', (
    Request request,
    String articleId,
  ) async {
    final adminUser = await requireEditor(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = await articles.unpublish(
        adminId: adminUser['id']!,
        articleId: articleId,
        reason: body['reason'] as String?,
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.post('/v1/admin/articles/<articleId>/cover', (
    Request request,
    String articleId,
  ) async {
    final adminUser = await requireEditor(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final raw = body['data'] as String? ?? '';
      final bytes = base64Decode(raw.replaceAll(RegExp(r'\s+'), ''));
      final article = await articles.setCover(
        adminId: adminUser['id']!,
        articleId: articleId,
        bytes: bytes,
        contentType: body['contentType'] as String? ?? 'image/jpeg',
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      final status = e.code == 'not_found' ? 404 : 400;
      return jsonErr(e.code, status: status);
    } on FormatException {
      return jsonErr('invalid_cover_data', status: 400);
    }
  });

  router.get('/v1/media/article-covers/<filename>', (
    Request request,
    String filename,
  ) {
    if (filename.contains('..') || filename.contains('/')) {
      return jsonErr('not_found', status: 404);
    }
    final file = articles.coverFileForUrl('/v1/media/article-covers/$filename');
    if (file == null) return jsonErr('not_found', status: 404);
    final ext = p.extension(filename).toLowerCase();
    final type = switch (ext) {
      '.png' => 'image/png',
      '.webp' => 'image/webp',
      '.gif' => 'image/gif',
      _ => 'image/jpeg',
    };
    return Response.ok(
      file.readAsBytesSync(),
      headers: {'Content-Type': type, 'Cache-Control': 'public, max-age=86400'},
    );
  });

  router.get('/v1/admin/users', (Request request) async {
    await requireFullAdmin(request);
    final q = request.url.queryParameters['q'];
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 100;
    return jsonOk({'users': await admin.listUsers(q: q, limit: limit)});
  });

  router.patch('/v1/admin/users/<userId>', (
    Request request,
    String userId,
  ) async {
    await requireFullAdmin(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final user = await admin.updateUser(
        userId: userId,
        role: body['role'] as String?,
        isAdmin: body.containsKey('isAdmin') ? body['isAdmin'] == true : null,
        displayName: body['displayName'] as String?,
      );
      return jsonOk({'user': user});
    } on AdminException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.get('/v1/admin/audit', (Request request) async {
    await requireFullAdmin(request);
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 50;
    final offset = int.tryParse(request.url.queryParameters['offset'] ?? '') ?? 0;
    return jsonOk({'logs': await admin.listAudit(limit: limit, offset: offset)});
  });

  router.get('/v1/admin/settings', (Request request) async {
    await requireFullAdmin(request);
    return jsonOk({'settings': await admin.getSettings()});
  });

  router.patch('/v1/admin/settings', (Request request) async {
    await requireFullAdmin(request);
    final body = parseJsonBody(await request.readAsString());
    return jsonOk({
      'settings': await admin.updateSettings(
        minAppVersion: body['minAppVersion'] as String?,
        adminLogins: body['adminLogins'] as String?,
      ),
    });
  });

  router.get('/v1/admin/backups', (Request request) async {
    await requireFullAdmin(request);
    return jsonOk({
      'status': await backups.status(),
      'backups': await backups.list(),
    });
  });

  router.post('/v1/admin/backups', (Request request) async {
    final user = await requireFullAdmin(request);
    try {
      final entry = await backups.create(
        source: 'manual',
        userId: user['id'],
      );
      return jsonOk({'backup': entry}, status: 201);
    } on BackupException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.get('/v1/admin/backups/<id>/download', (
    Request request,
    String id,
  ) async {
    await requireFullAdmin(request);
    try {
      final file = await backups.fileFor(id);
      final bytes = await file.readAsBytes();
      return Response.ok(
        bytes,
        headers: {
          'Content-Type': 'application/octet-stream',
          'Content-Disposition': 'attachment; filename="${file.uri.pathSegments.last}"',
        },
      );
    } on BackupException catch (e) {
      return jsonErr(e.code, status: e.code == 'not_found' ? 404 : 400);
    }
  });

  router.post('/v1/admin/backups/<id>/restore', (
    Request request,
    String id,
  ) async {
    final user = await requireFullAdmin(request);
    try {
      final result = await backups.restore(id: id, userId: user['id']);
      return jsonOk(result);
    } on BackupException catch (e) {
      final status = e.code == 'not_found' ? 404 : 400;
      return jsonErr(e.code, status: status);
    }
  });

  router.delete('/v1/admin/backups/<id>', (Request request, String id) async {
    final user = await requireFullAdmin(request);
    try {
      await backups.delete(id: id, userId: user['id']);
      return jsonOk({'ok': true});
    } on BackupException catch (e) {
      return jsonErr(e.code, status: e.code == 'not_found' ? 404 : 400);
    }
  });

  Handler apiHandler = Pipeline()
      .addMiddleware(cors)
      .addMiddleware(versionGate)
      .addMiddleware(logRequests())
      .addHandler(router.call);

  Handler? openApiHandler;
  if (openapiDir != null) {
    openApiHandler = Pipeline()
        .addMiddleware(cors)
        .addMiddleware(logRequests())
        .addHandler(createOpenApiHandler(openapiDir));
  }

  Future<Response> dispatchHandler(Request request) async {
    final path = request.url.path;
    if (path == chatWebSocketPath()) {
      return chatWsHandler(request);
    }
    if (openApiHandler != null && isOpenApiPublicPath(path)) {
      return openApiHandler(request);
    }
    try {
      return await apiHandler(request);
    } on _HttpException catch (e) {
      return jsonErr(e.code, status: e.status);
    } catch (e) {
      stderr.writeln('Server error: $e');
      return jsonErr('internal_error', status: 500);
    }
  }

  if (webAdminDir != null) {
    final staticHandler = createAdminStaticHandler(webAdminDir);
    return (Request request) {
      final path = request.url.path;
      if (path == 'admin' || path.startsWith('admin/')) {
        return staticHandler(request);
      }
      return dispatchHandler(request);
    };
  }

  return dispatchHandler;
}

Map<String, dynamic> _authJson(AuthResult r) => {
      'profileId': r.profileId,
      'token': r.token,
      'login': r.login,
      'displayName': r.displayName,
      'avatarEmoji': r.avatarEmoji,
      'role': r.role,
      'isAdmin': r.isAdmin,
      'canModerate': r.canModerate,
      'canEditContent': r.canEditContent,
      'isStaff': r.isStaff,
    };

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, DELETE, OPTIONS',
  'Access-Control-Allow-Headers':
      'Origin, Content-Type, Authorization, X-App-Version, X-Api-Version',
};

int _compareVersion(String a, String b) {
  final pa = a.split('.').map(int.parse).toList();
  final pb = b.split('.').map(int.parse).toList();
  for (var i = 0; i < 3; i++) {
    final va = i < pa.length ? pa[i] : 0;
    final vb = i < pb.length ? pb[i] : 0;
    if (va != vb) return va.compareTo(vb);
  }
  return 0;
}

class _HttpException implements Exception {
  _HttpException(this.status, this.code);
  final int status;
  final String code;
}

Future<HttpServer> startServer({
  required AppDatabase db,
  required ServerConfig config,
  String? webAdminDir,
  String? openapiDir,
  String fcmServerKey = '',
}) {
  final handler = createHandler(
    db: db,
    config: config,
    webAdminDir: webAdminDir,
    openapiDir: openapiDir,
    fcmServerKey: fcmServerKey,
  );
  return shelf_io.serve(handler, config.host, config.port);
}
