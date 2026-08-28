import 'category_entity.dart';
import 'transaction_type.dart';

class TransactionEntity {
  const TransactionEntity({
    required this.id,
    required this.amount,
    required this.type,
    required this.category,
    required this.date,
    this.note,
    this.accountId,
    required this.createdAt,
  });

  final String id;
  final double amount;
  final TransactionType type;
  final CategoryEntity category;
  final DateTime date;
  final String? note;
  final String? accountId;
  final DateTime createdAt;

  /// Со знаком: расход отрицателен, доход положителен.
  double get signedAmount =>
      type == TransactionType.expense ? -amount : amount;
}
