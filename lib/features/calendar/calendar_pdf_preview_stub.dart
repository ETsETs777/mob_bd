import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';

/// Fallback PDF preview on mobile/desktop — метаданные + подсказка.
Widget buildCalendarPdfPreview({
  required BuildContext context,
  required String fileName,
  required int byteLength,
  required VoidCallback onShare,
  Uint8List? bytes,
}) {
  final l10n = AppLocalizations.of(context)!;
  final palette = AppPalette.of(context);
  final sizeKb = (byteLength / 1024).clamp(1, 99999).round();

  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.document, size: 72, color: palette.accent),
          const Gap(16),
          Text(
            fileName,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: palette.textPrimary,
            ),
          ),
          const Gap(8),
          Text(
            l10n.userCalendarAttachmentPdfSize(sizeKb),
            style: TextStyle(color: palette.textSecondary),
          ),
          const Gap(16),
          Text(
            l10n.userCalendarAttachmentPdfHint,
            textAlign: TextAlign.center,
            style: TextStyle(color: palette.textSecondary, fontSize: 13),
          ),
          const Gap(20),
          FilledButton.icon(
            onPressed: onShare,
            icon: const Icon(Iconsax.export_3, size: 18),
            label: Text(l10n.userCalendarAttachmentShare),
          ),
        ],
      ),
    ),
  );
}
