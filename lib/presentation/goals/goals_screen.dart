import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/animated_progress_bar.dart';
import 'goal_form_screen.dart';
import 'goals_providers.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  Future<void> _addContribution(BuildContext context, WidgetRef ref, SavingsGoalEntity goal) async {
    final currency = ref.read(currencyProvider);
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Пополнить «${goal.title}»'),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
          style: context.text.amountLarge,
          decoration: InputDecoration(hintText: '0 ${currency.symbol}'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;
              Navigator.of(context).pop(value);
            },
            child: const Text('Добавить'),
          ),
        ],
      ),
    );

    if (amount != null && amount > 0) {
      await ref.read(savingsGoalRepositoryProvider).addContribution(id: goal.id, amount: amount);
    }
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, SavingsGoalEntity goal) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить цель?'),
        content: Text('Цель «${goal.title}» будет удалена вместе с накопленным прогрессом.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(savingsGoalRepositoryProvider).delete(goal.id);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Цели накоплений')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(fadeSlideRoute(const GoalFormScreen())),
        child: const Icon(Icons.add),
      ),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  'Пока нет целей — создайте первую кнопкой «+»',
                  style: context.text.body,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            itemCount: goals.length,
            separatorBuilder: (context, i) => const SizedBox(height: 12),
            itemBuilder: (context, i) {
              final goal = goals[i];
              return Dismissible(
                key: ValueKey(goal.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (_) async {
                  await _confirmDelete(context, ref, goal);
                  return false;
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: context.colors.expense.withValues(alpha: 0.15),
                    borderRadius: AppRadius.mediumAll,
                  ),
                  child: Icon(Icons.delete_outline, color: context.colors.expense),
                ),
                child: _GoalCard(
                  goal: goal,
                  onTap: () => Navigator.of(context).push(
                    fadeSlideRoute(GoalFormScreen(existing: goal)),
                  ),
                  onAddFunds: () => _addContribution(context, ref, goal),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Не удалось загрузить цели', style: context.text.body)),
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  const _GoalCard({required this.goal, required this.onTap, required this.onAddFunds});

  final SavingsGoalEntity goal;
  final VoidCallback onTap;
  final VoidCallback onAddFunds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return InkWell(
      borderRadius: AppRadius.mediumAll,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.colors.surface,
          borderRadius: AppRadius.mediumAll,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: goal.color.withValues(alpha: 0.16),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    goal.isCompleted ? Icons.check_circle_outline : Icons.savings_outlined,
                    color: goal.color,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(goal.title, style: context.text.title)),
                IconButton(
                  icon: Icon(Icons.add_circle_outline, color: context.colors.accent),
                  onPressed: onAddFunds,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${formatAmount(goal.currentAmount, currency)} из ${formatAmount(goal.targetAmount, currency)}',
              style: context.text.caption,
            ),
            const SizedBox(height: 12),
            AnimatedProgressBar(
              progress: goal.progress,
              color: goal.isCompleted ? context.colors.income : goal.color,
            ),
            if (goal.deadline != null) ...[
              const SizedBox(height: 8),
              Text(
                goal.isCompleted
                    ? 'Цель достигнута!'
                    : (goal.daysLeft != null && goal.daysLeft! < 0)
                        ? 'Дедлайн прошёл'
                        : 'Осталось ${goal.daysLeft} дн.',
                style: context.text.caption.copyWith(
                  color: goal.isCompleted
                      ? context.colors.income
                      : (goal.daysLeft != null && goal.daysLeft! < 0)
                          ? context.colors.expense
                          : context.colors.textTertiary,
                ),
              ),
            ] else if (goal.isCompleted) ...[
              const SizedBox(height: 8),
              Text(
                'Цель достигнута!',
                style: context.text.caption.copyWith(color: context.colors.income),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
