import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import 'category_avatar.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({super.key, required this.transaction});

  final TransactionEntity transaction;

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.type == TransactionType.income;
    final amountColor = isIncome ? AppColors.income : AppColors.textPrimary;
    final sign = isIncome ? '+' : '−';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CategoryAvatar(category: transaction.category),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.category.name, style: AppTypography.title),
                const SizedBox(height: 2),
                Text(
                  transaction.note?.isNotEmpty == true
                      ? '${formatDate(transaction.date)} · ${transaction.note}'
                      : formatDate(transaction.date),
                  style: AppTypography.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '$sign${formatAmount(transaction.amount)}',
            style: AppTypography.amountMedium.copyWith(color: amountColor),
          ),
        ],
      ),
    );
  }
}
