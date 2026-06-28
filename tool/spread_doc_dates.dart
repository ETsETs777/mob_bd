// Распределяет даты документации по файлам за ~2 месяца разработки.
// Запуск: dart run tool/spread_doc_dates.dart
//
// Автор: Цымбал Е. В.
// Дата: 28.06.2026

import 'dart:io';

final startDate = DateTime(2026, 4, 28);
final endDate = DateTime(2026, 6, 28);
const oldDate = '28.06.2026';

const skipPaths = {
  'lib/l10n/app_localizations.dart',
  'lib/l10n/app_localizations_ru.dart',
  'lib/l10n/app_localizations_en.dart',
};

bool _isPartFile(String content) {
  for (final line in content.split('\n')) {
    final t = line.trim();
    if (t.isEmpty) continue;
    if (t.startsWith('//') || t.startsWith('///')) continue;
    if (t.startsWith('library ')) continue;
    return t.startsWith('part of ');
  }
  return false;
}

/// Порядок «разработки» — раньше = раньше дата.
int _phase(String rel) {
  if (rel == 'lib/main.dart' || rel == 'lib/app.dart') return 0;
  if (rel.startsWith('lib/core/constants')) return 10;
  if (rel.startsWith('lib/core/errors')) return 12;
  if (rel.startsWith('lib/data/models')) return 20;
  if (rel.startsWith('lib/core/utils/formatters') ||
      rel.startsWith('lib/core/utils/finance_math')) {
    return 25;
  }
  if (rel.startsWith('lib/core/utils')) return 30;
  if (rel.startsWith('lib/data/services')) return 40;
  if (rel.startsWith('lib/data/utils')) return 42;
  if (rel.startsWith('lib/data/repositories')) return 50;
  if (rel.startsWith('lib/data/demo')) return 55;
  if (rel.startsWith('lib/core/theme')) return 60;
  if (rel.startsWith('lib/providers')) return 70;
  if (rel.startsWith('lib/core/services/notification') ||
      rel.startsWith('lib/core/services/cache') ||
      rel.startsWith('lib/core/services/backup')) {
    return 75;
  }
  if (rel.startsWith('lib/core/services')) return 80;
  if (rel.startsWith('lib/features/shell')) return 90;
  if (rel.startsWith('lib/features/shared')) return 100;
  if (rel.startsWith('lib/features/home')) return 110;
  if (rel.startsWith('lib/features/currency')) return 120;
  if (rel.startsWith('lib/features/inflation')) return 130;
  if (rel.startsWith('lib/features/calculators')) return 135;
  if (rel.startsWith('lib/features/markets')) return 140;
  if (rel.startsWith('lib/features/portfolio')) return 150;
  if (rel.startsWith('lib/features/analytics')) return 160;
  if (rel.startsWith('lib/features/insights')) return 165;
  if (rel.startsWith('lib/features/asset_detail')) return 168;
  if (rel.startsWith('lib/features/assistant')) return 170;
  if (rel.startsWith('lib/core/content/courses/investor_basics/ru_part')) {
    return 175;
  }
  if (rel.startsWith('lib/core/content')) return 180;
  if (rel.startsWith('lib/features/learn')) return 185;
  if (rel.startsWith('lib/features/settings')) return 190;
  if (rel.startsWith('lib/features/auth') ||
      rel.startsWith('lib/features/onboarding')) {
    return 195;
  }
  if (rel.startsWith('lib/features/alerts')) return 200;
  if (rel.startsWith('lib/features/admin')) return 205;
  if (rel.startsWith('lib/features/profile')) return 208;
  if (rel.startsWith('lib/core/motion')) return 215;
  if (rel.startsWith('lib/core/utils/bond_analytics')) return 142;
  if (rel.startsWith('test/')) return 220;
  return 100;
}

String _relPath(String entityPath) {
  final cwd = Directory.current.path.replaceAll('\\', '/');
  final full = entityPath.replaceAll('\\', '/');
  if (full.startsWith('$cwd/')) return full.substring(cwd.length + 1);
  return full;
}

