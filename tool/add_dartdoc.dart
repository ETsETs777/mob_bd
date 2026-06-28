// Скрипт добавляет dartdoc (///) ко всем символам в lib/ и test/.
// Запуск: dart run tool/add_dartdoc.dart [--check]
//
// Автор: Цымбал Е. В.
// Дата: 28.06.2026

import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer/source/line_info.dart';

const author = 'Цымбал Е. В.';
const docDate = '28.06.2026';

const skipPaths = {
  'lib/l10n/app_localizations.dart',
  'lib/l10n/app_localizations_ru.dart',
  'lib/l10n/app_localizations_en.dart',
};

const skipMethodNames = {
  'toString',
  'hashCode',
  'noSuchMethod',
  'operator==',
  'runtimeType',
};

void main(List<String> args) {
  final checkOnly = args.contains('--check');
  final verbose = args.contains('--verbose');
  final roots = ['lib', 'test'];
  final pending = <_DocTarget>[];
  final coverage = <String, _Coverage>{};
  final missingLabels = <String>[];

  for (final root in roots) {
    final dir = Directory(root);
    if (!dir.existsSync()) continue;

    for (final entity in dir.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final rel = _relPath(entity.path);
      if (skipPaths.contains(rel)) continue;

      final content = entity.readAsStringSync();
      if (_isPartFile(content)) continue;

      final result = parseString(content: content, path: rel);
      final unit = result.unit;
      final lineInfo = result.lineInfo;
      final visitor = _DocCollector(rel, content, lineInfo);
      unit.accept(visitor);
      pending.addAll(visitor.targets);
      if (verbose && visitor.targets.isNotEmpty) {
        for (final t in visitor.targets) {
          missingLabels.add('${t.filePath}:${t.line} ${t.label}');
        }
      }

      final folder = _folderKey(rel);
      coverage.putIfAbsent(folder, _Coverage.new);
      coverage[folder]!.total += visitor.totalSymbols;
      coverage[folder]!.documented += visitor.alreadyDocumented;
    }
  }

  if (checkOnly) {
    final missing = pending.length;
    _writeCoverageReport(coverage, missing);
    if (missing > 0) {
      stderr.writeln('Не задокументировано символов: $missing');
      if (verbose) {
        for (final l in missingLabels) {
          stderr.writeln('  $l');
        }
      }
      exit(1);
    }
    stdout.writeln('Dartdoc покрытие: 100%');
    exit(0);
  }

  final byFile = <String, List<_DocTarget>>{};
  for (final t in pending) {
    byFile.putIfAbsent(t.filePath, () => []).add(t);
  }

  var added = 0;
  for (final entry in byFile.entries) {
    final filePath = _normalizePath('${Directory.current.path}/${entry.key}');
    added += _applyDocs(filePath, entry.value);
  }

  _writeCoverageReport(coverage, 0);
  stdout.writeln('Готово: добавлено $added dartdoc-блоков в ${byFile.length} файлов.');
}

String _normalizePath(String p) => p.replaceAll('\\', '/');

String _relPath(String entityPath) {
  final cwd = _normalizePath(Directory.current.path);
  final full = _normalizePath(entityPath);
  if (full.startsWith('$cwd/')) return full.substring(cwd.length + 1);
  return full;
}

String _folderKey(String rel) {
  final parts = rel.split('/');
  if (parts.length >= 3) return '${parts[0]}/${parts[1]}';
  if (parts.length == 2) return parts[0];
  return parts.first;
}

class _Coverage {
  int total = 0;
  int documented = 0;

  double get percent =>
      total == 0 ? 100 : (documented / total) * 100;
}

class _DocTarget {
  _DocTarget({
    required this.filePath,
    required this.line,
    required this.lines,
    required this.label,
  });

  final String filePath;
  final int line; // 1-based insert before this line
  final List<String> lines;
  final String label;
}

class _DocCollector extends RecursiveAstVisitor<void> {
  _DocCollector(this.filePath, this.content, this.lineInfo);

  final String filePath;
  final String content;
  final LineInfo lineInfo;
  final List<_DocTarget> targets = [];
  int alreadyDocumented = 0;
  int totalSymbols = 0;

  @override
  void visitCompilationUnit(CompilationUnit node) {
    for (final decl in node.declarations) {
      _visitDeclaration(decl);
    }
  }

