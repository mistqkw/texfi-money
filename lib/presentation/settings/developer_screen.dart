import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/constants/app_theme_variant.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_palettes.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_style_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/theme/beta_options.dart';
import '../../core/utils/haptics.dart';
import '../shared/beta_glyph.dart';
import '../shared/pixel_button.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_segments.dart';
import '../shared/pixel_switch.dart';
import '../shared/restart_widget.dart';
import 'beta_style_reveal.dart';
import 'currency_provider.dart';
import 'developer_provider.dart';
import 'onboarding_provider.dart';
import 'theme_provider.dart';

/// Меню разработчика: открывается пятью нажатиями на версию в
/// «О приложении».
///
/// Здесь только то, что реально работает в релизной сборке: отладочные
/// флаги Flutter вроде `debugPaintSizeEnabled` в релизе молча ничего не
/// делают, и переключатель без последствий хуже, чем никакого. Графики
/// кадров, шахматки и дерево доступности — параметры самого `MaterialApp`,
/// замедление — `timeDilation` планировщика; всё это честно видно на
/// телефоне.
///
/// Бета-стиль стоит последним пунктом: это не диагностика, а
/// эксперимент, который меняет приложение целиком.
class DeveloperScreen extends ConsumerStatefulWidget {
  const DeveloperScreen({super.key});

  @override
  ConsumerState<DeveloperScreen> createState() => _DeveloperScreenState();
}

