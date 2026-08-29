import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../shared/category_avatar.dart';
import '../shared/category_providers.dart';
import '../shared/l10n_helpers.dart';
import '../shared/terminal_divider.dart';
import '../shared/transaction_tile.dart';
import 'history_providers.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  TransactionType? _type;
  String? _categoryId;
  DateTimeRange? _period;

  TransactionFilter get _filter => TransactionFilter(
        type: _type,
        categoryId: _categoryId,
        from: _period?.start,
        to: _period?.end,
      );

  bool get _hasActiveFilters => _type != null || _categoryId != null || _period != null;

  Future<void> _pickType() async {
    final l10n = context.l10n;
    final result = await showModalBottomSheet<TransactionType?>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.largeAll),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SheetOption(
              label: l10n.historyAllTypes,
              selected: _type == null,
              onTap: () => Navigator.pop(context),
            ),
            _SheetOption(
              label: l10n.commonIncome,
              selected: _type == TransactionType.income,
              onTap: () => Navigator.pop(context, TransactionType.income),
            ),
            _SheetOption(
              label: l10n.commonExpense,
              selected: _type == TransactionType.expense,
              onTap: () => Navigator.pop(context, TransactionType.expense),
            ),
          ],
        ),
      ),
    );
    setState(() => _type = result);
  }

  Future<void> _pickCategory() async {
    final categories = await ref.read(allCategoriesProvider.future);
    if (!mounted) return;
    final l10n = context.l10n;

    final result = await showModalBottomSheet<String?>(
      context: context,
      backgroundColor: context.colors.surface,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.largeAll),
      builder: (context) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            _SheetOption(
              label: l10n.historyAllCategories,
              selected: _categoryId == null,
              onTap: () => Navigator.pop(context),
            ),
            for (final CategoryEntity category in categories)
              _SheetOption(
                label: categoryDisplayName(context, category),
                selected: category.id == _categoryId,
                leading: CategoryAvatar(category: category, size: 32),
                onTap: () => Navigator.pop(context, category.id),
              ),
          ],
        ),
      ),
    );
    setState(() => _categoryId = result);
  }

  Future<void> _pickPeriod() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: _period,
    );
    if (picked == null) return;
    setState(() {
      _period = DateTimeRange(
        start: DateTime(picked.start.year, picked.start.month, picked.start.day),
        end: DateTime(picked.end.year, picked.end.month, picked.end.day, 23, 59, 59),
      );
    });
  }

  void _resetFilters() {
    setState(() {
      _type = null;
      _categoryId = null;
      _period = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(filteredTransactionsProvider(_filter));
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final l10n = context.l10n;

    String? categoryName;
    if (_categoryId != null) {
      for (final category in categoriesAsync.valueOrNull ?? const <CategoryEntity>[]) {
        if (category.id == _categoryId) {
          categoryName = categoryDisplayName(context, category);
          break;
        }
      }
    }

    final periodFormat = DateFormat('d.MM.yy', intlLocale(context.localeCode));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _FilterChip(
                  label: switch (_type) {
                    TransactionType.income => l10n.commonIncome,
                    TransactionType.expense => l10n.commonExpense,
                    null => l10n.historyTypeFilterLabel,
                  },
                  active: _type != null,
                  onTap: _pickType,
                ),
                _FilterChip(
                  label: categoryName ?? l10n.historyCategoryFilterLabel,
                  active: _categoryId != null,
                  onTap: _pickCategory,
                ),
                _FilterChip(
                  label: _period == null
                      ? l10n.historyPeriodFilterLabel
                      : '${periodFormat.format(_period!.start)} – ${periodFormat.format(_period!.end)}',
                  active: _period != null,
                  onTap: _pickPeriod,
                ),
                if (_hasActiveFilters)
                  _FilterChip(
                    label: l10n.historyReset,
                    active: false,
                    onTap: _resetFilters,
                    icon: Icons.close,
                  ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                if (transactions.isEmpty) {
                  return Center(
                    child: Text(l10n.historyEmpty, style: context.text.body),
                  );
                }
                final grouped = _groupByDay(transactions);
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                  itemCount: grouped.length,
                  itemBuilder: (context, i) {
                    final item = grouped[i];
                    if (item is DateTime) {
                      return Padding(
                        padding: EdgeInsets.only(top: i == 0 ? 0 : 16, bottom: 8),
                        child: TerminalDivider(label: formatDate(item, context)),
                      );
                    }
                    final tx = item as TransactionEntity;
                    return Dismissible(
                      key: ValueKey(tx.id),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Icon(Icons.delete_outline, color: context.colors.expense),
                      ),
                      onDismissed: (_) {
                        Haptics.delete();
                        ref.read(transactionRepositoryProvider).delete(tx.id);
                      },
                      child: TransactionTile(transaction: tx),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text(l10n.historyLoadError, style: context.text.body)),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.active, required this.onTap, this.icon});

  final String label;
  final bool active;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? context.colors.accent.withValues(alpha: 0.16) : context.colors.surfaceVariant,
          borderRadius: AppRadius.smallAll,
          border: active ? Border.all(color: context.colors.accent, width: 1) : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: context.text.label.copyWith(
                color: active ? context.colors.accent : context.colors.textSecondary,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 4),
              Icon(icon, size: 14, color: context.colors.textSecondary),
            ] else ...[
              const SizedBox(width: 4),
              Icon(Icons.expand_more, size: 16, color: active ? context.colors.accent : context.colors.textTertiary),
            ],
          ],
        ),
      ),
    );
  }
}

class _SheetOption extends StatelessWidget {
  const _SheetOption({required this.label, required this.selected, required this.onTap, this.leading});

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(label, style: context.text.title),
      trailing: selected ? Icon(Icons.check, color: context.colors.accent) : null,
      onTap: onTap,
    );
  }
}

/// Список отсортирован по дате убывания (см. `TransactionRepository.watchAll`).
/// Разбивает его на плоский список [DateTime] (маркер дня) / [TransactionEntity].
List<Object> _groupByDay(List<TransactionEntity> transactions) {
  final result = <Object>[];
  DateTime? lastDay;
  for (final tx in transactions) {
    final day = DateTime(tx.date.year, tx.date.month, tx.date.day);
    if (lastDay == null || day != lastDay) {
      result.add(day);
      lastDay = day;
    }
    result.add(tx);
  }
  return result;
}
