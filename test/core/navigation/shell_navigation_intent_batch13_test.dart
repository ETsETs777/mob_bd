import 'package:flutter_test/flutter_test.dart';

import 'package:ecopulse/core/navigation/shell_navigation_intent.dart';

void main() {
  test('openCommunityMessages sets messages sub tab', () {
    ShellNavigationIntent.openCommunityMessages();
    expect(ShellNavigationIntent.shellTab, 5);
    expect(ShellNavigationIntent.communitySubTab, 0);
  });
}
