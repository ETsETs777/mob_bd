import '../../data/services/cache_service.dart';
import 'user_local_data_auto_sync.dart';

/// Сортировка списка чатов.
class ChatSortPreferences {
  ChatSortPreferences._();

  static const _cacheKey = 'chat_sort_unread_first_v1';

  static bool get unreadFirst {
    final raw = CacheService.instance.getString(_cacheKey);
    return raw == null || raw == '1';
  }

  static Future<void> setUnreadFirst(bool value) async {
    await CacheService.instance.putString(_cacheKey, value ? '1' : '0');
    UserLocalDataAutoSync.onCommunityPrefsChanged();
  }
}
