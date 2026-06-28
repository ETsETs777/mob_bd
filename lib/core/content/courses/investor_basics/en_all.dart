// =============================================================================
// EcoPulse · lib/core/content/courses/investor_basics/en_all.dart
// Автор: Цымбал Е. В.
// Дата: 16.06.2026
// Обучающие курсы и маппинг глав. Файл: en_all.
// =============================================================================

import '../../../../data/models/course.dart';

List<CourseChapter> get investorBasicsEnChapters => [
      CourseChapter(
        id: 'ch1',
        title: 'Chapter 1. Why Invest',
        summary: 'Inflation, goals, and conscious risk',
        partTitle: 'Part I. Basics',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Money loses purchasing power',
            body:
                'If you keep 100,000 ₽ under a mattress or in a non-interest account, five to ten years later that sum buys noticeably fewer goods and services. That is inflation — a gradual rise in the general price level. Even modest inflation of 5–7% per year erodes part of your savings. The central bank key rate shown on EcoPulse\'s home screen reflects how the regulator fights inflation and what conservative instruments like deposits and OFZ bonds may offer.\n\n'
                'Investing is not a way to get rich in a week. It is an attempt to preserve and grow capital faster than inflation erodes it, while accepting conscious risk. This is a long process: results are measured in years, not days. Without understanding why you invest, it is easy to abandon a strategy at the first drawdown or, conversely, take excessive risk chasing quick profit.\n\n'
                'Compare savings yield to inflation monthly using EcoPulse.',
          ),
          CourseSection(
            heading: 'Investments vs savings',
            body:
                'Savings are money you may need soon or that does not require growth: an emergency fund, a down payment due in six months, car repairs. They should be liquid and reliable. Investments are capital you deliberately set aside for the future over several years: retirement, children\'s education, a major purchase in ten years.\n\n'
                'The line is not rigid: a savings account with interest is a low-risk form of saving. A stock portfolio held for twenty years is an investment with high volatility. A common beginner mistake is mixing these roles — keeping emergency money in volatile assets or leaving everything in deposits that lag inflation for life. EcoPulse helps track both layers: a paper portfolio for practice and quotes to see how different asset classes behave.\n\n'
                'Three buckets — spending, reserve, long capital — keep roles separate in practice.',
          ),
          CourseSection(
            heading: 'Who can invest',
            body:
                'Formally, any adult with ID and a brokerage account. Practically, someone with an emergency fund, no toxic debt at 25–40% annual interest, and an understanding that markets can fall for months. You do not need a large starting amount: many brokers allow buying fractional ETF shares or stocks from a few thousand rubles.\n\n'
                'Consistency matters more than a one-time lump sum. 5,000 ₽ per month over ten years at moderate returns can beat a one-time 200,000 ₽ invested on a whim and forgotten. Investing is a skill of discipline and learning, not a lottery. This course provides a foundation; decisions about specific securities remain yours or a licensed advisor\'s.\n\n'
                'Small regular contributions beat waiting for the perfect lump sum every time.',
          ),
          CourseSection(
            heading: 'Realistic expectations',
            body:
                'Markets are not obliged to rise every year. Drawdowns of 20–40% happen even in large blue-chip stocks. Promises of stable 30% per month are a red flag for fraud, not investing. Historically, broad stock indices have outpaced inflation over long periods, but the past does not guarantee the future: there have been decades with zero or negative real returns.\n\n'
                'A healthy goal for a long-term portfolio is to beat inflation by a few percentage points per year while accepting drawdowns. For the conservative slice, preserve nominal value and receive predictable coupon income. EcoPulse does not promise returns: the app shows data, news, and learning tools, not personal recommendations.\n\n'
                'Journal expectations on calm days; read them when headlines get loud.',
          ),
          CourseSection(
            heading: 'Information is not investment advice',
            body:
                'EcoPulse is an educational and analytical platform: currency rates, MOEX indices, crypto quotes, the daily economic brief, the correlation screen, and the paper portfolio. All of this helps you observe the market and practice without risking real money. No chapter of this course and no app screen replaces individual consultation accounting for your income, debts, family, and tax status.\n\n'
                'Before your first real trade, write down: goal, horizon, acceptable drawdown, target asset weights. That makes it easier to resist emotions when news moves fast. If unsure, start with EcoPulse\'s paper portfolio for a few months — a free sandbox where mistakes cost no rubles but teach discipline.\n\n'
                'Verify broker licenses; EcoPulse educates — it never asks for your passwords.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch2',
        title: 'Chapter 2. Emergency Fund',
        summary: 'Reserve, budget, and debt order',
        partTitle: 'Part I. Basics',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Why you need a cushion',
            body:
                'An emergency fund covers three to six months of essential expenses: rent or mortgage, food, utilities, loan payments, phone, medicine. It is not for growth but for peace of mind: job loss, illness, or a broken car should not force you to sell stocks at the bottom or take a payday loan at 1% per day.\n\n'
                'Without a cushion, any investment strategy is fragile. The market drops 25% and you urgently need living expenses — you lock in a loss. With a reserve, you ride out the drawdown without touching the portfolio. Size is personal: a freelancer with irregular income needs a larger cushion than a civil servant in a two-income household.\n\n'
                'Size the cushion in rubles from statements, not rough guesses.',
          ),
          CourseSection(
            heading: 'Where to keep the reserve',
            body:
                'The cushion should be liquid and reliable. A bank savings account, a deposit with partial withdrawal without penalty, or sometimes short-term OFZ with a clear maturity date work well. Stocks, crypto, and structured products with long lock-ups do not: in a crisis they may fall in price and be unavailable for withdrawal.\n\n'
                'Deposit rates often track the central bank key rate — you can follow it in EcoPulse and compare with inflation. If a deposit yields 8% while prices rise 7%, real gain is modest, but for an emergency fund accessibility matters more than maximum yield. Do not chase super rates at questionable institutions: keep reserves only in systemically important banks or instruments with clear risk.\n\n'
                'Review reserve size when life changes; liquidity beats maximum yield for this bucket.',
          ),
          CourseSection(
            heading: 'Budget and the 50/30/20 rule',
            body:
                'A simple income framework helps find money for cushion and investments:\n'
                '• 50% — needs (housing, food, transport, mandatory payments)\n'
                '• 30% — wants (leisure, hobbies, subscriptions)\n'
                '• 20% — savings and investments\n\n'
                'Ratios are flexible: in an expensive city needs may take 60%, then savings might be 10%, but regularity beats perfect percentages. Even 5–10% of income set aside monthly eventually builds both cushion and starter capital. Track spending for two or three months — leaks often appear immediately: unused subscriptions, impulse buys.\n\n\n\n'
                'If 50/30/20 does not fit, pay yourself first: move a fixed sum to savings at month start. Even 3,000 ₽ monthly builds habit and reserve within a year. Calendar a funding day and a short budget review — rituals beat one burst of enthusiasm. Then spend two minutes on EcoPulse for market context, not impulse trades.',
          ),
          CourseSection(
            heading: 'Debts before investing',
            body:
                'High-interest debt — credit cards at 25–40%, consumer loans, microloans — often eats any return from stocks or ETFs. Sensible order: first close or restructure such obligations, then build the cushion, then grow the risky part of the portfolio.\n\n'
                'A mortgage at 8–10% is a separate case: sometimes early repayment gives guaranteed return comparable to conservative investments. Compare the loan rate with expected portfolio return after taxes and fees. EcoPulse does not track your loans, but understanding net financial position is the foundation of any strategy. Investing in stocks while carrying a card at 36% is mathematically a losing idea.\n\n'
                'List debts with rate, balance, and payment. Extra payments on the highest rate are often the best risk-free return. While a thirty-percent card remains open, aggressive stocks are a lottery on bad math. Net position matters more than a pretty portfolio chart.',
          ),
          CourseSection(
            heading: 'When the cushion is ready',
            body:
                'Signs of readiness: three to six months of expenses in liquid form, you are not waking up worried about layoffs, and there is no urgent expensive debt. Then you can direct surplus to an investment account — gradually, without going all-in on one stock.\n\n'
                'Do not invest the cushion for growth: if the reserve grows to eight months of expenses, surplus can be reallocated, but keep the base minimum. Review cushion size when you change jobs, have a child, or take a mortgage. EcoPulse\'s paper portfolio can be topped up freely — it does not replace the reserve but trains skills while you build a real one.\n\n'
                'When the cushion is ready, invest surplus gradually with a written rule.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch3',
        title: 'Chapter 3. Risk and Return',
        summary: 'The trade-off you cannot avoid',
        partTitle: 'Part I. Basics',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'No return without risk',
            body:
                'The higher the potential return, the greater the uncertainty. Bank deposits and OFZ are relatively predictable but may not beat inflation. Large-company stocks can rise for decades yet fall 30–50% in single years. Crypto swings even more — EcoPulse\'s Fear & Greed index shows that market\'s mood from extreme fear to extreme greed.\n\n'
                'Guaranteed high return without explained risk is a sign of fraud, not investing. A healthy question for any instrument: what can I lose in a reasonable worst case, and am I ready psychologically and financially?\n\n'
                'Build a ladder: deposits and OFZ first, then stocks, then high-volatility assets with smaller weight each step. Before buying, ask where income comes from and what can go wrong. Fear and Greed in EcoPulse reminds you emotions run hot in crypto.',
          ),
          CourseSection(
            heading: 'Volatility and drawdowns',
            body:
                'Volatility is the amplitude of price swings. A daily move of +2% or −3% in one stock is normal, not a crash or rocket. Drawdown is the fall from a recent peak: a portfolio was 500,000 ₽, now 380,000 ₽ — a 24% drawdown.\n\n'
                'Beginners often panic at the first drawdown and sell at a loss. Experienced investors decide in advance the maximum portfolio loss they can tolerate without changing strategy. If −30% would keep you awake, your stock weight is too high. Watch dynamics in EcoPulse but do not react to every tick: for a long horizon, portfolio structure matters more than daily noise.\n\n'
                'Write your max drawdown before the market tests it for real.',
          ),
          CourseSection(
            heading: 'Systematic vs idiosyncratic risk',
            body:
                'Systematic risk hits the whole market: 2008 crisis, 2020 pandemic, a sharp key rate hike. One perfect stock will not save you — almost everything falls. Idiosyncratic risk is tied to one company: scandal, issuer bankruptcy, a bad report.\n\n'
                'Diversification reduces idiosyncratic risk: one issuer\'s fall hurts a slice of the portfolio, not all your money. Systematic risk remains — soften it with bonds, cash, and different asset classes. EcoPulse\'s correlation screen shows how closely your positions move together: if everything rises and falls in sync, protection is limited.\n\n'
                'Add assets that react differently to the same news — bonds, currency, and index funds, not ten stocks in one sector. One favorite name can hurt disproportionately. EcoPulse\'s correlation screen shows whether positions move as one. Diversification limits fatal single bets.',
          ),
          CourseSection(
            heading: 'Investor risk profile',
            body:
                'Three factors shape how much risk feels comfortable:\n'
                '• Horizon — longer means more time to survive drawdowns\n'
                '• Emergency fund — larger means more calm in volatile markets\n'
                '• Temperament — some cannot tolerate −15% even with a 20-year horizon\n\n'
                'Profiles are often labeled conservative, moderate, or aggressive. They are not permanent labels: with age and as goals approach (home purchase in three years), many shift conservative. EcoPulse does not assign a profile for you — honest answers to the questions above matter more than any online quiz.\n\n\n\n'
                'Ask honestly: is missing a rally or losing 20% worse? Youth and long horizon do not require aggression if you are anxious. Start moderate and raise stock weight as paper-portfolio experience grows. EcoPulse does not assign a profile — you choose targets and test them in calm and stressful weeks.',
          ),
          CourseSection(
            heading: 'How to measure return',
            body:
                'Look at return after fees and taxes, in real terms — net of inflation. +10% nominally with 8% inflation is only +2% real. Compare your portfolio to a suitable benchmark: IMOEX for Russian stocks, S&P 500 for the US, not a friend\'s chat success story.\n\n'
                'Short-term results (a week, a month) say little about strategy quality. Evaluate a year or longer. EcoPulse\'s paper portfolio makes it easy to track P&L and check whether one lucky trade drove results. Risk and return are a pair: accepting one, you inevitably accept the other.\n\n'
                'Measure return over a year or more, net of fees, taxes, and inflation. Compare to an index, not a friend\'s profit screenshot. EcoPulse\'s paper portfolio shows whether one lucky trade drove results. Less risk usually means a lower ceiling — a fair trade.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch4',
        title: 'Chapter 4. Compound Interest',
        summary: 'Time as the investor\'s main ally',
        partTitle: 'Part I. Basics',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What compound interest is',
            body:
                'Simple interest accrues only on the original amount. Compound interest accrues on principal plus accumulated interest. 100,000 ₽ at 10% per year: first year +10,000 ₽, second year interest is on 110,000 ₽, and so on. The longer the period, the more visible the snowball effect.\n\n'
                'Compound interest is often called the eighth wonder of the world — for good reason. Over 20 years at 8% with no additions, 100,000 ₽ becomes roughly 466,000 ₽. With monthly contributions of 10,000 ₽ the effect is even stronger. Time and regularity often matter more than catching the perfect entry point.\n\n'
                'Compare two sums: one reinvests interest, one withdraws it. The gap after fifteen years often surprises beginners. Moderate return plus time plus discipline beats heroic yields. EcoPulse links patience on quotes with patience in saving and regular contributions.',
          ),
          CourseSection(
            heading: 'The role of time',
            body:
                'Starting at 25 with small sums is often better than starting at 45 with a large lump sum but a short horizon to retirement. A younger investor has more market cycles to survive drawdowns and more years to reinvest dividends and coupons.\n\n'
                'Waiting for perfect conditions is costly: every year without contributions is a lost year of compounding. You do not need a perfect start — even a modest monthly transfer to a brokerage account after building a cushion starts the mechanism. EcoPulse is not a broker, but the course and paper portfolio help you learn while the first real capital accumulates.\n\n'
                'If you started late, compensate with slightly larger regular contributions, not an all-in bet. Five invested years at thirty beat five idle years at thirty-five. Learn in EcoPulse while real capital accumulates after the cushion is funded and documented.',
          ),
          CourseSection(
            heading: 'Reinvesting dividends and coupons',
            body:
                'If you do not withdraw dividends and coupons but buy more securities, capital grows faster. Many ETFs reinvest automatically — check fund documents. Individual stocks may pay dividends to your account — you can manually reinvest in the same or another asset.\n\n'
                'Over long horizons reinvestment can account for a significant share of the final sum — sometimes comparable to price appreciation. Taxes and fees on each reinvestment reduce the effect — covered in Part V. In EcoPulse\'s paper portfolio you can simulate what happens if you reinvest profit each quarter versus withdrawing it as cash.\n\n'
                'Reinvest coupons and dividends on schedule, not on mood. Broker auto-plans reduce the urge to spend payouts on impulse. In EcoPulse\'s demo, compare reinvest versus cash-out on the same horizon to see compounding hands-on without real money at stake.',
          ),
          CourseSection(
            heading: 'Rule of 72 and planning',
            body:
                'Rule of 72 is a quick estimate: divide 72 by the annual return in percent to approximate years to double capital. At 8% per year: 72 ÷ 8 ≈ 9 years. It is an approximation, not an exact formula, but useful for goal conversations.\n\n'
                'I want 3 million in 15 years is the reverse problem: what sum and rate are needed with monthly contributions? Calculators show that regular contributions sometimes matter more than aggressive but risky return assumptions. Inflated expectations (+30% every year) break the plan at the first drawdown.\n\n'
                'Use the rule of seventy-two in family talks: at six percent, capital doubles in about twelve years. For precision, use a calculator with contributions and inflation. Assume five to seven percent after tax in plans. EcoPulse helps you avoid baking twenty-five percent into dreams.',
          ),
          CourseSection(
            heading: 'Enemies of compounding',
            body:
                'Broker fees, frequent trading, taxes, inflation, and spending profits slow the snowball. Trading on every headline multiplies costs. An early drawdown is psychologically hard, but with continued contributions you buy assets cheaper — averaging works in your favor with discipline.\n\n'
                'The main enemy is stopping: selling everything in panic and leaving the market for years. EcoPulse helps train patience on a virtual portfolio: see how P&L would have changed holding through 2020 or 2022 drawdowns — without risking real savings.\n\n'
                'Cut leaks: excess trades, expensive products, spending profits on impulse. Each percent of drag works against you for years. In a drawdown, keep contributing if goals unchanged — you buy more units for the same money. Scroll past drawdowns in EcoPulse to train nerves.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch5',
        title: 'Chapter 5. Financial Goals',
        summary: 'Setting goals and choosing horizon',
        partTitle: 'Part I. Basics',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'SMART financial goals',
            body:
                'A goal like I want to be rich does not work. Better: save 800,000 ₽ for a mortgage down payment by December 2028 — specific, measurable, with a deadline. SMART: Specific, Measurable, Achievable, Relevant, Time-bound. Each goal gets its own mental or account bucket: cushion, housing, retirement, vacation.\n\n'
                'Different goals need different instruments. A vacation in one year — deposit or savings account, not volatile stocks. Retirement in 25 years — a meaningful share of stocks and ETFs is reasonable. Mixing everything in one portfolio blurs priorities: it is easy to spend retirement money on an impulse purchase.\n\n'
                'List each goal on its own line: amount, deadline, priority, acceptable risk. SMART means concrete — not save a lot, but six hundred thousand rubles for education by a fixed date. Revise when job or family changes. Separate buckets beat one aggressive portfolio at the first drop.',
          ),
          CourseSection(
            heading: 'Horizon determines risk',
            body:
                'Up to 1–2 years — conservative: deposits, short bonds, liquidity over yield. 3–5 years — moderate risk: mix of bonds and stocks. 7+ years — you can weather drawdowns and hold a significant stock weight. As the goal date nears, shift smoothly to calmer instruments — not the week before buying a home.\n\n'
                'EcoPulse shows historical volatility of assets — use it for an honest check: are you ready for a 15% portfolio drop one year before the goal? If not, reduce risky assets in advance, not in panic.\n\n'
                'Two years before a major goal, start lowering stock weight — not two weeks before signing. EcoPulse shows how volatile your mix is. If a twenty-percent drop one year before a home purchase is unacceptable, shift to deposits or short bonds early while you still have time.',
          ),
          CourseSection(
            heading: 'Priorities and trade-offs',
            body:
                'Cushion, mortgage, investments, children\'s education at once — resources are limited. Prioritize: cushion and toxic debt first, then nearest-deadline goals, then long ones like retirement. A little of everything sometimes works, but without a cushion any strategy is vulnerable.\n\n'
                'Discuss goals with family: expenses and risks are shared. Write a one-page plan: goal, amount, timeline, monthly income share, instrument types. Review every six months — life changes, and so may the plan, but not every week on news headlines.\n\n'
                'Order goals: safety first, near deadlines second, long horizons third. Discuss who decides under stress — one calm voice prevents mistakes. Keep the plan on one page. EcoPulse monitors markets, not your goal list on every minus three percent IMOEX day.',
          ),
          CourseSection(
            heading: 'Nominal vs real goals',
            body:
                'One million rubles in ten years is a nominal figure. With 7% annual inflation, a million\'s purchasing power may feel like ~500,000 ₽ today. For long goals, build inflation into calculations or target real return after it.\n\n'
                'Key rate and inflation expectations are visible in EcoPulse and the daily brief. A goal to preserve and grow means beating inflation, not just a bigger number on the screen. Otherwise the achieved goal will not buy what you planned.\n\n'
                'Recalculate goals in today\'s rubles using inflation. A nominal million in ten years may buy like half a million now. EcoPulse\'s brief on inflation and rates supports those calculations. Real return after tax is the target, not a bigger number on screen alone.',
          ),
          CourseSection(
            heading: 'From goal to portfolio',
            body:
                'After defining goals, choose structure: asset classes, weights, contribution and review frequency. This bridges to Part III on the portfolio. For now, one rule: one goal — one horizon — one risk level.\n\n'
                'EcoPulse\'s paper portfolio lets you trial a strategy for retirement in 20 years: build 60% stocks / 40% bonds, add virtually each month, watch P&L and emotions in drawdowns. Mistakes here are free; on a real account they cost nerves and money. Part I laid the foundation — next we cover specific instruments.\n\n'
                'Link each goal to a draft portfolio: retirement — more stocks and ETFs; three-year goal — more cash and bonds. EcoPulse\'s paper portfolio tests emotions on that mix before real money is committed to the same structure.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch6',
        title: 'Chapter 6. Stocks',
        summary: 'A share in a company and sources of return',
        partTitle: 'Part II. Instruments',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What a stock is',
            body:
                'A stock is a share in a company\'s capital. Buying SBER, LKOH, or AAPL makes you a co-owner with a claim on profit (dividends) and participation in the company\'s value growth. Stocks trade on an exchange — in Russia the main venue is MOEX, whose quotes EcoPulse shows with daily change, volume, and issuer sector.\n\n'
                'Price is not a forever fair value but today\'s balance of supply and demand: earnings, news, rates, market mood. Yesterday\'s leader can lag tomorrow. Stocks are a growth instrument with high volatility, not a deposit substitute.\n\n'
                'Study the business, not just the ticker: revenue model, competitors, debt. One line in the app starts analysis; it does not finish it. Compare several names in one sector on EcoPulse. Start with industries you understand to read news without rumor buys.',
          ),
          CourseSection(
            heading: 'Dividends and price appreciation',
            body:
                'Shareholder return comes from price growth (capital gain) and dividends — payouts of part of profit. Not every company pays dividends: young tech firms often reinvest everything. Dividend aristocrats are steady payers with a history of rising payouts.\n\n'
                'Dividends are taxed; ex-dates and amounts are in issuer disclosures. After the ex-dividend date the price often drops roughly by the payout — normal mechanics, not a crash. In EcoPulse, follow issuer news — it affects both dividend expectations and quotes.\n\n'
                'Dividend yield moves with price — a high percentage can signal trouble. Check payout history and policy. After the ex-date, price often adjusts — normal mechanics. Follow issuer news in EcoPulse; it drives both dividends and quotes over the coming quarters.',
          ),
          CourseSection(
            heading: 'How to read a quote',
            body:
                'On EcoPulse\'s MOEX screen note: current price, daily % change, trading volume (liquidity), sector, and recent news. Low volume means wider spread risk when trading. Compare performance with IMOEX: if a stock steadily lags the market without a clear reason, investigate before adding.\n\n'
                'A quote is a starting point for research, not a buy signal. Look at financials (revenue, debt, margin), multiples (P/E where relevant), and competitors. One pretty one-month chart does not replace understanding the business.\n\n'
                'Volume shows how easily you can trade without spread loss. Compare a name to IMOEX — steady lag without reason deserves research. Before buying, list what you need: revenue, debt, margin. A quote is a starting point, not a buy order from the app.',
          ),
          CourseSection(
            heading: 'Blue chips and second tier',
            body:
                'Blue chips are large liquid companies with recognizable businesses. They fall in crises too but rarely vanish from the exchange. Second and third tier are smaller firms: higher growth potential and higher risk of fraud, low liquidity, and corporate conflicts.\n\n'
                'Beginners often do better starting with liquid names or an index ETF than a 3 ₽ lottery ticket. Diversifying across sectors (finance, oil and gas, IT, consumer) reduces dependence on one industry. Sectors appear in EcoPulse when browsing MOEX quotes.\n\n'
                'Begin with liquid names or an index ETF if experience is thin. Second tier suits those who read reports and tolerate swings. Spread virtual buys across sectors in EcoPulse and watch sector news hit the portfolio. One industry overweight is hidden concentration risk.',
          ),
          CourseSection(
            heading: 'Stock risks',
            body:
                'A company can go bankrupt — shareholders stand last in line. Sanctions, nationalization, delisting, manipulation — idiosyncratic risks. Systemic crises hit the whole market. Do not put money needed within a year into a single stock.\n\n'
                'EcoPulse\'s paper portfolio is a safe way to live with stock volatility: buy virtually two or three blue chips and one second-tier name, compare behavior when news hits. Mistakes in practice mode cost no real rubles but build discipline.\n\n'
                'Cap a single stock — for example five to ten percent of the portfolio. Money needed within a year should not sit in one volatile name. In EcoPulse\'s demo, compare a blue chip and a second-tier name on the same headline — amplitude teaches risk quickly.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch7',
        title: 'Chapter 7. Bonds',
        summary: 'Debt instruments and coupon income',
        partTitle: 'Part II. Instruments',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'A bond as a loan',
            body:
                'Buying a bond means lending to an issuer — government or company. In return you receive coupons (periodic interest) and principal at maturity if the issuer does not default. Bonds are usually less volatile than stocks but offer less capital growth potential — they stabilize portfolios and provide income.\n\n'
                'Yield to maturity (YTM) accounts for current price, coupons, and term — compare bonds by YTM, not coupon rate alone. EcoPulse shows MOEX bond quotes alongside stocks.\n\n'
                'Yield to maturity beats a pretty coupon on the label — it uses price and term. Compare bonds by YTM, not name alone. MOEX bond quotes in EcoPulse track rate moves. A bond is a contract: read maturity, coupon schedule, and call provisions if any.',
          ),
          CourseSection(
            heading: 'OFZ and corporate bonds',
            body:
                'OFZ are Russian federal bonds; the issuer is the state. They are relatively reliable in rubles but not absolutely risk-free: secondary-market prices move when the key rate changes. Corporate bonds pay more but carry credit risk — from AAA ratings to junk.\n\n'
                'Before buying, check rating (if any), issuer industry, and debt levels in financials. A high coupon often compensates for high default risk. The central bank key rate in EcoPulse is a guide: when it rises, old low-coupon bonds often cheapen.\n\n'
                'OFZ anchor the conservative ruble sleeve, but exchange price still moves. Corporates need issuer checks: statements, rating, sector. High coupon often pays for high risk. EcoPulse\'s key rate guides you: when it rises, old low-coupon bonds usually cheapen on screen.',
          ),
          CourseSection(
            heading: 'Bond price and rates',
            body:
                'The relationship is inverse: when market rates rise, existing fixed-coupon bonds usually fall in price — investors demand higher yield. When rates fall, prices may rise. If you hold to maturity and the issuer is solvent, you receive planned coupons regardless of screen price swings.\n\n'
                'Selling before maturity locks the market price — profit or loss is possible. Long bonds (10+ years) are more rate-sensitive than short ones. For a calm portfolio slice, shorter duration is often chosen.\n\n'
                'Hold to maturity with a solvent issuer — coupons arrive on schedule. Sell early and you take market price, gain or loss. Long issues react more to rates than short ones. For a calm slice, shorter duration means fewer surprises when the central bank meets.',
          ),
          CourseSection(
            heading: 'Coupons and taxes',
            body:
                'Coupon income is subject to personal income tax (current rates and exemptions — check tax authority sites; this is general information, not tax advice). Individual investment accounts (IIS) may offer deductions if rules are met. Include tax when comparing bonds to deposits: gross yield is not net in your pocket.\n\n'
                'Reinvesting coupons accelerates compounding — like stock dividends. In EcoPulse\'s paper portfolio add virtual OFZ and see how their share stabilizes total P&L when stocks fall.\n\n'
                'Compare coupon income to deposits after tax — gross and net differ. An IIS may help if rules are met — ask your broker. Reinvesting coupons accelerates growth like dividends. Add virtual OFZ in EcoPulse and watch them stabilize P&L when stocks fall sharply.',
          ),
          CourseSection(
            heading: 'Bonds in the portfolio',
            body:
                'Typical role is ballast: smoothing stock drawdowns and providing predictable cash flow from coupons. Weight depends on age, goals, and risk tolerance — more in Part III. Do not expect OFZ to match stock returns in a bull market — different job.\n\n'
                'Follow issuer news in EcoPulse: restructuring, sanctions, rating cuts can sharply move corporate prices. Government OFZ react more to macro and rates than to one company headline.\n\n'
                'Bonds smooth drawdowns and pay predictable cash flow — do not expect bull-market stock returns. Weight depends on age, goals, and tolerance. Issuer news in EcoPulse — rating cuts, restructuring, sanctions — hits corporates faster than sovereign OFZ paper.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch8',
        title: 'Chapter 8. ETFs and Exchange-Traded Funds',
        summary: 'Diversification in one trade',
        partTitle: 'Part II. Instruments',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What an ETF is',
            body:
                'An ETF (exchange-traded fund) is a fund whose units trade like a single stock. Inside is a basket of stocks or bonds following an index or strategy. An ETF on IMOEX or the S&P 500 lets you buy a slice of the whole market in one trade instead of dozens of individual names.\n\n'
                'Fund fee (TER — total expense ratio) is deducted from assets annually — often 0.2–1% for index ETFs, higher for active funds. Compare TER when choosing. Ruble and currency ETFs trade on MOEX — quotes are in EcoPulse.\n\n'
                'An ETF saves time: one trade instead of dozens. Check TER and unit liquidity. Compare two funds on the same index — TER compounds over years. MOEX ETF quotes sit in EcoPulse next to stocks and bonds for side-by-side monitoring during your research.',
          ),
          CourseSection(
            heading: 'Index vs active ETFs',
            body:
                'An index ETF tracks an index (IMOEX, RGBI, S&P 500) with minimal tracking error — low fees, transparent holdings. An active ETF or mutual fund tries to beat the market — statistically often fails after fees.\n\n'
                'Long-term investors favor index buy-and-hold: fewer trades, less temptation to time the market. Past index growth does not guarantee the future — multi-year drawdowns have happened.\n\n'
                'Index ETFs suit long buy-and-hold: fewer trades, less urge to time the market. Active funds rarely beat the market steadily after fees. Past index growth is not a promise. Use ETFs as portfolio scaffolding alongside cushion, bonds, and written target weights from Part III.',
          ),
          CourseSection(
            heading: 'DCA strategy',
            body:
                'Dollar cost averaging (DCA) means regular purchases of a fixed amount (e.g., 10,000 ₽ monthly) regardless of price. It smooths the risk of investing everything on one peak day. On dips you buy more units; on rallies, fewer.\n\n'
                'It suits salary-based investing. It does not remove the need to pick a sensible base asset (index ETF) and stay disciplined at −20% on screen. In EcoPulse\'s paper portfolio simulate monthly buys versus a lump sum.\n\n'
                'DCA smooths the risk of investing everything on one peak day. On dips you buy more units; on rallies, fewer. Pick a sensible base asset — often an index ETF — and stick to the calendar. Simulate monthly buys versus lump sum in EcoPulse to compare paths on history.',
          ),
          CourseSection(
            heading: 'Bond and currency ETFs',
            body:
                'Bond ETFs (RGBI, corporate indices) diversify the debt sleeve without picking each issue. Foreign stock ETFs (S&P 500, NASDAQ) add USD/EUR exposure and other economies — with currency risk for a ruble investor.\n\n'
                'Read the prospectus: where assets are held, which index is tracked, discount or premium to NAV. In EcoPulse compare ETF performance with the base index — large gaps may signal liquidity or structure problems.\n\n'
                'Read the prospectus: which index, where assets sit, NAV premium or discount. Currency ETFs add foreign exposure and FX risk for ruble investors. Compare ETF performance to its index in EcoPulse — a large persistent gap may signal liquidity or tracking problems worth investigating.',
          ),
          CourseSection(
            heading: 'ETF limitations',
            body:
                'ETFs are not insured against market falls: an IMOEX ETF drops with the index. TER and bid-ask spread reduce return. Some niche ETFs are illiquid — wide spreads. Sanctions and regulation can affect access to foreign ETFs — stay informed.\n\n'
                'An ETF is a tool, not magic: it solves diversification and simplicity but does not replace an emergency fund, horizon, or psychological resilience. Combine with bonds and cash at target weights from Part III.\n\n'
                'An IMOEX ETF falls with the index — no magic shield. TER, spread, and broker fees matter on every entry and exit. Niche ETFs can be illiquid with wide spreads. Combine ETFs with bonds, cash, and target weights rather than treating one fund as the whole plan.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch9',
        title: 'Chapter 9. Deposits and OFZ',
        summary: 'The conservative slice of capital',
        partTitle: 'Part II. Instruments',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Bank deposits',
            body:
                'A deposit places money in a bank for a fixed or floating rate for a term. Deposit insurance covers balances up to a limit (check the insurer\'s site for the current amount). Deposits suit emergency funds, 1–2 year goals, and capital where predictability beats maximum growth.\n\n'
                'Rates often follow the central bank key rate — track it in EcoPulse. A high rate at an unknown bank may mean higher risk — for reserves choose systemically important institutions. Early withdrawal penalties reduce flexibility — for a cushion prefer savings accounts or deposits with partial withdrawal.\n\n'
                'Deposits fit cushion and one-to-two-year goals. Check deposit insurance limits and bank reliability. Early withdrawal penalties hurt flexibility — for reserve, prefer savings or partial-withdrawal deposits. Rates often follow the key rate — track it in EcoPulse alongside inflation prints.',
          ),
          CourseSection(
            heading: 'Savings accounts',
            body:
                'A savings account is a flexible deposit alternative: interest on balance, quick access. The rate may be below a term deposit but above zero on a card. Convenient for cushion and short goals.\n\n'
                'Banks change terms — read the contract: minimum balance, caps on higher rates, conditions for rate cuts. Compare effective annual yield with inflation: safe does not mean growing purchasing power.\n\n'
                'Savings accounts keep reserve accessible with interest on balance. Read terms: caps on higher rates, conditions for cuts. Compare effective annual yield to inflation — safe does not mean growing purchasing power. Often the best compromise for short goals and emergency liquidity you can tap quickly.',
          ),
          CourseSection(
            heading: 'OFZ for the conservative block',
            body:
                'OFZ offer government coupon income with the option to sell on exchange before maturity. Fixed-coupon OFZ pay steady coupons; inflation-linked OFZ partially protect nominal value in real terms. Choice depends on your view of inflation and rates.\n\n'
                'Buying OFZ through a broker often costs less than bank structured products. Minimum MOEX lots are accessible to retail investors. OFZ quotes in EcoPulse help track dynamics alongside stocks.\n\n'
                'Fixed-coupon OFZ pay steady coupons; inflation-linked OFZ partly protect real value. Broker OFZ often cost less than bank wrappers with opaque fees. MOEX minimum lots are retail-friendly. OFZ quotes in EcoPulse sit beside stocks so you see rate-driven moves in one place.',
          ),
          CourseSection(
            heading: 'Deposit vs OFZ vs corporate bonds',
            body:
                'Deposit: maximum simplicity, deposit insurance, but rate may lag inflation; early exit has penalties. OFZ: exchange liquidity, rate sensitivity, no deposit insurance but sovereign credit risk. Corporate bonds: higher yield, higher default risk.\n\n'
                'For cushion — deposit or savings. For conservative investing over 3–7 years — mix OFZ, quality corporates, or bond ETFs. Do not chase maximum coupon without analyzing issuer risk.\n\n'
                'Deposit: simplicity and insurance; OFZ: exchange liquidity and rate sensitivity; corporates: higher yield and default risk. Cushion — deposit or savings. Three-to-seven-year conservative sleeve — mix OFZ, quality corporates, or a bond ETF rather than chasing coupon alone without credit work.',
          ),
          CourseSection(
            heading: 'Real return',
            body:
                'Compare all instruments after taxes and inflation. A 10% deposit with 8% inflation and income tax — modest real result. EcoPulse helps see the macro picture: key rate, exchange rates, central bank news — context for choosing when to lock money in deposits versus longer instruments.\n\n'
                'The conservative block is not a boring mistake — it provides calm and liquidity to rebalance when stocks dip and you add from coupons and deposit interest per plan.\n\n'
                'Real return is nominal minus inflation, taxes, and fees. A ten-percent deposit at eight-percent inflation and tax is modest in real terms. EcoPulse shows macro context: rate, FX, central bank news. The conservative block funds calm rebalancing when equities dip and you add from coupons per plan.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch10',
        title: 'Chapter 10. Currencies',
        summary: 'Exchange rates, risks, and portfolio role',
        partTitle: 'Part II. Instruments',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Why currency in a portfolio',
            body:
                'Holding part of assets in USD, EUR, or CNY diversifies currency risk for a ruble investor. If the ruble weakens, currency assets may rise in ruble terms; if the ruble strengthens, the opposite. This is not a bet against your home currency but insurance against one-sided exposure.\n\n'
                'EcoPulse shows USD/RUB, EUR/RUB, and other pairs with daily change. Set a price alert at a level that matters — practice reacting to thresholds, not every tick in the news feed.\n\n'
                'Currency exposure diversifies; it is not a bet against the ruble. Some expenses and goals may be in foreign currency — plan for that explicitly. Small regular conversions smooth bad entry timing. USD and EUR on EcoPulse are for observation and alerts at plan levels, not daily speculation.',
          ),
          CourseSection(
            heading: 'Ways to get currency exposure',
            body:
                'Cash and currency accounts are simple but earn little and carry bank or limit risk. Currency bonds, foreign-stock ETFs, and broker currency deposits add yield plus currency. Leveraged forex is speculation, not beginner investing.\n\n'
                'Converting an entire salary into dollars at a peak is timing risk. Regular small conversions smooth entry, like DCA for stocks. Watch bank and broker spread when exchanging — a hidden fee.\n\n'
                'Routes to exposure: FX accounts, currency bonds, foreign-stock ETFs. Leveraged forex is speculation, not a beginner base strategy. Watch bank and broker spread — a hidden fee on every conversion. Set an EcoPulse alert at a plan level and react deliberately, not on every headline move.',
          ),
          CourseSection(
            heading: 'Exchange rate and macro',
            body:
                'Rates depend on oil, trade balance, key rate, sanctions, geopolitics, import demand. Short-term prediction is nearly impossible — expert forecasts in EcoPulse\'s brief are context, not instructions. A long horizon softens a bad entry.\n\n'
                'When the ruble weakens sharply, imports cost more — inflation may rise and the central bank may hike rates. Understanding the rate–key rate–inflation link helps read EcoPulse\'s economic brief holistically.\n\n'
                'Rates depend on oil, trade balance, key rate, sanctions, import demand. Short-term forecasts in EcoPulse\'s brief are context, not orders. Link rate, key rate, and inflation when reading macro news together. A long horizon softens a bad FX entry more than perfect timing ever will.',
          ),
          CourseSection(
            heading: 'Currency controls and practice',
            body:
                'Transfer and purchase rules change — check current central bank and bank rules. Keep transaction records. Do not use gray-market exchange schemes from messengers — fraud and account block risk.\n\n'
                'A reasonable currency share for a ruble resident is often 10–30% (not a recommendation, a thinking anchor), depending on foreign expenses, income, and goals. Putting everything in dollars from fear is also risk if the ruble strengthens.\n\n'
                'Follow current central bank and bank rules; keep transaction records. Avoid gray-market messengers — fraud and account blocks. A reasonable FX share is individual: expenses, income, goals. All-in dollars from fear also hurts if the ruble strengthens for years.',
          ),
          CourseSection(
            heading: 'Currency in EcoPulse',
            body:
                'The home screen shows rates and dynamics. In the paper portfolio add a virtual USD or EUR position and see how it affects total P&L when the ruble moves. The correlation screen shows links between currency, stocks, and BTC — useful when building a portfolio in Part III.\n\n'
                'Currency is a diversification tool, not an emergency fund substitute. Keep liquid reserves in rubles on an accessible account; currency belongs in long goals and asset-class balance.\n\n'
                'EcoPulse home shows FX and dynamics; add virtual USD or EUR in the paper portfolio to see ruble moves on total P&L. The correlation screen links currency, stocks, and BTC. Keep liquid reserve in rubles on an accessible account; currency belongs in long goals and balance.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch11',
        title: 'Chapter 11. Diversification',
        summary: 'Do not put all eggs in one basket',
        partTitle: 'Part III. Portfolio',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What diversification means',
            body:
                'Diversification spreads capital across assets, sectors, countries, and currencies so one position\'s fall does not destroy the whole portfolio. Professionals call it the only free lunch in finance: idiosyncratic risk falls without proportionally cutting expected return when the mix is sensible.\n\n'
                'Betting on one sure stock, one sector, or one country is a lottery. Even experts err. ETFs, multiple issuers, bonds, and currency together usually survive crises less painfully than concentration in one ticker.\n\n'
                'Write target weights before buying — for example fifty percent stocks, thirty percent bonds, ten percent currency, ten percent cash. Without numbers, diversification becomes random tickers. Quarterly, compare actual weights to plan. MOEX sectors in EcoPulse reveal oil-and-gas or finance clustering you might not notice.',
          ),
          CourseSection(
            heading: 'Levels of diversification',
            body:
                'Within an asset class: not one stock but 10–30+ via ETF or a basket. Across classes: stocks + bonds + cash + perhaps currency, gold, or small crypto slices. Geography: MOEX plus foreign markets through available instruments. Currency: not 100% rubles if goals and expenses allow otherwise.\n\n'
                'EcoPulse shows MOEX sectors — useful to see whether virtual positions cluster in oil and gas or finance. The paper portfolio is a lab to experiment with diversification levels without risk.\n\n'
                'Diversify at several levels: many names inside stocks via ETF, across asset classes, geography where available. Ten stocks in one sector is not protection. EcoPulse\'s paper portfolio lets you test how those levels behave under one macro shock without risking real capital during the experiment.',
          ),
          CourseSection(
            heading: 'Pseudo-diversification',
            body:
                'Ten stocks in one sector is not diversification. Five ETFs on the same index under different names is duplication. Many altcoins fall in sync with BTC. Buying everything without target weights is chaos, not strategy.\n\n'
                'Conscious diversification starts with target weights: e.g., 50% stocks, 30% bonds, 10% currency, 10% cash. EcoPulse\'s correlation screen helps find hidden duplicates — assets that move almost as one.\n\n'
                'Check for duplicates: two ETFs on one index, five banks, altcoins moving with BTC. Conscious diversification means target weights and position caps. EcoPulse\'s correlation screen finds hidden clones. Buying everything without weights is a collection of tickers, not a strategy you can rebalance.',
          ),
          CourseSection(
            heading: 'Diversification vs return',
            body:
                'An overly broad average portfolio rarely crushes the market but also rarely collapses on one bad bet. Most private investors aim not to win a Nobel for market timing but to reach financial goals at acceptable risk.\n\n'
                'Skipping diversification for a super idea sometimes works — and more often hurts. Cap maximum single-position weight (e.g., 10% of portfolio) and stick to it except for deliberate plan exceptions.\n\n'
                'A broad portfolio rarely crushes the market but rarely dies on one mistake. Most investors aim to reach goals at acceptable risk. Cap one position — for example ten percent — unless the plan says otherwise. Skipping diversification for a super idea often hurts more than it helps.',
          ),
          CourseSection(
            heading: 'Practice in EcoPulse',
            body:
                'Build a paper portfolio of 5–7 assets across classes: a MOEX stock, ETF, virtual OFZ, BTC, USD. Watch P&L for a week and a month. When oil falls, see which positions suffer — that is real diversification, not theory.\n\n'
                'Reread this chapter after your first drawdown: then not putting eggs in one basket becomes personal experience, not abstraction.\n\n'
                'Build five to seven assets across classes in EcoPulse and watch a week and a month. When oil or rates move, note which positions hurt — theory becomes experience. Reread after your first drawdown: then baskets make personal sense instead of staying abstract textbook language.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch12',
        title: 'Chapter 12. Correlation',
        summary: 'How assets move relative to each other',
        partTitle: 'Part III. Portfolio',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What correlation is',
            body:
                'Correlation measures how closely two assets\' returns move together: from −1 (opposite) through 0 (independent) to +1 (nearly in sync). High positive correlation means when one falls, the other often does too — little protection. Low or negative correlation can smooth drawdowns.\n\n'
                'EcoPulse has a correlation screen — use it to see links among BTC, IMOEX, USD/RUB, and paper portfolio positions. It is a learning tool, not a mathematical guarantee of the future.\n\n'
                'Correlation near plus one means assets fall together — little protection. Near zero or negative can smooth drawdowns. EcoPulse\'s correlation screen links BTC, IMOEX, USD, and your positions — a learning lens, not a guarantee of future co-movement when stress returns to markets.',
          ),
          CourseSection(
            heading: 'Correlation changes',
            body:
                'In crises correlations often converge toward 1: stocks, risky bonds, and sometimes safe havens behave differently than in calm years. What did not correlate in 2019 may correlate in 2022. Diversification is a process, not a one-time setup.\n\n'
                'Review correlations every six months to a year and after major macro shocks. Do not over-optimize on the last quarter — data noise is large.\n\n'
                'In stress, correlations often collapse toward one — many assets drop together. What was independent in calm years may sync after a shock. Review links every six months and after major events. Do not over-fit one quarter of data — noise is large and misleading for portfolio design.',
          ),
          CourseSection(
            heading: 'Stocks and bonds',
            body:
                'Classic model: stocks rise in expansion, bonds stabilize in stress. In practice, sharp rate hikes can hurt both. OFZ and quality corporates are still often less volatile than second-tier stocks.\n\n'
                'Adding a bond ETF or OFZ to EcoPulse\'s paper portfolio and comparing P&L with 100% stocks shows correlation\'s role in a mixed portfolio.\n\n'
                'The classic stocks-plus-bonds mix often helps, but sharp rate hikes can hurt both for a time. OFZ and quality corporates are usually less volatile than second-tier stocks. Compare one hundred percent stocks versus a mixed sleeve in EcoPulse — the drawdown difference is a practical lesson, not theory.',
          ),
          CourseSection(
            heading: 'Crypto and traditional markets',
            body:
                'BTC was once pitched as digital gold uncorrelated with stocks. In practice correlation with risk assets is sometimes high — in risk-off episodes crypto can fall with tech stocks. A small crypto slice does not save a stock portfolio if both drop together.\n\n'
                'Fear & Greed in EcoPulse reflects crypto sentiment; compare with IMOEX and USD to build intuition about joint movement.\n\n'
                'BTC is not always digital gold — in risk-off episodes it can fall with tech. A small crypto slice does not save stocks if both drop together. Fear and Greed plus IMOEX and USD in EcoPulse build intuition on joint moves without requiring you to trade on every reading.',
          ),
          CourseSection(
            heading: 'Using the insights',
            body:
                'If all your assets correlate above 0.8, you are effectively one big bet. Add a class with different behavior: bonds, currency, another sector. Do not chase perfect negative correlation — it is rare and unstable.\n\n'
                'Correlation complements diversification: one is how many baskets, the other whether baskets move the same way. Together they build resilience — the theme of the next chapters.\n\n'
                'If everything correlates above zero point eight, you are one big bet. Add a class with different behavior: bonds, currency, another sector. Perfect negative correlation is rare and unstable. Correlation asks whether your baskets move the same way when headlines hit multiple markets at once.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch13',
        title: 'Chapter 13. Rebalancing',
        summary: 'Discipline to sell high and buy low',
        partTitle: 'Part III. Portfolio',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Why rebalance',
            body:
                'You set targets: 60% stocks, 40% bonds. The market rises — stocks become 75%, risk exceeds plan. Rebalancing returns to 60/40: part of profit is taken, the lagging class is bought. It is mechanical discipline against greed (let stocks run) and fear.\n\n'
                'Without rebalancing the portfolio drifts toward whatever rallied lately — often stocks before a possible drawdown. Regular return to targets is one of few systematic ways to sell near highs without predicting the market.\n\n'
                'Target weights are discipline, not forever. At seventy-five percent stocks on a sixty-percent plan, risk exceeds intent. Rebalancing sells part of the winner and buys the laggard — mechanically fighting greed and fear. Without it, the portfolio drifts toward whatever rallied last, often before a drawdown.',
          ),
          CourseSection(
            heading: 'When to rebalance',
            body:
                'Two approaches: on a calendar (quarterly or semi-annually) or on deviation (when a class moves 5–10 percentage points from target). Calendar is simpler; thresholds mean fewer trades. Do not rebalance weekly — fees and taxes eat the benefit.\n\n'
                'Major life events (wedding, home purchase in two years) are reasons to revise goals, not only weights. EcoPulse does not execute trades, but you can rebalance the paper portfolio manually for practice.\n\n'
                'Choose calendar rebalancing quarterly or semi-annual, or threshold when a class drifts five to ten points. Weekly tweaks eat fees and taxes. Life events warrant goal reviews, not only weight tweaks. Practice manual rebalancing in EcoPulse\'s paper portfolio before doing it with real commissions and tax events.',
          ),
          CourseSection(
            heading: 'Taxes and fees',
            body:
                'Selling appreciated stocks may trigger tax — factor that in on a real account. Sometimes it is easier to add new money to the lagging class without selling the winner — flow rebalancing. Broker commission on each trade reduces benefit from frequent small tweaks.\n\n'
                'On IIS and long horizons tax effect may matter less than risk discipline — but check current rules; this is not tax advice.\n\n'
                'Selling winners may trigger tax on a real account — factor that in. Sometimes add cash to the lagging class without selling — flow rebalancing. Broker commission on tiny trades erodes benefit. On long horizons, risk discipline may outweigh tax timing — confirm current rules with a specialist.',
          ),
          CourseSection(
            heading: 'Emotions vs rules',
            body:
                'Rebalancing makes you sell what everyone praises and buy what everyone hates — psychologically unpleasant but often useful. Written rules (if stocks exceed 65%, sell 5 points into bonds) settle arguments with yourself in euphoria or panic.\n\n'
                'In 2020–2021 many portfolios without rebalancing overloaded tech and crypto — later drawdowns hurt more than disciplined 60/40 portfolios.\n\n'
                'Rebalancing means selling what headlines praise and buying what they hate — unpleasant but often useful. Write rules upfront: if stocks exceed sixty-five percent, sell five points into bonds. EcoPulse\'s demo trains that uncomfortable discipline before real money and real tax forms arrive in spring.',
          ),
          CourseSection(
            heading: 'Practice',
            body:
                'Set targets in EcoPulse\'s paper portfolio: 50/30/20 (stocks/bonds/cash). Each virtual quarter check actual weights and trade back to targets. Note how it felt to sell a rising asset — training for a real account.\n\n'
                'Rebalancing does not guarantee return but manages risk — a core job of portfolio investing.\n\n'
                'Set fifty-thirty-twenty targets in EcoPulse and each virtual quarter restore weights. Note emotions when selling a rising asset — invaluable on a real account later. Rebalancing manages risk; it does not promise return or remove the need for an emergency fund outside the portfolio. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch14',
        title: 'Chapter 14. Asset Allocation by Age',
        summary: 'How risk shifts over time',
        partTitle: 'Part III. Portfolio',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Rule of 100 minus age',
            body:
                'A simple heuristic: stock share ≈ 100 minus your age (30 years old → ~70% stocks). The rest is bonds and cash. The rule is rough — it ignores cushion, pension, temperament — but illustrates that youth allows more volatility; near retirement preservation matters more.\n\n'
                'Modern variants use 110 or 120 minus age given longer lifespans — pick an anchor and adapt, do not copy blindly.\n\n'
                'Rule of one hundred minus age is rough — it ignores cushion, pension, temperament. Use it as illustration: youth allows more volatility; near retirement, preservation weighs more. Variants use one ten or one twenty minus age — adapt, do not copy blindly from a blog post.',
          ),
          CourseSection(
            heading: 'Life stages',
            body:
                '20–35: building capital, more aggressive if cushion exists. 35–50: peak income, family, mortgage — balance growth and stability. 50–65: gradually cut stocks as goals approach. 65+: focus on preservation, liquidity, predictable income — but all cash for twenty years of retirement may not beat inflation.\n\n'
                'EcoPulse does not know your age — you set risk when building paper or real portfolios.\n\n'
                'At twenty to thirty-five with a cushion, growth weight can be higher; thirty-five to fifty balances family and mortgage; fifty to sixty-five gradually cuts stocks; sixty-five plus emphasizes preservation and income — but all cash for twenty years may lose to inflation quietly.',
          ),
          CourseSection(
            heading: 'Goal beats age',
            body:
                'Buying a home in three years at 28 calls for a conservative portfolio despite youth. Retirement in thirty years at 55 may still allow a meaningful stock share. The goal map from Chapter 5 beats one formula. Each goal gets its own sub-portfolio with horizon and risk.\n\n'
                'Do not mix down-payment money due in two years with retirement in twenty-five in one aggressive basket.\n\n'
                'Buying a home in three years at twenty-eight needs a conservative mix despite youth. Retirement in thirty years at fifty-five may still allow stocks. The goal map from Chapter five beats one formula. Do not mix two-year down payment money with twenty-five-year retirement in one aggressive basket.',
          ),
          CourseSection(
            heading: 'Glide path',
            body:
                'Target-date approach: as you age or approach a goal date, stock share glides down smoothly — like some pension funds abroad. You can mimic manually: each year cut stocks 1–2 points, add bonds. Mechanical, without guessing the best exit year.\n\n'
                'Sudden all bonds at 60 versus gradual glide — the latter is usually less exposed to timing risk.\n\n'
                'Glide path: each year cut stocks one to two points and add bonds mechanically — like some pension funds abroad. Sudden all bonds at sixty is more timing risk than a gradual glide over five to ten years. Smooth transitions beat dramatic asset-class switches driven by birthday alone.',
          ),
          CourseSection(
            heading: 'Review the plan',
            body:
                'Once a year check: income, family, health, laws, goals changed? Update target weights and rebalance rules. EcoPulse\'s paper portfolio is a sandbox to compare 70/30 vs 40/60 through historical drawdowns — watch P&L and emotions.\n\n'
                'Age is a guide, not a sentence. A conservative 25-year-old and an aggressive 60-year-old with a large cushion exist — honesty with yourself beats a table.\n\n'
                'Once a year review income, family, health, laws, goals — update weights and rebalance rules. In EcoPulse compare seventy-thirty versus forty-sixty on historical drawdowns in the demo. Age guides; honesty with yourself about sleep and stress beats any allocation table online.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch15',
        title: 'Chapter 15. Paper Portfolio',
        summary: 'Practice without risking real money',
        partTitle: 'Part III. Portfolio',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Why paper trading',
            body:
                'A paper (demo) portfolio uses virtual money and real quotes without financial risk. You learn to place trades, see P&L, survive drawdowns, rebalance — mistakes cost no rubles. EcoPulse provides starting virtual capital on the home screen — use it systematically, not for one evening of play.\n\n'
                'Moving to real money makes sense after 3–6 months of disciplined practice, a ready cushion, and a clear plan — not after one lucky virtual +50% trade.\n\n'
                'Virtual money and real quotes — mistakes cost no rubles but build habits. Use EcoPulse\'s starting capital with a plan, weights, and journal, not one evening of play. Move to real money after months of discipline and a ready cushion, not one lucky fifty-percent demo trade.',
          ),
          CourseSection(
            heading: 'Building a learning portfolio',
            body:
                'Step 1: goals and target weights (e.g., 50% MOEX stocks/ETF, 25% bonds, 15% USD, 10% BTC). Step 2: buy 5–7 positions in EcoPulse. Step 3: write a manifesto — why each position, horizon, exit rule. Step 4: do not touch for a week — observe. Step 5: weekly journal of emotions and P&L.\n\n'
                'Compare with IMOEX — beating the index is not the learning goal; process and discipline are.\n\n'
                'Steps: goals and weights; five to seven positions; a manifesto for each holding; a week without trades; weekly emotion and P&L notes. Beating IMOEX is not the learning goal — process and discipline are what transfer when you open a brokerage account with real size.',
          ),
          CourseSection(
            heading: 'Common demo mistakes',
            body:
                'Virtual money so all-in on one meme stock — the habit transfers to real accounts. Too many trades for fun trains overtrading. Ignoring fees mentally — they exist on real accounts. Flat P&L for months without analysis wastes learning.\n\n'
                'Treat the paper portfolio seriously: same rules you plan for real money, same max position limits.\n\n'
                'Do not all-in on a meme stock in demo — the habit transfers to real accounts quickly. Trading for fun trains overtrading and ignores fees that exist on real accounts. Treat virtual capital with the same position limits and max drawdown rules you intend for real money.',
          ),
          CourseSection(
            heading: 'From demo to real account',
            body:
                'When cushion is ready, plan is written, and −15% in demo feels tolerable — open a brokerage or IIS account. Start smaller than you could — scale after half a year of real discipline. First trades — simple instruments from this course: ETF, OFZ, liquid stocks.\n\n'
                'EcoPulse remains for monitoring, the daily brief, alerts, and a parallel experimental demo for new ideas without risking core capital.\n\n'
                'When cushion, plan, and minus fifteen percent in demo feel tolerable, open a brokerage or IIS account. Start smaller than you could; scale after half a year of real discipline. EcoPulse stays for monitoring and parallel experiments without risking core capital during learning curves.',
          ),
          CourseSection(
            heading: 'Metrics of learning success',
            body:
                'Not did I earn 30% this month but: did I keep target weights? Rebalance by rules? Sell in panic? Keep a journal? Understand why a sector fell? Those skills transfer to real money; short virtual profit is often luck.\n\n'
                'Part III gave portfolio tools — Part IV covers macro and markets that move your paper and future real positions.\n\n'
                'Success is: kept weights, rebalanced by rules, avoided panic sells, kept a journal, understood why a sector fell. Short demo profit is often luck; process skills transfer. Part three gave tools — part four covers macro that moves your paper and future real positions daily.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch16',
        title: 'Chapter 16. Inflation',
        summary: 'The hidden enemy of purchasing power',
        partTitle: 'Part IV. Markets & Macro',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What inflation is',
            body:
                'Inflation is a sustained rise in the general price level of goods and services. The official CPI basket reflects average consumers; your personal experience may differ — if you spend heavily on housing and healthcare, your inflation may be higher. +5% nominal return with +8% inflation is a real loss of purchasing power.\n\n'
                'EcoPulse and the daily economic brief keep inflation and the key rate in view — without macro context it is hard to judge whether a 10% deposit is good or a −5% portfolio dip is bad.\n\n'
                'Compare your spending basket to official CPI — housing and healthcare heavy budgets may feel higher inflation. Plus five percent nominal at plus eight percent inflation is a real loss. EcoPulse and the daily brief keep inflation and the key rate visible for judging deposits and portfolio dips.',
          ),
          CourseSection(
            heading: 'Causes of inflation',
            body:
                'Demand-side: people and firms spend more than the economy produces — prices rise. Supply-side: supply shocks, sanctions, shortages — imports cost more. Monetary: too much money in the system. Often several factors act together, as in 2020–2022.\n\n'
                'The central bank raises the key rate to curb inflation — affecting deposits, mortgages, bond and stock quotes. The inflation–rate–markets link is the basis for reading macro news.\n\n'
                'Demand, supply, and monetary factors often combine — as in twenty twenty to twenty twenty-two. The central bank raises the key rate to cool prices, affecting deposits, mortgages, bonds, and stocks. Read news through inflation, rate, and markets together instead of isolated screaming headlines.',
          ),
          CourseSection(
            heading: 'Inflation and investing',
            body:
                'Deposits below inflation slowly erode real wealth. Stocks have historically partly compensated through corporate profit growth — but not every year or every name. Inflation-linked OFZ protect nominal value in real terms for the conservative slice. Real estate and commodities are discussed as hedges — with their own risks and liquidity limits.\n\n'
                'A long-term portfolio goal is to beat inflation after taxes, not merely show a positive nominal number.\n\n'
                'Deposits below inflation slowly erode real wealth. Stocks partly compensated via corporate profits — not every year or name. Inflation-linked OFZ help the conservative sleeve. Long-term goal: beat inflation after tax, not merely show a positive nominal balance on the statement.',
          ),
          CourseSection(
            heading: 'Hyperinflation and deflation',
            body:
                'Extremes: hyperinflation destroys savings in local currency (historical examples are lessons, not forecasts for Russia). Deflation (falling prices) seems good for shoppers but leads to stagnation, rising real debt burdens, and unemployment — stocks suffer.\n\n'
                'Moderate inflation (2–4% in developed economies, higher in emerging markets) is the backdrop strategies adapt to. Investors focus on real, not nominal, return.\n\n'
                'Hyperinflation destroys local savings — history lesson, not forecast. Deflation feels good shopping but brings stagnation and heavier real debt — stocks suffer too. Moderate inflation is the backdrop strategies adapt to. Focus on real, not nominal, return when comparing instruments over five-plus years.',
          ),
          CourseSection(
            heading: 'Tracking inflation in EcoPulse',
            body:
                'Read the brief: inflation data, central bank comments, exchange rate (import prices). Compare deposit rate and key rate with official inflation. When planning goals from Chapter 5, use 5–7% inflation in long calculations if unsure — conservative beats optimistic.\n\n'
                'Inflation is a hidden tax on cash and conservative instruments below its level — motivation to invest consciously, not to speculate.\n\n'
                'Use EcoPulse\'s brief: inflation prints, central bank tone, FX import prices. Compare deposit rate to official inflation. In long goal math, assume five to seven percent if unsure — conservative beats optimistic assumptions that leave you short when the deadline arrives.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch17',
        title: 'Chapter 17. Key Rate',
        summary: 'The central bank\'s main lever and market impact',
        partTitle: 'Part IV. Markets & Macro',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What the key rate is',
            body:
                'The central bank key rate is the benchmark cost of money in the economy. It influences deposit and loan rates, new OFZ yields, and sometimes the ruble. EcoPulse shows the current rate and context — a first screen to check when assessing where macro is heading.\n\n'
                'A rate hike usually fights inflation but makes credit costlier and can pressure stocks. A cut stimulates the economy and risk assets but may heat inflation.\n\n'
                'The key rate is the benchmark cost of money. EcoPulse shows the current level — first stop for macro context each week. Hikes fight inflation but tighten credit and can pressure stocks. Cuts stimulate risk assets but may heat prices — rarely is one lever the whole story.',
          ),
          CourseSection(
            heading: 'Rate and bonds',
            body:
                'When the key rate rises, new bonds are issued with higher coupons; old low-coupon bonds cheapen on the secondary market — unrealized loss if you sell. When rates fall, the opposite. Longer duration means higher sensitivity.\n\n'
                'If you hold OFZ to maturity, contractual coupons do not change — but market price on EcoPulse swings. Understanding the link reduces panic at a −3% paper loss.\n\n'
                'When the rate rises, new bonds carry higher coupons; old low-coupon paper cheapens on the secondary market. Longer duration, higher sensitivity. Hold OFZ to maturity and contractual coupons stay — but EcoPulse price still swings. Understanding the link reduces panic at a paper loss you need not realize.',
          ),
          CourseSection(
            heading: 'Rate and stocks',
            body:
                'A high rate raises the appeal of near-risk-free deposits and OFZ — some investors leave stocks. Costlier company credit pressures margins. Growth and tech names with distant cash flows are especially sensitive.\n\n'
                'A low rate tailwinds stocks but does not guarantee gains: 2022 showed geopolitics and sanctions can overpower one variable.\n\n'
                'High rates boost deposits and OFZ appeal — some leave stocks. Costlier corporate credit squeezes margins. Growth names with distant cash flows are especially sensitive. Low rates help stocks but do not guarantee gains — geopolitics and sanctions can overpower one variable for quarters at a time. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Rate and currency',
            body:
                'Rate hikes often support the ruble (carry, inflows to ruble assets). Cuts pressure the currency when other things equal. Read USD/RUB in EcoPulse together with central bank decisions — rate up plus stronger ruble is a common but not absolute pattern.\n\n'
                'Foreign borrowers and importers react differently to the rate–currency pair — what matters is your USD/EUR exposure.\n\n'
                'Rate hikes often support the ruble; cuts pressure it when other things equal. Read USD/RUB with central bank decisions in EcoPulse. Importers and foreign borrowers react differently — match the view to your FX exposure and whether you earn or spend in foreign currency.',
          ),
          CourseSection(
            heading: 'Using rate cycles in strategy',
            body:
                'Do not try to outtrade every central bank meeting — markets partly price expectations ahead. Long investors understand rate cycles last years; tacticians consider bond duration and stock sectors. Follow the meeting calendar in EcoPulse\'s economic brief.\n\n'
                'A world of 20% versus 5% key rate is different for deposits, mortgages, and stock portfolios — adjust the conservative slice without panicking on stocks the first day of a decision.\n\n'
                'Do not trade every central bank meeting — markets partly price expectations ahead of the announcement. Rate cycles last years, not days. Follow the meeting calendar in EcoPulse\'s brief. Adjust the conservative sleeve between a five-percent and twenty-percent rate world without panic-selling stocks on day one.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch18',
        title: 'Chapter 18. Moscow Exchange (MOEX)',
        summary: 'How Russia\'s main stock market works',
        partTitle: 'Part IV. Markets & Macro',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'MOEX\'s role',
            body:
                'Moscow Exchange is the primary venue for stocks, bonds, currency, and derivatives in Russia. The IMOEX index reflects the largest liquid names — the benchmark for the Russian market. EcoPulse aggregates MOEX quotes: prices, changes, sectors, news — a convenient entry for observation and learning.\n\n'
                'Trading follows set sessions; T+1 settlement affects liquidity planning. A broker connects you to the exchange.\n\n'
                'MOEX is Russia\'s main venue for stocks, bonds, FX, and derivatives. IMOEX benchmarks large liquid names. EcoPulse aggregates quotes, sectors, and news — an entry for observation before you size real orders. Sessions and T-plus-one settlement affect liquidity; the broker connects you to the exchange.',
          ),
          CourseSection(
            heading: 'Indices and sectors',
            body:
                'IMOEX is the broad market; MOEX10 is the top ten; sector indices cover oil and gas, finance, and more. Comparing your portfolio to IMOEX shows whether you beat or lag the market — for beginners matching via ETF often beats chasing alpha.\n\n'
                'Sectors in EcoPulse help avoid unconscious concentration — oil and gas is heavy in IMOEX but that is not a reason for 100% in one company.\n\n'
                'IMOEX is broad; MOEX10 is top ten; sector indices cover oil and gas, finance, and more. Versus IMOEX, beginners often do better matching via ETF than chasing alpha. EcoPulse sectors help avoid unconscious single-industry overload that looks diversified but is not.',
          ),
          CourseSection(
            heading: 'Liquidity and spread',
            body:
                'Blue chips (SBER, GAZP, LKOH, etc.) have tight spreads and large volume. Second tier risks not filling at your price. Check volume in EcoPulse before paper or real buys of illiquid names.\n\n'
                'On stress days liquidity can vanish — the screen price is not always the price of your large trade.\n\n'
                'Blue chips have tight spreads and volume; second tier may not fill at your price. Check volume in EcoPulse before illiquid paper or real buys. On stress days liquidity vanishes — screen price is not always the price of your full order size when you need to exit. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Restrictions and sanctions',
            body:
                'Since 2022, foreign investors, instruments, and settlement changed — follow news and rules from the clearing house, depository, and broker. Some tickers trade with limits; ADR/GDR and foreign listings add legal and operational complexity.\n\n'
                'EcoPulse shows available quotes within the app — it does not replace legal advice on specific securities and accounts.\n\n'
                'Since twenty twenty-two, access, settlement, and instruments changed — follow broker, clearing, and depository news. Some tickers trade with limits. EcoPulse shows available in-app quotes — not legal advice on specific securities, accounts, or whether you may hold a name as a retail investor. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Observation practice',
            body:
                'Weekly: IMOEX trend, 3–5 news items for watchlist issuers, compare with USD/RUB. In the paper portfolio hold 2–3 MOEX stocks plus an index ETF — see how the index and individual names diverge. Basic home-market literacy before diversifying abroad where available.\n\n'
                'MOEX is not the whole universe of assets but a key hub for the ruble investor.\n\n'
                'Weekly: IMOEX trend, three to five issuer headlines, USD/RUB comparison. Hold two to three MOEX stocks plus an index ETF in the paper portfolio — see index versus single-name divergence. MOEX is a key hub for ruble investors, not the entire investable universe available globally.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch19',
        title: 'Chapter 19. Cryptocurrencies',
        summary: 'High risk and a separate portfolio shelf',
        partTitle: 'Part IV. Markets & Macro',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'What a crypto asset is',
            body:
                'Cryptocurrencies are digital assets on a blockchain. BTC and ETH are the most liquid; thousands of altcoins carry high fraud and obsolescence risk. Price depends on demand, supply, regulation, macro, and narratives — not discounted cash flows like stocks.\n\n'
                'EcoPulse shows BTC, ETH quotes and the Fear & Greed index — observation tools, not buy or sell forecasts.\n\n'
                'BTC and ETH are most liquid; thousands of altcoins carry fraud and obsolescence risk. Price follows demand, supply, regulation, macro, narratives — not discounted cash flows like stocks. EcoPulse quotes and Fear and Greed are for observation, not buy or sell orders from the app.',
          ),
          CourseSection(
            heading: 'Volatility and risks',
            body:
                '−50% in a year for BTC is not unusual. Exchanges fail, projects scam, seed phrases are stolen by phishing. Leverage on crypto can wipe an account quickly. Regulatory status in Russia and globally changes — consider legal risk.\n\n'
                'Crypto is a speculative shelf, not an OFZ or emergency fund replacement. Many cap at 1–5% of portfolio with money they can lose entirely.\n\n'
                'Minus fifty percent in a year for BTC is not unusual historically. Exchanges fail, projects scam, seeds get phished. Leverage can wipe an account fast. Regulatory status shifts — consider legal risk. Crypto is a speculative shelf on money you can lose entirely — often one to five percent of portfolio.',
          ),
          CourseSection(
            heading: 'Crypto and macro',
            body:
                'Correlation with stocks shifts — in crises BTC is not always a haven. Dollar liquidity and Fed or central bank rates affect all risk assets including crypto. Extreme Fear in Fear & Greed is not tomorrow\'s bottom — a contrarian hint, not a guarantee.\n\n'
                'EcoPulse\'s correlation screen: BTC vs IMOEX vs USD — joint movement for portfolio decisions.\n\n'
                'BTC correlation with stocks shifts — not always a haven in crises. Dollar liquidity and central bank rates move all risk assets including crypto. Extreme Fear is not tomorrow\'s bottom — a contrarian hint, not a guarantee. EcoPulse shows BTC versus IMOEX and USD for portfolio thinking.',
          ),
          CourseSection(
            heading: 'Security',
            body:
                'Do not keep large sums on exchange longer than needed. Hardware wallet for long term; seed offline, not in cloud or screenshots. Double-check addresses; support never asks for seed. Guaranteed 20% monthly yield is a scam.\n\n'
                'EcoPulse\'s paper portfolio can simulate a small BTC slice without keys or phishing — P&L mechanics, not custody.\n\n'
                'Do not park large sums on exchanges longer than needed. Hardware wallet for long term; seed offline, never in cloud or screenshots. Support never asks for seed. Guaranteed twenty percent monthly is a scam. EcoPulse simulates small BTC without custody or phishing exposure during learning. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Crypto in EcoPulse',
            body:
                'Follow price, Fear & Greed, and brief news. Set a BTC price alert — discipline training. Do not trade every ±5% move. If adding crypto to a real portfolio — only after cushion, plan, and acceptance of total loss.\n\n'
                'The course gives context; compliance and decisions are yours.\n\n'
                'Track price, Fear and Greed, and brief news in EcoPulse. Set a BTC alert for discipline, not every five-percent intraday move. Real crypto only after cushion, plan, and acceptance of total loss. The course gives context; compliance and decisions remain yours alone. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch20',
        title: 'Chapter 20. Market Cycles',
        summary: 'Ups, downs, and patience',
        partTitle: 'Part IV. Markets & Macro',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Bull and bear markets',
            body:
                'A bull market is sustained growth over months or years; a bear is a drawdown of roughly 20%+ from a recent peak. Markets cycle: expansion, peak, recession, trough. Bottoms and tops are clear only in hindsight — timing usually loses to DCA and hold.\n\n'
                'EcoPulse shows quote and index history — scroll past IMOEX drawdowns to remind yourself −30% happened before and the market did not vanish (not a guarantee any single stock recovers).\n\n'
                'Bull markets run months or years; bears are roughly twenty percent plus off a peak. Bottoms and tops are clear in hindsight — timing usually loses to DCA and hold. EcoPulse history reminds you minus thirty percent happened before — not a guarantee every stock recovers, but markets endured.',
          ),
          CourseSection(
            heading: 'The economic cycle',
            body:
                'GDP growth, low unemployment, corporate profits tailwind stocks. Recession brings falling profits, rising defaults, credit stress. Bonds and gold sometimes soften stocks in recession — not always. Central bank and fiscal policy speed or slow phases.\n\n'
                'An investor with a ten-year horizon will live through several mini-cycles — the Part III plan matters more than one quarter of news.\n\n'
                'GDP growth, jobs, and profits tailwind stocks; recession brings defaults and credit stress. Bonds and gold sometimes soften stocks — not always in the same cycle. A ten-year horizon crosses several mini-cycles — the part three plan beats one quarter of frightening headlines.',
          ),
          CourseSection(
            heading: 'Behavioral traps of cycles',
            body:
                'At peaks everyone is an expert and FOMO rules; at bottoms the market is dead. Media amplifies extremes. Contrarian buying at the bottom needs cash and nerves — cushion and bonds provide ammo to rebalance into stocks on dips if the plan allows.\n\n'
                'The journal from Chapter 21 records what you felt in each phase — invaluable for the next cycle.\n\n'
                'At peaks, FOMO rules; at bottoms, the market is dead in headlines. Media amplifies extremes. Contrarian buying needs cash and nerves — cushion and bonds fund rebalancing into stocks on dips if the plan allows. Journal emotions from chapter twenty-one for the next cycle you will live through.',
          ),
          CourseSection(
            heading: 'Sector cycles',
            body:
                'Oil and gas, metals, tech, consumer — behave differently by phase. Rotation: cyclicals lead early recovery; defensives late cycle. You need not trade rotation — broad ETFs already mix sectors. Betting on the next hot sector is for experienced speculators.\n\n'
                'MOEX sectors in EcoPulse explain why your oil name rises when oil is up even if the economy looks weak.\n\n'
                'Oil, metals, tech, consumer move differently by phase. Broad ETFs already mix sectors — rotation trading is for speculators with time and risk budget. MOEX sectors in EcoPulse explain oil names rising with crude even when the broader economy looks weak on other indicators.',
          ),
          CourseSection(
            heading: 'Your horizon vs the cycle',
            body:
                'A 25-year horizon makes the current bear an episode. A one-year horizon means a bear can wreck a home-buying plan. Matching horizon to stock share (Chapter 14) beats forecasting the bottom in three months. DCA continues in a bear — same money buys more units.\n\n'
                'Part IV gave a macro lens; Part V covers psychology, taxes, fraud, and EcoPulse practice for a sustainable path.\n\n'
                'A twenty-five-year horizon makes the current bear an episode; a one-year horizon makes a bear wreck a home-buying plan. Match horizon to stock weight, not a three-month bottom forecast. DCA in a bear buys more units for the same money. Part four gave macro — part five covers psychology and practice.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch21',
        title: 'Chapter 21. Investor Psychology',
        summary: 'Emotions cost more than fees',
        partTitle: 'Part V. Practice',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Fear and greed',
            body:
                'On a falling market the instinct is exit to cash and save what is left. On a rising market it is invest everything before it is too late. Both often harm: the first locks loss, the second buys euphoria. Markets reward patience and punish impulsivity over long horizons — not every day.\n\n'
                'A plan written on a calm day — goals, weights, max drawdown — is an anchor. EcoPulse does not remove emotions, but the paper portfolio lets you safely experience a first −20% drawdown and see the world did not end.\n\n'
                'Write the plan on a calm day: goals, weights, max drawdown — an anchor when markets fall. EcoPulse does not remove emotions, but the paper portfolio lets you live minus twenty percent without harming the budget. Patience rewards over years, not every trading session or push notification.',
          ),
          CourseSection(
            heading: 'FOMO and panic',
            body:
                'FOMO pushes buying after +50% in a month when risk/reward is worse. Panic headlines at −30% trigger selling at a loss. A 24-hour rule before large trades is a simple filter. Everyone in the chat is buying is not an investment thesis.\n\n'
                'Fear & Greed for crypto and the tone of EcoPulse\'s brief are mood thermometers, not reasons to copy the crowd.\n\n'
                'FOMO buys after plus fifty percent months when risk/reward is worse. Panic sells on minus thirty percent headlines lock losses. A twenty-four-hour rule before large trades helps. Chat hype is not a thesis. Fear and Greed and brief tone are thermometers, not crowd instructions to copy blindly.',
          ),
          CourseSection(
            heading: 'Confirmation bias and narrative',
            body:
                'Investors seek news confirming their position and ignore contradictions. A story around a ticker (the next Tesla) replaces earnings numbers. Fight back: read bull and bear cases; ask what must go wrong for me to sell.\n\n'
                'A trade journal: date, thesis, emotion at entry/exit, outcome. After six months error patterns appear — overconfidence, revenge trading after a loss.\n\n'
                'Read bull and bear cases; ask what would make you sell. A trade journal over six months reveals overconfidence and revenge trading after a loss. Stories around a ticker do not replace earnings, balance sheet, and cash flow numbers you can verify in issuer materials.',
          ),
          CourseSection(
            heading: 'Overtrading',
            body:
                'Frequent trades from boredom or news multiply fees and mistakes. Research shows active retail traders often underperform the index. Long investors review the portfolio weekly or monthly, not every five minutes — EcoPulse alerts replace compulsive checking.\n\n'
                'If you cannot stop watching quotes — lower stock weight or disable push except alerts at plan levels.\n\n'
                'Frequent boredom trades multiply fees; active retail often lags the index after costs. Review weekly or monthly — EcoPulse alerts replace compulsive checking every few minutes. If you cannot stop watching quotes, lower stock weight or trim push except alerts at plan levels you wrote in advance.',
          ),
          CourseSection(
            heading: 'Building habits',
            body:
                'Regular contributions on payday, quarterly rebalance, weekly EcoPulse brief — rituals beat motivation. Mistakes are inevitable; the goal is not zero mistakes but no ruin from one mistake. Psychological resilience is an asset no terminal displays.\n\n'
                'Move to Chapter 22 knowing taxes and scams also hit net worth — not only the market.\n\n'
                'Payday contributions, quarterly rebalance, weekly EcoPulse brief — rituals beat motivation spikes. Mistakes happen; aim to avoid ruin from one mistake. Psychological resilience is an asset no terminal displays. Chapter twenty-two covers taxes and scams that also hit net worth outside market moves. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch22',
        title: 'Chapter 22. Taxes — Overview',
        summary: 'What reduces net return',
        partTitle: 'Part V. Practice',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Personal income tax on investments in Russia',
            body:
                'Income from selling securities, coupons, and dividends is subject to personal income tax (rates and exemptions change — check tax authority and law; general information only, not tax advice). Long-term holding benefits (3+ years for qualifying securities) may reduce load if conditions are met.\n\n'
                'Count net return after tax when comparing with deposits where the bank may withhold tax.\n\n'
                'Security sales, coupons, and dividends face personal income tax — rates and exemptions change; check tax authority sites. Long holding benefits may reduce load if conditions are met. Count net return versus deposits where tax may be withheld at source before you celebrate nominal gains.',
          ),
          CourseSection(
            heading: 'IIS types A and B',
            body:
                'Individual investment accounts offer tax advantages if rules are followed: type A — deduction on contributions; type B — exemption from tax on profit with long holding. You cannot simply open and withdraw in a year — restrictions and lost benefits apply. One IIS per person.\n\n'
                'Choosing A vs B depends on income, horizon, planned amount — confirm with broker and tax specialist.\n\n'
                'IIS type A offers contribution deductions; type B may exempt profit with long holding — rules and restrictions apply. One IIS per person. A versus B depends on income, horizon, amount — confirm with broker and tax specialist rather than guessing from a forum post last year.',
          ),
          CourseSection(
            heading: 'Taxable events',
            body:
                'Selling at a profit is an event. Dividends are often withheld at source. Rebalancing may create taxable gains. Crypto taxation in Russia is evolving — do not ignore reporting if applicable.\n\n'
                'Keep trade records (broker statements) — a surprise tax bill in April is unpleasant. EcoPulse does not file returns for you.\n\n'
                'Selling at a profit is an event; dividends often withheld at source; rebalancing may create gains. Crypto taxation evolves — do not ignore reporting if applicable. Keep broker statements — EcoPulse does not file for you, and surprise tax bills in April are avoidable with records. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Fees as a tax',
            body:
                'Broker commission, exchange fee, FX spread, ETF TER — each percent eats compounding. 0.3% per trade times 100 trades adds up. Free brokers monetize via spread and margin. Compare total cost of ownership.\n\n'
                'Real return = nominal − inflation − taxes − fees. Chapters 4, 9, and 22 together paint the full picture.\n\n'
                'Broker commission, exchange fee, FX spread, ETF TER — each percent eats compounding. Real return equals nominal minus inflation minus taxes minus fees. Chapters four, nine, and twenty-two together show full drag that beginners often forget when comparing deposit ads to portfolio screenshots online. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Planning',
            body:
                'Long horizon + IIS + infrequent trades often mean lower drag. Short speculation carries the highest tax and fee load. Build a 13–15% mental haircut on profit in goal planning (or the current rate).\n\n'
                'Laws change — check tax authority and broker updates yearly; the course does not replace professional tax advice.\n\n'
                'Long horizon, IIS, and infrequent trades often lower drag. Short speculation carries the highest tax and fee load. Plan with a thirteen to fifteen percent mental haircut on profit. Laws change — check tax authority and broker updates yearly; this course is not professional tax advice. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch23',
        title: 'Chapter 23. Fraud and Traps',
        summary: 'How not to lose capital before the market does',
        partTitle: 'Part V. Practice',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Red flags',
            body:
                'Guaranteed 20% monthly return, secret strategy, pressure to invest today, unlicensed broker, referral pyramids, pump group membership — scam patterns. If it worked steadily, organizers would not sell it in Telegram for 500 ₽.\n\n'
                'Check central bank license for brokers and asset managers. EcoPulse does not take your money on account — education only; transfers to a chat investment guru are outside the app and its protection.\n\n'
                'Guaranteed twenty percent monthly, pressure to invest today, unlicensed brokers, referral pyramids — scam patterns. Verify central bank broker licenses on official registers. EcoPulse does not take your money — transfers to chat gurus are outside app protection and often end in total loss.',
          ),
          CourseSection(
            heading: 'Phishing and impersonation',
            body:
                'Fake broker sites, verify account emails, fake Telegram support asking for seed or password. Always type broker URL manually; use 2FA; do not click email links. Exchanges never ask for seed phrase — ever.\n\n'
                'EcoPulse\'s offline assistant answers dollar rate questions; it does not ask for passwords — any EcoPulse support requesting money is fraud.\n\n'
                'Fake broker sites, verify-account emails, fake support asking for seed or password. Type broker URLs manually; use two-factor authentication; never click email links for login. Exchanges never ask for seed. Any EcoPulse support requesting money or credentials is fraud impersonating the brand. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Pump and dump and paid analysis',
            body:
                'Coordinated pumps of illiquid stocks let insiders sell at the peak; retail holds the loss. Insider tip in a channel often means you are liquidity. Paid courses with 100% win rate are marketing. Distinguish education (this course, EcoPulse) from promises of riches.\n\n'
                'If the thesis cannot survive five minutes explaining to a friend — do not buy.\n\n'
                'Coordinated pumps let insiders sell at the peak; channel tips often mean you are liquidity for their exit. Paid courses with one hundred percent win rates are marketing. Distinguish education from riches promises. If you cannot explain the thesis in five minutes to a friend, do not buy the asset.',
          ),
          CourseSection(
            heading: 'Bank structured products',
            body:
                '100% capital protection plus participation — read footnotes: caps, barriers, bank credit risk, complex payoff. Often expensive versus simple OFZ plus ETF. Not all products are scams but opaque fees and risk need a prospectus review.\n\n'
                'Simplicity helps beginners: ETF, OFZ, deposit beat a forty-page structured note.\n\n'
                'Capital protection plus participation products — read footnotes: caps, barriers, bank credit risk. Often costlier than simple OFZ plus ETF for the same rough risk band. Not all are scams, but opaque fees need a prospectus review. Simplicity helps beginners avoid paying for complexity they cannot monitor. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Protecting yourself',
            body:
                'Rule: if you do not understand how the counterparty earns and where your risk sits — do not sign. Diversifying across brokers and banks within insurance limits is a separate topic. Trust the course process, not hype.\n\n'
                'Scam victims lose 100% — market volatility rarely wipes a disciplined diversified portfolio forever.\n\n'
                'If you do not understand how the counterparty earns and where your risk sits — do not sign. Scam victims lose one hundred percent; market volatility rarely wipes a disciplined diversified portfolio forever. Trust process and licensed channels, not urgency and exclusive Telegram access. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch24',
        title: 'Chapter 24. EcoPulse Tools',
        summary: 'Using the app every day',
        partTitle: 'Part V. Practice',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Home screen and quotes',
            body:
                'Starting point: key rate, USD/RUB, BTC, MOEX indices. A two-minute morning pulse of the market. Not deep research but a filter for what is abnormal today. MOEX stock and bond quotes — watchlist for learning and alerts.\n\n'
                'Compare daily change with paper P&L — context for why the portfolio moved ±2%.\n\n'
                'Morning two minutes on EcoPulse: key rate, USD/RUB, BTC, IMOEX — a pulse, not deep research replacing issuer work. Compare daily change with paper P&L — context for plus or minus two percent moves. MOEX quotes and watchlists support learning and meaningful alerts, not fifty noisy pings. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Paper portfolio and P&L',
            body:
                'Virtual capital, buy and sell at market prices, track profit and loss. Use to practice Chapters III–IV: diversification, rebalance, surviving a cycle. Several months of journal plus demo before real money is strong onboarding.\n\n'
                'Treat virtual capital seriously — same rules, same max position size.\n\n'
                'Virtual capital, market-price trades, P&L tracking — practice parts three and four: diversification, rebalance, cycles. Months of journal plus demo before real money is strong onboarding that cheap brokers skip in their ads. Same rules and position caps as real money from day one in demo. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Correlation and Fear & Greed',
            body:
                'The correlation screen shows links among BTC, IMOEX, USD, and your positions. Fear & Greed reflects crypto sentiment. Lenses, not trading signals. Everything correlated at 0.9 means revisit the mix, not sell everything now.\n\n'
                'Weekly ritual: open correlation after major news (central bank decision, oil shock) — learn macro impact.\n\n'
                'Correlation links BTC, IMOEX, USD, and your positions; Fear and Greed reflects crypto mood — lenses, not signals. Everything at zero point nine correlation means revisit the mix, not sell all now in panic. Open correlation after major macro news weekly to build intuition slowly. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Brief, alerts, and assistant',
            body:
                'The daily economic brief — inflation, rates, corporate news in one place. Price alerts on USD/RUB or BTC — react to plan levels, not noise. Offline assistant: dollar rate, what happened today — quick answers without opening a browser.\n\n'
                'Set 2–3 meaningful alerts, not 50 — alert fatigue means ignored alerts.\n\n'
                'Daily brief — inflation, rates, corporate news in one place. Two or three meaningful price alerts, not fifty — alert fatigue kills usefulness when a real threshold is breached. Offline assistant answers quick FX questions without opening a browser tab during a meeting or commute. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'This course in the app',
            body:
                '25 chapters, roughly 120 pages — reread as you gain experience. Chapter 1 after your first drawdown; Chapter 23 before a large transfer to an unknown broker. EcoPulse grows — new screens supplement practice, they do not replace cushion and thinking.\n\n'
                'In-app feedback helps improve content — you are part of a community of learners.\n\n'
                'Twenty-five chapters — reread as experience grows. Chapter one after first drawdown; chapter twenty-three before a large transfer to an unknown broker. EcoPulse grows with new screens — they supplement cushion and thinking, not replace emergency savings or written goals on your fridge. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
        ],
      ),
      CourseChapter(
        id: 'ch25',
        title: 'Chapter 25. Next Steps',
        summary: 'From learning to sustainable practice',
        partTitle: 'Part V. Practice',
        readMinutes: 0,
        sections: [
          CourseSection(
            heading: 'Checklist before real money',
            body:
                '□ Emergency fund 3–6 months in liquid account\n'
                '□ No toxic double-digit debt\n'
                '□ Written goals, horizon, target allocation\n'
                '□ 3+ months paper portfolio with journal\n'
                '□ Basic understanding of tax and IIS\n'
                '□ Licensed broker, tariffs compared\n\n'
                'Missing items are not forever stop signs but each is a risk factor. Continue EcoPulse demo in parallel with a small real account.\n\n\n\n'
                'Checklist gaps are risk factors, not permanent stop signs. Continue EcoPulse demo alongside a small real account while you fill holes. Readiness means checklist items met and behavior tested in demo, not waiting for zero volatility or a perfect entry that never arrives.',
          ),
          CourseSection(
            heading: 'Plan for the first 12 months',
            body:
                'Months 1–3: contributions only, 1–2 simple instruments (ETF + OFZ). Months 4–6: first rebalance, review correlation. Months 7–12: assess net return vs IMOEX, tax prep, adjust allocation for age and goals. Do not add complexity (options, leverage, altcoins) in year one.\n\n'
                'Weekly: EcoPulse brief. Monthly: contribution and P&L review. Quarterly: rebalance check.\n\n'
                'Months one to three: contributions and one to two simple instruments like ETF plus OFZ. Months four to six: first rebalance, correlation review. Months seven to twelve: net return versus IMOEX, tax prep, allocation tweak. No options, leverage, or altcoin complexity in year one. Weekly brief; monthly P&L; quarterly rebalance check.',
          ),
          CourseSection(
            heading: 'Further learning',
            body:
                'Issuer reporting basics, macro calendar (central bank meetings, oil, US payroll if you follow global markets), books and courses — with critical thinking, no copy trading gurus. Professional financial planner if capital is significant.\n\n'
                'The EcoPulse course is foundation, not ceiling. Revisit chapters at life changes: marriage, child, relocation.\n\n'
                'Issuer reporting basics, macro calendar, books and courses — with critical thinking, no copy-trading gurus. Licensed planner if capital is significant. Revisit chapters at marriage, child, relocation — foundation, not ceiling. Learning continues after the last chapter scrolls off the screen. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Community and discipline',
            body:
                'Discuss ideas, not buy X now tips. Accountability partner or family alignment on the plan. Celebrate process (regular investing), not only outcome (+30% year may be luck). Losses are tuition if lessons are recorded.\n\n'
                'The market will be here tomorrow; FOMO last chance is a lie.\n\n'
                'Discuss ideas, not buy X now tips. Align with family on the plan. Celebrate regular investing, not only plus thirty percent years that may be luck. Losses are tuition if lessons are recorded in a journal you actually reread. The market will be here tomorrow — last-chance FOMO is a lie. Use EcoPulse to tie this lesson to live quotes, the daily brief, and paper-portfolio practice before you risk real capital.',
          ),
          CourseSection(
            heading: 'Final word',
            body:
                'You completed 25 chapters: basics, instruments, portfolio, macro, practice. Investing is a marathon without a finish line: goals evolve, markets cycle, laws change. EcoPulse is a companion for observation, training, and brief — not an oracle.\n\n'
                'Information only, not personal advice. Good luck with learning and discipline — they matter more than any hot ticker. Take one step today: open the paper portfolio or read the daily brief. Consistency wins.\n\n'
                'You finished twenty-five chapters: basics, instruments, portfolio, macro, practice. Investing is a marathon: goals evolve, markets cycle, laws change. EcoPulse is a companion for observation and training, not an oracle. Information only, not personal advice. Take one step today — paper portfolio or daily brief. Consistency wins over heroics.',
          ),
        ],
      ),
    ];
