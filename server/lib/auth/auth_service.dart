import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:uuid/uuid.dart';

import '../config.dart';
import '../db/database.dart';
import 'password_service.dart';

class AuthResult {
  AuthResult({
    required this.profileId,
    required this.token,
    required this.login,
    required this.displayName,
    required this.avatarEmoji,
  });

  final String profileId;
  final String token;
  final String login;
  final String displayName;
  final String avatarEmoji;
}

class AuthService {
  AuthService(this.db, this.config, this.passwords);

  final AppDatabase db;
  final ServerConfig config;
  final PasswordService passwords;
  final _uuid = const Uuid();

  String _hashToken(String token) {
    return sha256.convert(utf8.encode(token)).toString();
  }

  AuthResult _issueToken({
    required String userId,
    required String login,
    required String displayName,
    required String avatarEmoji,
    String? deviceName,
  }) {
    final sessionId = _uuid.v4();
    final expires = DateTime.now().toUtc().add(
          Duration(days: ServerConfig.tokenTtlDays),
        );

    final jwt = JWT(
      {
        'sub': userId,
        'jti': sessionId,
        'login': login,
      },
      issuer: 'ecopulse-home-server',
    );

    final token = jwt.sign(
      SecretKey(config.jwtSecret),
      expiresIn: Duration(days: ServerConfig.tokenTtlDays),
    );

    db.db.execute(
      'INSERT INTO sessions(id, user_id, token_hash, expires_at, device_name, created_at) '
      'VALUES(?, ?, ?, ?, ?, ?)',
      [
        sessionId,
        userId,
        _hashToken(token),
        expires.toIso8601String(),
        deviceName,
        DateTime.now().toUtc().toIso8601String(),
      ],
    );

    return AuthResult(
      profileId: userId,
      token: token,
      login: login,
      displayName: displayName,
      avatarEmoji: avatarEmoji,
    );
  }

  AuthResult register({
    required String login,
    required String password,
    String displayName = '',
    String avatarEmoji = '📈',
    String? deviceName,
  }) {
    final normalizedLogin = login.trim().toLowerCase();
    if (normalizedLogin.length < 3) {
      throw AuthException('login_too_short');
    }
    if (password.length < 4) {
      throw AuthException('password_too_short');
    }

    final existing = db.db.select(
      'SELECT id FROM users WHERE login = ?',
      [normalizedLogin],
    );
    if (existing.isNotEmpty) {
      throw AuthException('login_taken');
    }

    final userId = _uuid.v4();
    final now = DateTime.now().toUtc().toIso8601String();
    db.db.execute(
      'INSERT INTO users(id, login, password_hash, display_name, avatar_emoji, created_at) '
      'VALUES(?, ?, ?, ?, ?, ?)',
      [
        userId,
        normalizedLogin,
        passwords.hash(password),
        displayName.trim(),
        avatarEmoji,
        now,
      ],
    );

    db.audit(action: 'register', userId: userId, meta: {'login': normalizedLogin});

    return _issueToken(
      userId: userId,
      login: normalizedLogin,
      displayName: displayName.trim(),
      avatarEmoji: avatarEmoji,
      deviceName: deviceName,
    );
  }

  AuthResult login({
    required String login,
    required String password,
    String? deviceName,
  }) {
    final normalizedLogin = login.trim().toLowerCase();
    final rows = db.db.select(
      'SELECT id, login, password_hash, display_name, avatar_emoji FROM users WHERE login = ?',
      [normalizedLogin],
    );
    if (rows.isEmpty) {
      throw AuthException('invalid_credentials');
    }
    final row = rows.first;
    if (!passwords.verify(password, row['password_hash'] as String)) {
      db.audit(action: 'login_failed', meta: {'login': normalizedLogin});
      throw AuthException('invalid_credentials');
    }

    final userId = row['id'] as String;
    db.audit(action: 'login', userId: userId);

    return _issueToken(
      userId: userId,
      login: row['login'] as String,
      displayName: row['display_name'] as String,
      avatarEmoji: row['avatar_emoji'] as String,
      deviceName: deviceName,
    );
  }

  Map<String, String>? verifyBearer(String? header) {
    if (header == null || !header.startsWith('Bearer ')) return null;
    final token = header.substring(7).trim();
    if (token.isEmpty) return null;

    try {
      final jwt = JWT.verify(token, SecretKey(config.jwtSecret));
      final payload = jwt.payload;
      final userId = payload['sub'] as String?;
      final jti = payload['jti'] as String?;
      if (userId == null || jti == null) return null;

      final hash = _hashToken(token);
      final sessions = db.db.select(
        'SELECT user_id FROM sessions WHERE id = ? AND token_hash = ? AND expires_at > ?',
        [jti, hash, DateTime.now().toUtc().toIso8601String()],
      );
      if (sessions.isEmpty) return null;

      final users = db.db.select(
        'SELECT id, login, display_name, avatar_emoji FROM users WHERE id = ?',
        [userId],
      );
      if (users.isEmpty) return null;
      final u = users.first;
      return {
        'id': u['id'] as String,
        'login': u['login'] as String,
        'displayName': u['display_name'] as String,
        'avatarEmoji': u['avatar_emoji'] as String,
      };
    } catch (_) {
      return null;
    }
  }

  void logout(String userId, String? bearerHeader) {
    if (bearerHeader == null || !bearerHeader.startsWith('Bearer ')) return;
    final token = bearerHeader.substring(7).trim();
    try {
      final jwt = JWT.verify(token, SecretKey(config.jwtSecret));
      final jti = jwt.payload['jti'] as String?;
      if (jti != null) {
        db.db.execute('DELETE FROM sessions WHERE id = ?', [jti]);
      }
    } catch (_) {}
    db.audit(action: 'logout', userId: userId);
  }
}

class AuthException implements Exception {
  AuthException(this.code);
  final String code;

  @override
  String toString() => code;
}
