import 'dart:convert';

import 'article_draft_storage.dart';
import 'avatar_storage.dart';
import 'calendar_attachment_storage.dart';
import '../../data/models/user_calendar_event.dart';
import '../../data/services/cache_service.dart';
import '../../providers/calendar/user_calendar_provider.dart';
import '../../providers/calendar/user_calendar_settings_provider.dart';

/// Сборка payload аватара, календаря и community prefs для backup / sync.
class UserLocalDataBundle {
  UserLocalDataBundle._();

  static const articleBookmarksKey = 'article_bookmarks_v1';
  static const articleReadAtKey = 'article_read_at_v1';
  static const chatThreadPinnedKey = 'chat_thread_pinned_v1';
  static const chatThreadMutedKey = 'chat_thread_muted_v1';
  static const chatThreadHiddenKey = 'chat_thread_hidden_v1';
  static const messageReadAtKey = 'chat_thread_read_at_v1';
  static const chatSortUnreadFirstKey = 'chat_sort_unread_first_v1';

  static Map<String, String> _communityPrefsFromCache() {
    final cache = CacheService.instance;
    return {
      'articleBookmarks': cache.getString(articleBookmarksKey) ?? '',
      'articleReadAt': cache.getString(articleReadAtKey) ?? '',
      'chatThreadPinned': cache.getString(chatThreadPinnedKey) ?? '',
      'chatThreadMuted': cache.getString(chatThreadMutedKey) ?? '',
      'chatThreadHidden': cache.getString(chatThreadHiddenKey) ?? '',
      'messageReadAt': cache.getString(messageReadAtKey) ?? '',
      'chatSortUnreadFirst': cache.getString(chatSortUnreadFirstKey) ?? '',
      'articleDraft': cache.getString(ArticleDraftStorage.cacheKey) ?? '',
    };
  }

  static Map<String, dynamic> build({
    required List<UserCalendarEvent> events,
    required String calendarSettingsJson,
    required bool useCustomAvatar,
  }) {
    final attachments = <String, Map<String, String>>{};
    for (final event in events) {
      if (!event.hasAttachment) continue;
      final bytes = CalendarAttachmentStorage.loadBytes(event.id);
      if (bytes == null) continue;
      attachments[event.id] = {
        'name': event.attachmentName ?? 'attachment',
        'mime': event.attachmentMime ?? 'application/octet-stream',
        'b64': base64Encode(bytes),
      };
    }

    final avatarB64 = AvatarStorage.hasImage
        ? CacheService.instance.getString(AvatarStorage.cacheKey)
        : null;

    final communityPrefs = _communityPrefsFromCache();

    final core = {
      'calendarEvents': events.map((e) => e.toJson()).toList(),
      'calendarSettings': calendarSettingsJson,
      'useCustomAvatar': useCustomAvatar,
      'communityPrefs': communityPrefs,
      if (avatarB64 != null && avatarB64.isNotEmpty) 'avatarB64': avatarB64,
      if (attachments.isNotEmpty) 'attachments': attachments,
    };

    final fingerprint = jsonEncode(core).hashCode.toRadixString(16);

    return {
      'fingerprint': fingerprint,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
      ...core,
    };
  }

  static Map<String, dynamic> buildFromCache() {
    final eventsRaw =
        CacheService.instance.getString(UserCalendarNotifier.cacheKey);
    final settingsRaw =
        CacheService.instance.getString(UserCalendarSettingsNotifier.cacheKey);
    final profileRaw = CacheService.instance.getString('user_profile');

    var events = <UserCalendarEvent>[];
    if (eventsRaw != null && eventsRaw.isNotEmpty) {
      try {
        final list = jsonDecode(eventsRaw) as List<dynamic>;
        events = list
            .map((e) => UserCalendarEvent.fromJson(e as Map<String, dynamic>))
            .toList();
      } catch (_) {}
    }

    var useCustomAvatar = false;
    if (profileRaw != null && profileRaw.isNotEmpty) {
      try {
        final map = jsonDecode(profileRaw) as Map<String, dynamic>;
        useCustomAvatar = map['useCustomAvatar'] as bool? ?? false;
      } catch (_) {}
    }

    return build(
      events: events,
      calendarSettingsJson: settingsRaw ?? '',
      useCustomAvatar: useCustomAvatar,
    );
  }

  static Future<void> _applyCommunityPrefs(Map<String, dynamic>? prefs) async {
    if (prefs == null) return;
    final cache = CacheService.instance;
    final mapping = <String, String>{
      'articleBookmarks': articleBookmarksKey,
      'articleReadAt': articleReadAtKey,
      'chatThreadPinned': chatThreadPinnedKey,
      'chatThreadMuted': chatThreadMutedKey,
      'chatThreadHidden': chatThreadHiddenKey,
      'messageReadAt': messageReadAtKey,
      'chatSortUnreadFirst': chatSortUnreadFirstKey,
      'articleDraft': ArticleDraftStorage.cacheKey,
    };

    for (final entry in mapping.entries) {
      final value = prefs[entry.key];
      if (value is String && value.isNotEmpty) {
        await cache.putString(entry.value, value);
      }
    }
  }

  /// Восстанавливает локальные данные из payload сервера.
  static Future<int> apply(Map<String, dynamic> payload) async {
    final cache = CacheService.instance;
    var restored = 0;

    final avatarB64 = payload['avatarB64'] as String?;
    if (avatarB64 != null && avatarB64.isNotEmpty) {
      await cache.putString(AvatarStorage.cacheKey, avatarB64);
      restored++;
    }

    final useCustomAvatar = payload['useCustomAvatar'] as bool? ?? false;
    final profileRaw = cache.getString('user_profile');
    if (profileRaw != null && profileRaw.isNotEmpty) {
      try {
        final map = jsonDecode(profileRaw) as Map<String, dynamic>;
        map['useCustomAvatar'] = useCustomAvatar;
        await cache.putString('user_profile', jsonEncode(map));
        restored++;
      } catch (_) {}
    }

    final settings = payload['calendarSettings'];
    if (settings is String && settings.isNotEmpty) {
      await cache.putString(UserCalendarSettingsNotifier.cacheKey, settings);
      restored++;
    }

    final communityPrefs = payload['communityPrefs'];
    if (communityPrefs is Map<String, dynamic>) {
      await _applyCommunityPrefs(communityPrefs);
      restored++;
    }

    final eventsRaw = payload['calendarEvents'];
    if (eventsRaw is List) {
      final events = eventsRaw
          .map((e) => UserCalendarEvent.fromJson(e as Map<String, dynamic>))
          .toList();
      await cache.putString(
        UserCalendarNotifier.cacheKey,
        jsonEncode(events.map((e) => e.toJson()).toList()),
      );
      restored++;

      final attachments = payload['attachments'];
      if (attachments is Map<String, dynamic>) {
        for (final entry in attachments.entries) {
          final meta = entry.value as Map<String, dynamic>?;
          final b64 = meta?['b64'] as String?;
          if (b64 == null || b64.isEmpty) continue;
          await CalendarAttachmentStorage.saveBytes(
            entry.key,
            base64Decode(b64),
          );
          restored++;
        }
      }
    }

    return restored;
  }
}
