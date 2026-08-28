import 'package:drift/drift.dart';

/// Месячный лимит расходов по категории. Одна запись на категорию.
class Budgets extends Table {
  TextColumn get id => text()();

  /// Ссылается на `Categories.id` (без декларативного FK — см. репозитории).
  TextColumn get categoryId => text().unique()();
  RealColumn get monthlyLimit => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
