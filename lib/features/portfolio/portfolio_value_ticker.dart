import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../core/utils/formatters.dart';
import '../../l10n/app_localizations.dart';

/// Анимированный total портфеля с индикатором LIVE.
class PortfolioValueTicker extends StatefulWidget {
  const PortfolioValueTicker({
    super.key,
    required this.totalValueRub,
    required this.isLive,
    this.fontSize = 28,
    this.liveUpdatedAt,
  });

  final double totalValueRub;
  final bool isLive;
  final double fontSize;
  final DateTime? liveUpdatedAt;

  @override
  State<PortfolioValueTicker> createState() => _PortfolioValueTickerState();
}

class _PortfolioValueTickerState extends State<PortfolioValueTicker> {
  double? _previousTotal;
  Color? _flashColor;

  @override
  void didUpdateWidget(PortfolioValueTicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_previousTotal != null &&
        widget.totalValueRub != _previousTotal &&
        widget.totalValueRub != oldWidget.totalValueRub) {
      final palette = AppPalette.of(context);
      _flashColor = widget.totalValueRub > _previousTotal!
          ? palette.positive
          : palette.negative;
      Future<void>.delayed(const Duration(milliseconds: 600), () {
        if (mounted) setState(() => _flashColor = null);
      });
    }
    _previousTotal = widget.totalValueRub;
  }

  @override
  void initState() {
    super.initState();
    _previousTotal = widget.totalValueRub;
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold,
                color: _flashColor ?? palette.textPrimary,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
              child: Text(Formatters.rub(widget.totalValueRub)),
            ),
            if (widget.isLive) ...[
              const Gap(10),
              _LiveBadge(label: l10n.portfolioLiveBadge),
            ],
          ],
        ),
        if (widget.isLive && widget.liveUpdatedAt != null) ...[
          const Gap(4),
          Text(
            l10n.portfolioLiveUpdated(
              Formatters.formatJournalPreview(widget.liveUpdatedAt!.toLocal()),
            ),
            style: TextStyle(fontSize: 11, color: palette.textSecondary),
          ),
        ],
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: palette.positive.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.positive.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: palette.positive,
              shape: BoxShape.circle,
            ),
          ),
          const Gap(5),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: palette.positive,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }
}