class _DeveloperScreenState extends ConsumerState<DeveloperScreen> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((info) {
      if (mounted) setState(() => _info = info);
    }).catchError((Object _) {});
  }

  String get _buildMode => kReleaseMode
      ? 'release'
      : kProfileMode
          ? 'profile'
          : 'debug';

  List<(String, String)> _facts(BuildContext context) {
    final l10n = context.l10n;
    final media = MediaQuery.of(context);
    final info = _info;
    final locale = Localizations.localeOf(context);
    final beta = context.style.beta;
    return [
      (
        l10n.devInfoVersion,
        info == null ? '—' : '${info.version} (${info.buildNumber})',
      ),
      (l10n.devInfoPackage, info?.packageName ?? '—'),
      (l10n.devInfoMode, _buildMode),
      (l10n.devInfoPlatform, defaultTargetPlatform.name),
      (
        l10n.devInfoScreen,
        '${media.size.width.round()}×${media.size.height.round()} dp',
      ),
      (l10n.devInfoPixelRatio, '${media.devicePixelRatio.toStringAsFixed(2)}×'),
      (l10n.devInfoTextScale, '${media.textScaler.scale(100).round()}%'),
      (l10n.devInfoLocale, locale.toLanguageTag()),
      (
        l10n.devInfoStyle,
        beta ? 'beta' : ref.watch(themeVariantProvider).name,
      ),
    ];
  }

  Future<void> _copyFacts(List<(String, String)> facts) async {
    final text = facts.map((f) => '${f.$1}: ${f.$2}').join('\n');
    await Clipboard.setData(ClipboardData(text: text));
    Haptics.success();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.devCopied)));
  }

  Future<void> _showPrefs() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final keys = prefs.getKeys().toList()..sort();
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.7,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: AppSpacing.screen,
            children: [
              Text(context.l10n.devShowPrefs, style: context.text.headline),
              AppSpacing.gapMd,
              for (final key in keys) ...[
                Text(key, style: context.text.mono),
                const SizedBox(height: 2),
                Text('${prefs.get(key)}', style: context.text.body),
                AppSpacing.gapSm,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _replayOnboarding() async {
    await ref.read(hasSeenOnboardingProvider.notifier).reset();
    if (!mounted) return;
    RestartWidget.restartApp(context);
  }

  Future<void> _reset() async {
    await resetDeveloperSettings(ref);
    Haptics.success();
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(context.l10n.devResetDone)));
  }

  Future<void> _hideMenu() async {
    await ref.read(devMenuUnlockedProvider.notifier).set(false);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  /// Бета-стиль: спросить, затем сменить стиль под занавесом.
  Future<void> _toggleBeta(Offset origin) async {
    final l10n = context.l10n;
    final enabling = !ref.read(betaStyleProvider);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(enabling ? l10n.devBetaEnableTitle : l10n.devBetaDisableTitle),
        content: Text(enabling ? l10n.devBetaEnableBody : l10n.devBetaDisableBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              enabling ? l10n.devBetaEnableAction : l10n.devBetaDisableAction,
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    // Включение идёт через занавес тушью: знак по эталону рисовался на
    // тёмном, и на бумаге его светлая обводка пропала бы. Занавес потом
    // растворяется в бумагу. Выключение — волной фона возвращаемой темы.
    final variant = ref.read(themeVariantProvider);
    final target = enabling
        ? (variant == AppThemeVariant.light
            ? AppPalettes.betaInk
            : AppPalettes.betaFor(variant).background)
        : AppPalettes.forVariant(variant).background;

    await playBetaStyleReveal(
      context,
      origin: origin,
      enabling: enabling,
      targetBackground: target,
      onSwitch: () => ref.read(betaStyleProvider.notifier).set(enabling),
      glyph: ref.read(betaOptionsProvider).glyph.animationGlyph,
    );
  }

  /// Та же анимация, что при включении беты, но без смены стиля — чтобы
  /// посмотреть её ещё раз, не выключая бету.
  Future<void> _replayReveal() async {
    final variant = ref.read(themeVariantProvider);
    final size = MediaQuery.sizeOf(context);
    await playBetaStyleReveal(
      context,
      origin: Offset(size.width / 2, size.height * 0.8),
      enabling: true,
      targetBackground: variant == AppThemeVariant.light
          ? AppPalettes.betaInk
          : AppPalettes.betaFor(variant).background,
      onSwitch: () {},
      glyph: ref.read(betaOptionsProvider).glyph.animationGlyph,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final facts = _facts(context);
    final speed = ref.watch(animationSpeedProvider);
    final speedIndex = AnimationSpeedNotifier.options.indexOf(speed);

    Widget flag(
      StateNotifierProvider<BoolPrefNotifier, bool> provider,
      String label,
      String subtitle,
    ) {
      return _DevSwitch(
        label: label,
        subtitle: subtitle,
        value: ref.watch(provider),
        onChanged: (value) => ref.read(provider.notifier).set(value),
      );
    }

    /// Выбор из нескольких вариантов: подпись, пояснение, сегменты.
    Widget choice({
      required String label,
      String? subtitle,
      required List<String> labels,
      required int index,
      required ValueChanged<int> onSelected,
    }) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(label, style: context.text.title),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: context.text.caption.copyWith(color: colors.textTertiary),
              ),
            ],
            AppSpacing.gapSm,
            PixelSegments(
              padding: EdgeInsets.zero,
              labels: labels,
              currentIndex: index < 0 ? 0 : index,
              onSelected: onSelected,
            ),
          ],
        ),
      );
    }

    final beta = ref.watch(betaStyleProvider);
    final options = ref.watch(betaOptionsProvider);
    final textScale = ref.watch(textScaleOverrideProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.devTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          PixelSectionHeader(title: l10n.devSectionBuild, index: 1),
          PixelCard(
            onLongPress: () => _copyFacts(facts),
            child: Column(
              children: [
                for (final fact in facts) _FactLine(label: fact.$1, value: fact.$2),
              ],
            ),
          ),
          AppSpacing.gapMd,
          PixelButton(
            label: l10n.devCopyInfo,
            filled: false,
            sprite: PixelIcons.code,
            onPressed: () => _copyFacts(facts),
          ),
          AppSpacing.gapXl,

          PixelSectionHeader(title: l10n.devSectionRendering, index: 2),
          flag(perfOverlayProvider, l10n.devPerfOverlay, l10n.devPerfOverlayDesc),
          flag(
            rasterCheckerboardProvider,
            l10n.devRasterCheckerboard,
            l10n.devRasterCheckerboardDesc,
          ),
          flag(
            layerCheckerboardProvider,
            l10n.devLayerCheckerboard,
            l10n.devLayerCheckerboardDesc,
          ),
          flag(
            semanticsDebuggerProvider,
            l10n.devSemanticsDebugger,
            l10n.devSemanticsDebuggerDesc,
          ),
          AppSpacing.gapXl,

          PixelSectionHeader(title: l10n.devSectionMotion, index: 3),
          Text(l10n.devAnimationSpeed, style: context.text.title),
          const SizedBox(height: 2),
          Text(
            l10n.devAnimationSpeedDesc,
            style: context.text.caption.copyWith(color: colors.textTertiary),
          ),
          AppSpacing.gapMd,
          PixelSegments(
            padding: EdgeInsets.zero,
            labels: [
              for (final option in AnimationSpeedNotifier.options)
                '${option.toStringAsFixed(0)}×',
            ],
            currentIndex: speedIndex < 0 ? 0 : speedIndex,
            onSelected: (i) => ref
                .read(animationSpeedProvider.notifier)
                .set(AnimationSpeedNotifier.options[i]),
          ),
          AppSpacing.gapMd,
          flag(skipSplashProvider, l10n.devSkipSplash, l10n.devSkipSplashDesc),
          AppSpacing.gapXl,

          PixelSectionHeader(title: l10n.devSectionInterface, index: 4),
          flag(
            backgroundNoiseProvider,
            l10n.devBackgroundNoise,
            l10n.devBackgroundNoiseDesc,
          ),
          flag(devBannerProvider, l10n.devBanner, l10n.devBannerDesc),
          flag(layoutGridProvider, l10n.devLayoutGrid, l10n.devLayoutGridDesc),
          flag(touchIndicatorsProvider, l10n.devTouches, l10n.devTouchesDesc),
          choice(
            label: l10n.devTextScale,
            subtitle: l10n.devTextScaleDesc,
            labels: [
              for (final option in TextScaleNotifier.options)
                option == 0
                    ? l10n.devTextScaleSystem
                    : '${(option * 100).round()}%',
            ],
            index: TextScaleNotifier.options.indexOf(textScale),
            onSelected: (i) => ref
                .read(textScaleOverrideProvider.notifier)
                .set(TextScaleNotifier.options[i]),
          ),
          AppSpacing.gapXl,

          PixelSectionHeader(title: l10n.devSectionHaptics, index: 5),
          Text(
            l10n.devHapticsTest,
            style: context.text.caption.copyWith(color: colors.textTertiary),
          ),
          AppSpacing.gapMd,
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              for (final (label, play) in <(String, VoidCallback)>[
                (l10n.devHapticSelect, Haptics.select),
                (l10n.devHapticSuccess, Haptics.success),
                (l10n.devHapticIncome, Haptics.income),
                (l10n.devHapticExpense, Haptics.expense),
                (l10n.devHapticError, Haptics.error),
                (l10n.devHapticCelebrate, Haptics.celebrate),
              ])
                _HapticChip(label: label, onTap: play),
            ],
          ),
          AppSpacing.gapXl,

          PixelSectionHeader(title: l10n.devSectionData, index: 6),
          _DevAction(
            icon: PixelIcons.replay,
            label: l10n.devReplayOnboarding,
            subtitle: l10n.devReplayOnboardingDesc,
            onTap: _replayOnboarding,
          ),
          _DevAction(
            icon: PixelIcons.terminal,
            label: l10n.devShowPrefs,
            subtitle: l10n.devShowPrefsDesc,
            onTap: _showPrefs,
          ),
          _DevAction(
            icon: PixelIcons.replay,
            label: l10n.devRestart,
            subtitle: l10n.devRestartDesc,
            onTap: () => RestartWidget.restartApp(context),
          ),
          _DevAction(
            icon: PixelIcons.settings,
            label: l10n.devReset,
            onTap: _reset,
          ),
          _DevAction(
            icon: PixelIcons.lock,
            label: l10n.devHideMenu,
            subtitle: l10n.devHideMenuDesc,
            onTap: _hideMenu,
          ),
          AppSpacing.gapXl,

          PixelSectionHeader(title: l10n.devSectionExperimental, index: 7),
          _BetaStyleTile(
            enabled: beta,
            glyph: options.glyph.animationGlyph,
            onTap: _toggleBeta,
          ),
          AppSpacing.gapXl,

          // Настройки беты видны всегда: их удобно выставить до включения,
          // чтобы бета сразу открылась такой, как нужно.
          PixelSectionHeader(title: l10n.devSectionBeta, index: 8),
          if (!beta)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                l10n.devBetaOnlyHint,
                style: context.text.caption.copyWith(color: colors.textTertiary),
              ),
            ),
          choice(
            label: l10n.devBetaGlyph,
            subtitle: l10n.devBetaGlyphDesc,
            labels: [r'$', 'm', l10n.devBetaGlyphNone],
            index: BetaGlyphChoice.values.indexOf(options.glyph),
            onSelected: (i) => ref
                .read(betaGlyphProvider.notifier)
                .set(BetaGlyphChoice.values[i].name),
          ),
          if (options.glyph != BetaGlyphChoice.none) ...[
            choice(
              label: l10n.devBetaGlyphStrength,
              labels: [
                l10n.devStrengthQuiet,
                l10n.devStrengthNormal,
                l10n.devStrengthBold,
                l10n.devStrengthFull,
              ],
              index: BetaGlyphStrength.values.indexOf(options.strength),
              onSelected: (i) => ref
                  .read(betaGlyphStrengthProvider.notifier)
                  .set(BetaGlyphStrength.values[i].name),
            ),
            choice(
              label: l10n.devBetaGlyphSize,
              labels: [
                l10n.devSizeSmall,
                l10n.devSizeNormal,
                l10n.devSizeLarge,
              ],
              index: BetaGlyphSize.values.indexOf(options.size),
              onSelected: (i) => ref
                  .read(betaGlyphSizeProvider.notifier)
                  .set(BetaGlyphSize.values[i].name),
            ),
          ],
          choice(
            label: l10n.devBetaTransition,
            labels: [
              l10n.devTransitionPageTurn,
              l10n.devTransitionFade,
              l10n.devTransitionInstant,
            ],
            index: BetaTransition.values.indexOf(options.transition),
            onSelected: (i) => ref
                .read(betaTransitionProvider.notifier)
                .set(BetaTransition.values[i].name),
          ),
          flag(betaGrainProvider, l10n.devBetaGrain, l10n.devBetaGrainDesc),
          flag(
            betaSerifBodyProvider,
            l10n.devBetaSerifBody,
            l10n.devBetaSerifBodyDesc,
          ),
          _DevAction(
            icon: PixelIcons.replay,
            label: l10n.devBetaReplay,
            onTap: _replayReveal,
          ),
        ],
      ),
    );
  }
}

