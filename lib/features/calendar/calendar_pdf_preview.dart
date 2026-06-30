import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'calendar_pdf_preview_stub.dart'
    if (dart.library.html) 'calendar_pdf_preview_web.dart';

bool calendarAttachmentIsImage(String? mime) =>
    mime != null && mime.startsWith('image/');

bool calendarAttachmentIsPdf(String? mime) => mime == 'application/pdf';

/// PDF preview: iframe на web, карточка с «Поделиться» на mobile.
Widget buildCalendarPdfPreviewWidget({
  required BuildContext context,
  required Uint8List bytes,
  required String fileName,
  required VoidCallback onShare,
}) {
  return buildCalendarPdfPreview(
    context: context,
    fileName: fileName,
    byteLength: bytes.length,
    onShare: onShare,
    bytes: bytes,
  );
}
