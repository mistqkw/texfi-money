import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/asset_entity.dart';
import '../../domain/entities/cash_flow_type.dart';
import '../settings/currency_provider.dart';
import '../shared/pixel_icon.dart';
import '../shared/terminal_box.dart';
import 'wealth_labels.dart';
import 'wealth_providers.dart';

/// Создание и правка актива.
///
/// Тип денежного потока и уровень риска выбираются руками и один раз —
/// приложение не пытается вывести их из названия или категории. Оно и не
/// смогло бы: «машина» бывает и рабочим инструментом, который кормит, и
/// вещью, которая только ест бензин, и знает об этом только владелец.
class AssetFormScreen extends ConsumerStatefulWidget {
  const AssetFormScreen({super.key, this.existing});

  final AssetEntity? existing;

  @override
  ConsumerState<AssetFormScreen> createState() => _AssetFormScreenState();
}

class _AssetFormScreenState extends ConsumerState<AssetFormScreen> {
  late final TextEditingController _name =
      TextEditingController(text: widget.existing?.name ?? '');
  late final TextEditingController _value = TextEditingController(
    text: widget.existing == null
        ? ''
        : widget.existing!.currentValue.toStringAsFixed(2),
  );
  late final TextEditingController _note =
      TextEditingController(text: widget.existing?.note ?? '');

  late String? _categoryId = widget.existing?.category.id;
  late String? _riskId = widget.existing?.riskLevel.id;
  late CashFlowType _flow = widget.existing?.cashFlowType ?? CashFlowType.neutral;
  DateTime _valuedAt = DateTime.now();

  bool get _isNew => widget.existing == null;

