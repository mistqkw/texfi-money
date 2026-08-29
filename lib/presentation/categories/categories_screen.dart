import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/category_repository.dart';
import '../shared/category_avatar.dart';
import '../shared/category_providers.dart';
import '../shared/l10n_helpers.dart';
import '../shared/press_scale.dart';
import 'category_form_screen.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  Future<void> _openForm(BuildContext context, {CategoryEntity? category}) {
    return Navigator.of(context).push(
      fadeSlideRoute(CategoryFormScreen(initial: category)),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    CategoryEntity category,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.categoriesDeleteTitle),
        content: Text(l10n.categoriesDeleteConfirm(categoryDisplayName(context, category))),
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
    if (confirmed != true) return;

    try {
      Haptics.delete();
      await ref.read(categoryRepositoryProvider).delete(category.id);
    } on CategoryInUseException {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.categoryDeleteHasTransactionsError)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(allCategoriesProvider);
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.categoriesTitle)),
      floatingActionButton: PressScale(
        child: FloatingActionButton(
          onPressed: () {
            Haptics.select();
            _openForm(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          final expense = categories.where((c) => c.type == TransactionType.expense).toList();
          final income = categories.where((c) => c.type == TransactionType.income).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            children: [
              _SectionHeader(l10n.categoriesExpenseSection),
              ...expense.map((c) => _CategoryRow(
                    category: c,
                    onTap: c.isCustom ? () => _openForm(context, category: c) : null,
                    onDelete: c.isCustom ? () => _confirmDelete(context, ref, c) : null,
                  )),
              const SizedBox(height: 24),
              _SectionHeader(l10n.categoriesIncomeSection),
              ...income.map((c) => _CategoryRow(
                    category: c,
                    onTap: c.isCustom ? () => _openForm(context, category: c) : null,
                    onDelete: c.isCustom ? () => _confirmDelete(context, ref, c) : null,
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text(l10n.categoriesLoadError, style: context.text.body)),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: context.text.headline),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({required this.category, this.onTap, this.onDelete});

  final CategoryEntity category;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            CategoryAvatar(category: category, size: 40),
            const SizedBox(width: 12),
            Expanded(
              child: Text(categoryDisplayName(context, category), style: context.text.title),
            ),
            if (onDelete != null)
              IconButton(
                icon: Icon(Icons.delete_outline, color: context.colors.textTertiary),
                onPressed: onDelete,
              )
            else
              Icon(Icons.lock_outline, color: context.colors.textTertiary, size: 18),
          ],
        ),
      ),
    );
  }
}
