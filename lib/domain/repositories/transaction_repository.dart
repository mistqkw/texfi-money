import '../entities/transaction_entity.dart';
import '../entities/transaction_type.dart';

class TransactionFilter {
  const TransactionFilter({
    this.from,
    this.to,
    this.categoryId,
    this.type,
  });

  final DateTime? from;
  final DateTime? to;
  final String? categoryId;
  final TransactionType? type;
}

abstract class TransactionRepository {
  Stream<List<TransactionEntity>> watchAll(TransactionFilter filter);
  Stream<List<TransactionEntity>> watchRecent({int limit = 5});

  /// Сумма доходов и расходов за месяц, содержащий [month].
  Stream<({double income, double expense})> watchMonthlySummary(DateTime month);

  /// Общий баланс за всё время.
  Stream<double> watchTotalBalance();

  Future<String> add({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String? note,
  });

  Future<void> delete(String id);
}
