import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/category_total.dart';
import '../../domain/entities/monthly_total.dart';
import '../settings/currency_provider.dart';
import '../shared/category_avatar.dart';
import 'statistics_providers.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyAsync = ref.watch(monthlyTotalsProvider);
    final categoryAsync = ref.watch(expenseCategoryTotalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Статистика')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          Text('Доходы и расходы по месяцам', style: AppTypography.headline),
          const SizedBox(height: 16),
          monthlyAsync.when(
            data: (months) => _MonthlyBarChart(months: months),
            loading: () => const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => Text('Не удалось загрузить данные', style: AppTypography.body),
          ),
          const SizedBox(height: 32),
          Text('Расходы по категориям в этом месяце', style: AppTypography.headline),
          const SizedBox(height: 16),
          categoryAsync.when(
            data: (categories) => _CategoryPie(categories: categories),
            loading: () => const SizedBox(
              height: 220,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, st) => Text('Не удалось загрузить данные', style: AppTypography.body),
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

    return Container(
      height: 240,
      padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.largeAll),
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
                  final label = DateFormat('LLL', 'ru_RU').format(months[index].month);
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(label, style: AppTypography.caption),
                  );
                },
              ),
            ),
          ),
          barGroups: [
            for (int i = 0; i < months.length; i++)
              BarChartGroupData(
                x: i,
                barsSpace: 4,
                barRods: [
                  BarChartRodData(
                    toY: months[i].income,
                    color: AppColors.income,
                    width: 8,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  BarChartRodData(
                    toY: months[i].expense,
                    color: AppColors.expense,
                    width: 8,
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
      return Container(
        height: 160,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.largeAll),
        child: Text('Нет расходов в этом месяце', style: AppTypography.body),
      );
    }

    final total = categories.fold<double>(0, (sum, c) => sum + c.total);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: AppRadius.largeAll),
      child: Column(
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
                    titleStyle: AppTypography.caption.copyWith(
                      color: AppColors.onAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: categories.map((c) {
              final percent = total <= 0 ? 0 : c.total / total * 100;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    CategoryAvatar(category: c.category, size: 28),
                    const SizedBox(width: 10),
                    Expanded(child: Text(c.category.name, style: AppTypography.title)),
                    Text(
                      '${percent.toStringAsFixed(0)}% · ${formatAmount(c.total, currency)}',
                      style: AppTypography.caption,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