  void _visitDeclaration(Declaration node) {
    if (node is ClassDeclaration) {
      _maybeAdd(node, _describeClass(node.name.lexeme, node));
      for (final member in node.members) {
        _visitClassMember(member, node.name.lexeme);
      }
    } else if (node is EnumDeclaration) {
      final values = node.constants.map((c) => c.name.lexeme).join(', ');
      _maybeAdd(node, 'Enum [${node.name.lexeme}]: $values.');
      if (_enumConstantsMultiline(node)) {
        for (final constant in node.constants) {
          _maybeAdd(constant, _describeEnumValue(constant.name.lexeme));
        }
      }
    } else if (node is MixinDeclaration) {
      _maybeAdd(node, 'Mixin [${node.name.lexeme}].');
    } else if (node is ExtensionDeclaration) {
      final extName = node.name?.lexeme ?? 'unnamed';
      _maybeAdd(node, 'Extension [$extName].');
    } else if (node is FunctionDeclaration) {
      _maybeAdd(node, _describeFunction(node.name.lexeme, topLevel: true));
    } else if (node is TopLevelVariableDeclaration) {
      for (final v in node.variables.variables) {
        _maybeAdd(node, _describeTopLevelVar(v.name.lexeme));
      }
    } else if (node is GenericTypeAlias) {
      _maybeAdd(node, 'Typedef [${node.name.lexeme}].');
    }
  }

  void _visitClassMember(Declaration member, String className) {
    if (member is ConstructorDeclaration) {
      final name = member.name?.lexeme ?? className;
      _maybeAdd(member, 'Создаёт [$className]${name != className ? ' ($name)' : ''}.');
    } else if (member is MethodDeclaration) {
      if (skipMethodNames.contains(member.name.lexeme)) return;
      if (member.isGetter) {
        _maybeAdd(member, 'Getter [${member.name.lexeme}] класса [$className].');
        return;
      }
      if (member.isSetter) {
        _maybeAdd(member, 'Setter [${member.name.lexeme}] класса [$className].');
        return;
      }
      _maybeAdd(member, _describeMethod(member.name.lexeme, className));
    } else if (member is FieldDeclaration) {
      for (final v in member.fields.variables) {
        _maybeAdd(member, _describeField(v.name.lexeme, className));
      }
    }
  }

  void _maybeAdd(AstNode node, String summary) {
    totalSymbols++;
    if (_hasDoc(node)) {
      alreadyDocumented++;
      return;
    }
    final insertLine = _insertLine(node);
    targets.add(
      _DocTarget(
        filePath: filePath,
        line: insertLine,
        lines: _formatDoc(summary),
        label: summary,
      ),
    );
  }

  bool _hasDoc(AstNode node) {
    if (node is AnnotatedNode && node.documentationComment != null) {
      return true;
    }
    if (node is Declaration && node.documentationComment != null) {
      return true;
    }
    return false;
  }

  int _insertLine(AstNode node) {
    if (node is AnnotatedNode && node.metadata.isNotEmpty) {
      return lineInfo.getLocation(node.metadata.first.offset).lineNumber;
    }
    return lineInfo.getLocation(node.offset).lineNumber;
  }

  List<String> _formatDoc(String summary) {
    final trimmed = summary.trim();
    if (trimmed.contains('\n')) {
      final parts = trimmed.split('\n').map((l) => '/// $l').toList();
      parts.add('///');
      parts.add('/// Автор: $author');
      parts.add('/// Дата: $docDate');
      return parts;
    }
    return [
      '/// $trimmed',
      '///',
      '/// Автор: $author',
      '/// Дата: $docDate',
    ];
  }

  String _describeClass(String name, ClassDeclaration node) {
    if (name.startsWith('_')) {
      return 'Приватный класс [$name]${_widgetHint(name)}.';
    }
    if (_extendsStateless(node)) {
      return 'StatelessWidget [$name] — UI-компонент EcoPulse.';
    }
    if (_extendsStateful(node)) {
      return 'StatefulWidget [$name] — экран или виджет с локальным state.';
    }
    if (name.endsWith('Notifier')) {
      return 'Riverpod AsyncNotifier [$name] — загрузка и кэш state.';
    }
    if (name.endsWith('Repository')) {
      return 'Репозиторий [$name] — API и Hive-кэш.';
    }
    if (name.endsWith('Service')) {
      return 'Сервис [$name] — фоновая или системная логика.';
    }
    if (name.endsWith('Provider')) {
      return 'Провайдер/обёртка [$name].';
    }
    return 'Класс [$name].';
  }

  bool _extendsStateless(ClassDeclaration node) {
    return node.extendsClause?.superclass.name2.lexeme == 'StatelessWidget';
  }

  bool _extendsStateful(ClassDeclaration node) {
    return node.extendsClause?.superclass.name2.lexeme == 'StatefulWidget';
  }

