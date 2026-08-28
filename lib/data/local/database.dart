import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'default_categories.dart';
import 'tables/budgets_table.dart';
import 'tables/categories_table.dart';
import 'tables/savings_goals_table.dart';
import 'tables/transactions_table.dart';

part 'database.g.dart';

@DriftDatabase(tables: [Categories, Transactions, Budgets, SavingsGoals])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await batch((batch) {
            batch.insertAll(categories, buildDefaultCategories());
          });
        },
      );

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'texfi_money');
  }
}
