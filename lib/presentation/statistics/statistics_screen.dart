import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/category_total.dart';
import '../../domain/entities/monthly_total.dart';
import '../../domain/entities/spend_usefulness.dart';
import '../settings/currency_provider.dart';
import '../shared/app_title.dart';
import '../shared/empty_state.dart';
import '../shared/l10n_helpers.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_charts.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_spinner.dart';
import '../wealth/wealth_labels.dart';
import '../wealth/wealth_providers.dart';
import 'statistics_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key, this.embedded = false});

  /// Экран открыт как сегмент внутри вкладки-группы: заголовок и
  /// переключатель сегментов рисует хозяин, свой AppBar здесь был бы
  /// вторым подряд.
  final bool embedded;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyTotalsProvider);
    final categoryAsync = ref.watch(expenseCategoryTotalsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: embedded ? null : AppBar(title: AppTitle(l10n.statisticsTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          // Заголовки живут в метке рамки, как на остальных экранах, —
          // отдельная строка над карточкой здесь была единственным местом,
          // выпадавшим из общего языка.
          PixelCard(
            label: l10n.statisticsMonthlyChartTitle.toUpperCase(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: monthlyAsync.when(
              data: (months) => _MonthlyBarChart(months: months),
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: PixelSpinner()),
              ),
              error: (e, st) => SizedBox(
                height: 150,
                child: Center(
                  child: Text(l10n.statisticsLoadError, style: context.text.body),
                ),
              ),
            ),
          ),
          AppSpacing.gapLg,
          PixelCard(
            label: l10n.statisticsCategoryChartTitle.toUpperCase(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: categoryAsync.when(
              data: (categories) => _CategoryPie(categories: categories),
              loading: () => const SizedBox(
                height: 150,
                child: Center(child: PixelSpinner()),
              ),
              error: (e, st) => SizedBox(
                height: 150,
                child: Center(
                  child: Text(l10n.statisticsLoadError, style: context.text.body),
                ),
              ),
            ),
          ),
          AppSpacing.gapLg,
          const _UsefulnessSection(),
        ],
      ),
    );
  }
}

/// Разбивка расходов по собственной оценке полезности.
///
/// Показывается только тогда, когда оценки вообще есть. У человека,
/// который ими не пользуется, это была бы карточка с одной строкой «без
/// оценки — сто процентов»: место занимает, не говорит ничего.
class _UsefulnessSection extends ConsumerWidget {
  const _UsefulnessSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final now = DateTime.now();
    final totals = ref
            .watch(
              usefulnessTotalsProvider((
                from: DateTime(now.year, now.month),
                to: DateTime(now.year, now.month + 1)
                    .subtract(const Duration(days: 1)),
              )),
            )
            .valueOrNull ??
        const <SpendUsefulness?, double>{};

    final rated = totals.entries.where((e) => e.key != null).toList();
    if (rated.isEmpty) return const SizedBox.shrink();

    final sum = totals.values.fold<double>(0, (acc, value) => acc + value);
    final ordered = [
      for (final value in SpendUsefulness.values)
        if (totals[value] != null) MapEntry(value, totals[value]!),
      // «Без оценки» идёт последним и намеренно остаётся видимым: доля
      // неоценённого — это тоже ответ на вопрос, насколько картине можно
      // верить.
      if (totals[null] != null) MapEntry(null, totals[null]!),
    ];

    Color colorFor(SpendUsefulness? value) => switch (value) {
          SpendUsefulness.useful => colors.income,
          SpendUsefulness.useless => colors.expense,
          SpendUsefulness.neutral => colors.textSecondary,
          null => colors.textTertiary,
        };

    return PixelCard(
      label: l10n.usefulnessSection.toUpperCase(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (final entry in ordered) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    usefulnessLabel(l10n, entry.key),
                    style: context.text.body.copyWith(color: colorFor(entry.key)),
                  ),
                ),
                Text(
                  formatAmount(entry.value, currency, context),
                  style: context.text.mono,
                ),
                AppSpacing.gapHSm,
                SizedBox(
                  width: 44,
                  child: Text(
                    sum == 0
                        ? '0%'
                        : '${(entry.value / sum * 100).toStringAsFixed(0)}%',
                    textAlign: TextAlign.right,
                    style: context.text.mono
                        .copyWith(color: colors.textTertiary),
                  ),
                ),
              ],
            ),
            AppSpacing.gapSm,
          ],
          Text(
            l10n.usefulnessHint,
            style: context.text.caption.copyWith(color: colors.textTertiary),
          ),
        ],
      ),
    );
  }
}

class _MonthlyBarChart extends StatelessWidget {
  const _MonthlyBarChart({required this.months});

  final List<MonthlyTotal> months;

  @override
  Widget build(BuildContext context) {
    return PixelBarChart(
      groups: [
        for (final month in months)
          (
            label: formatMonthShort(month.month, context),
            income: month.income,
            expense: month.expense,
          ),
      ],
      incomeColor: context.colors.income,
      expenseColor: context.colors.expense,
    );
  }
}

class _CategoryPie extends ConsumerWidget {
  const _CategoryPie({required this.categories});

  final List<CategoryTotal> categories;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    if (categories.isEmpty) {
      return EmptyState(
        sprite: PixelIcons.statistics,
        message: context.l10n.statisticsNoExpenses,
      );
    }

    final total = categories.fold<double>(0, (sum, c) => sum + c.total);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PixelShareBar(
          shares: [
            for (final c in categories) (value: c.total, color: c.category.color),
          ],
        ),
        AppSpacing.gapLg,
        for (final c in categories)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Row(
              children: [
                PixelSwatch(color: c.category.color),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    categoryDisplayName(context, c.category),
                    style: context.text.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Text(
                  total <= 0 ? '0%' : '${(c.total / total * 100).toStringAsFixed(0)}%',
                  style: context.text.mono,
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  formatAmount(c.total, currency, context),
                  style: context.text.amountMedium,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
