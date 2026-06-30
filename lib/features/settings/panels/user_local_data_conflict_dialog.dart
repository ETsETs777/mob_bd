import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';

/// `local` | `remote` | null (отмена).
Future<String?> showUserLocalDataConflictDialog(
  BuildContext context,
  AppLocalizations l10n,
) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.userLocalDataSyncConflictTitle),
      content: Text(l10n.userLocalDataSyncConflictMessage),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'remote'),
          child: Text(l10n.userLocalDataSyncUseRemote),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, 'local'),
          child: Text(l10n.userLocalDataSyncKeepLocal),
        ),
      ],
    ),
  );
}
