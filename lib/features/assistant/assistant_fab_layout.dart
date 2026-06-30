import 'package:flutter/material.dart';

/// Геометрия FAB ассистента относительно nav bar и узких экранов.
abstract final class AssistantFabLayout {
  static const fabSize = 56.0;
  static const margin = 16.0;
  static const narrowWidth = 360.0;
  static const narrowExtraLift = 10.0;

  /// Доп. отступ снизу для списков, чтобы FAB не перекрывал последние элементы.
  static double scrollBottomPadding(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < narrowWidth;
    return fabSize + margin + (narrow ? narrowExtraLift : 0);
  }

  static FloatingActionButtonLocation location(BuildContext context) {
    final narrow = MediaQuery.sizeOf(context).width < narrowWidth;
    return _AssistantFabLocation(
      extraBottom: narrow ? narrowExtraLift : 0,
    );
  }
}

/// FAB над [NavigationBar], с доп. подъёмом на узких экранах.
class _AssistantFabLocation extends FloatingActionButtonLocation {
  const _AssistantFabLocation({required this.extraBottom});

  final double extraBottom;

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final base = FloatingActionButtonLocation.endFloat.getOffset(
      scaffoldGeometry,
    );
    return Offset(base.dx, base.dy - extraBottom);
  }
}
