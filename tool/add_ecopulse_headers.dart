// Скрипт добавляет шапки документации во все .dart файлы lib/.
// Запуск: dart run tool/add_ecopulse_headers.dart
//
// Автор: Цымбал Е. В.
// Дата: 28.06.2026

import 'dart:io';

const author = 'Цымбал Е. В.';
const docDate = '28.06.2026';
const marker = 'EcoPulse ·';

final skipFiles = {
  'lib/l10n/app_localizations.dart',
  'lib/l10n/app_localizations_ru.dart',
  'lib/l10n/app_localizations_en.dart',
};

/// Краткие описания для ключевых файлов (остальные — по шаблону папки).
final descriptions = <String, String>{
  'lib/main.dart':
      'Точка входа: инициализация Hive, уведомлений, API-ключей, запуск ProviderScope.',
  'lib/app.dart':
      'Корневой MaterialApp: тема, локаль, фон, home → AppGate.',
  'lib/providers/app_providers.dart':
      'Глобальные Riverpod-провайдеры: валюты, инфляция, рынки, ключевая ставка.',
  'lib/features/shell/main_shell.dart':
      'Shell приложения: 5 табов, AppTabLayer, нижняя навигация, AssistantFab.',
  'lib/features/shell/app_shell_shortcuts.dart':
      'Горячие клавиши web/desktop: цифры 1–5 переключают табы.',
  'lib/features/shell/app_gate.dart':
      'Входной экран: onboarding, биометрия, переход в MainShell.',
  'lib/core/theme/app_tokens.dart':
      'Design tokens: AppSpacing, AppRadii, AppBreakpoints.',
  'lib/core/theme/app_typography.dart':
      'Типографика: tabular figures для котировок (AppTypography.quote).',
  'lib/core/theme/app_theme.dart': 'Светлая/тёмная тема, палитры, Google Fonts.',
  'lib/core/motion/app_motion.dart':
      'Анимации и маршруты: AppPageRoute, Hero, openBondAnalyticsPage.',
  'lib/features/shared/widgets/app_card.dart':
      'Единая карточка Card + InkWell + hover для web.',
  'lib/core/utils/bond_analytics.dart':
      'Расчёты облигаций: кривая ОФЗ, ladder, календарь купонов.',
  'lib/features/markets/markets_screen.dart':
      'Экран «Рынки»: акции, крипто, облигации, watchlist.',
  'lib/features/home/home_screen.dart':
      'Главная: сводка метрик, радар, новости, портфель, курсы.',
};

final folderDescriptions = <String, String>{
  'lib/core/constants': 'Константы и каталоги (API, рынки, облигации).',
  'lib/core/content': 'Обучающие курсы и маппинг глав.',
  'lib/core/motion': 'Анимации, переходы между экранами.',
  'lib/core/services': 'Сервисы: уведомления, backup, assistant, фоновые задачи.',
  'lib/core/theme': 'Design system: тема, токены, палитра.',
  'lib/core/utils': 'Утилиты: форматирование, математика, аналитика.',
  'lib/data/demo': 'Mock-данные для демо-режима без сети.',
  'lib/data/models': 'Модели данных (DTO, immutable классы).',
  'lib/data/repositories': 'Репозитории: загрузка и кэширование из API.',
  'lib/data/services': 'HTTP-клиент (Dio), Hive-кэш.',
  'lib/features/admin': 'Скрытая admin-панель разработчика.',
  'lib/features/analytics': 'Сравнение активов, корреляции.',
  'lib/features/asset_detail': 'Детальная карточка актива с графиком.',
  'lib/features/assistant': 'AI-ассистент: FAB, sheet, голос.',
  'lib/features/calculators': 'Финансовые калькуляторы.',
  'lib/features/currency': 'Вкладка валют: курсы, конвертер, сравнение.',
  'lib/features/home': 'Главный экран и виджеты секций.',
  'lib/features/inflation': 'Инфляция по странам, графики, детали.',
  'lib/features/insights': 'Timeline событий, macro-календарь.',
  'lib/features/learn': 'Курсы и читалка глав.',
  'lib/features/markets': 'Рынки и аналитика облигаций (ОФЗ).',
  'lib/features/portfolio': 'Бумажный портфель, аллокация, P&L.',
  'lib/features/settings': 'Настройки, профиль, backup, layout.',
  'lib/features/shared': 'Общие виджеты и действия приложения.',
  'lib/features/shell': 'Навигация и оболочка приложения.',
  'lib/l10n': 'Локализация RU/EN (ARB-исходники).',
  'lib/providers': 'Riverpod state: провайдеры и notifiers.',
};

String describeFile(String relPath) {
  if (descriptions.containsKey(relPath)) return descriptions[relPath]!;

  if (relPath.startsWith('test/')) {
    final name = relPath.split('/').last.replaceAll('.dart', '');
    return 'Unit/widget тест: $name.';
  }

  final parts = relPath.replaceAll('\\', '/').split('/');
  final fileName = parts.last.replaceAll('.dart', '');

  for (final entry in folderDescriptions.entries) {
    if (relPath.replaceAll('\\', '/').startsWith(entry.key)) {
      return '${entry.value} Файл: $fileName.';
    }
  }

  return 'Модуль EcoPulse. Файл: $fileName.';
}

String buildHeader(String relPath, {required bool isPart}) {
  final desc = describeFile(relPath);
  final pathLine = relPath.replaceAll('\\', '/');
  if (isPart) {
    return '''
// $marker $pathLine
// Автор: $author
// Дата: $docDate
// $desc
''';
  }
  return '''
// =============================================================================
// $marker $pathLine
// Автор: $author
// Дата: $docDate
// $desc
// =============================================================================

''';
}

bool hasHeader(String content) =>
    content.contains(author) || content.contains(marker);

bool isPartFile(String content) =>
    content.trimLeft().startsWith('part of') ||
    content.trimLeft().startsWith("part '");

Future<void> main() async {
  final roots = ['lib', 'test'];
  var added = 0;
  var skipped = 0;
  final index = <String>[];

  for (final root in roots) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;

    await for (final entity in dir.list(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final normalized = entity.path.replaceAll('\\', '/');
      if (skipFiles.contains(normalized)) {
        skipped++;
        continue;
      }

      var content = await entity.readAsString();
      if (hasHeader(content)) {
        skipped++;
        if (root == 'lib') {
          index.add('- `$normalized` — *(шапка уже есть)*');
        }
        continue;
      }

      final part = isPartFile(content);
      final header = buildHeader(normalized, isPart: part);
      await entity.writeAsString('$header$content');
      added++;
      if (root == 'lib') {
        index.add('- `$normalized` — ${describeFile(normalized)}');
      }
    }
  }

  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    stderr.writeln('Запускайте из корня проекта (папка с pubspec.yaml).');
    exit(1);
  }

  final indexFile = File('docs/file-index.md');
  indexFile.parent.createSync(recursive: true);
  await indexFile.writeAsString('''# Индекс файлов lib/

> Автор: $author · $docDate  
> Сгенерировано скриптом \`dart run tool/add_ecopulse_headers.dart\`

Полный список исходников с кратким назначением каждого файла.

${index.join('\n')}

''');

  stdout.writeln('Готово: добавлено $added, пропущено $skipped.');
  stdout.writeln('Индекс: docs/file-index.md');
}
