import 'package:drift/drift.dart';

/// Категории транзакций: предустановленные и созданные пользователем.
class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// Ключ иконки из каталога `CategoryIcons` (core/constants).
  TextColumn get iconKey => text()();

  /// ARGB-значение цвета категории.
  IntColumn get colorValue => integer()();

  /// 'income' | 'expense'.
  TextColumn get type => text()();

  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
