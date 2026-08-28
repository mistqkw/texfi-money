import '../entities/category_total.dart';
import '../entities/monthly_total.dart';
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

  @override
  bool operator ==(Object other) {
    return other is TransactionFilter &&
        other.from == from &&
        other.to == to &&
        other.categoryId == categoryId &&
        other.type == type;
  }

  @override
  int get hashCode => Object.hash(from, to, categoryId, type);
}

abstract class TransactionRepository {
  Stream<List<TransactionEntity>> watchAll(TransactionFilter filter);
  Stream<List<TransactionEntity>> watchRecent({int limit = 5});

  /// Сумма доходов и расходов за месяц, содержащий [month].
  Stream<({double income, double expense})> watchMonthlySummary(DateTime month);

  /// Общий баланс за всё время.
  Stream<double> watchTotalBalance();

  /// Доходы/расходы по месяцам: последние [monthsCount] месяцев, включая текущий.
  Stream<List<MonthlyTotal>> watchMonthlyTotals(int monthsCount);

  /// Разбивка по категориям заданного типа за месяц, содержащий [month].
  Stream<List<CategoryTotal>> watchCategoryTotals({
    required DateTime month,
    required TransactionType type,
  });

  Future<String> add({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String? note,
    String? accountId,
  });

  Future<void> delete(String id);
}
