import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:texfi_money/data/local/backup_service.dart';
import 'package:texfi_money/data/local/database.dart';
import 'package:texfi_money/data/repositories/account_repository_impl.dart';
import 'package:texfi_money/data/repositories/category_repository_impl.dart';
import 'package:texfi_money/data/repositories/debt_profile_repository_impl.dart';
import 'package:texfi_money/data/repositories/transaction_repository_impl.dart';
import 'package:texfi_money/domain/entities/transaction_type.dart';
import 'package:texfi_money/domain/repositories/transaction_repository.dart';

void main() {
  test('экспорт и импорт бэкапа восстанавливают все данные', () async {
    final sourceDb = AppDatabase.forTesting(NativeDatabase.memory());
    final accountRepo = AccountRepositoryImpl(sourceDb);
    final txRepo = TransactionRepositoryImpl(sourceDb, CategoryRepositoryImpl(sourceDb));
    final debtRepo = DebtProfileRepositoryImpl(sourceDb);

    final accountId = await accountRepo.create(name: 'Карта', color: const Color(0xFF4A7DFB));
    await txRepo.add(
      amount: 1000,
      type: TransactionType.income,
      categoryId: 'cat_salary',
      date: DateTime(2026, 1, 10),
      accountId: accountId,
    );
    await txRepo.add(
      amount: 300,
      type: TransactionType.expense,
      categoryId: 'cat_groceries',
      date: DateTime(2026, 1, 12),
    );
    await debtRepo.create(name: 'Андрей', color: const Color(0xFFFEBC2E));

    final json = await BackupService(sourceDb).exportToJson();
    await sourceDb.close();

    final targetDb = AppDatabase.forTesting(NativeDatabase.memory());
    // В целевой базе уже есть предустановленные категории и одна лишняя
    // транзакция — импорт должен полностью заменить содержимое.
    await TransactionRepositoryImpl(targetDb, CategoryRepositoryImpl(targetDb)).add(
      amount: 50,
      type: TransactionType.expense,
      categoryId: 'cat_transport',
      date: DateTime.now(),
    );

    await BackupService(targetDb).restoreFromJson(json);

    final transactions =
        await TransactionRepositoryImpl(targetDb, CategoryRepositoryImpl(targetDb))
            .watchAll(const TransactionFilter())
            .first;
    expect(transactions.length, 2);
    expect(transactions.any((t) => t.amount == 1000 && t.accountId == accountId), isTrue);
    expect(transactions.any((t) => t.amount == 50), isFalse);

    final accounts = await AccountRepositoryImpl(targetDb).watchAll().first;
    expect(accounts.single.name, 'Карта');

    final profiles = await DebtProfileRepositoryImpl(targetDb).watchAll().first;
    expect(profiles.single.name, 'Андрей');

    await targetDb.close();
  });

  test('импорт файла неверного формата бросает BackupFormatException', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    expect(
      () => BackupService(db).restoreFromJson('{"not":"a backup"}'),
      throwsA(isA<BackupFormatException>()),
    );
    await db.close();
  });
}
