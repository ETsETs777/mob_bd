import '../../l10n/app_localizations.dart';

/// Локализованное сообщение об ошибке home server / статей по коду.
String homeServerErrorMessage(AppLocalizations l10n, String code) {
  if (code.isEmpty) return '';
  return switch (code) {
    'login_taken' => l10n.homeServerErrorLoginTaken,
    'invalid_credentials' => l10n.homeServerErrorInvalidCredentials,
    'login_too_short' => l10n.homeServerErrorLoginShort,
    'password_too_short' => l10n.homeServerErrorPasswordShort,
    'upgrade_required' => l10n.homeServerErrorUpgrade,
    'no_url' => l10n.homeServerErrorNoUrl,
    'network_error' => l10n.homeServerErrorNetwork,
    'not_logged_in' => l10n.userArticlesErrorNeedLogin,
    'unauthorized' => l10n.userArticlesErrorUnauthorized,
    'forbidden' => l10n.userArticlesErrorForbidden,
    'not_found' => l10n.userArticlesErrorNotFound,
    'title_required' => l10n.userArticlesErrorTitleRequired,
    'body_required' => l10n.userArticlesErrorBodyRequired,
    'invalid_payload' => l10n.userArticlesErrorInvalidPayload,
    'title_too_short' => l10n.userArticlesErrorTitleTooShort,
    'title_too_long' => l10n.userArticlesErrorTitleTooLong,
    'body_too_short' => l10n.userArticlesErrorBodyTooShort,
    'body_too_long' => l10n.userArticlesErrorBodyTooLong,
    'invalid_status' => l10n.userArticlesErrorInvalidStatus,
    _ => l10n.userArticlesErrorServer,
  };
}
