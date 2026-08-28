import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/budget_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/animated_progress_bar.dart';
import '../shared/category_avatar.dart';
import 'budgets_providers.dart';
import 'set_budget_screen.dart';

class BudgetsScreen extends ConsumerWidget {
  const BudgetsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetsAsync = ref.watch(currentMonthBudgetsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Бюджеты')),
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
                  'Пока нет бюджетов — задайте месячный лимит по категории кнопкой «+»',
                  style: AppTypography.body,
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
        error: (e, st) => Center(child: Text('Не удалось загрузить бюджеты', style: AppTypography.body)),
      ),
    );
  }
}

class _BudgetCard extends ConsumerWidget {
  const _BudgetCard({required this.budget});

  final BudgetEntity budget;

  Color get _barColor {
    if (budget.isOverLimit) return AppColors.expense;
    if (budget.isNearLimit) return AppColors.warning;
    return AppColors.accent;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return InkWell(
      borderRadius: AppRadius.mediumAll,
      onTap: () => Navigator.of(context).push(
        fadeSlideRoute(SetBudgetScreen(existing: budget)),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mediumAll,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CategoryAvatar(category: budget.category, size: 36),
                const SizedBox(width: 12),
                Expanded(child: Text(budget.category.name, style: AppTypography.title)),
                Text(
                  '${formatAmount(budget.spent, currency)} / ${formatAmount(budget.monthlyLimit, currency)}',
                  style: AppTypography.caption,
                ),
              ],
            ),
            const SizedBox(height: 12),
            AnimatedProgressBar(progress: budget.progress, color: _barColor),
            if (budget.isOverLimit) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.error_outline, size: 14, color: AppColors.expense),
                  const SizedBox(width: 4),
                  Text(
                    'Превышен на ${formatAmount(budget.spent - budget.monthlyLimit, currency)}',
                    style: AppTypography.caption.copyWith(color: AppColors.expense),
                  ),
                ],
              ),
            ] else if (budget.isNearLimit) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 14, color: AppColors.warning),
                  const SizedBox(width: 4),
                  Text(
                    'Приближается к лимиту',
                    style: AppTypography.caption.copyWith(color: AppColors.warning),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
