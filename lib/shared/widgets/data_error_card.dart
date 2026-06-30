import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/user_error_message.dart';
import '../../l10n/app_localizations.dart';
import 'app_card.dart';

/// Единый блок ошибки загрузки данных (вместо сырого DioException).
class DataErrorCard extends StatelessWidget {
  const DataErrorCard({
    super.key,
    required this.error,
    this.onRetry,
    this.compact = false,
    this.padding,
  });

  final Object error;
  final VoidCallback? onRetry;
  final bool compact;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final message = userErrorMessage(error, l10n: l10n);

    if (compact) {
      return AppCard(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Iconsax.warning_2, color: palette.negative, size: 20),
            const Gap(12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: palette.textSecondary, fontSize: 13),
              ),
            ),
            if (onRetry != null)
              IconButton(
                tooltip: l10n.retry,
                onPressed: onRetry,
                icon: Icon(Iconsax.refresh, color: palette.accent, size: 20),
              ),
          ],
        ),
      );
    }

    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: palette.negative.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Iconsax.wifi_square,
                size: 36,
                color: palette.negative,
              ),
            ),
            const Gap(16),
            Text(
              l10n.errorDataTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: palette.textPrimary,
              ),
            ),
            const Gap(8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: palette.textSecondary,
                height: 1.4,
                fontSize: 14,
              ),
            ),
            if (onRetry != null) ...[
              const Gap(20),
              FilledButton.tonal(
                onPressed: onRetry,
                child: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
