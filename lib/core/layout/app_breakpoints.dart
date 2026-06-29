import 'package:flutter/material.dart';

/// Breakpoints для tablet / desktop layout.
abstract final class AppBreakpoints {
  static const double tablet = 840;
  static const double desktop = 1200;

  static bool isTablet(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= tablet;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktop;
}
