import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors_ext.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles_ext.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../settings/currency_provider.dart';
import 'category_avatar.dart';
import 'l10n_helpers.dart';

class TransactionTile extends ConsumerWidget {
  const TransactionTile({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currency = ref.watch(currencyProvider);
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? context.colors.income : context.colors.textPrimary;
    final sign = isIncome ? '+' : '−';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CategoryAvatar(category: transaction.category),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(categoryDisplayName(context, transaction.category), style: context.text.title),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  transaction.note?.isNotEmpty == true
                      ? '${formatDate(transaction.date, context)} · ${transaction.note}'
                      : formatDate(transaction.date, context),
                  style: context.text.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '$sign${formatAmount(transaction.amount, currency, context)}',
            style: context.text.amountMedium.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}
