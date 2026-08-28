import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/category_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_motion.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_typography.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';

/// Форма создания или редактирования категории.
/// При создании возвращает [CategoryEntity], при редактировании — `true`.
class CategoryFormScreen extends ConsumerStatefulWidget {
  const CategoryFormScreen({super.key, this.initial, this.initialType});

  final CategoryEntity? initial;
  final TransactionType? initialType;

  @override
  ConsumerState<CategoryFormScreen> createState() => _CategoryFormScreenState();
}

class _CategoryFormScreenState extends ConsumerState<CategoryFormScreen> {
  late final TextEditingController _nameController;
  late TransactionType _type;
  late String _iconKey;
  late Color _color;
  bool _saving = false;

  bool get _isEditing => widget.initial != null;

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _type = initial?.type ?? widget.initialType ?? TransactionType.expense;
    _iconKey = initial?.iconKey ?? CategoryIcons.catalog.keys.first;
    _color = initial?.color ?? AppColors.categoryPalette.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty && !_saving;

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    final repo = ref.read(categoryRepositoryProvider);
    final name = _nameController.text.trim();

    if (_isEditing) {
      await repo.update(widget.initial!.copyWith(
        name: name,
        iconKey: _iconKey,
        color: _color,
      ));
      if (mounted) Navigator.of(context).pop(true);
    } else {
      final created = await repo.create(
        name: name,
        iconKey: _iconKey,
        colorValue: _color.toARGB32(),
        type: _type,
      );
      if (mounted) Navigator.of(context).pop(created);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Редактировать категорию' : 'Новая категория'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            if (!_isEditing) ...[
              _TypeToggle(
                type: _type,
                onChanged: (t) => setState(() => _type = t),
              ),
              const SizedBox(height: 24),
            ],
            TextField(
              controller: _nameController,
              autofocus: !_isEditing,
              style: AppTypography.title.copyWith(color: AppColors.textPrimary),
              decoration: const InputDecoration(hintText: 'Название категории'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text('Иконка', style: AppTypography.label),
            const SizedBox(height: 8),
            _IconPicker(
              selectedKey: _iconKey,
              color: _color,
              onSelected: (key) => setState(() => _iconKey = key),
            ),
            const SizedBox(height: 24),
            Text('Цвет', style: AppTypography.label),
            const SizedBox(height: 8),
            _ColorPicker(
              selected: _color,
              onSelected: (color) => setState(() => _color = color),
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
          _segment(TransactionType.expense, 'Расход'),
          _segment(TransactionType.income, 'Доход'),
        ],
      ),
    );
  }

  Widget _segment(TransactionType value, String label) {
    final selected = value == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => onChanged(value),
        child: AnimatedContainer(
          duration: AppMotion.fast,
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

class _IconPicker extends StatelessWidget {
  const _IconPicker({
    required this.selectedKey,
    required this.color,
    required this.onSelected,
  });

  final String selectedKey;
  final Color color;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: CategoryIcons.catalog.entries.map((entry) {
        final selected = entry.key == selectedKey;
        return GestureDetector(
          onTap: () => onSelected(entry.key),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: selected ? color.withValues(alpha: 0.18) : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? color : AppColors.divider,
                width: selected ? 1.5 : 1,
              ),
            ),
            child: Icon(entry.value, color: selected ? color : AppColors.textSecondary),
          ),
        );
      }).toList(),
    );
  }
}

class _ColorPicker extends StatelessWidget {
  const _ColorPicker({required this.selected, required this.onSelected});

  final Color selected;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: AppColors.categoryPalette.map((color) {
        final isSelected = color.toARGB32() == selected.toARGB32();
        return GestureDetector(
          onTap: () => onSelected(color),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.textPrimary, width: 2)
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 18)
                : null,
          ),
        );
      }).toList(),
    );
  }
}
