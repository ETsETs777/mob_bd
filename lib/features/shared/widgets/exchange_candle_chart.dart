import 'package:candlesticks/candlesticks.dart';
import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../../core/customization/chart_render_style.dart';
import '../../../core/theme/app_palette.dart';
import '../../../core/utils/trading_chart_adapters.dart';
import '../../../core/utils/trading_chart_style.dart';
import '../../../data/models/candle_point.dart';
import '../../../data/models/user_customization.dart';
import '../../../l10n/app_localizations.dart';

/// Биржевой свечной график: pinch-zoom, pan, OHLC-bar, объём, crosshair.
class ExchangeCandleChartWidget extends StatefulWidget {
  const ExchangeCandleChartWidget({
    super.key,
    required this.candles,
    this.currencySymbol = '₽',
    this.height = 320,
    this.renderStyle,
  });

  final List<CandlePoint> candles;
  final String currencySymbol;
  final double height;
  final ChartRenderStyle? renderStyle;

  @override
  State<ExchangeCandleChartWidget> createState() =>
      _ExchangeCandleChartWidgetState();
}

class _ExchangeCandleChartWidgetState extends State<ExchangeCandleChartWidget> {
  late final CandlesticksController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CandlesticksController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context);
    final visual = widget.renderStyle?.visual ?? const ChartVisualOptions();
    final packageCandles = TradingChartAdapters.toPackageCandles(
      widget.candles,
      includeVolume: visual.showVolume,
    );

    if (packageCandles.length < 2) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            l10n?.chartInsufficientCandles ?? 'Not enough candle data',
            style: TextStyle(color: palette.textSecondary),
          ),
        ),
      );
    }

    final style = TradingChartStyle.resolve(
      context: context,
      palette: palette,
      visual: visual,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (visual.enablePanZoom) _ChartZoomBar(controller: _controller, palette: palette),
        Container(
          height: widget.height,
          decoration: BoxDecoration(
            color: palette.surfaceLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: palette.border),
          ),
          clipBehavior: Clip.antiAlias,
          child: Candlesticks(
            key: ValueKey(Object.hashAll([
              packageCandles.length,
              packageCandles.first.close,
              packageCandles.last.close,
              visual.showVolume,
              visual.showGrid,
            ])),
            candles: packageCandles,
            controller: _controller,
            style: style,
          ),
        ),
      ],
    );
  }
}

class _ChartZoomBar extends StatelessWidget {
  const _ChartZoomBar({
    required this.controller,
    required this.palette,
  });

  final CandlesticksController controller;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _ZoomIconButton(
            icon: Iconsax.search_zoom_out,
            palette: palette,
            onTap: controller.zoomOut,
          ),
          const SizedBox(width: 6),
          _ZoomIconButton(
            icon: Iconsax.search_zoom_in,
            palette: palette,
            onTap: controller.zoomIn,
          ),
          const SizedBox(width: 6),
          _ZoomIconButton(
            icon: Iconsax.refresh,
            palette: palette,
            onTap: () {
              controller.jumpTo(-10);
              controller.setZoom(6);
            },
          ),
        ],
      ),
    );
  }
}

class _ZoomIconButton extends StatelessWidget {
  const _ZoomIconButton({
    required this.icon,
    required this.palette,
    required this.onTap,
  });

  final IconData icon;
  final AppPalette palette;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.surfaceLight,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: palette.textPrimary),
        ),
      ),
    );
  }
}
