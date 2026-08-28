import 'package:drift/drift.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/account_entity.dart';
import '../../domain/entities/transaction_type.dart';
import '../../domain/repositories/account_repository.dart';
import '../local/database.dart';

class AccountRepositoryImpl implements AccountRepository {
  AccountRepositoryImpl(this._db);

  final AppDatabase _db;
  final _uuid = const Uuid();

  AccountEntity _mapRow(Account row) => AccountEntity(
        id: row.id,
        name: row.name,
        color: Color(row.colorValue),
        createdAt: row.createdAt,
      );

  @override
  Stream<List<AccountEntity>> watchAll() {
    return (_db.select(_db.accounts)
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.asc)]))
        .watch()
        .map((rows) => rows.map(_mapRow).toList());
  }

  @override
  Stream<double> watchBalance(String accountId) {
    final query = _db.select(_db.transactions)
      ..where((t) => t.accountId.equals(accountId));
    return query.watch().map((rows) {
      var total = 0.0;
      for (final row in rows) {
        total += row.type == TransactionType.income.storageKey ? row.amount : -row.amount;
      }
      return total;
    });
  }

  @override
  Future<String> create({required String name, required Color color}) async {
    final id = _uuid.v4();
    await _db.into(_db.accounts).insert(AccountsCompanion.insert(
          id: id,
          name: name,
          colorValue: color.toARGB32(),
        ));
    return id;
  }

  @override
  Future<void> update(AccountEntity account) {
    return (_db.update(_db.accounts)..where((t) => t.id.equals(account.id))).write(
      AccountsCompanion(
        name: Value(account.name),
        colorValue: Value(account.color.toARGB32()),
      ),
    );
  }

  @override
  Future<void> delete(String id) async {
    // Транзакции, привязанные к удаляемому счёту, не удаляются —
    // просто теряют привязку.
    await (_db.update(_db.transactions)..where((t) => t.accountId.equals(id))).write(
      const TransactionsCompanion(accountId: Value(null)),
    );
    await (_db.delete(_db.accounts)..where((t) => t.id.equals(id))).go();
  }
}
