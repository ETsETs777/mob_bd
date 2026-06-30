class HomeServerAuth {
  const HomeServerAuth({
    this.serverUrl = '',
    this.token = '',
    this.profileId = '',
    this.login = '',
    this.displayName = '',
    this.avatarEmoji = '📈',
    this.role = '',
    this.isAdmin = false,
    this.canModerate = false,
    this.canEditContent = false,
    this.isStaff = false,
    this.apiVersion = '1',
    this.minAppVersion = '',
    this.serverVersion = '',
  });

  final String serverUrl;
  final String token;
  final String profileId;
  final String login;
  final String displayName;
  final String avatarEmoji;
  final String role;
  final bool isAdmin;
  final bool canModerate;
  final bool canEditContent;
  final bool isStaff;
  final String apiVersion;
  final String minAppVersion;
  final String serverVersion;

  bool get isLoggedIn => token.isNotEmpty && profileId.isNotEmpty;
  bool get hasServerUrl => serverUrl.trim().isNotEmpty;

  /// Модерация статей (moderator или admin).
  bool get canModerateArticles => canModerate;

  HomeServerAuth copyWith({
    String? serverUrl,
    String? token,
    String? profileId,
    String? login,
    String? displayName,
    String? avatarEmoji,
    String? role,
    bool? isAdmin,
    bool? canModerate,
    bool? canEditContent,
    bool? isStaff,
    String? apiVersion,
    String? minAppVersion,
    String? serverVersion,
    bool clearToken = false,
  }) {
    return HomeServerAuth(
      serverUrl: serverUrl ?? this.serverUrl,
      token: clearToken ? '' : (token ?? this.token),
      profileId: clearToken ? '' : (profileId ?? this.profileId),
      login: clearToken ? '' : (login ?? this.login),
      displayName: clearToken ? '' : (displayName ?? this.displayName),
      avatarEmoji: avatarEmoji ?? this.avatarEmoji,
      role: clearToken ? '' : (role ?? this.role),
      isAdmin: clearToken ? false : (isAdmin ?? this.isAdmin),
      canModerate: clearToken ? false : (canModerate ?? this.canModerate),
      canEditContent:
          clearToken ? false : (canEditContent ?? this.canEditContent),
      isStaff: clearToken ? false : (isStaff ?? this.isStaff),
      apiVersion: apiVersion ?? this.apiVersion,
      minAppVersion: minAppVersion ?? this.minAppVersion,
      serverVersion: serverVersion ?? this.serverVersion,
    );
  }

  Map<String, dynamic> toJson() => {
        'serverUrl': serverUrl,
        'token': token,
        'profileId': profileId,
        'login': login,
        'displayName': displayName,
        'avatarEmoji': avatarEmoji,
        'role': role,
        'isAdmin': isAdmin,
        'canModerate': canModerate,
        'canEditContent': canEditContent,
        'isStaff': isStaff,
        'apiVersion': apiVersion,
        'minAppVersion': minAppVersion,
        'serverVersion': serverVersion,
      };

  factory HomeServerAuth.fromJson(Map<String, dynamic> json) {
    final role = json['role'] as String? ?? '';
    final legacyAdmin = json['isAdmin'] as bool? ?? false;
    final canModerate = json['canModerate'] as bool? ??
        (role == 'moderator' || role == 'admin' || legacyAdmin);
    final canEditContent = json['canEditContent'] as bool? ??
        (role == 'editor' || role == 'admin' || legacyAdmin);
    final isStaff = json['isStaff'] as bool? ??
        (role.isNotEmpty || legacyAdmin);
    return HomeServerAuth(
      serverUrl: json['serverUrl'] as String? ?? '',
      token: json['token'] as String? ?? '',
      profileId: json['profileId'] as String? ?? '',
      login: json['login'] as String? ?? '',
      displayName: json['displayName'] as String? ?? '',
      avatarEmoji: json['avatarEmoji'] as String? ?? '📈',
      role: role,
      isAdmin: json['isAdmin'] as bool? ??
          (role == 'admin' || (legacyAdmin && role.isEmpty)),
      canModerate: canModerate,
      canEditContent: canEditContent,
      isStaff: isStaff,
      apiVersion: json['apiVersion']?.toString() ?? '1',
      minAppVersion: json['minAppVersion'] as String? ?? '',
      serverVersion: json['serverVersion'] as String? ?? '',
    );
  }
}