  @override
  void dispose() {
    _name.dispose();
    _value.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _name.text.trim();
    final value = double.tryParse(_value.text.replaceAll(',', '.'));
    final categoryId = _categoryId;
    final riskId = _riskId;
    if (name.isEmpty || categoryId == null || riskId == null) return;

    final repository = ref.read(assetRepositoryProvider);
    final note = _note.text.trim().isEmpty ? null : _note.text.trim();

    if (_isNew) {
      if (value == null) return;
      await repository.create(
        name: name,
        categoryId: categoryId,
        riskLevelId: riskId,
        cashFlowType: _flow,
        value: value,
        valuedAt: _valuedAt,
      );
    } else {
      // Стоимость здесь не меняется намеренно: у неё своя кнопка и своя
      // дата. Правка названия не должна молча дописывать точку в историю
      // сегодняшним числом.
      await repository.update(
        id: widget.existing!.id,
        name: name,
        categoryId: categoryId,
        riskLevelId: riskId,
        cashFlowType: _flow,
        note: note,
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final categories = ref.watch(assetCategoriesProvider).valueOrNull ?? const [];
    final levels = ref.watch(riskLevelsProvider).valueOrNull ?? const [];

    _categoryId ??= categories.isEmpty ? null : categories.first.id;
    _riskId ??= levels.isEmpty ? null : levels.first.id;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isNew ? l10n.assetNew : l10n.assetEdit),
        actions: [
          if (!_isNew)
            IconButton(
              icon: PixelIcon(PixelIcons.danger, color: colors.expense),
              tooltip: l10n.assetDelete,
              onPressed: _confirmDelete,
            ),
        ],
      ),
      body: ListView(
        padding: AppSpacing.screen,
        children: [
          TerminalBox(
            label: l10n.assetName.toLowerCase(),
            child: TextField(
              controller: _name,
              decoration: const InputDecoration(border: InputBorder.none),
              style: context.text.body,
            ),
          ),
          AppSpacing.gapLg,
          if (_isNew) ...[
            TerminalBox(
              label: l10n.assetValue.toLowerCase(),
              child: TextField(
                controller: _value,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(border: InputBorder.none),
                style: context.text.amountMedium,
              ),
            ),
            AppSpacing.gapLg,
            TerminalBox(
              label: l10n.assetValuedAt.toLowerCase(),
              onTap: _pickDate,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatDate(_valuedAt, context),
                      style: context.text.body,
                    ),
                  ),
                  PixelIcon(
                    PixelIcons.history,
                    size: 16,
                    color: colors.textTertiary,
                  ),
                ],
              ),
            ),
            AppSpacing.gapLg,
          ],
          TerminalBox(
            label: l10n.assetFlow.toLowerCase(),
            child: Column(
              children: [
                for (final type in CashFlowType.values)
                  _ChoiceRow(
                    selected: _flow == type,
                    icon: cashFlowIcon(type),
                    label: cashFlowLabel(l10n, type),
                    color: switch (type) {
                      CashFlowType.income => colors.income,
                      CashFlowType.liability => colors.expense,
                      CashFlowType.neutral => colors.textSecondary,
                    },
                    onTap: () => setState(() => _flow = type),
                  ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          TerminalBox(
            label: l10n.assetCategory.toLowerCase(),
            child: Column(
              children: [
                for (final category in categories)
                  _ChoiceRow(
                    selected: _categoryId == category.id,
                    icon: PixelIcons.forCategoryKey(category.iconKey),
                    label: category.name,
                    color: category.color,
                    onTap: () => setState(() => _categoryId = category.id),
                  ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          TerminalBox(
            label: l10n.assetRisk.toLowerCase(),
            child: Column(
              children: [
                for (final level in levels)
                  _ChoiceRow(
                    selected: _riskId == level.id,
                    icon: PixelIcons.risk,
                    label: level.name,
                    color: level.color,
                    onTap: () => setState(() => _riskId = level.id),
                  ),
              ],
            ),
          ),
          AppSpacing.gapLg,
          TerminalBox(
            label: l10n.assetNote.toLowerCase(),
            child: TextField(
              controller: _note,
              maxLines: 2,
              decoration: const InputDecoration(border: InputBorder.none),
              style: context.text.body,
            ),
          ),
          if (!_isNew) ...[
            AppSpacing.gapLg,
            _HistorySection(asset: widget.existing!),
          ],
          AppSpacing.gapXl,
          FilledButton(
            onPressed: _save,
            child: Text(_isNew ? l10n.wealthAddAsset : l10n.commonSave),
          ),
        ],
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _valuedAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _valuedAt = picked);
  }

  Future<void> _confirmDelete() async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.assetDelete),
        content: Text(l10n.assetDeleteBody),
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
    if (confirmed != true || !mounted) return;
    await ref.read(assetRepositoryProvider).delete(widget.existing!.id);
    if (mounted) Navigator.of(context).pop();
  }
}

class _ChoiceRow extends StatelessWidget {
  const _ChoiceRow({
    required this.selected,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final bool selected;
  final List<String> icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            PixelIcon(icon, size: 18, color: color),
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

/// История стоимости и кнопка новой оценки.
class _HistorySection extends ConsumerWidget {
  const _HistorySection({required this.asset});

  final AssetEntity asset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final colors = context.colors;
    final currency = ref.watch(currencyProvider);
    final history =
        ref.watch(assetHistoryProvider(asset.id)).valueOrNull ?? const [];

    return TerminalBox(
      label: l10n.assetHistory.toLowerCase(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final point in history.reversed)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      formatDate(point.recordedAt, context),
                      style: context.text.caption
                          .copyWith(color: colors.textSecondary),
                    ),
                  ),
                  Text(
                    formatAmount(point.value, currency, context),
                    style: context.text.mono,
                  ),
                ],
              ),
            ),
          AppSpacing.gapSm,
          Text(
            l10n.assetHistoryHint,
            style: context.text.caption.copyWith(color: colors.textTertiary),
          ),
          AppSpacing.gapMd,
          OutlinedButton(
            onPressed: () => _revalue(context, ref),
            child: Text(l10n.assetRevalue),
          ),
        ],
      ),
    );
  }

  Future<void> _revalue(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final controller = TextEditingController();
    var date = DateTime.now();

    final value = await showDialog<double>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.assetRevalueTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
              ),
              AppSpacing.gapMd,
              // Дата отдельно: оценку вносят и задним числом — человек
              // узнаёт стоимость прошлого года и хочет поставить её туда,
              // где она была, а не туда, где он сейчас.
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: date,
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => date = picked);
                },
                child: Text(formatDate(date, context)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.commonCancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(
                double.tryParse(controller.text.replaceAll(',', '.')),
              ),
              child: Text(l10n.commonSave),
            ),
          ],
        ),
      ),
    );

    controller.dispose();
    if (value == null) return;
    await ref
        .read(assetRepositoryProvider)
        .revalue(assetId: asset.id, value: value, recordedAt: date);
  }
}
