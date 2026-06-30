import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/app/feature_tour_provider.dart';

/// Шаг guided tour — подсветка виджета с [targetKey].
class FeatureTourStep {
  const FeatureTourStep({
    required this.targetKey,
    required this.title,
    required this.body,
    this.preferBelow = true,
  });

  final GlobalKey targetKey;
  final String title;
  final String body;
  final bool preferBelow;
}

/// Показывает overlay-tour один раз (или принудительно при [force]).
abstract final class FeatureTour {
  static Future<void> maybeShow({
    required BuildContext context,
    required WidgetRef ref,
    required String tourId,
    required List<FeatureTourStep> steps,
    bool force = false,
  }) async {
    if (!context.mounted || steps.isEmpty) return;
    if (!force && ref.read(featureTourCompletedProvider(tourId))) return;

    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!context.mounted) return;

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, _, __) => _FeatureTourOverlay(
        tourId: tourId,
        steps: steps,
      ),
    );
  }
}

class _FeatureTourOverlay extends ConsumerStatefulWidget {
  const _FeatureTourOverlay({
    required this.tourId,
    required this.steps,
  });

  final String tourId;
  final List<FeatureTourStep> steps;

  @override
  ConsumerState<_FeatureTourOverlay> createState() =>
      _FeatureTourOverlayState();
}

class _FeatureTourOverlayState extends ConsumerState<_FeatureTourOverlay> {
  int _index = 0;

  Rect? _targetRect(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return null;
    final offset = box.localToGlobal(Offset.zero);
    return offset & box.size;
  }

  void _next(AppLocalizations l10n) {
    if (_index < widget.steps.length - 1) {
      setState(() => _index++);
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    await ref.read(featureTourCompletedProvider(widget.tourId).notifier).complete();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = AppPalette.of(context);
    final media = MediaQuery.of(context);
    final step = widget.steps[_index];
    final hole = _targetRect(step.targetKey);
    final isLast = _index == widget.steps.length - 1;

    return Material(
      color: Colors.transparent,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hole != null)
            CustomPaint(
              painter: _SpotlightPainter(
                hole: hole,
                color: Colors.black.withValues(alpha: 0.72),
              ),
              size: media.size,
            )
          else
            ColoredBox(color: Colors.black.withValues(alpha: 0.72)),
          Positioned.fill(
            child: _TourCard(
              palette: palette,
              l10n: l10n,
              step: step,
              hole: hole,
              screenSize: media.size,
              padding: media.padding,
              stepIndex: _index,
              stepCount: widget.steps.length,
              isLast: isLast,
              onSkip: _finish,
              onNext: () => _next(l10n),
            ),
          ),
        ],
      ),
    );
  }
}

class _TourCard extends StatelessWidget {
  const _TourCard({
    required this.palette,
    required this.l10n,
    required this.step,
    required this.hole,
    required this.screenSize,
    required this.padding,
    required this.stepIndex,
    required this.stepCount,
    required this.isLast,
    required this.onSkip,
    required this.onNext,
  });

  final AppPalette palette;
  final AppLocalizations l10n;
  final FeatureTourStep step;
  final Rect? hole;
  final Size screenSize;
  final EdgeInsets padding;
  final int stepIndex;
  final int stepCount;
  final bool isLast;
  final VoidCallback onSkip;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    const cardWidth = 320.0;
    const cardMargin = 16.0;
    final maxTop = screenSize.height - padding.bottom - 220;
    double top = padding.top + cardMargin + 80;

    if (hole != null) {
      if (step.preferBelow) {
        top = hole!.bottom + 16;
        if (top > maxTop) top = hole!.top - 200;
      } else {
        top = hole!.top - 200;
        if (top < padding.top + cardMargin) top = hole!.bottom + 16;
      }
    }

    top = top.clamp(padding.top + cardMargin, maxTop);

    return Stack(
      children: [
        Positioned(
          left: cardMargin,
          right: cardMargin,
          top: top,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: cardWidth),
              child: Card(
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        step.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                      ),
                      const Gap(8),
                      Text(
                        step.body,
                        style: TextStyle(
                          color: palette.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      const Gap(16),
                      Row(
                        children: [
                          Text(
                            '${stepIndex + 1}/$stepCount',
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: onSkip,
                            child: Text(l10n.featureTourSkip),
                          ),
                          FilledButton(
                            onPressed: onNext,
                            child: Text(
                              isLast ? l10n.featureTourDone : l10n.featureTourNext,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SpotlightPainter extends CustomPainter {
  _SpotlightPainter({required this.hole, required this.color});

  final Rect hole;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final outer = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));
    final highlight = RRect.fromRectAndRadius(
      hole.inflate(8),
      const Radius.circular(12),
    );
    final inner = Path()..addRRect(highlight);
    final scrim = Path.combine(PathOperation.difference, outer, inner);
    canvas.drawPath(scrim, Paint()..color = color);
    canvas.drawRRect(
      highlight,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(covariant _SpotlightPainter oldDelegate) =>
      oldDelegate.hole != hole;
}
