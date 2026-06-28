// =============================================================================
// EcoPulse · lib/features/onboarding/onboarding_screen.dart
// Автор: Цымбал Е. В.
// Дата: 20.06.2026
// Модуль EcoPulse. Файл: onboarding_screen.
// =============================================================================

import 'package:flutter/material.dart';

import 'package:flutter_animate/flutter_animate.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gap/gap.dart';

import 'package:iconsax_flutter/iconsax_flutter.dart';

import 'package:smooth_page_indicator/smooth_page_indicator.dart';
/// Класс [OnboardingScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026

/// Создаёт [OnboardingScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026


/// Поле [onComplete] класса [OnboardingScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
import '../../core/theme/app_palette.dart';

/// Создаёт State для [OnboardingScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
import '../../l10n/app_localizations.dart';

import '../../providers/onboarding_provider.dart';

/// Приватный класс [_OnboardingScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026

/// Поле [_pageController] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026

/// Поле [_page] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
class OnboardingScreen extends ConsumerStatefulWidget {

/// Приватный метод [_pages] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  const OnboardingScreen({super.key, required this.onComplete});



/// Поле [onComplete] класса [OnboardingScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final VoidCallback onComplete;



/// Создаёт State для [OnboardingScreen].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override

  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();

}



/// Приватный класс [_OnboardingScreenState] — экран/state.
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {

/// Освобождает ресурсы [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  final _pageController = PageController();

/// Поле [_page] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  int _page = 0;



/// Приватный метод [_finish] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  List<_OnboardingPageData> _pages(AppLocalizations l10n) => [

        _OnboardingPageData(

          icon: Iconsax.convert_card,
/// Приватный метод [_next] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026

          title: l10n.onboarding1Title,

          subtitle: l10n.onboarding1Subtitle,

        ),

        _OnboardingPageData(

          icon: Iconsax.chart_2,

/// Отрисовывает UI [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
          title: l10n.onboarding2Title,

          subtitle: l10n.onboarding2Subtitle,

        ),

        _OnboardingPageData(

          icon: Iconsax.chart,

          title: l10n.onboarding3Title,

          subtitle: l10n.onboarding3Subtitle,

        ),

      ];



/// Освобождает ресурсы [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  @override

  void dispose() {

    _pageController.dispose();

    super.dispose();

  }



/// Приватный метод [_finish] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  Future<void> _finish() async {

    await ref.read(onboardingCompletedProvider.notifier).complete();

    widget.onComplete();

  }



/// Приватный метод [_next] класса [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  void _next(int pageCount) {

    if (_page < pageCount - 1) {

      _pageController.nextPage(

        duration: const Duration(milliseconds: 350),

        curve: Curves.easeOutCubic,

      );

    } else {

      _finish();

    }

  }



/// Отрисовывает UI [_OnboardingScreenState].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  @override

  Widget build(BuildContext context) {

    final palette = AppPalette.of(context);

    final l10n = AppLocalizations.of(context)!;

    final pages = _pages(l10n);

    final isLast = _page == pages.length - 1;



    return Scaffold(

      body: SafeArea(

        child: Column(

          children: [

            Align(

              alignment: Alignment.centerRight,

              child: TextButton(

                onPressed: _finish,

                child: Text(

/// Приватный класс [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
                  l10n.onboardingSkip,
/// Создаёт [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026

                  style: TextStyle(color: palette.textSecondary),

                ),

              ),
/// Поле [icon] класса [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026

/// Поле [title] класса [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
            ),
/// Поле [subtitle] класса [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026

            Expanded(

              child: PageView.builder(

                controller: _pageController,

                itemCount: pages.length,

                onPageChanged: (i) => setState(() => _page = i),

                itemBuilder: (context, index) {

                  final data = pages[index];

                  return Padding(

                    padding: const EdgeInsets.symmetric(horizontal: 32),

                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [

                        Container(

                          padding: const EdgeInsets.all(28),

                          decoration: BoxDecoration(

                            color: palette.accent.withValues(alpha: 0.12),

                            shape: BoxShape.circle,

                          ),

                          child: Icon(data.icon, size: 56, color: palette.accent),

                        )

                            .animate()

                            .fadeIn(duration: 400.ms)

                            .scale(begin: const Offset(0.8, 0.8)),

                        const Gap(40),

                        Text(

                          data.title,

                          textAlign: TextAlign.center,

                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(

                                fontWeight: FontWeight.bold,

                              ),

                        ),

                        const Gap(16),

                        Text(

                          data.subtitle,

                          textAlign: TextAlign.center,

                          style: TextStyle(

                            color: palette.textSecondary,

                            height: 1.5,

                            fontSize: 15,

                          ),

                        ),

                      ],

                    ),

                  );

                },

              ),

            ),

            SmoothPageIndicator(

              controller: _pageController,

              count: pages.length,

              effect: WormEffect(

                dotHeight: 8,

                dotWidth: 8,

                activeDotColor: palette.accent,

                dotColor: palette.border,

              ),

            ),

            const Gap(24),

            Padding(

              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),

              child: SizedBox(

                width: double.infinity,

                child: FilledButton(

                  onPressed: () => _next(pages.length),

                  child: Text(isLast ? l10n.onboardingStart : l10n.onboardingNext),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}



/// Приватный класс [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 21.06.2026
class _OnboardingPageData {

/// Создаёт [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 22.06.2026
  const _OnboardingPageData({

    required this.icon,

    required this.title,

    required this.subtitle,

  });



/// Поле [icon] класса [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 23.06.2026
  final IconData icon;

/// Поле [title] класса [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 24.06.2026
  final String title;

/// Поле [subtitle] класса [_OnboardingPageData].
///
/// Автор: Цымбал Е. В.
/// Дата: 20.06.2026
  final String subtitle;

}


