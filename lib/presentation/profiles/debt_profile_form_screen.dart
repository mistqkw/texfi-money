import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/debt_profile_entity.dart';

class DebtProfileFormScreen extends ConsumerStatefulWidget {
  const DebtProfileFormScreen({super.key, this.existing});

  final DebtProfileEntity? existing;

  @override
  ConsumerState<DebtProfileFormScreen> createState() => _DebtProfileFormScreenState();
}

class _DebtProfileFormScreenState extends ConsumerState<DebtProfileFormScreen> {
  late final TextEditingController _nameController;
  late Color _color;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _color = existing?.color ?? AppColors.categoryPalette.first;
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
    final name = _nameController.text.trim();

    if (_isEditing) {
      final repo = ref.read(debtProfileRepositoryProvider);
      await repo.update(
        DebtProfileEntity(
          id: widget.existing!.id,
          name: name,
          balance: widget.existing!.balance,
          color: _color,
          createdAt: widget.existing!.createdAt,
        ),
      );
    } else {
      await ref.read(debtProfileRepositoryProvider).create(name: name, color: _color);
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.profileFormTitleEdit : l10n.profileFormTitleNew),
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
              controller: _nameController,
              autofocus: !_isEditing,
              style: context.text.title.copyWith(color: context.colors.textPrimary),
              decoration: InputDecoration(hintText: l10n.profileFormNameHint),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 24),
            Text(l10n.commonColor, style: context.text.label),
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
                child: Text(_isEditing ? l10n.commonSave : l10n.commonCreate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
