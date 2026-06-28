// =============================================================================
// EcoPulse · lib/features/shared/widgets/metric_card.dart
// Автор: Цымбал Е. В.
// Дата: 03.06.2026
// Общие виджеты и действия приложения. Файл: metric_card.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_palette.dart';
import '../../../l10n/app_localizations.dart';
import 'animated_value_text.dart';

/// StatelessWidget [MetricCard] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
class MetricCard extends StatelessWidget {
/// Создаёт [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  const MetricCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.changePercent,
    this.onTap,
    this.sparkline,
    this.animateIndex = 0,
    this.sourceBadge,
    this.numericValue,
    this.valueFormatter,
    this.compact = false,
    this.heroWatchlistKey,
  });

/// Поле [title] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final String title;
/// Поле [value] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final String value;
/// Поле [subtitle] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final String? subtitle;
/// Поле [changePercent] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final double? changePercent;
/// Поле [onTap] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final VoidCallback? onTap;
/// Поле [sparkline] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final List<double>? sparkline;
/// Поле [animateIndex] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final int animateIndex;
/// Поле [sourceBadge] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final String? sourceBadge;
/// Поле [numericValue] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final double? numericValue;
/// Поле [valueFormatter] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final String Function(double)? valueFormatter;
/// Поле [compact] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final bool compact;
/// Поле [heroWatchlistKey] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final String? heroWatchlistKey;

/// Приватный метод [_copyValue] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  void _copyValue(BuildContext context) {
    Clipboard.setData(ClipboardData(text: value));
    HapticFeedback.mediumImpact();
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${l10n?.copied ?? 'Copied'}: $value'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

/// Приватный метод [_shareValue] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  void _shareValue(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final message = l10n?.shareMessage(title, value) ?? '$title: $value';
    Share.share(message, subject: title);
  }

/// Приватный метод [_showActions] класса [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  void _showActions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy_outlined),
              title: Text(l10n?.copyQuote ?? 'Copy'),
              onTap: () {
                Navigator.pop(context);
                _copyValue(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share_outlined),
              title: Text(l10n?.shareQuote ?? 'Share'),
              onTap: () {
                Navigator.pop(context);
                _shareValue(context);
              },
            ),
          ],
        ),
      ),
    );
  }

/// Отрисовывает UI [MetricCard].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final pad = compact ? 12.0 : 16.0;
    final valueStyle = AppTypography.quote(
      TextStyle(
        fontSize: compact ? 20 : 24,
        fontWeight: FontWeight.w700,
        color: palette.textPrimary,
        letterSpacing: -0.5,
      ),
    );

    return Card(
      child: InkWell(
        onTap: onTap,
        onLongPress: () => _showActions(context),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(pad),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: heroWatchlistKey != null
                        ? Hero(
                            tag: 'asset-title-$heroWatchlistKey',
                            child: Material(
                              color: Colors.transparent,
                              child: Text(
                                title,
                                style: TextStyle(
                                  color: palette.textSecondary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        : Text(
                            title,
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                  ),
                  if (sourceBadge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: palette.surfaceLight,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: palette.border),
                      ),
                      child: Text(
                        sourceBadge!,
                        style: TextStyle(
                          fontSize: 10,
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  if (changePercent != null && changePercent!.abs() >= 5) ...[
                    if (sourceBadge != null) const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: palette.negative.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'VOL',
                        style: TextStyle(
                          fontSize: 10,
                          color: palette.negative,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
              if (numericValue != null && valueFormatter != null)
                AnimatedValueText(
                  value: numericValue!,
                  style: valueStyle,
                  format: valueFormatter!,
                )
              else
                Text(value, style: valueStyle),
              if (changePercent != null) ...[
                const SizedBox(height: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: (changePercent! >= 0
                            ? palette.positive
                            : palette.negative)
                        .withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${changePercent! >= 0 ? '+' : ''}${changePercent!.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: changePercent! >= 0
                          ? palette.positive
                          : palette.negative,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
              if (subtitle != null) ...[
                const SizedBox(height: 4),
                Text(
                  subtitle!,
                  style: TextStyle(color: palette.textSecondary, fontSize: 12),
                ),
              ],
              if (sparkline != null && sparkline!.length > 1 && !compact) ...[
                const SizedBox(height: 12),
                RepaintBoundary(
                  child: MiniSparkline(values: sparkline!),
                ),
              ] else if (sparkline != null && sparkline!.length > 1 && compact) ...[
                const SizedBox(height: 8),
                RepaintBoundary(
                  child: MiniSparkline(values: sparkline!, height: 24),
                ),
              ],
            ],
          ),
        ),
      ),
    )
        .animate(delay: (animateIndex * (compact ? 30 : 60)).ms)
        .fadeIn(duration: 350.ms, curve: Curves.easeOut)
        .slideY(begin: 0.06, end: 0, curve: Curves.easeOut);
  }
}

/// StatelessWidget [MiniSparkline] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class MiniSparkline extends StatelessWidget {
/// Создаёт [MiniSparkline].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  const MiniSparkline({
    super.key,
    required this.values,
    this.height = 36,
    this.strokeWidth = 2,
    this.showFill = true,
  });

/// Поле [values] класса [MiniSparkline].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final List<double> values;
/// Поле [height] класса [MiniSparkline].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final double height;
  final double strokeWidth;
  final bool showFill;

/// Отрисовывает UI [MiniSparkline].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    if (values.length < 2) return const SizedBox.shrink();

    final min = values.reduce((a, b) => a < b ? a : b);
    final max = values.reduce((a, b) => a > b ? a : b);
    final range = max - min == 0 ? 1.0 : max - min;
    final isUp = values.last >= values.first;
    final color = isUp ? palette.positive : palette.negative;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(
          values: values,
          min: min,
          range: range,
          color: color,
          fillColor: color.withValues(alpha: 0.1),
          strokeWidth: strokeWidth,
          showFill: showFill,
        ),
      ),
    );
  }
}

/// Приватный класс [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class _SparklinePainter extends CustomPainter {
/// Создаёт [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  _SparklinePainter({
    required this.values,
    required this.min,
    required this.range,
    required this.color,
    required this.fillColor,
    this.strokeWidth = 2,
    this.showFill = true,
  });

/// Поле [values] класса [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  final List<double> values;
/// Поле [min] класса [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  final double min;
/// Поле [range] класса [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  final double range;
/// Поле [color] класса [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  final Color color;
/// Поле [fillColor] класса [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 03.06.2026
  final Color fillColor;
  final double strokeWidth;
  final bool showFill;

/// Метод [paint] класса [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 04.06.2026
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final fillPath = Path();
    final linePath = Path();

    for (var i = 0; i < values.length; i++) {
      final x = (i / (values.length - 1)) * size.width;
      final y = size.height - ((values[i] - min) / range) * size.height;
      if (i == 0) {
        linePath.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        linePath.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }
    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    if (showFill) {
      canvas.drawPath(fillPath, Paint()..color = fillColor);
    }
    canvas.drawPath(linePath, linePaint);
  }

/// Метод [shouldRepaint] класса [_SparklinePainter].
///
/// Автор: Цымбал Е. В.
/// Дата: 05.06.2026
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
