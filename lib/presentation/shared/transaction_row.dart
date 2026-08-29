import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../core/theme/app_page_route.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/haptics.dart';
import '../../data/providers/data_providers.dart';
import '../../domain/entities/transaction_entity.dart';
import '../add_transaction/add_transaction_screen.dart';
import 'transaction_tile.dart';

/// Строка транзакции со всеми жестами сразу — чтобы поведение на главном
/// экране и в истории не расходилось:
///   тап            — открыть на редактирование;
///   долгое нажатие — меню (повторить / изменить / удалить);
///   свайп влево    — удалить;
///   свайп вправо   — повторить сегодняшним днём.
class TransactionRow extends ConsumerWidget {
  const TransactionRow({super.key, required this.transaction});

  final TransactionEntity transaction;

  void _edit(BuildContext context) {
    Haptics.select();
    Navigator.of(context).push(
      fadeSlideRoute(AddTransactionScreen(existing: transaction)),
    );
  }

  void _repeat(BuildContext context) {
    Haptics.select();
    Navigator.of(context).push(
      fadeSlideRoute(AddTransactionScreen(prefill: transaction)),
    );
  }

  Future<void> _delete(WidgetRef ref) async {
    Haptics.delete();
    await ref.read(transactionRepositoryProvider).delete(transaction.id);
  }

  Future<void> _showMenu(BuildContext context, WidgetRef ref) async {
    Haptics.select();
    final l10n = context.l10n;

    final action = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: context.colors.surface,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.replay, color: context.colors.accent),
              title: Text(l10n.txActionRepeat, style: context.text.title),
              onTap: () => Navigator.pop(context, 'repeat'),
            ),
            ListTile(
              leading: Icon(Icons.edit_outlined, color: context.colors.textSecondary),
              title: Text(l10n.txActionEdit, style: context.text.title),
              onTap: () => Navigator.pop(context, 'edit'),
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: context.colors.expense),
              title: Text(
                l10n.commonDelete,
                style: context.text.title.copyWith(color: context.colors.expense),
              ),
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (!context.mounted || action == null) return;
    switch (action) {
      case 'repeat':
        _repeat(context);
      case 'edit':
        _edit(context);
      case 'delete':
        await _delete(ref);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: ValueKey(transaction.id),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(Icons.replay, color: context.colors.accent),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Icon(Icons.delete_outline, color: context.colors.expense),
      ),
      confirmDismiss: (direction) async {
        // Свайп вправо — не удаление: открываем повтор и возвращаем строку
        // на место, чтобы исходная транзакция осталась в списке.
        if (direction == DismissDirection.startToEnd) {
          _repeat(context);
          return false;
        }
        return true;
      },
      onDismissed: (_) => _delete(ref),
      child: GestureDetector(
        onTap: () => _edit(context),
        onLongPress: () => _showMenu(context, ref),
        child: TransactionTile(transaction: transaction),
      ),
    );
  }
}
