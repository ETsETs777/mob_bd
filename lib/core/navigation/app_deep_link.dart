/// Universal deep links: `ecopulse://` custom scheme + `https://ecopulse.app/` App Links.
library;

enum AppDeepLinkKind { article, thread, calendar }

class AppDeepLink {
  const AppDeepLink({required this.kind, required this.id});

  final AppDeepLinkKind kind;
  final String id;

  static const customScheme = 'ecopulse';
  static const webHost = 'ecopulse.app';

  static AppDeepLink? parse(Uri uri) {
    if (uri.scheme == customScheme) {
      final kind = _kindFromHost(uri.host);
      if (kind == null) return null;
      final id = _extractId(uri);
      if (id == null || id.isEmpty) return null;
      return AppDeepLink(kind: kind, id: id);
    }

    if (uri.scheme == 'https' &&
        uri.host.toLowerCase() == webHost &&
        uri.pathSegments.isNotEmpty) {
      final kind = _kindFromPathSegment(uri.pathSegments.first);
      if (kind == null) return null;
      final pathId = uri.pathSegments.length > 1
          ? uri.pathSegments[1]
          : uri.queryParameters['id'];
      if (pathId == null || pathId.isEmpty) return null;
      return AppDeepLink(kind: kind, id: pathId);
    }

    return null;
  }

  static AppDeepLink? parseString(String raw) {
    final uri = Uri.tryParse(raw.trim());
    if (uri == null) return null;
    return parse(uri);
  }

  static bool looksLikeAppDeepLink(String raw) => parseString(raw) != null;

  Uri toCustomUri() => Uri(
        scheme: customScheme,
        host: _hostForKind(kind),
        path: '/$id',
      );

  Uri toWebUri() => Uri.https(webHost, '/${_pathForKind(kind)}/$id');

  String get customLink => toCustomUri().toString();

  String get webLink => toWebUri().toString();

  /// Prefer HTTPS for sharing (App Links / Universal Links).
  String get shareLink => webLink;

  static AppDeepLink article(String id) =>
      AppDeepLink(kind: AppDeepLinkKind.article, id: id);

  static AppDeepLink thread(String id) =>
      AppDeepLink(kind: AppDeepLinkKind.thread, id: id);

  static AppDeepLink calendarEvent(String id) =>
      AppDeepLink(kind: AppDeepLinkKind.calendar, id: id);

  static AppDeepLinkKind? _kindFromHost(String host) => switch (host) {
        'article' => AppDeepLinkKind.article,
        'thread' => AppDeepLinkKind.thread,
        'calendar' => AppDeepLinkKind.calendar,
        _ => null,
      };

  static AppDeepLinkKind? _kindFromPathSegment(String segment) =>
      switch (segment) {
        'article' => AppDeepLinkKind.article,
        'articles' => AppDeepLinkKind.article,
        'thread' => AppDeepLinkKind.thread,
        'threads' => AppDeepLinkKind.thread,
        'calendar' => AppDeepLinkKind.calendar,
        'event' => AppDeepLinkKind.calendar,
        'events' => AppDeepLinkKind.calendar,
        _ => null,
      };

  static String _hostForKind(AppDeepLinkKind kind) => switch (kind) {
        AppDeepLinkKind.article => 'article',
        AppDeepLinkKind.thread => 'thread',
        AppDeepLinkKind.calendar => 'calendar',
      };

  static String _pathForKind(AppDeepLinkKind kind) => switch (kind) {
        AppDeepLinkKind.article => 'article',
        AppDeepLinkKind.thread => 'thread',
        AppDeepLinkKind.calendar => 'calendar',
      };

  static String? _extractId(Uri uri) {
    if (uri.scheme == customScheme) {
      if (uri.pathSegments.isNotEmpty) {
        return uri.pathSegments.firstWhere(
          (s) => s.isNotEmpty,
          orElse: () => '',
        );
      }
      return uri.queryParameters['id'];
    }
    return null;
  }
}

/// Extract article id from chat message (legacy `article:id` or deep link URL).
String? extractArticleReferenceId(String text) {
  const marker = '\n\narticle:';
  final legacyIdx = text.lastIndexOf(marker);
  if (legacyIdx != -1) {
    final id = text.substring(legacyIdx + marker.length).trim();
    if (id.isNotEmpty) return id.split(RegExp(r'\s')).first;
  }

  for (final line in text.split('\n')) {
    final trimmed = line.trim();
    final link = AppDeepLink.parseString(trimmed);
    if (link?.kind == AppDeepLinkKind.article) return link!.id;
    if (trimmed.contains('ecopulse.app/article/')) {
      final parsed = AppDeepLink.parseString(trimmed);
      if (parsed?.kind == AppDeepLinkKind.article) return parsed!.id;
    }
    if (trimmed.startsWith('ecopulse://article')) {
      final parsed = AppDeepLink.parseString(trimmed);
      if (parsed?.kind == AppDeepLinkKind.article) return parsed!.id;
    }
  }
  return null;
}

String displayTextWithoutArticleReference(String text) {
  const marker = '\n\narticle:';
  final legacyIdx = text.lastIndexOf(marker);
  if (legacyIdx != -1) {
    return text.substring(0, legacyIdx).trimRight();
  }

  final lines = text.split('\n');
  final kept = <String>[];
  for (final line in lines) {
    final trimmed = line.trim();
    if (AppDeepLink.parseString(trimmed)?.kind == AppDeepLinkKind.article) {
      continue;
    }
    if (trimmed.contains('ecopulse.app/article/') ||
        trimmed.startsWith('ecopulse://article')) {
      continue;
    }
    kept.add(line);
  }
  return kept.join('\n').trimRight();
}
