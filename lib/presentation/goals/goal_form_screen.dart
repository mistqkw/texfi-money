import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../core/utils/haptics.dart';
import '../../core/utils/image_storage.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/savings_goal_entity.dart';
import '../settings/currency_provider.dart';
import '../shared/color_picker_row.dart';

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
  String? _imagePath;
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
    _imagePath = existing?.imagePath;
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

  Future<void> _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;
    final savedPath = await savePickedImage(picked);
    if (!mounted) return;
    Haptics.select();
    setState(() => _imagePath = savedPath);
  }

  void _removeImage() {
    Haptics.select();
    setState(() => _imagePath = null);
  }

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
    Haptics.success();
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
        imagePath: _imagePath,
        clearImage: _imagePath == null,
      ));
    } else {
      await ref.read(savingsGoalRepositoryProvider).create(
            title: title,
            targetAmount: _target,
            deadline: _deadline,
            color: _color,
            imagePath: _imagePath,
          );
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final currency = ref.watch(currencyProvider);
    final l10n = context.l10n;
    final deadlineText =
        _deadline == null ? l10n.goalFormNoDeadline : formatFullDate(_deadline!, context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.goalFormTitleEdit : l10n.goalFormTitleNew),
        leading: IconButton(
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: AppSpacing.screen,
          children: [
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 44,
                      backgroundColor: _color.withValues(alpha: 0.16),
                      backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                      child: _imagePath == null
                          ? Icon(Icons.add_a_photo_outlined, color: _color, size: 28)
                          : null,
                    ),
                  ),
                  if (_imagePath != null)
                    Positioned(
                      right: -4,
                      top: -4,
                      child: GestureDetector(
                        onTap: _removeImage,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: context.colors.expense,
                          child: const Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AppSpacing.gapXl,
            TextField(
              controller: _titleController,
              autofocus: !_isEditing,
              style: context.text.title.copyWith(color: context.colors.textPrimary),
              decoration: InputDecoration(hintText: l10n.goalFormNameHint),
              onChanged: (_) => setState(() {}),
            ),
            AppSpacing.gapXl,
            Text(l10n.goalFormTargetLabel, style: context.text.label),
            AppSpacing.gapSm,
            TextField(
              controller: _targetController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              style: context.text.amountLarge,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(hintText: '0 ${currency.symbol}'),
            ),
            AppSpacing.gapXl,
            Text(l10n.goalFormDeadlineLabel, style: context.text.label),
            AppSpacing.gapSm,
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
                    const SizedBox(width: AppSpacing.md),
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
            AppSpacing.gapXl,
            Text(l10n.commonColor, style: context.text.label),
            AppSpacing.gapSm,
            ColorPickerRow(
              selected: _color,
              onSelected: (color) => setState(() => _color = color),
            ),
            AppSpacing.gapXxl,
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
