import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'default_categories.dart';
import 'default_wealth.dart';
import 'tables/accounts_table.dart';
import 'tables/asset_categories_table.dart';
import 'tables/assets_table.dart';
import 'tables/budgets_table.dart';
import 'tables/categories_table.dart';
import 'tables/debt_profiles_table.dart';
import 'tables/risk_levels_table.dart';
import 'tables/savings_goals_table.dart';
import 'tables/subscriptions_table.dart';
import 'tables/transactions_table.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    Categories,
    Transactions,
    Budgets,
    SavingsGoals,
    Accounts,
    DebtProfiles,
    AssetCategories,
    RiskLevels,
    Assets,
    AssetValues,
    Subscriptions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await batch((batch) {
            batch.insertAll(categories, buildDefaultCategories());
            batch.insertAll(assetCategories, buildDefaultAssetCategories());
            batch.insertAll(riskLevels, buildDefaultRiskLevels());
          });
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(accounts);
            await m.createTable(debtProfiles);
            await m.addColumn(transactions, transactions.accountId);
          }
          if (from < 3) {
            await m.addColumn(savingsGoals, savingsGoals.imagePath);
            await m.addColumn(accounts, accounts.bankId);
          }
          if (from < 4) {
            // Учёт капитала. Всё новое — отдельными таблицами и одной
            // колонкой: существующие данные не переносятся и не меняются,
            // а транзакции получают необязательную оценку полезности,
            // которая у всех прошлых операций остаётся пустой. Пустая —
            // это «не оценивал», а не «нейтрально».
            await m.createTable(assetCategories);
            await m.createTable(riskLevels);
            await m.createTable(assets);
            await m.createTable(assetValues);
            await m.createTable(subscriptions);
            await m.addColumn(transactions, transactions.usefulness);

            // Наполнение справочников идёт здесь же, а не при первом
            // открытии экрана: список активов без единой категории и без
            // уровней риска — это экран, на котором нельзя ничего создать.
            await batch((batch) {
              batch.insertAll(assetCategories, buildDefaultAssetCategories());
              batch.insertAll(riskLevels, buildDefaultRiskLevels());
            });
          }
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'texfi_money');
  }
}
