// =============================================================================
// EcoPulse · lib/providers/asset_notes_provider.dart
// Автор: Цымбал Е. В.
// Дата: 18.05.2026
// Riverpod state: провайдеры и notifiers. Файл: asset_notes_provider.
// =============================================================================

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';

/// Riverpod-провайдер [assetNotesProvider].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
final assetNotesProvider =
    NotifierProvider<AssetNotesNotifier, Map<String, String>>(
  AssetNotesNotifier.new,
);

/// Riverpod AsyncNotifier [AssetNotesNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
class AssetNotesNotifier extends Notifier<Map<String, String>> {
/// Поле [cacheKey] класса [AssetNotesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  static const cacheKey = 'asset_notes';

/// Отрисовывает UI [AssetNotesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
  @override
  Map<String, String> build() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return {};
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return map.map((k, v) => MapEntry(k, v as String));
    } catch (_) {
      return {};
    }
  }

/// Метод [noteFor] класса [AssetNotesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.05.2026
  String? noteFor(String assetKey) {
    final note = state[assetKey];
    if (note == null || note.trim().isEmpty) return null;
    return note.trim();
  }

/// Метод [setNote] класса [AssetNotesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.05.2026
  Future<void> setNote(String assetKey, String text) async {
    final trimmed = text.trim();
    final next = Map<String, String>.from(state);
    if (trimmed.isEmpty) {
      next.remove(assetKey);
    } else {
      next[assetKey] = trimmed;
    }
    state = next;
    await _persist();
  }

/// Метод [loadFromMap] класса [AssetNotesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.05.2026
  Future<void> loadFromMap(Map<String, String> notes) async {
    state = Map.from(notes);
    await _persist();
  }

/// Приватный метод [_persist] класса [AssetNotesNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.05.2026
  Future<void> _persist() async {
    await CacheService.instance.putString(cacheKey, jsonEncode(state));
  }
}