class _FactLine extends StatelessWidget {
  const _FactLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(label.toUpperCase(), style: context.text.mono),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: context.text.label.copyWith(color: context.colors.textPrimary),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}

class _DevSwitch extends StatelessWidget {
  const _DevSwitch({
    required this.label,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.text.title),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: context.text.caption.copyWith(color: colors.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            PixelSwitch(value: value, onChanged: onChanged),
          ],
        ),
      ),
    );
  }
}

class _DevAction extends StatelessWidget {
  const _DevAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
  });

  final List<String> icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: PixelIcon(icon, color: colors.textSecondary),
      title: Text(label, style: context.text.title),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: context.text.caption.copyWith(color: colors.textTertiary),
            ),
      trailing: PixelIcon(PixelIcons.chevronRight, color: colors.textTertiary, size: 14),
      onTap: onTap,
    );
  }
}

/// Кнопка проверки одного ритма вибрации. Вибрация играется, даже если
/// отклик выключен в настройках: проверять выключенное незачем, а
/// вернуть выключатель в исходное — забота этой кнопки.
class _HapticChip extends StatelessWidget {
  const _HapticChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.style;
    return InkWell(
      borderRadius: style.controlRadius,
      onTap: () {
        final was = Haptics.enabled;
        Haptics.enabled = true;
        onTap();
        // Ритм — несколько импульсов с паузами; выключатель возвращается
        // после того, как последний из них гарантированно ушёл.
        Future<void>.delayed(const Duration(milliseconds: 600), () {
          Haptics.enabled = was;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: style.controlRadius,
          border: Border.all(color: colors.border, width: style.borderWidth),
        ),
        child: Text(label, style: context.text.label),
      ),
    );
  }
}

