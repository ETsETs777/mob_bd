// =============================================================================
// EcoPulse · lib/data/services/cache_service.dart
// Автор: Цымбал Е. В.
// Дата: 11.05.2026
// HTTP-клиент (Dio), Hive-кэш. Файл: cache_service.
// =============================================================================

import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Сервис [CacheService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
class CacheService {
/// Создаёт [CacheService] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  CacheService._();
/// Поле [instance] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  static final instance = CacheService._();

/// Поле [boxName] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  static const boxName = 'ecopulse_cache';
/// Поле [_box] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  Box<String>? _box;

/// Метод [init] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(boxName);
  }

/// Метод [get] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  T? get<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    final raw = _box?.get(key);
    if (raw == null) return null;
    try {
      return fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

/// Метод [getList] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  List<T>? getList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final raw = _box?.get(key);
    if (raw == null) return null;
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null;
    }
  }

/// Метод [set] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<void> set(String key, Object value) async {
    await _box?.put(key, jsonEncode(value));
  }

/// Метод [isFresh] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  bool isFresh(String key, Duration ttl) {
    final ts = cachedAt(key);
    if (ts == null) return false;
    return DateTime.now().difference(ts) < ttl;
  }

/// Метод [cachedAt] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 12.05.2026
  DateTime? cachedAt(String key) {
    final meta = _box?.get('${key}_ts');
    if (meta == null) return null;
    return DateTime.tryParse(meta);
  }

/// Метод [markFresh] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 13.05.2026
  Future<void> markFresh(String key) async {
    await _box?.put('${key}_ts', DateTime.now().toIso8601String());
  }

/// Метод [getString] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 14.05.2026
  String? getString(String key) {
    final value = _box?.get(key);
    return value is String ? value : null;
  }

/// Метод [putString] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 15.05.2026
  Future<void> putString(String key, String value) async {
    await _box?.put(key, value);
  }

/// Метод [deleteKey] класса [CacheService].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  Future<void> deleteKey(String key) async {
    await _box?.delete(key);
  }
}
