// =============================================================================
// EcoPulse · lib/features/auth/pin_lock_screen.dart
// Автор: Цымбал Е. В.
// Дата: 19.06.2026
// Модуль EcoPulse. Файл: pin_lock_screen.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../../core/theme/app_backgrounds.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/background_provider.dart';
import '../../providers/security_provider.dart';
import '../shared/widgets/app_background.dart';

/// Класс [PinLockScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class PinLockScreen extends ConsumerStatefulWidget {
/// Создаёт [PinLockScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  const PinLockScreen({super.key, required this.onUnlocked});

/// Поле [onUnlocked] класса [PinLockScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final VoidCallback onUnlocked;

/// Создаёт State для [PinLockScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

/// Приватный класс [_PinLockScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
class _PinLockScreenState extends ConsumerState<PinLockScreen> {
/// Поле [_input] класса [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  String _input = '';
/// Поле [_error] класса [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  String? _error;
/// Поле [_shakeKey] класса [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  int _shakeKey = 0;
/// Поле [_biometricAttempted] класса [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  bool _biometricAttempted = false;

/// Инициализация state [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

/// Приватный метод [_tryBiometric] класса [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  Future<void> _tryBiometric() async {
    if (_biometricAttempted) return;
    _biometricAttempted = true;

    final settings = ref.read(securitySettingsProvider);
    if (!settings.biometricEnabled) return;

    final available = await ref.read(biometricAvailableProvider.future);
    if (!available || !mounted) return;

    final l10n = AppLocalizations.of(context)!;
    final ok = await ref.read(biometricAuthServiceProvider).authenticate(
          reason: l10n.pinUseBiometric,
        );
    if (!mounted) return;
    if (ok) {
      HapticFeedback.mediumImpact();
      ref.read(appUnlockedProvider.notifier).unlock();
      widget.onUnlocked();
    }
  }

/// Приватный метод [_onDigit] класса [_PinLockScreenState].
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
      _submit();
    }
  }

/// Приватный метод [_onBackspace] класса [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  void _onBackspace() {
    if (_input.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _error = null;
      _input = _input.substring(0, _input.length - 1);
    });
  }

/// Приватный метод [_submit] класса [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final ok = ref.read(securitySettingsProvider.notifier).verify(_input);
    if (ok) {
      HapticFeedback.mediumImpact();
      ref.read(appUnlockedProvider.notifier).unlock();
      widget.onUnlocked();
    } else {
      HapticFeedback.heavyImpact();
      setState(() {
        _error = l10n.pinWrongCode;
        _input = '';
        _shakeKey++;
      });
    }
  }

/// Отрисовывает UI [_PinLockScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  @override
  Widget build(BuildContext context) {
    final preset = ref.watch(backgroundPresetProvider);
    final isLight = preset.isLight;
    final l10n = AppLocalizations.of(context)!;
    final biometricEnabled = ref.watch(securitySettingsProvider).biometricEnabled;
    final biometricAvailable = ref.watch(biometricAvailableProvider);

    final textColor = isLight ? const Color(0xFF1F2328) : Colors.white;
    final subColor =
        isLight ? const Color(0xFF656D76) : Colors.white.withValues(alpha: 0.75);

    final showBiometricButton = biometricEnabled &&
        biometricAvailable.maybeWhen(data: (v) => v, orElse: () => false);

    return AppBackground(
      child: SafeArea(
        child: Column(
          children: [
            const Gap(48),
            Icon(Iconsax.security_safe, size: 48, color: textColor),
            const Gap(16),
            Text(
              l10n.appTitle,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: textColor,
                letterSpacing: -0.5,
              ),
            ),
            const Gap(8),
            Text(
              l10n.pinEnterCode,
              style: TextStyle(color: subColor, fontSize: 15),
            ),
            const Gap(32),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Text(
                _error ?? ' ',
                key: ValueKey(_error),
                style: TextStyle(
                  color: _error != null ? const Color(0xFFFF6B6B) : Colors.transparent,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Gap(16),
            _PinDots(
              count: _input.length,
              length: pinLength,
              color: textColor,
              shakeKey: _shakeKey,
            ),
            if (showBiometricButton) ...[
              const Gap(24),
              IconButton(
                iconSize: 48,
                tooltip: l10n.pinUseBiometric,
                onPressed: () {
                  _biometricAttempted = false;
                  _tryBiometric();
                },
                icon: Icon(Iconsax.finger_scan, color: textColor),
              ),
            ],
            const Spacer(),
            _PinKeypad(
              textColor: textColor,
              onDigit: _onDigit,
              onBackspace: _onBackspace,
            ),
            const Gap(32),
          ],
        ),
      ),
    );
  }
}

/// Приватный класс [_PinDots].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
class _PinDots extends StatelessWidget {
/// Создаёт [_PinDots].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  const _PinDots({
    required this.count,
    required this.length,
    required this.color,
    required this.shakeKey,
  });

/// Поле [count] класса [_PinDots].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final int count;
/// Поле [length] класса [_PinDots].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final int length;
/// Поле [color] класса [_PinDots].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  final Color color;
/// Поле [shakeKey] класса [_PinDots].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final int shakeKey;

/// Отрисовывает UI [_PinDots].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        final filled = i < count;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: filled ? 14 : 12,
          height: filled ? 14 : 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: filled ? color : Colors.transparent,
            border: Border.all(
              color: color.withValues(alpha: filled ? 1 : 0.45),
              width: 2,
            ),
          ),
        );
      }),
    )
        .animate(key: ValueKey(shakeKey))
        .shake(hz: 4, duration: 400.ms, curve: Curves.easeOut);
  }
}

/// Приватный класс [_PinKeypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
class _PinKeypad extends StatelessWidget {
/// Создаёт [_PinKeypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  const _PinKeypad({
    required this.textColor,
    required this.onDigit,
    required this.onBackspace,
  });

/// Поле [textColor] класса [_PinKeypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  final Color textColor;
/// Поле [onDigit] класса [_PinKeypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final ValueChanged<String> onDigit;
/// Поле [onBackspace] класса [_PinKeypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final VoidCallback onBackspace;

/// Отрисовывает UI [_PinKeypad].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override
  Widget build(BuildContext context) {
    const keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '⌫'],
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) {
                if (key.isEmpty) {
                  return const SizedBox(width: 72, height: 72);
                }
                if (key == '⌫') {
                  return _KeyButton(
                    label: key,
                    textColor: textColor,
                    onTap: onBackspace,
                  );
                }
                return _KeyButton(
                  label: key,
                  textColor: textColor,
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

/// Приватный класс [_KeyButton].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
class _KeyButton extends StatelessWidget {
/// Создаёт [_KeyButton].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  const _KeyButton({
    required this.label,
    required this.textColor,
    required this.onTap,
  });

/// Поле [label] класса [_KeyButton].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final String label;
/// Поле [textColor] класса [_KeyButton].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
  final Color textColor;
/// Поле [onTap] класса [_KeyButton].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final VoidCallback onTap;

/// Отрисовывает UI [_KeyButton].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  @override
  Widget build(BuildContext context) {
    final isBackspace = label == '⌫';

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 72,
          height: 72,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: isBackspace ? 0.08 : 0.12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
          ),
          child: isBackspace
              ? Icon(Iconsax.arrow_left, color: textColor, size: 22)
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
        ),
      ),
    );
  }
}