  String _widgetHint(String name) {
    if (name.contains('Tile')) return ' — плитка списка';
    if (name.contains('Card')) return ' — карточка секции';
    if (name.contains('Sheet')) return ' — bottom sheet';
    if (name.contains('Screen') || name.contains('State')) {
      return ' — экран/state';
    }
    return '';
  }

  String _describeEnum(String name) => 'Enum [$name] — перечисление значений.';

  String _describeEnumValue(String name) =>
      'Значение enum [$name].';

  String _describeFunction(String name, {required bool topLevel}) {
    if (name.startsWith('_')) {
      return 'Приватная функция [$name].';
    }
    if (name.startsWith('build')) {
      return 'Функция [$name] — построение данных или UI.';
    }
    return 'Функция [$name]${topLevel ? ' (top-level)' : ''}.';
  }

  String _describeTopLevelVar(String name) {
    if (name.endsWith('Provider')) {
      return _describeProvider(name);
    }
    return 'Top-level переменная [$name].';
  }

  String _describeProvider(String name) {
    const known = {
      'currencyRatesProvider': 'Riverpod: курсы валют (Frankfurter + MOEX).',
      'inflationProvider': 'Riverpod: инфляция CPI по странам (World Bank).',
      'keyRateProvider': 'Riverpod: ключевая ставка ЦБ РФ.',
      'navigationIndexProvider': 'Riverpod: индекс активного таба shell (0–4).',
      'demoModeProvider': 'Riverpod: демо-режим с mock-данными.',
      'watchlistProvider': 'Riverpod: избранные активы watchlist.',
      'localeProvider': 'Riverpod: локаль RU/EN.',
      'themeProvider': 'Riverpod: тема light/dark/system.',
    };
    return known[name] ?? 'Riverpod-провайдер [$name].';
  }

  String _describeMethod(String name, String className) {
    switch (name) {
      case 'build':
        return 'Отрисовывает UI [$className].';
      case 'refresh':
        return 'Перезагружает данные [$className] с API/кэша.';
      case 'initState':
        return 'Инициализация state [$className].';
      case 'dispose':
        return 'Освобождает ресурсы [$className].';
      case 'createState':
        return 'Создаёт State для [$className].';
    }
    if (name.startsWith('_')) {
      return 'Приватный метод [$name] класса [$className].';
    }
    return 'Метод [$name] класса [$className].';
  }

  String _describeField(String name, String className) {
    return 'Поле [$name] класса [$className].';
  }

  bool _enumConstantsMultiline(EnumDeclaration node) {
    if (node.constants.length <= 1) return true;
    final lines = node.constants
        .map((c) => lineInfo.getLocation(c.offset).lineNumber)
        .toSet();
    return lines.length > 1;
  }
}

int _applyDocs(String filePath, List<_DocTarget> targets) {
  if (targets.isEmpty) return 0;

  final file = File(filePath);
  final lines = file.readAsLinesSync();
  targets.sort((a, b) => b.line.compareTo(a.line));

  var added = 0;
  for (final t in targets) {
    final idx = t.line - 1;
    if (idx < 0 || idx > lines.length) continue;
    lines.insertAll(idx, t.lines);
    added++;
  }

  file.writeAsStringSync('${lines.join('\n')}\n');
  return added;
}

void _writeCoverageReport(Map<String, _Coverage> coverage, int missing) {
  final buffer = StringBuffer()
    ..writeln('# Dartdoc coverage')
    ..writeln()
    ..writeln('> Автор: $author · $docDate')
    ..writeln('> Сгенерировано: `dart run tool/add_dartdoc.dart`')
    ..writeln()
    ..writeln('| Папка | С doc | Без doc | % |')
    ..writeln('|-------|-------|---------|---|');

  var totalDoc = 0;
  var totalAll = 0;
  for (final entry in coverage.entries.toList()..sort((a, b) => a.key.compareTo(b.key))) {
    final c = entry.value;
    totalDoc += c.documented;
    totalAll += c.total;
    final pending = c.total - c.documented;
    buffer.writeln(
      '| `${entry.key}` | ${c.documented} | $pending | ${c.percent.toStringAsFixed(1)}% |',
    );
  }

  buffer
    ..writeln()
    ..writeln('**Всего символов:** $totalAll')
    ..writeln('**С dartdoc:** $totalDoc')
    ..writeln('**Без doc (последний --check):** $missing')
    ..writeln()
    ..writeln('Проверка: `dart run tool/add_dartdoc.dart --check`');

  File('docs/dartdoc-coverage.md').writeAsStringSync(buffer.toString());
}
