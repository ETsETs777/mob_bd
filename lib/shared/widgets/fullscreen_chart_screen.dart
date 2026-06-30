import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/motion/app_motion.dart';
import '../../data/models/chart_render_input.dart';
import '../../data/models/user_customization.dart';
import 'custom_chart_view.dart';

/// Полноэкранный график с landscape-ориентацией.
class FullscreenChartScreen extends StatefulWidget {
  const FullscreenChartScreen({
    super.key,
    required this.title,
    required this.contextId,
    required this.input,
    this.overrideType,
  });

  final String title;
  final ChartContextId contextId;
  final ChartRenderInput input;
  final ChartTypeId? overrideType;

  static Future<void> open(
    BuildContext context, {
    required String title,
    required ChartContextId contextId,
    required ChartRenderInput input,
    ChartTypeId? overrideType,
  }) {
    return openAppPage<void>(
      context,
      FullscreenChartScreen(
        title: title,
        contextId: contextId,
        input: input,
        overrideType: overrideType,
      ),
      fullscreenDialog: true,
    );
  }

  @override
  State<FullscreenChartScreen> createState() => _FullscreenChartScreenState();
}

class _FullscreenChartScreenState extends State<FullscreenChartScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left),
          tooltip: MaterialLocalizations.of(context).backButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomChartView(
            contextId: widget.contextId,
            input: widget.input,
            overrideType: widget.overrideType,
            height: MediaQuery.sizeOf(context).height - 96,
          ),
        ),
      ),
    );
  }
}
