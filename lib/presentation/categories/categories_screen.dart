import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../shared/category_avatar.dart';
import '../shared/category_providers.dart';
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Удалить категорию?'),
        content: Text('Категория «${category.name}» будет удалена без возможности восстановления.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Отмена'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Удалить'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await ref.read(categoryRepositoryProvider).delete(category.id);
    } on StateError catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(allCategoriesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Категории')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
      body: categoriesAsync.when(
        data: (categories) {
          final expense = categories.where((c) => c.type == TransactionType.expense).toList();
          final income = categories.where((c) => c.type == TransactionType.income).toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
            children: [
              _SectionHeader('Расходы'),
              ...expense.map((c) => _CategoryRow(
                    category: c,
                    onTap: c.isCustom ? () => _openForm(context, category: c) : null,
                    onDelete: c.isCustom ? () => _confirmDelete(context, ref, c) : null,
                  )),
              const SizedBox(height: 24),
              _SectionHeader('Доходы'),
              ...income.map((c) => _CategoryRow(
                    category: c,
                    onTap: c.isCustom ? () => _openForm(context, category: c) : null,
                    onDelete: c.isCustom ? () => _confirmDelete(context, ref, c) : null,
                  )),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Не удалось загрузить категории', style: context.text.body)),
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
            Expanded(child: Text(category.name, style: context.text.title)),
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
