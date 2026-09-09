import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../settings/security_provider.dart';
import 'pixel_icon.dart';

/// Замок перед содержимым приложения.
///
/// Держит две вещи, которые легко перепутать. Первая — сам запрос при
/// открытии. Вторая, менее очевидная и более важная: возврат замка после
/// того, как приложение побывало в фоне. Блокировка, которая спрашивает
/// один раз за запуск процесса, защищает только от того, кто взял холодный
/// телефон; телефон же обычно берут со стола у разблокированного владельца,
/// и приложение там висит свёрнутым неделями.
///
/// Отсюда и порог: мгновенный повторный запрос при каждом переключении
/// приложений сделал бы работу невозможной — за курсом валют выходят
/// постоянно. Полминуты — это «отвлёкся», а не «ушёл».
class LockGate extends ConsumerStatefulWidget {
  const LockGate({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<LockGate> createState() => _LockGateState();
}

class _LockGateState extends ConsumerState<LockGate>
    with WidgetsBindingObserver {
  /// Сколько приложение может пробыть в фоне, не требуя замка заново.
  static const Duration _grace = Duration(seconds: 30);

  bool _unlocked = false;
  bool _asking = false;
  DateTime? _leftAt;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      // Первое применение — здесь, а не в `ref.listen`: тот срабатывает
      // только на изменение, а флаг нужен уже на первом кадре.
      ref.read(screenPrivacyProvider).setSecure(
            ref.read(hideInSwitcherProvider),
          );
      _ensureUnlocked();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        final leftAt = _leftAt;
        _leftAt = null;
        // Пока идёт системный диалог замка, приложение само считается
        // ушедшим в фон. Без этой проверки запрос закрывал бы сам себя и
        // тут же открывался заново — бесконечный цикл.
        if (_asking) return;
        if (leftAt != null && DateTime.now().difference(leftAt) > _grace) {
          setState(() => _unlocked = false);
        }
        _ensureUnlocked();
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
      case AppLifecycleState.detached:
        _leftAt ??= DateTime.now();
    }
  }

  Future<void> _ensureUnlocked() async {
    if (_unlocked || _asking) return;
    if (!ref.read(appLockEnabledProvider)) {
      if (mounted) setState(() => _unlocked = true);
      return;
    }

    setState(() => _asking = true);
    final ok = await ref.read(appLockProvider).authenticate(
          reason: context.mounted ? context.l10n.securityUnlockReason : '',
        );
    if (!mounted) return;
    setState(() {
      _asking = false;
      _unlocked = ok;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Скрытие содержимого от системы висит здесь же, а не отдельным
    // виджетом: это ровно то же «приложение закрыто от посторонних», только
    // снаружи, и включаться оно должно там же, где появляется первый экран
    // с деньгами. Онбординг остаётся незакрытым намеренно — прятать нечего.
    ref.listen<bool>(hideInSwitcherProvider, (previous, next) {
      ref.read(screenPrivacyProvider).setSecure(next);
    });

    // Настройку могли выключить изнутри приложения — тогда замок должен
    // перестать закрывать содержимое немедленно, а не со следующего запуска.
    final enabled = ref.watch(appLockEnabledProvider);
    if (!enabled || _unlocked) return widget.child;

    final colors = context.colors;
    final l10n = context.l10n;

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Padding(
          padding: AppSpacing.screen,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              PixelSprite(
                pattern: PixelIcons.budgets,
                size: 48,
                color: colors.accent,
              ),
              AppSpacing.gapXl,
              Text(
                l10n.securityLockedTitle,
                style: context.text.title,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapSm,
              Text(
                l10n.securityLockedBody,
                style: context.text.caption,
                textAlign: TextAlign.center,
              ),
              AppSpacing.gapXl,
              // Пока диалог открыт, кнопка не нужна и мешала бы: нажатие
              // подняло бы второй запрос поверх первого.
              if (!_asking)
                FilledButton(
                  onPressed: _ensureUnlocked,
                  child: Text(l10n.securityUnlock),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
