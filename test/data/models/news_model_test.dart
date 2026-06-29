// =============================================================================
// EcoPulse · test/news_model_test.dart
// Автор: Цымбал Е. В.
// Дата: 26.06.2026
// Unit/widget тест: news_model_test.
// =============================================================================

import 'package:ecopulse/data/models/macro_event.dart';
import 'package:ecopulse/data/models/news_item.dart';
import 'package:flutter_test/flutter_test.dart';

/// Функция [main] (top-level).
///
/// Автор: Цымбал Е. В.
/// Дата: 27.06.2026
void main() {
  test('NewsItem fromJson parses finnhub payload', () {
    final item = NewsItem.fromJson({
      'id': 42,
      'headline': 'Markets rally',
      'summary': 'Stocks up',
      'source': 'CNBC',
      'url': 'https://example.com',
      'datetime': 1_700_000_000,
      'image': 'https://img.example/a.png',
    });

    expect(item.id, 42);
    expect(item.headline, 'Markets rally');
    expect(item.imageUrl, 'https://img.example/a.png');
  });

  test('MacroEvent fromJson parses calendar row', () {
    final event = MacroEvent.fromJson({
      'event': 'CPI',
      'country': 'US',
      'date': '2026-06-28',
      'time': '14:30',
      'impact': 'high',
      'estimate': 3.1,
      'prev': 3.0,
      'unit': '%',
    });

    expect(event.event, 'CPI');
    expect(event.country, 'US');
    expect(event.estimate, '3.1');
    expect(event.previous, '3.0');
    expect(event.impact, 'high');
  });
}
