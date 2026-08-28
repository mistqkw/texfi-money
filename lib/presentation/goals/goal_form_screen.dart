import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../settings/currency_provider.dart';

class GoalFormScreen extends ConsumerStatefulWidget {
  const GoalFormScreen({super.key, this.existing});

  final SavingsGoalEntity? existing;

  @override
  ConsumerState<GoalFormScreen> createState() => _GoalFormScreenState();
}

class _GoalFormScreenState extends ConsumerState<GoalFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _targetController;
  DateTime? _deadline;
  late Color _color;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _titleController = TextEditingController(text: existing?.title ?? '');
    _targetController = TextEditingController(
      text: existing != null ? existing.targetAmount.toStringAsFixed(0) : '',
    );
    _deadline = existing?.deadline;
    _color = existing?.color ?? AppColors.categoryPalette.first;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _targetController.dispose();
    super.dispose();
  }

  double get _target => double.tryParse(_targetController.text.replaceAll(',', '.')) ?? 0;

  bool get _canSave =>
      _titleController.text.trim().isNotEmpty && _target > 0 && !_saving;

  Future<void> _pickDeadline() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _deadline ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );
    if (picked != null) setState(() => _deadline = picked);
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    final title = _titleController.text.trim();

    if (_isEditing) {
      final repo = ref.read(savingsGoalRepositoryProvider);
      await repo.update(widget.existing!.copyWith(
        title: title,
        targetAmount: _target,
        deadline: _deadline,
        clearDeadline: _deadline == null,
        color: _color,
      ));
    } else {
      await ref.read(savingsGoalRepositoryProvider).create(
            title: title,
            targetAmount: _target,
            deadline: _deadline,
            color: _color,
          );
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    final deadlineText = _deadline == null
        ? 'Без дедлайна'
        : DateFormat('d MMMM yyyy', 'ru_RU').format(_deadline!);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Изменить цель' : 'Новая цель'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            TextField(
              controller: _titleController,
              autofocus: !_isEditing,
              style: context.text.title.copyWith(color: context.colors.textPrimary),
              decoration: const InputDecoration(hintText: 'Название цели, например «ПК»'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text('Целевая сумма', style: context.text.label),
            const SizedBox(height: 8),
            TextField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              style: context.text.amountLarge,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: '0 ${currency.symbol}'),
            ),
            const SizedBox(height: 24),
            Text('Дедлайн', style: context.text.label),
            const SizedBox(height: 8),
            InkWell(
              onTap: _pickDeadline,
              borderRadius: AppRadius.mediumAll,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: context.colors.surfaceVariant,
                  borderRadius: AppRadius.mediumAll,
                ),
                child: Row(
                  children: [
                    Icon(Icons.event_outlined, size: 20, color: context.colors.textSecondary),
                    const SizedBox(width: 12),
                    Expanded(child: Text(deadlineText, style: context.text.title)),
                    if (_deadline != null)
                      IconButton(
                        icon: Icon(Icons.clear, size: 18, color: context.colors.textTertiary),
                        onPressed: () => setState(() => _deadline = null),
                      )
                    else
                      Icon(Icons.chevron_right, color: context.colors.textTertiary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Цвет', style: context.text.label),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppColors.categoryPalette.map((color) {
                final isSelected = color.toARGB32() == _color.toARGB32();
                return GestureDetector(
                  onTap: () => setState(() => _color = color),
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(color: context.colors.textPrimary, width: 2)
                          : null,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 18)
                        : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSave ? _save : null,
                child: Text(_isEditing ? 'Сохранить' : 'Создать'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
