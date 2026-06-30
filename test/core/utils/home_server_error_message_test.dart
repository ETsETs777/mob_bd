import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/home_server_error_message.dart';
import 'package:ecopulse/l10n/app_localizations_en.dart';
import 'package:ecopulse/l10n/app_localizations_ru.dart';

void main() {
  test('maps article and network error codes in English', () {
    final l10n = AppLocalizationsEn();
    expect(homeServerErrorMessage(l10n, 'network_error'), l10n.homeServerErrorNetwork);
    expect(homeServerErrorMessage(l10n, 'not_logged_in'), l10n.userArticlesErrorNeedLogin);
    expect(homeServerErrorMessage(l10n, 'title_required'), l10n.userArticlesErrorTitleRequired);
    expect(homeServerErrorMessage(l10n, 'unknown_code'), l10n.userArticlesErrorServer);
  });

  test('maps article errors in Russian', () {
    final l10n = AppLocalizationsRu();
    expect(homeServerErrorMessage(l10n, 'forbidden'), l10n.userArticlesErrorForbidden);
    expect(homeServerErrorMessage(l10n, 'unauthorized'), l10n.userArticlesErrorUnauthorized);
  });
}
