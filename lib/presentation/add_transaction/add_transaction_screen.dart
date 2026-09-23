import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_page_transitions.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/account_entity.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/spend_usefulness.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../accounts/account_providers.dart';
import '../categories/category_form_screen.dart';
import '../settings/currency_provider.dart';
import '../shared/category_chip.dart';
import '../shared/category_providers.dart';
import '../shared/pixel_button.dart';
import '../shared/pixel_card.dart';
import '../shared/pixel_icon.dart';
import '../shared/pixel_segments.dart';
import '../shared/pixel_spinner.dart';
import '../wealth/wealth_labels.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  const AddTransactionScreen({super.key, this.existing, this.prefill});

  /// Транзакция, которую редактируем. null — создаём новую.
  final TransactionEntity? existing;

  /// Транзакция-образец для повтора: поля подставляются, но сохранение
  /// создаёт новую запись сегодняшним днём.
  final TransactionEntity? prefill;

  @override
  ConsumerState<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  late TransactionType _type;
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  /// Оценка полезности. `null` — не оценивал, и это осмысленное значение,
  /// а не «ещё не выбрал»: большинство трат так и останутся без оценки.
  SpendUsefulness? _usefulness;
  String? _selectedCategoryId;
  String? _selectedAccountId;
  late DateTime _date;
  bool _saving = false;
  int _bounceTrigger = 0;

  bool get _isEditing => widget.existing != null;

  double get _amount =>
      double.tryParse(_amountController.text.replaceAll(',', '.')) ?? 0;

  bool get _canSave => _amount > 0 && _selectedCategoryId != null && !_saving;

  @override
  void initState() {
    super.initState();
    // Повтор подставляет всё, кроме даты — она всегда сегодняшняя.
    final source = widget.existing ?? widget.prefill;
    _type = source?.type ?? TransactionType.expense;
    _date = widget.existing?.date ?? DateTime.now();
    _selectedCategoryId = source?.category.id;
    _selectedAccountId = source?.accountId;
    _usefulness = source?.usefulness;
    if (source != null) {
      _amountController.text = source.amount == source.amount.roundToDouble()
          ? source.amount.toStringAsFixed(0)
          : source.amount.toString();
      _noteController.text = source.note ?? '';
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _onTypeChanged(TransactionType type) {
    if (type == _type) return;
    Haptics.select();
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
      pixelDissolveRoute(CategoryFormScreen(initialType: _type)),
    );
    if (created != null) setState(() => _selectedCategoryId = created.id);
  }

  Future<void> _handleSave() async {
    if (!_canSave) return;
    final repo = ref.read(transactionRepositoryProvider);

    // Отклик тем весомее, чем сильнее сумма выбивается из привычной
    // для этой категории — крупную трату чувствуешь, не глядя на экран.
    final reference = await repo.averageAmount(type: _type, categoryId: _selectedCategoryId);
    final weight = Haptics.weightFor(amount: _amount, reference: reference);
    _type == TransactionType.income ? Haptics.income(weight) : Haptics.expense(weight);

    if (!mounted) return;
    setState(() {
      _saving = true;
      _bounceTrigger++;
    });

    await Future.delayed(AppMotion.fast);
    final note = _noteController.text.trim().isEmpty ? null : _noteController.text.trim();

    if (_isEditing) {
      await repo.update(
        id: widget.existing!.id,
        amount: _amount,
        type: _type,
        categoryId: _selectedCategoryId!,
        date: _date,
        note: note,
        accountId: _selectedAccountId,
        usefulness: _usefulness,
      );
    } else {
      await repo.add(
        amount: _amount,
        type: _type,
        categoryId: _selectedCategoryId!,
        date: _date,
        note: note,
        accountId: _selectedAccountId,
        usefulness: _usefulness,
      );
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesByTypeProvider(_type));
    final accountsAsync = ref.watch(allAccountsProvider);

    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.addTxTitleEdit : l10n.addTxTitle),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const PixelIcon(PixelIcons.close),
          onPressed: () => Navigator.of(context).pop(false),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screen,
          children: [
            _TypeToggle(type: _type, onChanged: _onTypeChanged),
            AppSpacing.gapXl,
            _AmountField(controller: _amountController, onChanged: () => setState(() {})),
            AppSpacing.gapXl,
            Text(l10n.commonCategory.toUpperCase(), style: context.text.mono),
            AppSpacing.gapSm,
            categoriesAsync.when(
              data: (categories) => _CategoryGrid(
                categories: categories,
                selectedId: _selectedCategoryId,
                onSelected: (id) => setState(() => _selectedCategoryId = id),
                onAddCategory: _addCategory,
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: PixelSpinner()),
              ),
              error: (e, st) => Text(l10n.addTxLoadCategoriesError, style: context.text.body),
            ),
            accountsAsync.maybeWhen(
              data: (accounts) {
                if (accounts.isEmpty) return const SizedBox.shrink();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSpacing.gapXl,
                    Text(l10n.addTxAccountLabel.toUpperCase(), style: context.text.mono),
                    AppSpacing.gapSm,
                    _AccountRow(
                      accounts: accounts,
                      selectedId: _selectedAccountId,
                      onSelected: (id) => setState(() => _selectedAccountId = id),
                    ),
                  ],
                );
              },
              orElse: () => const SizedBox.shrink(),
            ),
            AppSpacing.gapXl,
            _DateRow(date: _date, onTap: _pickDate),
            // Оценка полезности — только у расходов: спрашивать, стоил ли
            // того полученный доход, бессмысленно.
            if (_type == TransactionType.expense) ...[
              AppSpacing.gapLg,
              _UsefulnessRow(
                value: _usefulness,
                onChanged: (value) => setState(() => _usefulness = value),
              ),
            ],
            AppSpacing.gapLg,
            TextField(
              controller: _noteController,
              style: context.text.body.copyWith(color: context.colors.textPrimary),
              decoration: InputDecoration(hintText: l10n.addTxNoteHint),
            ),
            AppSpacing.gapXxl,
            PixelButton(
              label: l10n.commonSave,
              busy: _saving,
              onPressed: _canSave ? _handleSave : null,
            )
                .animate(key: ValueKey(_bounceTrigger))
                .scaleXY(end: 1.06, duration: 80.ms, curve: Curves.easeOut)
                .then()
                .scaleXY(end: 1.0, duration: 110.ms, curve: Curves.elasticOut),
          ],
        ),
      ),
    );
  }
}

