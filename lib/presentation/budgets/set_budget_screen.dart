import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../settings/currency_provider.dart';
import '../shared/category_avatar.dart';
import '../shared/category_chip.dart';
import '../shared/category_providers.dart';
import '../shared/l10n_helpers.dart';
import 'budgets_providers.dart';

/// Создание или редактирование месячного лимита по категории.
class SetBudgetScreen extends ConsumerStatefulWidget {
  const SetBudgetScreen({super.key, this.existing});

  final BudgetEntity? existing;

  @override
  ConsumerState<SetBudgetScreen> createState() => _SetBudgetScreenState();
}

class _SetBudgetScreenState extends ConsumerState<SetBudgetScreen> {
  String? _categoryId;
  late final TextEditingController _amountController;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _categoryId = widget.existing?.category.id;
    _amountController = TextEditingController(
      text: widget.existing != null ? widget.existing!.monthlyLimit.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  double get _amount => double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

  bool get _canSave => _amount > 0 && _categoryId != null && !_saving;

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    await ref
        .read(budgetRepositoryProvider)
        .setLimit(categoryId: _categoryId!, monthlyLimit: _amount);
    if (mounted) Navigator.of(context).pop(true);
  }

  Future<void> _delete() async {
    await ref.read(budgetRepositoryProvider).delete(widget.existing!.id);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.setBudgetTitleEdit : l10n.setBudgetTitleNew),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isEditing)
            IconButton(icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            if (_isEditing) ...[
              Row(
                children: [
                  CategoryAvatar(category: widget.existing!.category),
                  const SizedBox(width: 12),
                  Text(
                    categoryDisplayName(context, widget.existing!.category),
                    style: context.text.headline,
                  ),
                ],
              ),
            ] else ...[
              Text(l10n.commonCategory, style: context.text.label),
              const SizedBox(height: 8),
              _CategoryPicker(
                selectedId: _categoryId,
                onSelected: (id) => setState(() => _categoryId = id),
              ),
            ],
            const SizedBox(height: 24),
            Text(l10n.setBudgetLimitLabel, style: context.text.label),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              autofocus: !_isEditing,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              style: context.text.amountLarge,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: '0 ${currency.symbol}'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave ? _save : null,
                child: Text(_isEditing ? l10n.commonSave : l10n.commonCreate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryPicker extends ConsumerWidget {
  const _CategoryPicker({required this.selectedId, required this.onSelected});

  final String? selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesByTypeProvider(TransactionType.expense));
    final budgetsAsync = ref.watch(currentMonthBudgetsProvider);
    final l10n = context.l10n;

    return categoriesAsync.when(
      data: (categories) {
        final usedIds = budgetsAsync.valueOrNull?.map((b) => b.category.id).toSet() ?? {};
        final available = categories.where((c) => !usedIds.contains(c.id)).toList();

        if (available.isEmpty) {
          return Text(
            l10n.setBudgetNoCategoriesLeft,
            style: context.text.body,
          );
        }

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: available.map((category) {
            return CategorySelectChip(
              category: category,
              selected: category.id == selectedId,
              onTap: () => onSelected(category.id),
            );
          }).toList(),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, st) => Text(l10n.setBudgetLoadCategoriesError, style: context.text.body),
    );
  }
}
