import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/widgets/empty_state.dart';
import '../profile/profile_server_screen.dart';

/// Empty state когда Community требует входа на Home Server.
class CommunityConnectEmpty extends StatelessWidget {
  const CommunityConnectEmpty({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Iconsax.cloud_connection,
  });

  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return EmptyState(
      title: title,
      subtitle: subtitle ?? l10n.communityConnectHint,
      icon: icon,
      actionLabel: l10n.communityConnectAction,
      onAction: () => openAppPage(context, const ProfileServerScreen()),
    );
  }
}
