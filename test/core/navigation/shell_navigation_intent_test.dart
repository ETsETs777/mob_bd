import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/navigation/shell_navigation_intent.dart';

void main() {
  test('openCommunityArticles sets shell navigation intent', () {
    ShellNavigationIntent.openCommunityArticles();
    expect(ShellNavigationIntent.shellTab, 5);
    expect(ShellNavigationIntent.communitySubTab, 1);
  });
}
