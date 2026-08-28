import 'package:drift/drift.dart';

import '../../core/theme/app_colors.dart';
import 'database.dart';

/// Предустановленные категории, создаваемые при первом запуске.
List<CategoriesCompanion> buildDefaultCategories() {
  final palette = AppColors.categoryPalette;
  int i = 0;
  int nextColor() => palette[i++ % palette.length].toARGB32();

  CategoriesCompanion expense(String id, String name, String iconKey) =>
      CategoriesCompanion.insert(
        id: id,
        name: name,
        iconKey: iconKey,
        colorValue: nextColor(),
        type: 'expense',
        isCustom: const Value(false),
      );

  CategoriesCompanion income(String id, String name, String iconKey) =>
      CategoriesCompanion.insert(
        id: id,
        name: name,
        iconKey: iconKey,
        colorValue: nextColor(),
        type: 'income',
        isCustom: const Value(false),
      );

  return [
    expense('cat_groceries', 'Продукты', 'groceries'),
    expense('cat_transport', 'Транспорт', 'transport'),
    expense('cat_home', 'Жильё', 'home'),
    expense('cat_restaurant', 'Кафе и рестораны', 'restaurant'),
    expense('cat_entertainment', 'Развлечения', 'entertainment'),
    expense('cat_health', 'Здоровье', 'health'),
    expense('cat_clothes', 'Одежда', 'clothes'),
    expense('cat_bills', 'Счета', 'bills'),
    expense('cat_other_expense', 'Прочее', 'other'),
    income('cat_salary', 'Зарплата', 'salary'),
    income('cat_freelance', 'Подработка', 'freelance'),
    income('cat_gifts', 'Подарки', 'gifts'),
    income('cat_investments', 'Инвестиции', 'investments'),
    income('cat_other_income', 'Прочее', 'other'),
  ];
}
