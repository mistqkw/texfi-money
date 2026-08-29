import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_theme_variant.dart';
import '../../core/constants/banks.dart';
import '../../core/constants/currencies.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../l10n/app_localizations.dart';
import '../settings/currency_provider.dart';
import '../settings/onboarding_provider.dart';
import '../settings/theme_provider.dart';
import '../shared/bank_mark.dart';
import '../shared/l10n_helpers.dart';
import '../shared/root_shell.dart';
import '../shared/terminal_box.dart';

class _Slide {
  const _Slide({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _page = 0;
  String? _selectedBankId;

  List<_Slide> _slides(AppLocalizations l10n) => [
        _Slide(
          icon: Icons.account_balance_wallet_outlined,
          title: l10n.onboardingSlide1Title,
          body: l10n.onboardingSlide1Body,
        ),
        _Slide(
          icon: Icons.flag_outlined,
          title: l10n.onboardingSlide2Title,
          body: l10n.onboardingSlide2Body,
        ),
        _Slide(
          icon: Icons.terminal,
          title: l10n.onboardingSlide3Title,
          body: l10n.onboardingSlide3Body,
        ),
        _Slide(
          icon: Icons.lock_outline,
          title: l10n.onboardingSlide4Title,
          body: l10n.onboardingSlide4Body,
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    final bank = BankCatalog.byId(_selectedBankId);
    if (bank != null) {
      await ref.read(accountRepositoryProvider).create(
            name: bank.name,
            color: bank.color,
            bankId: bank.id,
          );
    }
    await ref.read(hasSeenOnboardingProvider.notifier).markSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootShell()),
    );
  }

  void _next(int pageCount) {
    Haptics.select();
    if (_page == pageCount - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(duration: AppMotion.normal, curve: AppMotion.standard);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = _slides(l10n);
    // После контентных слайдов — три интерактивных шага настройки.
    final pageCount = slides.length + 3;
    final currencyPage = slides.length;
    final themePage = slides.length + 1;
    final bankPage = slides.length + 2;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: _finish,
                child: Text(l10n.onboardingSkip),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) {
                  if (i == currencyPage) return _CurrencyStepView(active: i == _page);
                  if (i == themePage) return _ThemeStepView(active: i == _page);
                  if (i == bankPage) {
                    return _BankStepView(
                      active: i == _page,
                      selectedId: _selectedBankId,
                      onSelected: (id) => setState(() => _selectedBankId = id),
                    );
                  }
                  return _SlideView(slide: slides[i], active: i == _page);
                },
              ),
            ),
            _Dots(count: pageCount, index: _page),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _next(pageCount),
                  child: Text(_page == pageCount - 1 ? l10n.onboardingStart : l10n.onboardingNext),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide, required this.active});

  final _Slide slide;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedScale(
            scale: active ? 1.0 : 0.7,
            duration: AppMotion.slow,
            curve: Curves.easeOutBack,
            child: AnimatedOpacity(
              opacity: active ? 1.0 : 0.0,
              duration: AppMotion.normal,
              child: TerminalBox(
                label: 'texfi',
                padding: const EdgeInsets.all(24),
                child: Icon(slide.icon, size: 56, color: context.colors.accent),
              ),
            ),
          ),
          const SizedBox(height: 40),
          AnimatedSlide(
            offset: active ? Offset.zero : const Offset(0, 0.2),
            duration: AppMotion.slow,
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: active ? 1.0 : 0.0,
              duration: AppMotion.normal,
              child: Column(
                children: [
                  Text(slide.title, style: context.text.headline, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text(
                    slide.body,
                    style: context.text.body,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Общая «въезжающая» анимация для интерактивных шагов онбординга —
/// повторяет ритм [_SlideView], чтобы переход между слайдами и шагами
/// настройки выглядел единым.
class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.active, required this.title, required this.child});

  final bool active;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedSlide(
            offset: active ? Offset.zero : const Offset(0, 0.2),
            duration: AppMotion.slow,
            curve: Curves.easeOutCubic,
            child: AnimatedOpacity(
              opacity: active ? 1.0 : 0.0,
              duration: AppMotion.normal,
              child: Column(
                children: [
                  Text(title, style: context.text.headline, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  child,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrencyStepView extends ConsumerWidget {
  const _CurrencyStepView({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(currencyProvider);
    final l10n = context.l10n;

    return _StepScaffold(
      active: active,
      title: l10n.onboardingCurrencyStepTitle,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 10,
        runSpacing: 10,
        children: AppCurrency.values.map((currency) {
          final selected = currency == current;
          return GestureDetector(
            onTap: () {
              Haptics.select();
              ref.read(currencyProvider.notifier).setCurrency(currency);
            },
            child: AnimatedContainer(
              duration: AppMotion.fast,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? context.colors.accent.withValues(alpha: 0.16) : context.colors.surface,
                borderRadius: AppRadius.mediumAll,
                border: Border.all(
                  color: selected ? context.colors.accent : context.colors.divider,
                  width: selected ? 1.5 : 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(currency.symbol, style: context.text.title),
                  const SizedBox(width: 6),
                  Text(currencyDisplayName(context, currency), style: context.text.caption),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ThemeStepView extends ConsumerWidget {
  const _ThemeStepView({required this.active});

  final bool active;

  String _label(AppLocalizations l10n, AppThemeVariant variant) => switch (variant) {
        AppThemeVariant.dark => l10n.themeDark,
        AppThemeVariant.light => l10n.themeLight,
        AppThemeVariant.oled => l10n.themeOled,
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(themeVariantProvider);
    final l10n = context.l10n;

    return _StepScaffold(
      active: active,
      title: l10n.onboardingThemeStepTitle,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (final variant in AppThemeVariant.values) ...[
            _ThemePreviewCard(
              variant: variant,
              label: _label(l10n, variant),
              selected: variant == current,
              onTap: () {
                Haptics.select();
                ref.read(themeVariantProvider.notifier).setVariant(variant);
              },
            ),
            if (variant != AppThemeVariant.values.last) const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _ThemePreviewCard extends StatelessWidget {
  const _ThemePreviewCard({
    required this.variant,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final AppThemeVariant variant;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalettes.forVariant(variant);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: AppMotion.fast,
            width: 76,
            height: 96,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: palette.background,
              borderRadius: AppRadius.mediumAll,
              border: Border.all(
                color: selected ? palette.accent : palette.divider,
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(color: palette.accent, borderRadius: AppRadius.smallAll),
                ),
                const Spacer(),
                Container(width: 36, height: 6, color: palette.textPrimary),
                const SizedBox(height: 6),
                Container(width: 24, height: 6, color: palette.textTertiary),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: context.text.caption.copyWith(
              color: selected ? context.colors.accent : context.colors.textSecondary,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _BankStepView extends StatelessWidget {
  const _BankStepView({required this.active, required this.selectedId, required this.onSelected});

  final bool active;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return _StepScaffold(
      active: active,
      title: l10n.onboardingBankStepTitle,
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 16,
        runSpacing: 16,
        children: [
          _BankBadge(
            label: l10n.accountFormNoBank,
            bank: null,
            color: context.colors.textTertiary,
            selected: selectedId == null,
            onTap: () {
              Haptics.select();
              onSelected(null);
            },
          ),
          for (final bank in BankCatalog.all)
            _BankBadge(
              label: bank.name,
              bank: bank,
              color: bank.color,
              selected: selectedId == bank.id,
              onTap: () {
                Haptics.select();
                onSelected(bank.id);
              },
            ),
        ],
      ),
    );
  }
}

class _BankBadge extends StatelessWidget {
  const _BankBadge({
    required this.label,
    required this.bank,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final BankPreset? bank;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: selected ? color : Colors.transparent, width: 2),
              ),
              child: bank != null
                  ? BankMark(bank: bank!, size: 40)
                  : Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.16),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.block, size: 18, color: color),
                    ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.text.caption.copyWith(
                color: selected ? color : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.standard,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: active ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: active ? context.colors.accent : context.colors.divider,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
