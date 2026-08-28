import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../l10n/app_localizations.dart';
import '../settings/onboarding_provider.dart';
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
    await ref.read(hasSeenOnboardingProvider.notifier).markSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const RootShell()),
    );
  }

  void _next(int slideCount) {
    if (_page == slideCount - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(duration: AppMotion.normal, curve: AppMotion.standard);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = _slides(l10n);

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
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => _SlideView(slide: slides[i], active: i == _page),
              ),
            ),
            _Dots(count: slides.length, index: _page),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _next(slides.length),
                  child: Text(_page == slides.length - 1 ? l10n.onboardingStart : l10n.onboardingNext),
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