/// Расход/доход. Тот же переключатель, что и на вкладках-группах, а не
/// собственная реализация: здесь была своя, со скруглением 8 и сплошной
/// синей заливкой выбранного сегмента — на экран приходилось два разных
/// переключателя, различающихся ровно ничем по смыслу.
///
/// Цвет выбранного сегмента семантический: расход красный, доход зелёный.
/// Подменять это фирменным синим значило бы прятать то, что пользователь
/// читает по цвету быстрее, чем по слову.
class _TypeToggle extends StatelessWidget {
  const _TypeToggle({required this.type, required this.onChanged});

  final TransactionType type;
  final ValueChanged<TransactionType> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isExpense = type == TransactionType.expense;

    return PixelSegments(
      padding: EdgeInsets.zero,
      labels: [context.l10n.commonExpense, context.l10n.commonIncome],
      currentIndex: isExpense ? 0 : 1,
      selectedColor: isExpense ? colors.expense : colors.income,
      onSelected: (index) => onChanged(
        index == 0 ? TransactionType.expense : TransactionType.income,
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

    // Сумма — главное поле экрана, и раньше оно им не выглядело: число
    // стояло по центру пустоты, без рамки и подписи, так что поле читалось
    // как случайный «0» посреди экрана. Теперь это карточка с меткой, как
    // баланс на главной.
    return PixelCard(
      accent: true,
      label: context.l10n.addTxAmountLabel.toUpperCase(),
      padding: const EdgeInsets.fromLTRB(AppSpacing.page, AppSpacing.lg, AppSpacing.page, AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: (_) => onChanged(),
              autofocus: true,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              style: context.text.balance,
              decoration: InputDecoration(
                hintText: '0',
                hintStyle: context.text.balance.copyWith(color: context.colors.textTertiary),
                filled: false,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          AppSpacing.gapHMd,
          Text(
            currency.symbol,
            style: context.text.balance.copyWith(color: context.colors.textSecondary),
          ),
        ],
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
    // Сетка в две равные колонки вместо свободного переноса. Чипы
    // шириной по длине названия давали рваный правый край и строки то из
    // одного, то из двух элементов — список из десяти категорий выглядел
    // так, будто его собрали не глядя.
    final cells = <Widget>[
      for (final category in categories)
        CategorySelectChip(
          category: category,
          selected: category.id == selectedId,
          onTap: () => onSelected(category.id),
        ),
      GestureDetector(
        onTap: onAddCategory,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: context.colors.surface,
            borderRadius: AppRadius.cardSmallAll,
            border: Border.all(
              color: context.colors.border,
              width: AppRadius.pixelBorder,
            ),
          ),
          child: Row(
            children: [
              PixelIcon(PixelIcons.add, size: 20, color: context.colors.textSecondary),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  context.l10n.addTxAddCategory,
                  style: context.text.label.copyWith(color: context.colors.textPrimary),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    ];

    return Column(
      children: [
        for (var row = 0; row < (cells.length + 1) ~/ 2; row++) ...[
          if (row > 0) AppSpacing.gapMd,
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(child: cells[row * 2]),
                AppSpacing.gapHMd,
                // Нечётный хвост: пустая ячейка вместо растягивания
                // последнего чипа на всю ширину — иначе он читался бы как
                // выделенный, хотя ничем не отличается от соседей.
                Expanded(
                  child: row * 2 + 1 < cells.length
                      ? cells[row * 2 + 1]
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _AccountRow extends StatelessWidget {
  const _AccountRow({required this.accounts, required this.selectedId, required this.onSelected});

  final List<AccountEntity> accounts;
  final String? selectedId;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _chip(context, null, context.l10n.addTxNoAccount, context.colors.textSecondary),
        for (final account in accounts) _chip(context, account.id, account.name, account.color),
      ],
    );
  }

  Widget _chip(BuildContext context, String? id, String label, Color color) {
    final selected = id == selectedId;
    return GestureDetector(
      onTap: () => onSelected(id),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? color.withValues(alpha: 0.16) : context.colors.surface,
          borderRadius: AppRadius.cardSmallAll,
          border: Border.all(
            color: selected ? color : context.colors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: context.text.title),
          ],
        ),
      ),
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
      borderRadius: AppRadius.cardSmallAll,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: context.colors.surfaceVariant,
          borderRadius: AppRadius.cardSmallAll,
        ),
        child: Row(
          children: [
            PixelIcon(PixelIcons.calendar, size: 20, color: context.colors.textSecondary),
            const SizedBox(width: AppSpacing.md),
            Expanded(child: Text(formatDate(date, context), style: context.text.title)),
            PixelIcon(PixelIcons.chevronRight, color: context.colors.textTertiary),
          ],
        ),
      ),
    );
  }
}

/// Выбор полезности траты.
///
/// Три кнопки и возможность снять выбор повторным нажатием. Снять важно:
/// поставленная сгоряча оценка иначе осталась бы навсегда, а «не
/// оценивал» — это отдельное состояние, к которому надо уметь вернуться.
class _UsefulnessRow extends StatelessWidget {
  const _UsefulnessRow({required this.value, required this.onChanged});

  final SpendUsefulness? value;
  final ValueChanged<SpendUsefulness?> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    Color colorFor(SpendUsefulness item) => switch (item) {
          SpendUsefulness.useful => colors.income,
          SpendUsefulness.useless => colors.expense,
          SpendUsefulness.neutral => colors.textSecondary,
        };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.usefulnessLabel.toUpperCase(),
          style: context.text.label.copyWith(color: colors.textTertiary),
        ),
        AppSpacing.gapSm,
        Row(
          children: [
            for (final item in SpendUsefulness.values) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(value == item ? null : item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: value == item
                            ? colorFor(item)
                            : colors.border,
                        width: 2,
                      ),
                      color: value == item
                          ? colorFor(item).withValues(alpha: 0.12)
                          : null,
                    ),
                    child: Text(
                      usefulnessLabel(l10n, item),
                      textAlign: TextAlign.center,
                      style: context.text.caption.copyWith(
                        color: value == item
                            ? colorFor(item)
                            : colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              ),
              if (item != SpendUsefulness.values.last) AppSpacing.gapHSm,
            ],
          ],
        ),
      ],
    );
  }
}
