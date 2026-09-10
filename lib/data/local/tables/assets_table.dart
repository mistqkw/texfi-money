import 'package:drift/drift.dart';

/// Актив — то, из чего состоит капитал.
///
/// Отдельно от счетов и транзакций: счёт — это место, где лежат деньги и
/// куда попадают операции, актив — объект, у которого есть стоимость,
/// меняющаяся сама по себе. Квартира не участвует в движении денег, но
/// составляет капитал; счёт участвует в каждой операции, но его «стоимость»
/// — это просто остаток.
class Assets extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  TextColumn get categoryId => text()();

  TextColumn get riskLevelId => text()();

  /// Тип по денежному потоку: приносит, забирает или ни то ни другое.
  /// Хранится строкой, а не индексом: список фиксирован кодом, и строка
  /// переживает любую перестановку значений в перечислении.
  TextColumn get cashFlowType => text()();

  /// Последняя известная стоимость.
  ///
  /// Дублирует последнюю запись истории намеренно. Без неё каждый показ
  /// списка активов требовал бы подзапроса за максимальной датой по
  /// каждому активу, а список капитала открывают чаще, чем меняют оценки.
  RealColumn get currentValue => real()();

  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// История оценок актива.
///
/// Обновление стоимости добавляет точку, а не переписывает предыдущую:
/// без истории «динамика капитала за год» неоткуда взяться — она считается
/// не по сегодняшним числам, а по тому, какими они были тогда.
class AssetValues extends Table {
  TextColumn get id => text()();
  TextColumn get assetId => text()();
  RealColumn get value => real()();

  /// Дата, к которой относится оценка. Задаётся пользователем и может быть
  /// в прошлом: человек вносит квартиру сегодня, зная её стоимость год
  /// назад, и эта точка должна встать на своё место в графике.
  DateTimeColumn get recordedAt => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
