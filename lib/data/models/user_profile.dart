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
    this.email = '',
    this.phone = '',
  });

  final String? profileId;
  final String displayName;
  final String avatarEmoji;
  final String countryCode;
  final String email;
  final String phone;

/// Getter [hasName] класса [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.05.2026
  bool get hasName => displayName.trim().isNotEmpty;
  bool get hasContact => email.trim().isNotEmpty || phone.trim().isNotEmpty;
  bool get isComplete => hasName && countryCode.isNotEmpty;

/// Метод [copyWith] класса [UserProfile].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  UserProfile copyWith({
    String? profileId,
    String? displayName,
    String? avatarEmoji,
    String? countryCode,
    String? email,
    String? phone,
  }) {
    return UserProfile(
      profileId: profileId ?? this.profileId,
      displayName: displayName ?? this.displayName,
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      countryCode: countryCode ?? this.countryCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
    );
  }

  Map<String, dynamic> toJson() => {
        if (profileId != null) 'profileId': profileId,
        'displayName': displayName,
        'avatarEmoji': avatarEmoji,
        'countryCode': countryCode,
        'email': email,
        'phone': phone,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        profileId: json['profileId'] as String?,
        displayName: json['displayName'] as String? ?? '',
        avatarEmoji: json['avatarEmoji'] as String? ?? '📈',
        countryCode: json['countryCode'] as String? ?? 'RU',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
      );
}

/// Top-level переменная [profileAvatarOptions].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.05.2026
const profileAvatarOptions = ['📈', '💰', '🚀', '🎯', '💎', '🏦', '🌍', '⚡'];