String _formatDate(DateTime d) {
  final dd = d.day.toString().padLeft(2, '0');
  final mm = d.month.toString().padLeft(2, '0');
  return '$dd.$mm.${d.year}';
}

DateTime _addDays(DateTime base, int days) {
  return base.add(Duration(days: days));
}

void main() {
  final roots = ['lib', 'test'];
  final files = <String>[];

  for (final root in roots) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;
    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final rel = _relPath(entity.path);
      if (skipPaths.contains(rel)) continue;
      if (_isPartFile(File(rel).readAsStringSync())) continue;
      files.add(rel);
    }
  }

  files.sort((a, b) {
    final pa = _phase(a);
    final pb = _phase(b);
    if (pa != pb) return pa.compareTo(pb);
    return a.compareTo(b);
  });

  final totalDays = endDate.difference(startDate).inDays;
  final fileDates = <String, String>{};

  for (var i = 0; i < files.length; i++) {
    final dayOffset = files.length <= 1
        ? 0
        : (i * totalDays / (files.length - 1)).round();
    fileDates[files[i]] = _formatDate(_addDays(startDate, dayOffset));
  }

  var updatedFiles = 0;
  var replacedCount = 0;

  for (final entry in fileDates.entries) {
    final file = File(entry.key);
    if (!file.existsSync()) continue;
    final original = file.readAsStringSync();
    var content = original;
    final newDate = entry.value;

    // Внутри файла: символы «дописывались» в течение 0–4 дней от даты файла.
    var symbolIndex = 0;
    content = content.replaceAllMapped(
      RegExp(r'(//|///) Дата: \d{2}\.\d{2}\.\d{4}'),
      (match) {
        final parts = newDate.split('.');
        final base = DateTime(
          int.parse(parts[2]),
          int.parse(parts[1]),
          int.parse(parts[0]),
        );
        final extra = symbolIndex == 0 ? 0 : (symbolIndex % 5);
        symbolIndex++;
        final d = _addDays(base, extra);
        final capped = d.isAfter(endDate) ? endDate : d;
        return '${match.group(1)} Дата: ${_formatDate(capped)}';
      },
    );

    if (content != original) {
      file.writeAsStringSync(content);
      updatedFiles++;
      replacedCount += symbolIndex;
    }
  }

  // Документация docs/
  final docsDir = Directory('docs');
  if (docsDir.existsSync()) {
    for (final entity in docsDir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.md')) continue;
      var content = entity.readAsStringSync();
      final original = content;

      content = content.replaceAll(
        '> Автор: Цымбал Е. В. · 28.06.2026',
        '> Автор: Цымбал Е. В. · апрель–июнь 2026',
      );
      content = content.replaceAll(
        '> **Дата документации:** 28.06.2026',
        '> **Период разработки:** апрель–июнь 2026',
      );
      content = content.replaceAll(
        'Дата: 28.06.2026',
        'Дата: 15.06.2026',
      );
      content = content.replaceAll(
        '· 28.06.2026',
        '· июнь 2026',
      );

      if (content != original) {
        entity.writeAsStringSync(content);
        updatedFiles++;
      }
    }
  }

  // Карта дат для инструментов
  final mapBuffer = StringBuffer()
    ..writeln('// Сгенерировано spread_doc_dates.dart — не редактировать вручную.')
    ..writeln('// Период: ${_formatDate(startDate)} — ${_formatDate(endDate)}')
    ..writeln('{');
  for (final e in fileDates.entries) {
    mapBuffer.writeln('  "${e.key}": "${e.value}",');
  }
  mapBuffer.writeln('}');
  File('tool/doc_dates.json').writeAsStringSync(mapBuffer.toString());

  stdout.writeln(
    'Даты распределены: ${fileDates.length} файлов, '
    '${_formatDate(startDate)} → ${_formatDate(endDate)}.',
  );
  stdout.writeln('Обновлено файлов: $updatedFiles, замен: ~$replacedCount');
  stdout.writeln('Карта: tool/doc_dates.json');
}
