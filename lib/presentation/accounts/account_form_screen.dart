import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/banks.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/account_entity.dart';

class AccountFormScreen extends ConsumerStatefulWidget {
  const AccountFormScreen({super.key, this.existing});

  final AccountEntity? existing;

  @override
  ConsumerState<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends ConsumerState<AccountFormScreen> {
  late final TextEditingController _nameController;
  late Color _color;
  String? _bankId;
  bool _saving = false;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.name ?? '');
    _color = existing?.color ?? AppColors.categoryPalette.first;
    _bankId = existing?.bankId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canSave => _nameController.text.trim().isNotEmpty && !_saving;

  void _pickBank(BankPreset? bank) {
    Haptics.select();
    setState(() {
      _bankId = bank?.id;
      if (bank != null) {
        _color = bank.color;
        if (_nameController.text.trim().isEmpty) _nameController.text = bank.name;
      }
    });
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    final name = _nameController.text.trim();

    if (_isEditing) {
      await ref.read(accountRepositoryProvider).update(
            widget.existing!.copyWith(name: name, color: _color, bankId: _bankId, clearBank: _bankId == null),
          );
    } else {
      await ref.read(accountRepositoryProvider).create(name: name, color: _color, bankId: _bankId);
    }
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.accountFormTitleEdit : l10n.accountFormTitleNew),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(l10n.accountFormBankLabel, style: context.text.label),
            const SizedBox(height: 8),
            SizedBox(
              height: 84,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: BankCatalog.all.length + 1,
                separatorBuilder: (context, i) => const SizedBox(width: 12),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    return _BankChip(
                      label: l10n.accountFormNoBank,
                      monogram: '—',
                      color: context.colors.textTertiary,
                      selected: _bankId == null,
                      onTap: () => _pickBank(null),
                    );
                  }
                  final bank = BankCatalog.all[i - 1];
                  return _BankChip(
                    label: bank.name,
                    monogram: bank.monogram,
                    color: bank.color,
                    selected: _bankId == bank.id,
                    onTap: () => _pickBank(bank),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _nameController,
              autofocus: !_isEditing,
              style: context.text.title.copyWith(color: context.colors.textPrimary),
              decoration: InputDecoration(hintText: l10n.accountFormNameHint),
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

class _BankChip extends StatelessWidget {
  const _BankChip({
    required this.label,
    required this.monogram,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String monogram;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 64,
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.16),
                shape: BoxShape.circle,
                border: selected ? Border.all(color: color, width: 2) : null,
              ),
              child: Text(
                monogram,
                style: context.text.title.copyWith(color: color, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.text.caption.copyWith(
                color: selected ? color : context.colors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
