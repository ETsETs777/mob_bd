import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/utils/home_server_error_message.dart';
import 'package:ecopulse/l10n/app_localizations_en.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('maps article validation error codes', () {
    expect(
      homeServerErrorMessage(l10n, 'title_too_short'),
      l10n.userArticlesErrorTitleTooShort,
    );
    expect(
      homeServerErrorMessage(l10n, 'invalid_status'),
      l10n.userArticlesErrorInvalidStatus,
    );
  });
}
