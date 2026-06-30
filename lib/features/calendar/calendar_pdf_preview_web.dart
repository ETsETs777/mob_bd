// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

/// In-app PDF preview via iframe (Flutter web).
Widget buildCalendarPdfPreview({
  required BuildContext context,
  required String fileName,
  required int byteLength,
  required VoidCallback onShare,
  Uint8List? bytes,
}) {
  if (bytes == null || bytes.isEmpty) {
    return const Center(child: CircularProgressIndicator());
  }

  final viewId = 'calendar_pdf_${fileName.hashCode}_${bytes.length}';
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);

  ui_web.platformViewRegistry.registerViewFactory(viewId, (int _) {
    final iframe = html.IFrameElement()
      ..src = url
      ..style.border = 'none'
      ..style.width = '100%'
      ..style.height = '100%';
    return iframe;
  });

  return HtmlElementView(viewType: viewId);
}
