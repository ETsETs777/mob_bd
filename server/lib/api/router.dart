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
import '../services/thread_service.dart';

Handler createHandler({
  required AppDatabase db,
  required ServerConfig config,
}) {
  final passwords = PasswordService();
  final auth = AuthService(db, config, passwords);
  final threads = ThreadService(db);
  final customization = CustomizationService(db);

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
