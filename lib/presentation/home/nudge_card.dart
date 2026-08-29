import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../domain/nudges.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../settings/currency_provider.dart';
import '../shared/l10n_helpers.dart';
import '../shared/terminal_box.dart';
import 'nudge_providers.dart';

/// Показывает самую важную актуальную подсказку. Намеренно одна за раз —
/// стопка предупреждений превращается в шум, который перестают читать.
class NudgeCard extends ConsumerWidget {
  const NudgeCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nudges = ref.watch(nudgesProvider);

    return AnimatedSize(
      duration: AppMotion.normal,
      curve: AppMotion.standard,
      alignment: Alignment.topCenter,
      child: nudges.isEmpty
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _NudgeBody(key: ValueKey(nudges.first.id), nudge: nudges.first),
            ),
    );
  }
}

class _NudgeBody extends ConsumerStatefulWidget {
  const _NudgeBody({super.key, required this.nudge});

  final Nudge nudge;

  @override
  ConsumerState<_NudgeBody> createState() => _NudgeBodyState();
}

class _NudgeBodyState extends ConsumerState<_NudgeBody> {
  @override
  void initState() {
    super.initState();
    // Деликатное касание в момент появления — подсказку легко пропустить
    // глазами, если она въехала пока смотришь в другую часть экрана.
    WidgetsBinding.instance.addPostFrameCallback((_) => Haptics.nudge());
  }

  Color _accent(BuildContext context) => switch (widget.nudge.kind) {
        NudgeKind.budgetOver => context.colors.expense,
        NudgeKind.budgetClose => context.colors.warning,
        NudgeKind.unusualAmount => context.colors.warning,
        NudgeKind.goalClose => context.colors.income,
        NudgeKind.quietDays => context.colors.accent,
      };

  IconData _icon() => switch (widget.nudge.kind) {
        NudgeKind.budgetOver => Icons.error_outline,
        NudgeKind.budgetClose => Icons.warning_amber_rounded,
        NudgeKind.unusualAmount => Icons.help_outline,
        NudgeKind.goalClose => Icons.flag_outlined,
        NudgeKind.quietDays => Icons.schedule,
      };

  String _label(BuildContext context) => switch (widget.nudge.kind) {
        NudgeKind.budgetOver => context.l10n.budgetsTitle.toLowerCase(),
        NudgeKind.budgetClose => context.l10n.budgetsTitle.toLowerCase(),
        NudgeKind.unusualAmount => context.l10n.commonCategory.toLowerCase(),
        NudgeKind.goalClose => context.l10n.goalsTitle.toLowerCase(),
        NudgeKind.quietDays => context.l10n.navHome.toLowerCase(),
      };

  String _text(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final nudge = widget.nudge;
    final currency = ref.watch(currencyProvider);

    // Название категории берём из транзакции/бюджета, но предустановленные
    // категории показываем переведёнными — как и везде в приложении.
    final category = nudge.transaction != null
        ? categoryDisplayName(context, nudge.transaction!.category)
        : (nudge.categoryName ?? '');

    return switch (nudge.kind) {
      NudgeKind.unusualAmount =>
        l10n.nudgeUnusualAmount((nudge.ratio ?? 0).toStringAsFixed(1), category),
      NudgeKind.budgetClose =>
        l10n.nudgeBudgetClose(category, (nudge.percent ?? 0).round().toString()),
      NudgeKind.budgetOver => l10n.nudgeBudgetOver(
          category,
          formatAmount(nudge.overAmount ?? 0, currency, context),
        ),
      NudgeKind.goalClose => l10n.nudgeGoalClose(
          nudge.goalTitle ?? '',
          (nudge.percent ?? 0).round().toString(),
        ),
      NudgeKind.quietDays => l10n.nudgeQuietDays(nudge.days ?? 0),
    };
  }

  void _dismiss() {
    Haptics.select();
    ref.read(dismissedNudgesProvider.notifier).dismiss(widget.nudge.id);
  }

  /// У подсказки про нетипичную сумму есть прямое действие — открыть эту
  /// транзакцию и поправить сумму. Остальные только информируют.
  void _openTarget() {
    final tx = widget.nudge.transaction;
    if (tx == null) return;
    Haptics.select();
    Navigator.of(context).push(fadeSlideRoute(AddTransactionScreen(existing: tx)));
  }

  @override
  Widget build(BuildContext context) {
    final accent = _accent(context);
    final hasAction = widget.nudge.transaction != null;

    return TerminalBox(
      label: _label(context),
      labelColor: accent,
      borderColor: accent.withValues(alpha: 0.45),
      padding: const EdgeInsets.fromLTRB(14, 18, 8, 10),
      onTap: hasAction ? _openTarget : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_icon(), size: 18, color: accent),
          const SizedBox(width: 10),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Text(_text(context, ref), style: context.text.body),
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: 18, color: context.colors.textTertiary),
            tooltip: context.l10n.nudgeDismiss,
            visualDensity: VisualDensity.compact,
            onPressed: _dismiss,
          ),
        ],
      ),
    );
  }
}
