import 'package:drift/drift.dart';

/// Цель накопления: название, целевая сумма, текущий прогресс, дедлайн.
class SavingsGoals extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  RealColumn get targetAmount => real()();
  RealColumn get currentAmount => real().withDefault(const Constant(0))();
  DateTimeColumn get deadline => dateTime().nullable()();
  IntColumn get colorValue => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  /// Путь к фото цели, скопированному в документы приложения. Необязательное.
  TextColumn get imagePath => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
