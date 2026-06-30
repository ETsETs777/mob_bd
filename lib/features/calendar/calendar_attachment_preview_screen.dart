import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/motion/app_motion.dart';
import '../../core/utils/calendar_attachment_storage.dart';
import '../../data/models/user_calendar_event.dart';
import '../../l10n/app_localizations.dart';
import 'calendar_pdf_preview.dart';

/// Просмотр вложения события календаря (изображение или PDF).
class CalendarAttachmentPreviewScreen extends StatelessWidget {
  const CalendarAttachmentPreviewScreen({
    super.key,
    required this.event,
    required this.bytes,
  });

  final UserCalendarEvent event;
  final Uint8List bytes;

  static Future<void> open(BuildContext context, UserCalendarEvent event) async {
    final bytes = CalendarAttachmentStorage.loadBytes(event.id);
    if (bytes == null || !context.mounted) return;
    await openAppPage(
      context,
      CalendarAttachmentPreviewScreen(event: event, bytes: bytes),
    );
  }

  Future<void> _share() async {
    final name = event.attachmentName ?? 'attachment';
    await Share.shareXFiles(
      [XFile.fromData(bytes, name: name, mimeType: event.attachmentMime)],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final mime = event.attachmentMime;
    final name = event.attachmentName ?? l10n.userCalendarViewAttachment;

    return Scaffold(
      appBar: AppBar(
        title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
        actions: [
          IconButton(
            icon: const Icon(Iconsax.export_3),
            tooltip: l10n.userCalendarAttachmentShare,
            onPressed: _share,
          ),
        ],
      ),
      body: calendarAttachmentIsImage(mime)
          ? InteractiveViewer(
              minScale: 0.5,
              maxScale: 4,
              child: Center(
                child: Image.memory(bytes, fit: BoxFit.contain),
              ),
            )
          : calendarAttachmentIsPdf(mime)
              ? buildCalendarPdfPreviewWidget(
                  context: context,
                  bytes: bytes,
                  fileName: name,
                  onShare: _share,
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.document, size: 48),
                        const Gap(12),
                        Text(name, textAlign: TextAlign.center),
                        const Gap(16),
                        FilledButton.icon(
                          onPressed: _share,
                          icon: const Icon(Iconsax.export_3, size: 18),
                          label: Text(l10n.userCalendarAttachmentShare),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
