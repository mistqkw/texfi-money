import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_transitions.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../domain/entities/budget_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/animated_progress_bar.dart';
import '../shared/app_title.dart';
import '../shared/category_avatar.dart';
import '../shared/empty_state.dart';
import '../shared/l10n_helpers.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_fab.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_spinner.dart';
import '../shared/staggered_entrance.dart';
import 'budgets_providers.dart';
import 'set_budget_screen.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key, this.embedded = false});

  /// Экран открыт как сегмент внутри вкладки-группы: заголовок и
  /// переключатель сегментов рисует хозяин, свой AppBar здесь был бы
  /// вторым подряд.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(currentMonthBudgetsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: embedded ? null : AppBar(title: AppTitle(l10n.budgetsTitle)),
      // Плавающая кнопка видна всегда, даже когда список пуст.
      //
      // Была попытка прятать её на пустом списке — раз пустое состояние
      // само предлагает действие, второй «плюс» рядом выглядит лишним. На
      // экране подписок пустого состояния нет вовсе, и добавить первую
      // подписку стало нечем: единственная кнопка исчезала ровно тогда,
      // когда была нужнее всего. Небольшой повтор действия дешевле
      // экрана, с которого нельзя уйти вперёд.
      floatingActionButton: PixelFab(
        onPressed: () {
          Haptics.select();
          Navigator.of(context).push(pixelDissolveRoute(const SetBudgetScreen()));
        },
      ),
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return EmptyState(
              sprite: PixelIcons.budgets,
              message: l10n.budgetsEmpty,
              actionLabel: l10n.setBudgetTitleNew,
              onAction: () {
                Haptics.select();
                Navigator.of(context)
                    .push(pixelDissolveRoute(const SetBudgetScreen()));
              },
            );
          }
          return ListView.separated(
            padding: AppSpacing.screenWithFab,
            itemCount: budgets.length,
            separatorBuilder: (context, i) => AppSpacing.gapMd,
            itemBuilder: (context, i) => StaggeredEntrance(
              index: i,
              child: _BudgetCard(budget: budgets[i]),
            ),
          );
        },
        loading: () => const Center(child: PixelSpinner()),
        error: (e, st) => Center(child: Text(l10n.budgetsLoadError, style: context.text.body)),
      ),
    );
  }
}

class _BudgetCard extends ConsumerWidget {
  const _BudgetCard({required this.budget});

  final BudgetEntity budget;

  Color _barColor(BuildContext context) {
    if (budget.isOverLimit) return context.colors.expense;
    if (budget.isNearLimit) return context.colors.warning;
    return context.colors.accent;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final l10n = context.l10n;

    // Метка карточки повторяла название категории слово в слово: «транспорт»
    // в рамке и «Транспорт» строкой ниже. Вместо неё — остаток по бюджету,
    // то есть ответ на вопрос, ради которого бюджет и заводят.
    return PixelCard(
      label: (budget.monthlyLimit - budget.spent) >= 0
          ? l10n.budgetsLeft(formatAmount(budget.monthlyLimit - budget.spent, currency, context)).toUpperCase()
          : l10n.budgetsOverBy(formatAmount(budget.spent - budget.monthlyLimit, currency, context)).toUpperCase(),
      labelColor: _barColor(context),
      onTap: () => Navigator.of(context).push(
        pixelDissolveRoute(SetBudgetScreen(existing: budget)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryAvatar(category: budget.category, size: 36),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Text(categoryDisplayName(context, budget.category), style: context.text.title),
              ),
              Text(
                '${formatAmount(budget.spent, currency, context)} / ${formatAmount(budget.monthlyLimit, currency, context)}',
                style: context.text.caption,
              ),
            ],
          ),
          AppSpacing.gapMd,
          AnimatedProgressBar(progress: budget.progress, color: _barColor(context)),
          if (budget.isOverLimit) ...[
            AppSpacing.gapSm,
            Row(
              children: [
                PixelIcon(PixelIcons.danger, size: 14, color: context.colors.expense),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.budgetsOverBy(formatAmount(budget.spent - budget.monthlyLimit, currency, context)),
                  style: context.text.caption.copyWith(color: context.colors.expense),
                ),
              ],
            ),
          ] else if (budget.isNearLimit) ...[
            AppSpacing.gapSm,
            Row(
              children: [
                PixelIcon(PixelIcons.danger, size: 14, color: context.colors.warning),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  l10n.budgetsNearLimit,
                  style: context.text.caption.copyWith(color: context.colors.warning),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
