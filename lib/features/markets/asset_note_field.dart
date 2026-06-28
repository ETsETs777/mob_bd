// =============================================================================
// EcoPulse · lib/features/markets/asset_note_field.dart
// Автор: Цымбал Е. В.
// Дата: 06.06.2026
// Рынки и аналитика облигаций (ОФЗ). Файл: asset_note_field.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';

import '../../core/theme/app_palette.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/asset_notes_provider.dart';

/// Класс [AssetNoteField].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
class AssetNoteField extends ConsumerStatefulWidget {
/// Создаёт [AssetNoteField].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  const AssetNoteField({super.key, required this.assetKey});

/// Поле [assetKey] класса [AssetNoteField].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  final String assetKey;

/// Создаёт State для [AssetNoteField].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  ConsumerState<AssetNoteField> createState() => _AssetNoteFieldState();
}

/// Приватный класс [_AssetNoteFieldState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
class _AssetNoteFieldState extends ConsumerState<AssetNoteField> {
/// Поле [_controller] класса [_AssetNoteFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  late final TextEditingController _controller;
/// Поле [_dirty] класса [_AssetNoteFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 08.06.2026
  bool _dirty = false;

/// Инициализация state [_AssetNoteFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 09.06.2026
  @override
  void initState() {
    super.initState();
    final note = ref.read(assetNotesProvider.notifier).noteFor(widget.assetKey);
    _controller = TextEditingController(text: note ?? '');
  }

/// Освобождает ресурсы [_AssetNoteFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 10.06.2026
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

/// Приватный метод [_save] класса [_AssetNoteFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 06.06.2026
  Future<void> _save() async {
    await ref
        .read(assetNotesProvider.notifier)
        .setNote(widget.assetKey, _controller.text);
    setState(() => _dirty = false);
  }

/// Отрисовывает UI [_AssetNoteFieldState].
///
/// Автор: Цымбал Е. В.
/// Дата: 07.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          l10n.assetNoteTitle,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: palette.textPrimary,
          ),
        ),
        const Gap(8),
        TextField(
          controller: _controller,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: l10n.assetNoteHint,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() => _dirty = true),
        ),
        if (_dirty) ...[
          const Gap(8),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.tonal(
              onPressed: _save,
              child: Text(l10n.profileSave),
            ),
          ),
        ],
      ],
    );
  }
}
