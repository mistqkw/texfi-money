import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../categories/category_form_screen.dart';
import '../settings/currency_provider.dart';
import '../shared/category_chip.dart';
import '../shared/category_providers.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  TransactionType _type = TransactionType.expense;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String? _selectedCategoryId;
  DateTime _date = DateTime.now();
  bool _saving = false;
  int _bounceTrigger = 0;

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

  bool get _canSave => _amount > 0 && _selectedCategoryId != null && !_saving;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType type) {
    if (type == _type) return;
    setState(() {
      _type = type;
      _selectedCategoryId = null;
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _addCategory() async {
    final created = await Navigator.of(context).push<CategoryEntity>(
      fadeSlideRoute(CategoryFormScreen(initialType: _type)),
    );
    if (created != null) setState(() => _selectedCategoryId = created.id);
  }

  Future<void> _handleSave() async {
    if (!_canSave) return;
    setState(() {
      _saving = true;
      _bounceTrigger++;
    });

    await Future.delayed(AppMotion.fast);
    await ref.read(transactionRepositoryProvider).add(
          amount: _amount,
          type: _type,
          categoryId: _selectedCategoryId!,
          date: _date,
          note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        );

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesByTypeProvider(_type));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Новая транзакция'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            _TypeToggle(type: _type, onChanged: _onTypeChanged),
            const SizedBox(height: 24),
            _AmountField(controller: _amountController, onChanged: () => setState(() {})),
            const SizedBox(height: 24),
            Text('Категория', style: AppTypography.label),
            const SizedBox(height: 8),
            categoriesAsync.when(
              data: (categories) => _CategoryGrid(
                categories: categories,
                selectedId: _selectedCategoryId,
                onSelected: (id) => setState(() => _selectedCategoryId = id),
                onAddCategory: _addCategory,
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, st) => Text('Не удалось загрузить категории', style: AppTypography.body),
            ),
            const SizedBox(height: 24),
            _DateRow(date: _date, onTap: _pickDate),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              style: AppTypography.body.copyWith(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Заметка (необязательно)'),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave ? _handleSave : null,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Сохранить'),
              )
                  .animate(key: ValueKey(_bounceTrigger))
                  .scaleXY(end: 1.06, duration: 120.ms, curve: Curves.easeOut)
                  .then()
                  .scaleXY(end: 1.0, duration: 150.ms, curve: Curves.elasticOut),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.type, required this.onChanged});

  final TransactionType type;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: AppRadius.mediumAll,
      ),
      child: Row(
        children: [
          _segment(context, TransactionType.expense, 'Расход'),
          _segment(context, TransactionType.income, 'Доход'),
        ],
      ),
    );
  }

  Widget _segment(BuildContext context, TransactionType value, String label) {
    final selected = value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: AppMotion.fast,
          curve: AppMotion.standard,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.accent : Colors.transparent,
            borderRadius: AppRadius.smallAll,
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.title.copyWith(
              color: selected ? AppColors.onAccent : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

class _AmountField extends ConsumerWidget {
  const _AmountField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);

    return TextField(
      controller: controller,
      onChanged: (_) => onChanged(),
      autofocus: true,
      textAlign: TextAlign.center,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
      style: AppTypography.balance,
      decoration: InputDecoration(
        hintText: '0 ${currency.symbol}',
        hintStyle: AppTypography.balance.copyWith(color: AppColors.textTertiary),
        filled: false,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  const _CategoryGrid({
    required this.categories,
    required this.selectedId,
    required this.onSelected,
    required this.onAddCategory,
  });

  final List<CategoryEntity> categories;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final VoidCallback onAddCategory;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        ...categories.map((category) => CategorySelectChip(
              category: category,
              selected: category.id == selectedId,
              onTap: () => onSelected(category.id),
            )),
        GestureDetector(
          onTap: onAddCategory,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.mediumAll,
              border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add, size: 20, color: AppColors.textSecondary),
                const SizedBox(width: 6),
                Text('Своя категория', style: AppTypography.title),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mediumAll,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: AppRadius.mediumAll,
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_outlined, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Expanded(child: Text(formatDate(date), style: AppTypography.title)),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
