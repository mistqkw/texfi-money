import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/budget_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/animated_progress_bar.dart';
import '../shared/category_avatar.dart';
import '../shared/l10n_helpers.dart';
import '../shared/terminal_box.dart';
import 'budgets_providers.dart';
import 'set_budget_screen.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(currentMonthBudgetsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.budgetsTitle)),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(fadeSlideRoute(const SetBudgetScreen())),
        child: const Icon(Icons.add),
      ),
      body: budgetsAsync.when(
        data: (budgets) {
          if (budgets.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.budgetsEmpty,
                  style: context.text.body,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            itemCount: budgets.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) => _BudgetCard(budget: budgets[i]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
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

    return TerminalBox(
      label: categoryDisplayName(context, budget.category).toLowerCase(),
      labelColor: _barColor(context),
      onTap: () => Navigator.of(context).push(
        fadeSlideRoute(SetBudgetScreen(existing: budget)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CategoryAvatar(category: budget.category, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Text(categoryDisplayName(context, budget.category), style: context.text.title),
              ),
              Text(
                '${formatAmount(budget.spent, currency, context)} / ${formatAmount(budget.monthlyLimit, currency, context)}',
                style: context.text.caption,
              ),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedProgressBar(progress: budget.progress, color: _barColor(context)),
          if (budget.isOverLimit) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.error_outline, size: 14, color: context.colors.expense),
                const SizedBox(width: 4),
                Text(
                  l10n.budgetsOverBy(formatAmount(budget.spent - budget.monthlyLimit, currency, context)),
                  style: context.text.caption.copyWith(color: context.colors.expense),
                ),
              ],
            ),
          ] else if (budget.isNearLimit) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, size: 14, color: context.colors.warning),
                const SizedBox(width: 4),
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
