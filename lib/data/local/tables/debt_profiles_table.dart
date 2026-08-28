import 'package:drift/drift.dart';

/// Профиль стороннего человека для учёта чужих денег: сколько он должен
/// пользователю (положительный [balance]) или пользователь ему
/// (отрицательный [balance]).
class DebtProfiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  RealColumn get balance => real().withDefault(const Constant(0))();
  IntColumn get colorValue => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
