class HomeServerAuth {
  const HomeServerAuth({
    this.serverUrl = '',
    this.token = '',
    this.profileId = '',
    this.login = '',
    this.displayName = '',
    this.avatarEmoji = '📈',
    this.isAdmin = false,
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
  final bool isAdmin;
  final String apiVersion;
  final String minAppVersion;
  final String serverVersion;

  bool get isLoggedIn => token.isNotEmpty && profileId.isNotEmpty;
  bool get hasServerUrl => serverUrl.trim().isNotEmpty;

  HomeServerAuth copyWith({
    String? serverUrl,
    String? token,
    String? profileId,
    String? login,
    String? displayName,
    String? avatarEmoji,
    bool? isAdmin,
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
      isAdmin: clearToken ? false : (isAdmin ?? this.isAdmin),
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
        'isAdmin': isAdmin,
        'apiVersion': apiVersion,
        'minAppVersion': minAppVersion,
        'serverVersion': serverVersion,
      };

  factory HomeServerAuth.fromJson(Map<String, dynamic> json) => HomeServerAuth(
        serverUrl: json['serverUrl'] as String? ?? '',
        token: json['token'] as String? ?? '',
        profileId: json['profileId'] as String? ?? '',
        login: json['login'] as String? ?? '',
        displayName: json['displayName'] as String? ?? '',
        avatarEmoji: json['avatarEmoji'] as String? ?? '📈',
        isAdmin: json['isAdmin'] as bool? ?? false,
        apiVersion: json['apiVersion']?.toString() ?? '1',
        minAppVersion: json['minAppVersion'] as String? ?? '',
        serverVersion: json['serverVersion'] as String? ?? '',
      );
}
