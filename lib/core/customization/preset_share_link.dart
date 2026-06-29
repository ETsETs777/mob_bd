// =============================================================================
// EcoPulse · lib/core/customization/preset_share_link.dart
// Автор: Цымбал Е. В.
// Дата: 28.06.2026
// Shareable preset links для marketplace (encode/decode).
// =============================================================================

import 'dart:convert';

import 'customization_preset.dart';

/// Кодек share-ссылок на пресеты кастомизации.
class PresetShareLink {
  PresetShareLink._();

  static const version = 1;
  static const webHost = 'ecopulse.app';
  static const webPath = '/preset';
  static const customScheme = 'ecopulse';
  static const customHost = 'preset';

  /// `https://ecopulse.app/preset?v=1&d=<base64url>`
  static String encode(CustomizationPreset preset) {
    final payload = base64Url.encode(
      utf8.encode(jsonEncode(preset.toJson())),
    );
    return Uri(
      scheme: 'https',
      host: webHost,
      path: webPath,
      queryParameters: {'v': '$version', 'd': payload},
    ).toString();
  }

  /// Распознаёт EcoPulse preset link или raw base64/json.
  static CustomizationPreset? decode(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final fromUri = _decodeFromUri(Uri.tryParse(trimmed));
    if (fromUri != null) return fromUri;

    if (trimmed.startsWith('{')) {
      return _decodeJson(trimmed);
    }

    try {
      final json = utf8.decode(base64Url.decode(trimmed));
      return _decodeJson(json);
    } catch (_) {
      return null;
    }
  }

  static bool looksLikePresetLink(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return false;
    if (uri.scheme == customScheme && uri.host == customHost) return true;
    if (uri.scheme == 'https' &&
        uri.host == webHost &&
        uri.path.startsWith(webPath)) {
      return true;
    }
    return false;
  }

  static CustomizationPreset? _decodeFromUri(Uri? uri) {
    if (uri == null) return null;

    final isCustom =
        uri.scheme == customScheme && uri.host == customHost;
    final isWeb = uri.scheme == 'https' &&
        uri.host == webHost &&
        uri.path.startsWith(webPath);
    if (!isCustom && !isWeb) return null;

    final versionRaw = uri.queryParameters['v'];
    if (versionRaw != null && int.tryParse(versionRaw) != version) {
      return null;
    }

    final payload = uri.queryParameters['d'];
    if (payload == null || payload.isEmpty) return null;

    try {
      final json = utf8.decode(base64Url.decode(payload));
      return _decodeJson(json);
    } catch (_) {
      return null;
    }
  }

  static CustomizationPreset? _decodeJson(String json) {
    try {
      final decoded = jsonDecode(json);
      final map = decoded is Map<String, dynamic>
          ? decoded
          : (decoded as List<dynamic>).first as Map<String, dynamic>;
      return CustomizationPreset.fromJson(map);
    } catch (_) {
      return null;
    }
  }
}
