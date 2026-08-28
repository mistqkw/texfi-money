import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'default_categories.dart';

/// Полный экспорт/импорт локальной БД в JSON — единственный способ
/// перенести или сохранить данные, так как приложение офлайн-only.
class BackupService {
  BackupService(this._db);

  final AppDatabase _db;

  static const int formatVersion = 1;

  Future<String> exportToJson() async {
    final categories = await _db.select(_db.categories).get();
    final transactions = await _db.select(_db.transactions).get();
    final budgets = await _db.select(_db.budgets).get();
    final goals = await _db.select(_db.savingsGoals).get();
    final accounts = await _db.select(_db.accounts).get();
    final debtProfiles = await _db.select(_db.debtProfiles).get();

    final payload = {
      'app': 'texfi_money',
      'formatVersion': formatVersion,
      'exportedAt': DateTime.now().toIso8601String(),
      'categories': categories.map((r) => r.toJson()).toList(),
      'transactions': transactions.map((r) => r.toJson()).toList(),
      'budgets': budgets.map((r) => r.toJson()).toList(),
      'savingsGoals': goals.map((r) => r.toJson()).toList(),
      'accounts': accounts.map((r) => r.toJson()).toList(),
      'debtProfiles': debtProfiles.map((r) => r.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(payload);
  }

  /// Полностью заменяет локальные данные содержимым бэкапа.
  Future<void> restoreFromJson(String jsonString) async {
    final Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(jsonString) as Map<String, dynamic>;
    } on FormatException {
      throw const BackupFormatException();
    }
    if (decoded['app'] != 'texfi_money' || decoded['formatVersion'] != formatVersion) {
      throw const BackupFormatException();
    }

    List<Map<String, dynamic>> rows(String key) =>
        (decoded[key] as List? ?? []).cast<Map<String, dynamic>>();

    await _db.transaction(() async {
      await _db.delete(_db.transactions).go();
      await _db.delete(_db.budgets).go();
      await _db.delete(_db.savingsGoals).go();
      await _db.delete(_db.debtProfiles).go();
      await _db.delete(_db.accounts).go();
      await _db.delete(_db.categories).go();

      for (final json in rows('categories')) {
        await _db.into(_db.categories).insert(
              Category.fromJson(json).toCompanion(true),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final json in rows('accounts')) {
        await _db.into(_db.accounts).insert(
              Account.fromJson(json).toCompanion(true),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final json in rows('debtProfiles')) {
        await _db.into(_db.debtProfiles).insert(
              DebtProfile.fromJson(json).toCompanion(true),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final json in rows('transactions')) {
        await _db.into(_db.transactions).insert(
              Transaction.fromJson(json).toCompanion(true),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final json in rows('budgets')) {
        await _db.into(_db.budgets).insert(
              Budget.fromJson(json).toCompanion(true),
              mode: InsertMode.insertOrReplace,
            );
      }
      for (final json in rows('savingsGoals')) {
        await _db.into(_db.savingsGoals).insert(
              SavingsGoal.fromJson(json).toCompanion(true),
              mode: InsertMode.insertOrReplace,
            );
      }
    });
  }

  /// Полностью очищает все данные и возвращает предустановленные категории —
  /// сброс приложения к состоянию первого запуска.
  Future<void> resetAllData() async {
    await _db.transaction(() async {
      await _db.delete(_db.transactions).go();
      await _db.delete(_db.budgets).go();
      await _db.delete(_db.savingsGoals).go();
      await _db.delete(_db.debtProfiles).go();
      await _db.delete(_db.accounts).go();
      await _db.delete(_db.categories).go();

      await _db.batch((batch) {
        batch.insertAll(_db.categories, buildDefaultCategories());
      });
    });
  }
}

class BackupFormatException implements Exception {
  const BackupFormatException();
}
