// =============================================================================
// EcoPulse · lib/features/auth/pin_setup_screen.dart
// Автор: Цымбал Е. В.
// Дата: 20.06.2026
// Модуль EcoPulse. Файл: pin_setup_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_palette.dart';
import '../../providers/security_provider.dart';

/// Enum [_SetupStep] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
/// Значение enum [enter].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
/// Значение enum [confirm].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
/// Значение enum [confirm].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
/// Значение enum [enter].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
enum _SetupStep { enter, confirm }

/// Класс [PinSetupScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
class PinSetupScreen extends ConsumerStatefulWidget {
/// Создаёт [PinSetupScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  const PinSetupScreen({
    super.key,
    required this.mode,
    this.oldPinRequired = false,
  });

/// Поле [mode] класса [PinSetupScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final PinSetupMode mode;
/// Поле [oldPinRequired] класса [PinSetupScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final bool oldPinRequired;

/// Создаёт State для [PinSetupScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

/// Значение enum [disable].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
/// Enum [PinSetupMode] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
/// Значение enum [change].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
/// Значение enum [create].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
/// Значение enum [disable].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
/// Значение enum [change].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
/// Значение enum [create].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
enum PinSetupMode { create, change, disable }

/// Приватный класс [_PinSetupScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
/// Поле [_step] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  _SetupStep _step = _SetupStep.enter;
/// Поле [_firstPin] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  String _firstPin = '';
/// Поле [_input] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  String _input = '';
/// Поле [_oldPin] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  String? _oldPin;
/// Поле [_error] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  String? _error;

/// Getter [_title] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  String get _title => switch (widget.mode) {
        PinSetupMode.create => 'Создайте код доступа',
        PinSetupMode.change => 'Новый код доступа',
        PinSetupMode.disable => 'Введите текущий код',
      };

/// Getter [_subtitle] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  String get _subtitle {
    if (widget.mode == PinSetupMode.disable) {
      return 'Для отключения защиты';
    }
    if (_step == _SetupStep.confirm) return 'Повторите код';
    if (widget.oldPinRequired && _oldPin == null) {
      return 'Сначала введите текущий код';
    }
    return '$_title · 4 цифры';
  }

/// Приватный метод [_onDigit] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  void _onDigit(String digit) {
    if (_input.length >= pinLength) return;
    HapticFeedback.lightImpact();
    setState(() {
      _error = null;
      _input += digit;
    });
    if (_input.length == pinLength) {
      Future.delayed(const Duration(milliseconds: 120), _handleComplete);
    }
  }

/// Приватный метод [_onBackspace] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  void _onBackspace() {
    if (_input.isEmpty) return;
    setState(() {
      _error = null;
      _input = _input.substring(0, _input.length - 1);
    });
  }

/// Приватный метод [_handleComplete] класса [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  Future<void> _handleComplete() async {
    final notifier = ref.read(securitySettingsProvider.notifier);

    if (widget.oldPinRequired && _oldPin == null) {
      if (!notifier.verify(_input)) {
        setState(() {
          _error = 'Неверный код';
          _input = '';
        });
        return;
      }
      setState(() {
        _oldPin = _input;
        _input = '';
        _step = _SetupStep.enter;
      });
      return;
    }

    if (widget.mode == PinSetupMode.disable) {
      final ok = await notifier.disablePin(_input);
      if (!mounted) return;
      if (ok) {
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _error = 'Неверный код';
          _input = '';
        });
      }
      return;
    }

    if (_step == _SetupStep.enter) {
      setState(() {
        _firstPin = _input;
        _input = '';
        _step = _SetupStep.confirm;
      });
      return;
    }

    if (_input != _firstPin) {
      setState(() {
        _error = 'Коды не совпадают';
        _input = '';
        _firstPin = '';
        _step = _SetupStep.enter;
      });
      return;
    }

    if (widget.mode == PinSetupMode.change && _oldPin != null) {
      final ok = await notifier.changePin(_oldPin!, _input);
      if (!mounted) return;
      if (ok) {
        ref.read(appUnlockedProvider.notifier).unlock();
        Navigator.of(context).pop(true);
      } else {
        setState(() {
          _error = 'Не удалось сменить код';
          _input = '';
        });
      }
      return;
    }

    final ok = await notifier.enablePin(_input);
    if (!mounted) return;
    if (ok) {
      ref.read(appUnlockedProvider.notifier).unlock();
      Navigator.of(context).pop(true);
    } else {
      setState(() {
        _error = 'Ошибка сохранения';
        _input = '';
      });
    }
  }

/// Отрисовывает UI [_PinSetupScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(switch (widget.mode) {
          PinSetupMode.create => 'Код доступа',
          PinSetupMode.change => 'Сменить код',
          PinSetupMode.disable => 'Отключить код',
        }),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Gap(32),
            Icon(Iconsax.lock_1, size: 40, color: palette.accent),
            const Gap(16),
            Text(
              _subtitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Gap(8),
            if (_error != null)
              Text(_error!, style: TextStyle(color: palette.negative)),
            const Gap(24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(pinLength, (i) {
                final filled = i < _input.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? palette.accent : Colors.transparent,
                    border: Border.all(
                      color: filled
                          ? palette.accent
                          : palette.textSecondary.withValues(alpha: 0.5),
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            const Spacer(),
            _Keypad(
              palette: palette,
              onDigit: _onDigit,
              onBackspace: _onBackspace,
            ),
            const Gap(24),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_Keypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class _Keypad extends StatelessWidget {
/// Создаёт [_Keypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  const _Keypad({
    required this.palette,
    required this.onDigit,
    required this.onBackspace,
  });

/// Поле [palette] класса [_Keypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final AppPalette palette;
/// Поле [onDigit] класса [_Keypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final ValueChanged<String> onDigit;
/// Поле [onBackspace] класса [_Keypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final VoidCallback onBackspace;

/// Отрисовывает UI [_Keypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override
  Widget build(BuildContext context) {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) {
                if (key.isEmpty) return const SizedBox(width: 64, height: 64);
                if (key == '⌫') {
                  return _PadKey(
                    palette: palette,
                    child: Icon(Iconsax.arrow_left, color: palette.textPrimary),
                    onTap: onBackspace,
                  );
                }
                return _PadKey(
                  palette: palette,
                  child: Text(
                    key,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: palette.textPrimary,
                    ),
                  ),
                  onTap: () => onDigit(key),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// Приватный класс [_PadKey].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
class _PadKey extends StatelessWidget {
/// Создаёт [_PadKey].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  const _PadKey({
    required this.palette,
    required this.child,
    required this.onTap,
  });

/// Поле [palette] класса [_PadKey].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final AppPalette palette;
/// Поле [child] класса [_PadKey].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final Widget child;
/// Поле [onTap] класса [_PadKey].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final VoidCallback onTap;

/// Отрисовывает UI [_PadKey].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  @override
  Widget build(BuildContext context) {
    return Material(
      color: palette.surfaceLight,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 64,
          height: 64,
          child: Center(child: child),
        ),
      ),
    );
  }
}
