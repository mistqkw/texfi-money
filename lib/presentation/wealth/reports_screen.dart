import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../settings/analysis_range_provider.dart';
import '../settings/currency_provider.dart';
import '../shared/app_title.dart';
import '../shared/category_providers.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_segments.dart';
import '../shared/pixel_spinner.dart';
import '../shared/pixel_switch.dart';

/// Параметры отчёта.
class ReportQuery {
  const ReportQuery({
    required this.from,
    required this.to,
    this.categoryId,
    this.type,
    this.byYear = false,
  });

  final DateTime from;
  final DateTime to;
  final String? categoryId;
  final TransactionType? type;

  /// Группировать по годам вместо месяцев.
  final bool byYear;

  @override
  bool operator ==(Object other) =>
      other is ReportQuery &&
      other.from == from &&
      other.to == to &&
      other.categoryId == categoryId &&
      other.type == type &&
      other.byYear == byYear;

  @override
  int get hashCode => Object.hash(from, to, categoryId, type, byYear);
}

/// Отчёт — выборка по существующим данным, а не новое хранилище.
///
/// Считается поверх того же запроса транзакций, что и остальные экраны:
/// иного источника цифр в приложении нет и заводить его незачем.
final reportProvider = FutureProvider.family<
    List<({DateTime bucket, double total, int count})>,
    ReportQuery>((ref, query) async {
  final transactions = await ref
      .watch(transactionRepositoryProvider)
      .watchAll(
        TransactionFilter(
          from: query.from,
          to: query.to,
          categoryId: query.categoryId,
          type: query.type,
        ),
      )
      .first;

  final buckets = <DateTime, ({double total, int count})>{};
  for (final tx in transactions) {
    final key = query.byYear
        ? DateTime(tx.date.year)
        : DateTime(tx.date.year, tx.date.month);
    final current = buckets[key] ?? (total: 0.0, count: 0);
    buckets[key] = (total: current.total + tx.amount, count: current.count + 1);
  }

  final keys = buckets.keys.toList()..sort();
  return [
    for (final key in keys)
      (bucket: key, total: buckets[key]!.total, count: buckets[key]!.count),
  ];
});

/// Гибкая выборка поверх уже накопленных данных.
///
/// Отдельный экран, а не фильтры в истории: история отвечает на вопрос
/// «что было», отчёт — «сколько вышло». Это разные вопросы, и списку
/// операций незачем превращаться в конструктор запросов.
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  String? _categoryId;
  TransactionType _type = TransactionType.expense;
  bool _byYear = false;
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final categories =
        ref.watch(categoriesByTypeProvider(_type)).valueOrNull ?? const [];

    final fallback = ref.watch(analysisRangeProvider).resolve(DateTime.now());
    final from = _range?.start ?? fallback.from;
    final to = _range?.end ?? fallback.to;

    final report = ref.watch(
      reportProvider(
        ReportQuery(
          from: from,
          to: to,
          categoryId: _categoryId,
          type: _type,
          byYear: _byYear,
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: AppTitle(l10n.reportsTitle)),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          PixelCard(
            label: l10n.reportsPeriod.toUpperCase(),
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
                initialDateRange: DateTimeRange(start: from, end: to),
              );
              if (picked != null) setState(() => _range = picked);
            },
            child: Text(
              '${formatDate(from, context)} — ${formatDate(to, context)}',
              style: context.text.body,
            ),
          ),
          AppSpacing.gapLg,
          // Здесь стоял Material SegmentedButton — капсула со скруглением
          // в половину высоты и сплошной заливкой, единственная на всё
          // приложение. Тот же переключатель, что на вкладках-группах и в
          // форме транзакции, с семантическим цветом выбора.
          PixelSegments(
            padding: EdgeInsets.zero,
            labels: [l10n.commonExpense, l10n.commonIncome],
            currentIndex: _type == TransactionType.expense ? 0 : 1,
            selectedColor: _type == TransactionType.expense
                ? context.colors.expense
                : context.colors.income,
            onSelected: (index) => setState(() {
              _type = index == 0 ? TransactionType.expense : TransactionType.income;
              // Категория относится к типу: оставить её при смене значило бы
              // показать отчёт, в который заведомо ничего не попадёт.
              _categoryId = null;
            }),
          ),
          AppSpacing.gapLg,
          PixelCard(
            label: l10n.reportsCategory.toUpperCase(),
            child: Column(
              children: [
                _CategoryRow(
                  label: l10n.reportsAllCategories,
                  selected: _categoryId == null,
                  onTap: () => setState(() => _categoryId = null),
                ),
                for (final category in categories)
                  _CategoryRow(
                    label: category.name,
                    category: category,
                    selected: _categoryId == category.id,
                    onTap: () => setState(() => _categoryId = category.id),
                  ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          PixelCard(
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _byYear ? l10n.reportsGroupByYear : l10n.reportsGroupByMonth,
                    style: context.text.title,
                  ),
                ),
                PixelSwitch(
                  value: _byYear,
                  onChanged: (value) => setState(() => _byYear = value),
                ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          report.when(
            data: (rows) {
              if (rows.isEmpty) {
                return Text(
                  l10n.reportsEmpty,
                  style:
                      context.text.body.copyWith(color: colors.textSecondary),
                );
              }
              final total =
                  rows.fold<double>(0, (sum, row) => sum + row.total);
              final max = rows
                  .map((row) => row.total)
                  .reduce((a, b) => a > b ? a : b);

              return PixelCard(
                label: l10n.reportsTotal.toUpperCase(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatAmount(total, currency, context),
                      style: context.text.amountLarge,
                    ),
                    AppSpacing.gapMd,
                    for (final row in rows)
                      _ReportRow(
                        label: _byYear
                            ? '${row.bucket.year}'
                            : '${row.bucket.month.toString().padLeft(2, '0')}.'
                                '${row.bucket.year}',
                        amount: formatAmount(row.total, currency, context),
                        count: row.count,
                        // Доля от самой большой строки, а не от суммы:
                        // так видно соотношение между периодами, ради
                        // которого на разбивку и смотрят.
                        fraction: max == 0 ? 0 : row.total / max,
                      ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: PixelSpinner()),
            error: (e, st) =>
                Text(l10n.reportsEmpty, style: context.text.body),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.label,
    required this.selected,
    required this.onTap,
    this.category,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final CategoryEntity? category;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            PixelIcon(
              category == null
                  ? PixelIcons.category
                  : PixelIcons.forCategoryKey(category!.iconKey),
              size: 18,
              color: category?.color ?? colors.textSecondary,
            ),
            AppSpacing.gapHMd,
            Expanded(child: Text(label, style: context.text.body)),
            if (selected)
              PixelIcon(PixelIcons.check, size: 16, color: colors.accent),
          ],
        ),
      ),
    );
  }
}

class _ReportRow extends StatelessWidget {
  const _ReportRow({
    required this.label,
    required this.amount,
    required this.count,
    required this.fraction,
  });

  final String label;
  final String amount;
  final int count;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(label, style: context.text.body)),
              Text(
                '$count',
                style:
                    context.text.caption.copyWith(color: colors.textTertiary),
              ),
              AppSpacing.gapHSm,
              Text(amount, style: context.text.mono),
            ],
          ),
          AppSpacing.gapXs,
          LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Container(height: 6, color: colors.surfaceVariant),
                Container(
                  height: 6,
                  width: constraints.maxWidth * fraction.clamp(0, 1),
                  color: colors.accent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
