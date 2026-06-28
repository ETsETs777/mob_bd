// =============================================================================
// EcoPulse · lib/providers/locale_provider.dart
// Автор: Цымбал Е. В.
// Дата: 22.05.2026
// Riverpod state: провайдеры и notifiers. Файл: locale_provider.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/cache_service.dart';

/// Enum [AppLocale] — перечисление значений.
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
enum AppLocale {
/// Значение enum [ru].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  ru('ru', 'Русский'),
/// Значение enum [en].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  en('en', 'English');

  const AppLocale(this.code, this.label);
  final String code;
  final String label;

  Locale get locale => Locale(code);

  static AppLocale fromCode(String? code) {
    if (code == 'en') return AppLocale.en;
    return AppLocale.ru;
  }
}

/// Riverpod: локаль RU/EN.
///
/// Автор: Цымбал Е. В.
/// Дата: 26.05.2026
final localeProvider =
    NotifierProvider<LocaleNotifier, AppLocale>(LocaleNotifier.new);

/// Riverpod AsyncNotifier [LocaleNotifier] — загрузка и кэш state.
///
/// Автор: Цымбал Е. В.
/// Дата: 22.05.2026
class LocaleNotifier extends Notifier<AppLocale> {
/// Поле [_key] класса [LocaleNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.05.2026
  static const _key = 'app_locale';

/// Отрисовывает UI [LocaleNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.05.2026
  @override
  AppLocale build() {
    return AppLocale.fromCode(CacheService.instance.getString(_key));
  }

/// Метод [setLocale] класса [LocaleNotifier].
///
/// Автор: Цымбал Е. В.
/// Дата: 25.05.2026
  Future<void> setLocale(AppLocale locale) async {
    state = locale;
    await CacheService.instance.putString(_key, locale.code);
  }
}
