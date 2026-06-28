// =============================================================================
// EcoPulse · lib/core/content/courses/investor_basics/quizzes.dart
// Автор: Цымбал Е. В.
// Дата: 16.06.2026
// Обучающие курсы и маппинг глав. Файл: quizzes.
// =============================================================================

import '../../../../data/models/course_quiz.dart';

/// Класс [InvestorBasicsQuizzes].
///
/// Автор: Цымбал Е. В.
/// Дата: 17.06.2026
class InvestorBasicsQuizzes {
/// Метод [forLocale] класса [InvestorBasicsQuizzes].
///
/// Автор: Цымбал Е. В.
/// Дата: 18.06.2026
  static List<CoursePartQuiz> forLocale({required bool isRu}) =>
      isRu ? _ru : _en;

/// Метод [byPartId] класса [InvestorBasicsQuizzes].
///
/// Автор: Цымбал Е. В.
/// Дата: 19.06.2026
  static CoursePartQuiz? byPartId(String id, {required bool isRu}) {
    for (final q in forLocale(isRu: isRu)) {
      if (q.id == id) return q;
    }
    return null;
  }

/// Поле [_ru] класса [InvestorBasicsQuizzes].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  static const _ru = [
    CoursePartQuiz(
      id: 'part1',
      title: 'Часть I — Основы',
      questions: [
        CourseQuizQuestion(
          question: 'Зачем вообще инвестировать, если есть депозит?',
          options: [
            CourseQuizOption(
              text: 'Чтобы опережать инфляцию на длинном горизонте',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Чтобы гарантированно заработать 30% в месяц',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Только если уже нет финансовой подушки',
              isCorrect: false,
            ),
          ],
          explanation:
              'Депозит часто не покрывает инфляцию полностью; инвестиции — попытка сохранить покупательную способность с осознанным риском.',
        ),
        CourseQuizQuestion(
          question: 'Сколько месяцев расходов обычно кладут в подушку?',
          options: [
            CourseQuizOption(text: '3–6 месяцев', isCorrect: true),
            CourseQuizOption(text: '1 неделя', isCorrect: false),
            CourseQuizOption(text: '10–15 лет', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'Что вернее про риск и доходность?',
          options: [
            CourseQuizOption(
              text: 'Больше потенциальная доходность — больше неопределённость',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Риск можно полностью убрать диверсификацией',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Акции никогда не падают больше чем на 5%',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Сложный процент — это когда…',
          options: [
            CourseQuizOption(
              text: 'Доход начинает начисляться на уже накопленный доход',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Банк начисляет штраф за просрочку',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Инфляция ускоряется каждый квартал',
              isCorrect: false,
            ),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part2',
      title: 'Часть II — Инструменты',
      questions: [
        CourseQuizQuestion(
          question: 'Акция — это…',
          options: [
            CourseQuizOption(
              text: 'Доля в компании',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Займ государству с фиксированным купоном',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Страховой полис',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Облигация для инвестора — это…',
          options: [
            CourseQuizOption(
              text: 'Долг эмитенту под купон и возврат номинала',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Право голоса на собрании акционеров',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Валютный форвард',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'ETF удобен тем, что…',
          options: [
            CourseQuizOption(
              text: 'Даёт корзину активов одной сделкой',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Гарантирует доход выше инфляции',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Не торгуется на бирже',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'ОФЗ — это облигации…',
          options: [
            CourseQuizOption(text: 'Российской Федерации', isCorrect: true),
            CourseQuizOption(text: 'Отдельной IT-компании', isCorrect: false),
            CourseQuizOption(text: 'Биржевого индекса', isCorrect: false),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part3',
      title: 'Часть III — Портфель',
      questions: [
        CourseQuizQuestion(
          question: 'Диверсификация нужна, чтобы…',
          options: [
            CourseQuizOption(
              text: 'Снизить зависимость от одного актива',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Убрать просадки полностью',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Увеличить число сделок',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Высокая корреляция двух активов означает…',
          options: [
            CourseQuizOption(
              text: 'Они часто движутся в одном направлении',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Один всегда растёт, другой падает',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Они не связаны с рынком',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Ребалансировка — это…',
          options: [
            CourseQuizOption(
              text: 'Возврат долей активов к целевым весам',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Продажа всего портфеля раз в день',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Покупка только одного тикера',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Бумажный портфель в EcoPulse нужен для…',
          options: [
            CourseQuizOption(
              text: 'Тренировки без риска реальных денег',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Получения дивидендов на карту',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Обхода налогов',
              isCorrect: false,
            ),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part4',
      title: 'Часть IV — Рынки и макро',
      questions: [
        CourseQuizQuestion(
          question: 'Инфляция — это…',
          options: [
            CourseQuizOption(
              text: 'Рост общего уровня цен',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Падение ключевой ставки',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Рост котировок одной акции',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Ключевая ставка ЦБ влияет на…',
          options: [
            CourseQuizOption(
              text: 'Стоимость кредитов и депозитов',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Только цену золота',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Погоду в Москве',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Fear & Greed Index отражает…',
          options: [
            CourseQuizOption(
              text: 'Настроение крипторынка',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Официальный прогноз ЦБ',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Налоговую ставку',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Рынок в фазе «медведя» — это когда…',
          options: [
            CourseQuizOption(
              text: 'Преобладает длительное снижение котировок',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Все акции только растут',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Биржа закрыта на каникулы',
              isCorrect: false,
            ),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part5',
      title: 'Часть V — Практика',
      questions: [
        CourseQuizQuestion(
          question: 'FOMO в инвестициях — это…',
          options: [
            CourseQuizOption(
              text: 'Страх упустить рост и покупка «на хаях»',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Стратегия долгосрочного ETF',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Налоговая льгота',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: '«Гарантированные 20% в месяц» — это…',
          options: [
            CourseQuizOption(
              text: 'Признак мошенничества',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Норма для ОФЗ',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Стандартная доходность индекса',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'EcoPulse Assistant может без Gemini…',
          options: [
            CourseQuizOption(
              text: 'Ответить про курс USD/RUB и сводку',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Открыть брокерский счёт',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Гарантировать прибыль',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Перед реальными сделками разумно…',
          options: [
            CourseQuizOption(
              text: 'Иметь подушку, план и понимание рисков',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'Вложить все сбережения в один тикер',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Игнорировать комиссии брокера',
              isCorrect: false,
            ),
          ],
        ),
      ],
    ),
  ];

/// Поле [_en] класса [InvestorBasicsQuizzes].
///
/// Автор: Цымбал Е. В.
/// Дата: 16.06.2026
  static const _en = [
    CoursePartQuiz(
      id: 'part1',
      title: 'Part I — Basics',
      questions: [
        CourseQuizQuestion(
          question: 'Why invest if deposits exist?',
          options: [
            CourseQuizOption(
              text: 'To outpace inflation over the long term',
              isCorrect: true,
            ),
            CourseQuizOption(
              text: 'To guarantee 30% monthly returns',
              isCorrect: false,
            ),
            CourseQuizOption(
              text: 'Only when you have no emergency fund',
              isCorrect: false,
            ),
          ],
        ),
        CourseQuizQuestion(
          question: 'Emergency fund size is usually…',
          options: [
            CourseQuizOption(text: '3–6 months of expenses', isCorrect: true),
            CourseQuizOption(text: '1 week', isCorrect: false),
            CourseQuizOption(text: '15 years', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'Risk and return are related: higher return usually means…',
          options: [
            CourseQuizOption(text: 'More uncertainty', isCorrect: true),
            CourseQuizOption(text: 'Zero volatility', isCorrect: false),
            CourseQuizOption(text: 'Government guarantee', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'Compound interest means…',
          options: [
            CourseQuizOption(
              text: 'Earnings generate further earnings',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Bank penalty fees', isCorrect: false),
            CourseQuizOption(text: 'Faster inflation only', isCorrect: false),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part2',
      title: 'Part II — Instruments',
      questions: [
        CourseQuizQuestion(
          question: 'A stock represents…',
          options: [
            CourseQuizOption(text: 'Ownership in a company', isCorrect: true),
            CourseQuizOption(text: 'A government loan', isCorrect: false),
            CourseQuizOption(text: 'Insurance policy', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'A bond is…',
          options: [
            CourseQuizOption(
              text: 'Debt to an issuer with coupons',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Voting rights only', isCorrect: false),
            CourseQuizOption(text: 'Currency forward', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'ETFs are useful because…',
          options: [
            CourseQuizOption(
              text: 'One trade buys a basket',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'They guarantee alpha', isCorrect: false),
            CourseQuizOption(text: 'They never trade on exchange', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'OFZ bonds are issued by…',
          options: [
            CourseQuizOption(text: 'Russian Federation', isCorrect: true),
            CourseQuizOption(text: 'A single tech firm', isCorrect: false),
            CourseQuizOption(text: 'A stock index', isCorrect: false),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part3',
      title: 'Part III — Portfolio',
      questions: [
        CourseQuizQuestion(
          question: 'Diversification helps…',
          options: [
            CourseQuizOption(
              text: 'Reduce reliance on one asset',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Eliminate all drawdowns', isCorrect: false),
            CourseQuizOption(text: 'Maximize trading fees', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'High correlation means assets…',
          options: [
            CourseQuizOption(
              text: 'Often move together',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Always move opposite', isCorrect: false),
            CourseQuizOption(text: 'Ignore the market', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'Rebalancing means…',
          options: [
            CourseQuizOption(
              text: 'Resetting weights to targets',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Selling everything daily', isCorrect: false),
            CourseQuizOption(text: 'One-ticker only', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'EcoPulse paper portfolio is for…',
          options: [
            CourseQuizOption(
              text: 'Practice without real money',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Receiving dividends to card', isCorrect: false),
            CourseQuizOption(text: 'Tax evasion', isCorrect: false),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part4',
      title: 'Part IV — Markets & macro',
      questions: [
        CourseQuizQuestion(
          question: 'Inflation is…',
          options: [
            CourseQuizOption(text: 'Rise in general price level', isCorrect: true),
            CourseQuizOption(text: 'Key rate cut only', isCorrect: false),
            CourseQuizOption(text: 'One stock rally', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'Central bank key rate affects…',
          options: [
            CourseQuizOption(
              text: 'Loan and deposit rates',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Only gold price', isCorrect: false),
            CourseQuizOption(text: 'Weather', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'Fear & Greed Index measures…',
          options: [
            CourseQuizOption(text: 'Crypto market sentiment', isCorrect: true),
            CourseQuizOption(text: 'Official CBR forecast', isCorrect: false),
            CourseQuizOption(text: 'VAT rate', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'A bear market phase is…',
          options: [
            CourseQuizOption(
              text: 'Extended broad decline',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Only rising prices', isCorrect: false),
            CourseQuizOption(text: 'Exchange holiday', isCorrect: false),
          ],
        ),
      ],
    ),
    CoursePartQuiz(
      id: 'part5',
      title: 'Part V — Practice',
      questions: [
        CourseQuizQuestion(
          question: 'FOMO means…',
          options: [
            CourseQuizOption(
              text: 'Buying after a big rally from fear of missing out',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Long-term ETF plan', isCorrect: false),
            CourseQuizOption(text: 'Tax credit', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: '“Guaranteed 20% per month” is…',
          options: [
            CourseQuizOption(text: 'A fraud red flag', isCorrect: true),
            CourseQuizOption(text: 'Normal for OFZ', isCorrect: false),
            CourseQuizOption(text: 'Index average', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'EcoPulse Assistant offline can…',
          options: [
            CourseQuizOption(
              text: 'Answer USD/RUB and brief queries',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'Open brokerage account', isCorrect: false),
            CourseQuizOption(text: 'Promise profit', isCorrect: false),
          ],
        ),
        CourseQuizQuestion(
          question: 'Before real trades you should…',
          options: [
            CourseQuizOption(
              text: 'Have cushion, plan and risk awareness',
              isCorrect: true,
            ),
            CourseQuizOption(text: 'All-in one ticker', isCorrect: false),
            CourseQuizOption(text: 'Ignore broker fees', isCorrect: false),
          ],
        ),
      ],
    ),
  ];
}
