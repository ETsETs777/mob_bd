import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';

import '../../data/services/cache_service.dart';

/// Локальное хранение пользовательского фото аватара (base64 в Hive).
class AvatarStorage {
  AvatarStorage._();

  static const cacheKey = 'user_profile_avatar_b64';

  static bool get hasImage {
    final raw = CacheService.instance.getString(cacheKey);
    return raw != null && raw.isNotEmpty;
  }

  static Uint8List? loadBytes() {
    final raw = CacheService.instance.getString(cacheKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveBytes(Uint8List bytes) async {
    await CacheService.instance.putString(cacheKey, base64Encode(bytes));
  }

  static Future<void> clear() async {
    await CacheService.instance.putString(cacheKey, '');
  }

  /// Выбор изображения из галереи/файлов, сжатие до ~256px.
  static Future<Uint8List?> pickAndProcess() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final raw = file.bytes;
    if (raw == null || raw.isEmpty) return null;
    if (raw.length > 8 * 1024 * 1024) return null;

    return resizeAvatarBytes(raw);
  }

  static Future<Uint8List?> resizeAvatarBytes(
    Uint8List input, {
    int maxSide = 256,
  }) async {
    try {
      final codec = await ui.instantiateImageCodec(
        input,
        targetWidth: maxSide,
        targetHeight: maxSide,
      );
      final frame = await codec.getNextFrame();
      final data = await frame.image.toByteData(format: ui.ImageByteFormat.png);
      frame.image.dispose();
      if (data == null) return null;
      return data.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }
}
