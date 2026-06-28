// =============================================================================
// EcoPulse · lib/core/content/investor_basics_course.dart
// Автор: Цымбал Е. В.
// Дата: 17.06.2026
// Обучающие курсы и маппинг глав. Файл: investor_basics_course.
// =============================================================================

import '../../data/models/course.dart';
import 'courses/investor_basics/ru_all.dart';
import 'courses/investor_basics/en_all.dart';

/// Оригинальный образовательный курс EcoPulse — не копия сторонних материалов.
class InvestorBasicsCourse {
/// Отрисовывает UI [InvestorBasicsCourse].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  static CourseBook build({required bool isRu}) => CourseBook(
        id: 'investor_basics',
        title: isRu ? 'Основы инвестирования' : 'Investing Basics',
        subtitle: isRu
            ? 'Практический курс для начинающих'
            : 'A practical beginner\'s guide',
        description: isRu
            ? '25 глав (~120 страниц) о деньгах, рисках, инструментах, портфеле, макро и практике — без обещаний «быстрого дохода». Только информация, не рекомендация.'
            : '25 chapters (~75 pages) on money, risk, instruments, portfolio, macro and practice — no promises of quick returns. Information only, not advice.',
        chapters: isRu ? investorBasicsRuChapters : investorBasicsEnChapters,
      );
}
