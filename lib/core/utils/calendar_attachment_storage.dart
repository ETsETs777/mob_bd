import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../../data/models/user_calendar_event.dart';
import '../../data/services/cache_service.dart';

/// Локальное хранение вложений событий календаря (base64 в Hive).
class CalendarAttachmentStorage {
  CalendarAttachmentStorage._();

  static const keyPrefix = 'user_calendar_attachment_';
  static const maxBytes = 5 * 1024 * 1024;

  static String keyFor(String eventId) => '$keyPrefix$eventId';

  static Uint8List? loadBytes(String eventId) {
    final raw = CacheService.instance.getString(keyFor(eventId));
    if (raw == null || raw.isEmpty) return null;
    try {
      return base64Decode(raw);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveBytes(String eventId, Uint8List bytes) async {
    await CacheService.instance.putString(keyFor(eventId), base64Encode(bytes));
  }

  static Future<void> clear(String eventId) async {
    await CacheService.instance.deleteKey(keyFor(eventId));
  }

  /// Список ключей вложений для backup.
  static List<String> backupKeysForEvents(List<UserCalendarEvent> events) {
    return [
      for (final e in events)
        if (e.hasAttachment) keyFor(e.id),
    ];
  }

  static Future<CalendarAttachmentPick?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf', 'png', 'jpg', 'jpeg', 'webp', 'heic'],
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final file = result.files.first;
    final raw = file.bytes;
    if (raw == null || raw.isEmpty || raw.length > maxBytes) return null;

    final name = file.name;
    final ext = name.split('.').last.toLowerCase();
    final mime = switch (ext) {
      'pdf' => 'application/pdf',
      'png' => 'image/png',
      'jpg' || 'jpeg' => 'image/jpeg',
      'webp' => 'image/webp',
      'heic' => 'image/heic',
      _ => 'application/octet-stream',
    };

    return CalendarAttachmentPick(
      bytes: raw,
      name: name,
      mime: mime,
    );
  }
}

class CalendarAttachmentPick {
  const CalendarAttachmentPick({
    required this.bytes,
    required this.name,
    required this.mime,
  });

  final Uint8List bytes;
  final String name;
  final String mime;
}
