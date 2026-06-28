// =============================================================================
// EcoPulse · lib/data/models/user_profile.dart
// Автор: Цымбал Е. В.
// Дата: 05.05.2026
// Модели данных (DTO, immutable классы). Файл: user_profile.
// =============================================================================

/// Класс [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
class UserProfile {
/// Создаёт [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  const UserProfile({
    this.profileId,
    this.displayName = '',
    this.avatarEmoji = '📈',
    this.countryCode = 'RU',
  });

  final String? profileId;
  final String displayName;
  final String avatarEmoji;
/// Поле [countryCode] класса [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
  final String countryCode;

/// Getter [hasName] класса [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  bool get hasName => displayName.trim().isNotEmpty;

/// Метод [copyWith] класса [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  UserProfile copyWith({
    String? profileId,
    String? displayName,
    String? avatarEmoji,
    String? countryCode,
  }) {
    return UserProfile(
      profileId: profileId ?? this.profileId,
      displayName: displayName ?? this.displayName,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      countryCode: countryCode ?? this.countryCode,
    );
  }

/// Метод [toJson] класса [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  Map<String, dynamic> toJson() => {
        if (profileId != null) 'profileId': profileId,
        'displayName': displayName,
        'avatarEmoji': avatarEmoji,
        'countryCode': countryCode,
      };

/// Создаёт [UserProfile] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        profileId: json['profileId'] as String?,
        displayName: json['displayName'] as String? ?? '',
        avatarEmoji: json['avatarEmoji'] as String? ?? '📈',
        countryCode: json['countryCode'] as String? ?? 'RU',
      );
}

/// Top-level переменная [profileAvatarOptions].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
const profileAvatarOptions = ['📈', '💰', '🚀', '🎯', '💎', '🏦', '🌍', '⚡'];