/// Последний пункт меню: переключатель бета-стиля с живым знаком.
///
/// Знак в строке нарисован теми же параметрами, что и в эталоне, — это
/// превью стиля, а не иконка: по нему видно, во что превратится
/// приложение, ещё до того, как на пункт нажали.
class _BetaStyleTile extends StatelessWidget {
  const _BetaStyleTile({
    required this.enabled,
    required this.glyph,
    required this.onTap,
  });

  final bool enabled;

  /// Знак превью — тот, что выбран для беты.
  final String glyph;
  final ValueChanged<Offset> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final style = context.style;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) => onTap(details.globalPosition),
      // У карточки нет своего onTap: нажатие ловит GestureDetector
      // снаружи — ему нужна точка касания, из которой побежит волна.
      child: PixelCard(
        accent: true,
        child: Row(
          children: [
            Container(
              width: 64,
              height: 64,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppPalettes.betaNight.background,
                borderRadius: style.controlRadius,
                border: Border.all(
                  color: AppPalettes.betaStroke.withValues(alpha: 0.35),
                  width: 1,
                ),
              ),
              child: ClipRect(child: BetaGlyph(glyph: glyph, size: 52)),
            ),
            AppSpacing.gapHMd,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.devBetaStyle, style: context.text.title),
                  const SizedBox(height: 2),
                  Text(
                    l10n.devBetaStyleDesc,
                    style: context.text.caption.copyWith(color: colors.textTertiary),
                  ),
                  AppSpacing.gapXs,
                  Text(
                    (enabled ? l10n.devBetaOn : l10n.devBetaOff).toUpperCase(),
                    style: context.text.mono.copyWith(
                      color: enabled ? colors.accent : colors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            PixelIcon(PixelIcons.chevronRight, color: colors.textTertiary, size: 14),
          ],
        ),
      ),
    );
  }
}
