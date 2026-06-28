// =============================================================================
// EcoPulse · lib/core/services/error_reporting_service.dart
// Автор: Цымбал Е. В.
// Дата: 29.05.2026
// Сервисы: уведомления, backup, assistant, фоновые задачи. Файл: error_reporting_service.
// =============================================================================

import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../data/services/cache_service.dart';

/// Класс [CrashReport].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
class CrashReport {
/// Создаёт [CrashReport].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  const CrashReport({
    required this.message,
    required this.stack,
    required this.at,
  });

/// Поле [message] класса [CrashReport].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  final String message;
/// Поле [stack] класса [CrashReport].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  final String stack;
/// Поле [at] класса [CrashReport].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  final DateTime at;

/// Метод [toJson] класса [CrashReport].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  Map<String, dynamic> toJson() => {
        'message': message,
        'stack': stack,
        'at': at.toIso8601String(),
      };

/// Создаёт [CrashReport] (fromJson).
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  factory CrashReport.fromJson(Map<String, dynamic> json) => CrashReport(
        message: json['message'] as String? ?? '',
        stack: json['stack'] as String? ?? '',
        at: DateTime.tryParse(json['at'] as String? ?? '') ?? DateTime.now(),
      );
}

/// Сервис [ErrorReportingService] — фоновая или системная логика.
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
class ErrorReportingService {
/// Создаёт [ErrorReportingService] (_).
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  ErrorReportingService._();

/// Поле [instance] класса [ErrorReportingService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  static final instance = ErrorReportingService._();

/// Поле [_cacheKey] класса [ErrorReportingService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  static const _cacheKey = 'crash_reports_v1';
/// Поле [_maxReports] класса [ErrorReportingService].
///
/// Автор: Цымбал Е. В.
/// Дата: 31.05.2026
  static const _maxReports = 20;

/// Метод [install] класса [ErrorReportingService].
///
/// Автор: Цымбал Е. В.
/// Дата: 01.06.2026
  void install() {
    final previous = FlutterError.onError;
    FlutterError.onError = (details) {
      _record(details.exceptionAsString(), details.stack?.toString() ?? '');
      previous?.call(details);
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      _record(error.toString(), stack.toString());
      return true;
    };
  }

/// Приватный метод [_record] класса [ErrorReportingService].
///
/// Автор: Цымбал Е. В.
/// Дата: 02.06.2026
  Future<void> _record(String message, String stack) async {
    try {
      final reports = [...loadReports(), CrashReport(message: message, stack: stack, at: DateTime.now())];
      final trimmed = reports.length > _maxReports
          ? reports.sublist(reports.length - _maxReports)
          : reports;
      await CacheService.instance.putString(
        _cacheKey,
        jsonEncode(trimmed.map((r) => r.toJson()).toList()),
      );
    } catch (_) {}
  }

/// Метод [loadReports] класса [ErrorReportingService].
///
/// Автор: Цымбал Е. В.
/// Дата: 29.05.2026
  List<CrashReport> loadReports() {
    final raw = CacheService.instance.getString(_cacheKey);
    if (raw == null || raw.isEmpty) return [];
    try {
      return (jsonDecode(raw) as List<dynamic>)
          .map((e) => CrashReport.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return [];
    }
  }

/// Метод [clear] класса [ErrorReportingService].
///
/// Автор: Цымбал Е. В.
/// Дата: 30.05.2026
  Future<void> clear() async {
    await CacheService.instance.putString(_cacheKey, '[]');
  }
}
