import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';

import '../auth/auth_service.dart';
import '../auth/password_service.dart';
import '../config.dart';
import '../db/database.dart';
import '../services/customization_service.dart';
import '../services/local_data_service.dart';
import '../services/thread_service.dart';
import '../services/article_service.dart';

Handler createHandler({
  required AppDatabase db,
  required ServerConfig config,
}) {
  final passwords = PasswordService();
  final auth = AuthService(db, config, passwords);
  final threads = ThreadService(db);
  final customization = CustomizationService(db);
  final localData = LocalDataService(db);
  final articles = ArticleService(db);

  Response jsonOk(Object body, {int status = 200}) => Response(
        status,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

  Response jsonErr(String code, {int status = 400}) =>
      jsonOk({'error': code}, status: status);

  bool checkAppVersion(Request request) {
    final appVersion = request.headers['x-app-version'];
    if (appVersion == null) return true;
    final min = db.meta('min_app_version', fallback: ServerConfig.minAppVersion);
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
      if (!checkAppVersion(request) && !request.url.path.endsWith('health')) {
        return jsonOk(
          {'error': 'upgrade_required', 'minAppVersion': db.meta('min_app_version')},
          status: 426,
        );
      }
      return inner(request);
    };
  };

  Map<String, String> requireUser(Request request) {
    final user = auth.verifyBearer(request.headers['authorization']);
    if (user == null) throw _HttpException(401, 'unauthorized');
    return user;
  }

  Map<String, String> requireAdmin(Request request) {
    final user = requireUser(request);
    if (user['isAdmin'] != '1') throw _HttpException(403, 'forbidden');
    return user;
  }

  final router = Router();

  router.get('/v1/health', (Request request) {
    return jsonOk({
      'ok': true,
      'serverVersion': db.meta('server_version', fallback: ServerConfig.serverVersion),
      'minAppVersion': db.meta('min_app_version', fallback: ServerConfig.minAppVersion),
      'apiVersion': ServerConfig.apiVersion,
    });
  });

  router.post('/v1/auth/register', (Request request) async {
    try {
      final body = parseJsonBody(await request.readAsString());
      final result = auth.register(
        login: body['login'] as String? ?? '',
        password: body['password'] as String? ?? '',
        displayName: body['displayName'] as String? ?? '',
        avatarEmoji: body['avatarEmoji'] as String? ?? '📈',
        deviceName: body['deviceName'] as String?,
      );
      threads.ensureSelfThread(result.profileId);
      return jsonOk(_authJson(result));
    } on AuthException catch (e) {
      return jsonErr(e.code, status: 409);
    }
  });

  router.post('/v1/auth/login', (Request request) async {
    try {
      final body = parseJsonBody(await request.readAsString());
      final result = auth.login(
        login: body['login'] as String? ?? '',
        password: body['password'] as String? ?? '',
        deviceName: body['deviceName'] as String?,
      );
      threads.ensureSelfThread(result.profileId);
      return jsonOk(_authJson(result));
    } on AuthException catch (e) {
      return jsonErr(e.code, status: 401);
    }
  });

  router.post('/v1/auth/logout', (Request request) {
    final user = requireUser(request);
    auth.logout(user['id']!, request.headers['authorization']);
    return jsonOk({'ok': true});
  });

  router.get('/v1/profile/me', (Request request) {
    final user = requireUser(request);
    return jsonOk({
      'profileId': user['id'],
      'login': user['login'],
      'displayName': user['displayName'],
      'avatarEmoji': user['avatarEmoji'],
      'isAdmin': user['isAdmin'] == '1',
    });
  });

  router.patch('/v1/profile/me', (Request request) async {
    final user = requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    final displayName = body['displayName'] as String?;
    final avatarEmoji = body['avatarEmoji'] as String?;

    if (displayName != null) {
      db.db.execute(
        'UPDATE users SET display_name = ? WHERE id = ?',
        [displayName.trim(), user['id']],
      );
    }
    if (avatarEmoji != null) {
      db.db.execute(
        'UPDATE users SET avatar_emoji = ? WHERE id = ?',
        [avatarEmoji, user['id']],
      );
    }

    final rows = db.db.select(
      'SELECT id, login, display_name, avatar_emoji FROM users WHERE id = ?',
      [user['id']],
    );
    final row = rows.first;
    db.audit(action: 'update_profile', userId: user['id']);
    return jsonOk({
      'profileId': row['id'],
      'login': row['login'],
      'displayName': row['display_name'],
      'avatarEmoji': row['avatar_emoji'],
      'isAdmin': user['isAdmin'] == '1',
    });
  });

  router.get('/v1/profile/customization', (Request request) {
    final user = requireUser(request);
    final snapshot = customization.get(user['id']!);
    if (snapshot == null) {
      return jsonErr('not_found', status: 404);
    }
    return jsonOk({'customization': snapshot});
  });

  router.put('/v1/profile/customization', (Request request) async {
    final user = requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    final raw = body['customization'];
    if (raw is! Map<String, dynamic>) {
      return jsonErr('invalid_payload', status: 400);
    }
    return jsonOk(customization.put(user['id']!, raw));
  });

  router.get('/v1/profile/local-data', (Request request) {
    final user = requireUser(request);
    final snapshot = localData.get(user['id']!);
    if (snapshot == null) {
      return jsonErr('not_found', status: 404);
    }
    return jsonOk({'localData': snapshot});
  });

  router.put('/v1/profile/local-data', (Request request) async {
    final user = requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    final raw = body['localData'];
    if (raw is! Map<String, dynamic>) {
      return jsonErr('invalid_payload', status: 400);
    }
    return jsonOk(localData.put(user['id']!, raw));
  });

  router.get('/v1/threads', (Request request) {
    final user = requireUser(request);
    threads.ensureSelfThread(user['id']!);
    return jsonOk({'threads': threads.listThreads(user['id']!)});
  });

  router.post('/v1/threads/direct', (Request request) async {
    final user = requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final thread = threads.createDirect(
        userId: user['id']!,
        targetProfileId: body['targetProfileId'] as String?,
        self: body['self'] == true,
      );
      return jsonOk({'thread': thread});
    } on ThreadException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  router.get('/v1/threads/<threadId>/messages', (Request request, String threadId) {
    final user = requireUser(request);
    final before = request.url.queryParameters['before'];
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 50;
    try {
      return jsonOk({
        'messages': threads.listMessages(
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
    final user = requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final message = threads.sendMessage(
        threadId: threadId,
        userId: user['id']!,
        text: body['text'] as String? ?? '',
      );
      return jsonOk({'message': message});
    } on ThreadException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.get('/v1/users/search', (Request request) {
    final user = requireUser(request);
    final q = request.url.queryParameters['q'] ?? '';
    return jsonOk({
      'users': threads.searchUsers(q, excludeUserId: user['id']),
    });
  });

  router.get('/v1/articles', (Request request) {
    requireUser(request);
    final limit = int.tryParse(request.url.queryParameters['limit'] ?? '') ?? 50;
    final offset = int.tryParse(request.url.queryParameters['offset'] ?? '') ?? 0;
    return jsonOk({
      'articles': articles.listPublished(limit: limit, offset: offset),
    });
  });

  router.get('/v1/articles/mine', (Request request) {
    final user = requireUser(request);
    return jsonOk({'articles': articles.listMine(user['id']!)});
  });

  router.post('/v1/articles', (Request request) async {
    final user = requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = articles.submit(
        authorId: user['id']!,
        title: body['title'] as String? ?? '',
        body: body['body'] as String? ?? '',
      );
      return jsonOk({'article': article}, status: 201);
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 400);
    }
  });

  router.get('/v1/articles/<articleId>', (Request request, String articleId) {
    final user = requireUser(request);
    final isAdmin = user['isAdmin'] == '1';
    final article = articles.get(
      articleId: articleId,
      viewerId: user['id']!,
      isAdmin: isAdmin,
    );
    if (article == null) return jsonErr('not_found', status: 404);
    return jsonOk({'article': article});
  });

  router.patch('/v1/articles/<articleId>', (Request request, String articleId) async {
    final user = requireUser(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = articles.update(
        authorId: user['id']!,
        articleId: articleId,
        title: body['title'] as String? ?? '',
        body: body['body'] as String? ?? '',
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

  router.delete('/v1/articles/<articleId>', (Request request, String articleId) {
    final user = requireUser(request);
    try {
      articles.delete(authorId: user['id']!, articleId: articleId);
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

  router.get('/v1/admin/articles/pending', (Request request) {
    requireAdmin(request);
    return jsonOk({'articles': articles.listPending()});
  });

  router.post('/v1/admin/articles/<articleId>/approve', (
    Request request,
    String articleId,
  ) {
    final admin = requireAdmin(request);
    try {
      final article = articles.approve(
        articleId: articleId,
        adminId: admin['id']!,
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
    final admin = requireAdmin(request);
    final body = parseJsonBody(await request.readAsString());
    try {
      final article = articles.reject(
        articleId: articleId,
        adminId: admin['id']!,
        reason: body['reason'] as String?,
      );
      return jsonOk({'article': article});
    } on ArticleException catch (e) {
      return jsonErr(e.code, status: 404);
    }
  });

  final handler = Pipeline()
      .addMiddleware(cors)
      .addMiddleware(versionGate)
      .addMiddleware(logRequests())
      .addHandler(router.call);

  return (Request request) async {
    try {
      return await handler(request);
    } on _HttpException catch (e) {
      return jsonErr(e.code, status: e.status);
    } catch (e) {
      stderr.writeln('Server error: $e');
      return jsonErr('internal_error', status: 500);
    }
  };
}

Map<String, dynamic> _authJson(AuthResult r) => {
      'profileId': r.profileId,
      'token': r.token,
      'login': r.login,
      'displayName': r.displayName,
      'avatarEmoji': r.avatarEmoji,
      'isAdmin': r.isAdmin,
    };

const _corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PATCH, PUT, OPTIONS',
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
}) {
  final handler = createHandler(db: db, config: config);
  return shelf_io.serve(handler, config.host, config.port);
}
