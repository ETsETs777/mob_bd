import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

/// `local` | `remote` | null (отмена).
Future<String?> showArticleSyncConflictDialog(
  BuildContext context,
  AppLocalizations l10n, {
  required String localTitle,
  required String serverTitle,
}) {
  return showDialog<String>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.userArticlesSyncConflictTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.userArticlesSyncConflictMessage),
          const SizedBox(height: 12),
          Text(
            l10n.userArticlesSyncConflictLocal(localTitle),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.userArticlesSyncConflictServer(serverTitle),
            style: TextStyle(color: Theme.of(ctx).colorScheme.onSurfaceVariant),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(ctx, 'remote'),
          child: Text(l10n.userArticlesSyncUseServer),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, 'local'),
          child: Text(l10n.userArticlesSyncKeepLocal),
        ),
      ],
    ),
  );
}
