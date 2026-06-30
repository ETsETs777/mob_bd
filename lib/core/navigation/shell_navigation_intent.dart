import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/app_providers.dart';

/// Отложенная навигация в shell без доступа к [WidgetRef] (уведомления).
class ShellNavigationIntent {
  ShellNavigationIntent._();

  static int? shellTab;
  static int? communitySubTab;

  static void openCommunity({int subTab = 0}) {
    shellTab = 5;
    communitySubTab = subTab;
  }

  static void openCommunityArticles() => openCommunity(subTab: 1);

  static void openCommunityMessages() => openCommunity(subTab: 0);

  static void consume(WidgetRef ref) {
    if (shellTab != null) {
      ref.read(navigationIndexProvider.notifier).state = shellTab!;
      shellTab = null;
    }
    if (communitySubTab != null) {
      ref.read(communityInitialTabProvider.notifier).state = communitySubTab!;
      communitySubTab = null;
    }
  }
}
