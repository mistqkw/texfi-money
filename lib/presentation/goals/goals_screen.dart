import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../core/utils/image_storage.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/animated_progress_bar.dart';
import '../shared/empty_state.dart';
import '../shared/pixel_fab.dart';
import '../shared/terminal_box.dart';
import 'goal_form_screen.dart';
import 'goals_providers.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  Future<void> _addContribution(BuildContext context, WidgetRef ref, SavingsGoalEntity goal) async {
    final currency = ref.read(currencyProvider);
    final l10n = context.l10n;
    final controller = TextEditingController();
    final amount = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.goalsAddFundsTitle(goal.title)),
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
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () {
              final value = double.tryParse(controller.text.replaceAll(',', '.')) ?? 0;
              Navigator.of(context).pop(value);
            },
            child: Text(l10n.commonAdd),
          ),
        ],
      ),
    );

    if (amount == null || amount <= 0) return;

    // Взнос, которым цель закрывается, заслуживает большего, чем обычное
    // «готово»: короткая нарастающая фанфара.
    final reachesGoal =
        !goal.isCompleted && goal.currentAmount + amount >= goal.targetAmount;
    reachesGoal ? Haptics.celebrate() : Haptics.success();

    await ref.read(savingsGoalRepositoryProvider).addContribution(id: goal.id, amount: amount);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref, SavingsGoalEntity goal) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.goalsDeleteTitle),
        content: Text(l10n.goalsDeleteConfirm(goal.title)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.commonCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.commonDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      Haptics.delete();
      await ref.read(savingsGoalRepositoryProvider).delete(goal.id);
      await deleteImageIfExists(goal.imagePath);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.goalsTitle)),
      floatingActionButton: PixelFab(
        onPressed: () {
          Haptics.select();
          Navigator.of(context).push(fadeSlideRoute(const GoalFormScreen()));
        },
      ),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return EmptyState(icon: Icons.flag_outlined, message: l10n.goalsEmpty);
          }
          return ListView.separated(
            padding: AppSpacing.screenWithFab,
            itemCount: goals.length,
            separatorBuilder: (context, i) => AppSpacing.gapMd,
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
        error: (e, st) => Center(child: Text(l10n.goalsLoadError, style: context.text.body)),
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
    final l10n = context.l10n;

    return TerminalBox(
      label: goal.title.toLowerCase(),
      labelColor: goal.isCompleted ? context.colors.income : goal.color,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: goal.color.withValues(alpha: 0.16),
                backgroundImage: goal.imagePath != null ? FileImage(File(goal.imagePath!)) : null,
                child: goal.imagePath == null
                    ? Icon(
                        goal.isCompleted ? Icons.check_circle_outline : Icons.savings_outlined,
                        color: goal.color,
                        size: 18,
                      )
                    : null,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(child: Text(goal.title, style: context.text.title)),
              IconButton(
                tooltip: l10n.goalsAddFundsTitle(goal.title),
                icon: Icon(Icons.add_circle_outline, color: context.colors.accent),
                onPressed: onAddFunds,
              ),
            ],
          ),
          AppSpacing.gapXs,
          Text(
            l10n.goalsProgressOf(
              formatAmount(goal.currentAmount, currency, context),
              formatAmount(goal.targetAmount, currency, context),
            ),
            style: context.text.caption,
          ),
          AppSpacing.gapMd,
          AnimatedProgressBar(
            progress: goal.progress,
            color: goal.isCompleted ? context.colors.income : goal.color,
          ),
          if (goal.deadline != null) ...[
            AppSpacing.gapSm,
            Text(
              goal.isCompleted
                  ? l10n.goalsAchieved
                  : (goal.daysLeft != null && goal.daysLeft! < 0)
                      ? l10n.goalsDeadlinePassed
                      : l10n.goalsDaysLeft(goal.daysLeft ?? 0),
              style: context.text.caption.copyWith(
                color: goal.isCompleted
                    ? context.colors.income
                    : (goal.daysLeft != null && goal.daysLeft! < 0)
                        ? context.colors.expense
                        : context.colors.textTertiary,
              ),
            ),
          ] else if (goal.isCompleted) ...[
            AppSpacing.gapSm,
            Text(
              l10n.goalsAchieved,
              style: context.text.caption.copyWith(color: context.colors.income),
            ),
          ],
        ],
      ),
    );
  }
}
