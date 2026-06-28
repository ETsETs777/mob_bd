// =============================================================================
// EcoPulse · lib/core/utils/chart_share.dart
// Автор: Цымбал Е. В.
// Дата: 07.05.2026
// Утилиты: форматирование, математика, аналитика. Файл: chart_share.
// =============================================================================

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';

/// Функция [shareWidgetAsPng] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
Future<void> shareWidgetAsPng({
  required GlobalKey boundaryKey,
  required String fileName,
  String? text,
}) async {
  final context = boundaryKey.currentContext;
  if (context == null) return;

  final boundary = context.findRenderObject() as RenderRepaintBoundary?;
  if (boundary == null) return;

  final image = await boundary.toImage(pixelRatio: 3);
  final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  if (byteData == null) return;

  await Share.shareXFiles(
    [
      XFile.fromData(
        byteData.buffer.asUint8List(),
        mimeType: 'image/png',
        name: fileName,
      ),
    ],
    text: text,
  );
}

/// StatelessWidget [ChartCaptureBoundary] — UI-компонент EcoPulse.
///
/// Автор: Цымбал Е. В.
/// Дата: 09.05.2026
class ChartCaptureBoundary extends StatelessWidget {
/// Создаёт [ChartCaptureBoundary].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.05.2026
  const ChartCaptureBoundary({
    super.key,
    required this.captureKey,
    required this.child,
  });

/// Поле [captureKey] класса [ChartCaptureBoundary].
///
/// Автор: Цымбал Е. В.
/// Дата: 11.05.2026
  final GlobalKey captureKey;
/// Поле [child] класса [ChartCaptureBoundary].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.05.2026
  final Widget child;

/// Отрисовывает UI [ChartCaptureBoundary].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.05.2026
  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: captureKey,
      child: child,
    );
  }
}
