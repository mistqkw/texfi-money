import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/category_total.dart';
import '../../domain/entities/monthly_total.dart';
import '../settings/currency_provider.dart';
import '../shared/category_avatar.dart';
import '../shared/empty_state.dart';
import '../shared/l10n_helpers.dart';
import '../shared/terminal_box.dart';
import 'statistics_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyTotalsProvider);
    final categoryAsync = ref.watch(expenseCategoryTotalsProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statisticsTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          // Заголовки живут в метке рамки, как на остальных экранах, —
          // отдельная строка над карточкой здесь была единственным местом,
          // выпадавшим из общего языка.
          TerminalBox(
            label: l10n.statisticsMonthlyChartTitle.toLowerCase(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.sm,
              AppSpacing.xl,
              AppSpacing.sm,
              AppSpacing.sm,
            ),
            child: monthlyAsync.when(
              data: (months) => _MonthlyBarChart(months: months),
              loading: () => const SizedBox(
                height: 208,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => SizedBox(
                height: 208,
                child: Center(
                  child: Text(l10n.statisticsLoadError, style: context.text.body),
                ),
              ),
            ),
          ),
          AppSpacing.gapLg,
          TerminalBox(
            label: l10n.statisticsCategoryChartTitle.toLowerCase(),
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.lg,
            ),
            child: categoryAsync.when(
              data: (categories) => _CategoryPie(categories: categories),
              loading: () => const SizedBox(
                height: 208,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => SizedBox(
                height: 208,
                child: Center(
                  child: Text(l10n.statisticsLoadError, style: context.text.body),
                ),
              ),
            ),
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
    final maxValue = months.fold<double>(
      0,
      (max, m) => [max, m.income, m.expense].reduce((a, b) => a > b ? a : b),
    );
    final maxY = maxValue <= 0 ? 100.0 : maxValue * 1.2;

    return SizedBox(
      height: 208,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 28,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();
                  if (index < 0 || index >= months.length) return const SizedBox.shrink();
                  final label = formatMonthShort(months[index].month, context);
                  return Padding(
                    padding: const EdgeInsets.only(top: AppSpacing.sm),
                    // Подписи осей — моноширинные, как и вся служебная
                    // типографика приложения.
                    child: Text(label, style: context.text.mono),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < months.length; i++)
              BarChartGroupData(
                x: i,
                barsSpace: AppSpacing.xs,
                barRods: [
                  BarChartRodData(
                    toY: months[i].income,
                    color: context.colors.income,
                    width: AppSpacing.sm,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  BarChartRodData(
                    toY: months[i].expense,
                    color: context.colors.expense,
                    width: AppSpacing.sm,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ],
              ),
          ],
        ),
      ),
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
        icon: Icons.pie_chart_outline,
        message: context.l10n.statisticsNoExpenses,
      );
    }

    final total = categories.fold<double>(0, (sum, c) => sum + c.total);

    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PieChart(
            PieChartData(
              sectionsSpace: 2,
              centerSpaceRadius: 48,
              sections: categories.map((c) {
                final percent = total <= 0 ? 0 : c.total / total * 100;
                return PieChartSectionData(
                  value: c.total,
                  color: c.category.color,
                  radius: 36,
                  showTitle: percent >= 8,
                  title: '${percent.toStringAsFixed(0)}%',
                  titleStyle: context.text.pixelAccent.copyWith(color: context.colors.onAccent),
                );
              }).toList(),
            ),
          ),
        ),
        AppSpacing.gapLg,
        Column(
          children: categories.map((c) {
            final percent = total <= 0 ? 0 : c.total / total * 100;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  CategoryAvatar(category: c.category, size: 28),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      categoryDisplayName(context, c.category),
                      style: context.text.title,
                    ),
                  ),
                  Text(
                    '${percent.toStringAsFixed(0)}% · ${formatAmount(c.total, currency, context)}',
                    style: context.text.caption,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
