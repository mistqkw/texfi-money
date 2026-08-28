import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/category_total.dart';
import '../../domain/entities/monthly_total.dart';
import '../../domain/entities/transaction_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../local/database.dart';
import 'category_repository_impl.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._db, this._categoryMapper);

  final AppDatabase _db;
  final CategoryRepositoryImpl _categoryMapper;
  final _uuid = const Uuid();

  TransactionEntity _mapRow(TypedResult row) {
    final tx = row.readTable(_db.transactions);
    final cat = row.readTable(_db.categories);
    return TransactionEntity(
      id: tx.id,
      amount: tx.amount,
      type: TransactionType.fromStorageKey(tx.type),
      category: _categoryMapper.mapRow(cat),
      date: tx.date,
      note: tx.note,
      createdAt: tx.createdAt,
    );
  }

  @override
  Stream<List<TransactionEntity>> watchAll(TransactionFilter filter) {
    final query = _db.select(_db.transactions).join([
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.transactions.categoryId),
      ),
    ]);

    if (filter.from != null) {
      query.where(_db.transactions.date.isBiggerOrEqualValue(filter.from!));
    }
    if (filter.to != null) {
      query.where(_db.transactions.date.isSmallerOrEqualValue(filter.to!));
    }
    if (filter.categoryId != null) {
      query.where(_db.transactions.categoryId.equals(filter.categoryId!));
    }
    if (filter.type != null) {
      query.where(_db.transactions.type.equals(filter.type!.storageKey));
    }
    query.orderBy([OrderingTerm.desc(_db.transactions.date)]);

    return query.watch().map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<List<TransactionEntity>> watchRecent({int limit = 5}) {
    final query = _db.select(_db.transactions).join([
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.transactions.categoryId),
      ),
    ])
      ..orderBy([OrderingTerm.desc(_db.transactions.date)])
      ..limit(limit);

    return query.watch().map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<({double income, double expense})> watchMonthlySummary(DateTime month) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final query = _db.select(_db.transactions)
      ..where((t) =>
          t.date.isBiggerOrEqualValue(start) & t.date.isSmallerThanValue(end));

    return query.watch().map((rows) {
      double income = 0;
      double expense = 0;
      for (final row in rows) {
        if (row.type == TransactionType.income.storageKey) {
          income += row.amount;
        } else {
          expense += row.amount;
        }
      }
      return (income: income, expense: expense);
    });
  }

  @override
  Stream<double> watchTotalBalance() {
    return _db.select(_db.transactions).watch().map((rows) {
      double balance = 0;
      for (final row in rows) {
        balance +=
            row.type == TransactionType.income.storageKey ? row.amount : -row.amount;
      }
      return balance;
    });
  }

  @override
  Stream<List<MonthlyTotal>> watchMonthlyTotals(int monthsCount) {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month - (monthsCount - 1), 1);
    final query = _db.select(_db.transactions)
      ..where((t) => t.date.isBiggerOrEqualValue(start));

    return query.watch().map((rows) {
      final months = List.generate(
        monthsCount,
        (i) => DateTime(now.year, now.month - (monthsCount - 1) + i, 1),
      );
      final income = List.filled(monthsCount, 0.0);
      final expense = List.filled(monthsCount, 0.0);

      for (final row in rows) {
        final index = months.indexWhere(
          (m) => m.year == row.date.year && m.month == row.date.month,
        );
        if (index == -1) continue;
        if (row.type == TransactionType.income.storageKey) {
          income[index] += row.amount;
        } else {
          expense[index] += row.amount;
        }
      }

      return List.generate(
        monthsCount,
        (i) => MonthlyTotal(month: months[i], income: income[i], expense: expense[i]),
      );
    });
  }

  @override
  Stream<List<CategoryTotal>> watchCategoryTotals({
    required DateTime month,
    required TransactionType type,
  }) {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final totalSum = _db.transactions.amount.sum();

    final query = _db.select(_db.transactions).join([
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.transactions.categoryId),
      ),
    ])
      ..where(_db.transactions.type.equals(type.storageKey) &
          _db.transactions.date.isBiggerOrEqualValue(start) &
          _db.transactions.date.isSmallerThanValue(end))
      ..addColumns([totalSum])
      ..groupBy([_db.transactions.categoryId]);

    return query.watch().map((rows) {
      final list = rows.map((row) {
        final category = row.readTable(_db.categories);
        final total = row.read(totalSum) ?? 0;
        return CategoryTotal(category: _categoryMapper.mapRow(category), total: total);
      }).toList();
      list.sort((a, b) => b.total.compareTo(a.total));
      return list;
    });
  }

  @override
  Future<String> add({
    required double amount,
    required TransactionType type,
    required String categoryId,
    required DateTime date,
    String? note,
  }) async {
    final id = _uuid.v4();
    await _db.into(_db.transactions).insert(TransactionsCompanion.insert(
          id: id,
          amount: amount,
          type: type.storageKey,
          categoryId: categoryId,
          date: date,
          note: Value(note),
        ));
    return id;
  }

  @override
  Future<void> delete(String id) {
    return (_db.delete(_db.transactions)..where((t) => t.id.equals(id))).go();
  }
}
