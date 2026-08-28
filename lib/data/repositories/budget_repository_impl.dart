import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/budget_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/budget_repository.dart';
import '../local/database.dart';
import 'category_repository_impl.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  BudgetRepositoryImpl(this._db, this._categoryMapper);

  final AppDatabase _db;
  final CategoryRepositoryImpl _categoryMapper;
  final _uuid = const Uuid();

  @override
  Stream<List<BudgetEntity>> watchAll(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final spentSum = _db.transactions.amount.sum();

    final query = _db.select(_db.budgets).join([
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.budgets.categoryId),
      ),
      leftOuterJoin(
        _db.transactions,
        _db.transactions.categoryId.equalsExp(_db.budgets.categoryId) &
            _db.transactions.type.equals(TransactionType.expense.storageKey) &
            _db.transactions.date.isBiggerOrEqualValue(start) &
            _db.transactions.date.isSmallerThanValue(end),
      ),
    ])
      ..addColumns([spentSum])
      ..groupBy([_db.budgets.id]);

    return query.watch().map((rows) {
      return rows.map((row) {
        final budget = row.readTable(_db.budgets);
        final category = row.readTable(_db.categories);
        final spent = row.read(spentSum) ?? 0;
        return BudgetEntity(
          id: budget.id,
          category: _categoryMapper.mapRow(category),
          monthlyLimit: budget.monthlyLimit,
          spent: spent,
        );
      }).toList();
    });
  }

  @override
  Future<void> setLimit({
    required String categoryId,
    required double monthlyLimit,
  }) async {
    final existing = await (_db.select(_db.budgets)
          ..where((t) => t.categoryId.equals(categoryId)))
        .getSingleOrNull();

    if (existing != null) {
      await (_db.update(_db.budgets)..where((t) => t.id.equals(existing.id)))
          .write(BudgetsCompanion(monthlyLimit: Value(monthlyLimit)));
    } else {
      await _db.into(_db.budgets).insert(BudgetsCompanion.insert(
            id: _uuid.v4(),
            categoryId: categoryId,
            monthlyLimit: monthlyLimit,
          ));
    }
  }

  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.budgets)..where((t) => t.id.equals(id))).go();
  }
}
