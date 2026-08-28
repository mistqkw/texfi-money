import 'package:flutter/widgets.dart';

import '../../core/constants/currencies.dart';
import '../../core/theme/app_l10n_ext.dart';
import '../../domain/entities/category_entity.dart';

/// Предустановленные категории хранятся в БД с именем на языке первого
/// запуска — при отображении подменяем его переводом по стабильному id,
/// чтобы смена языка сразу отражалась в UI. Свои категории показывают
/// то, что ввёл пользователь, как есть.
String categoryDisplayName(BuildContext context, CategoryEntity category) {
  final l10n = context.l10n;
  return switch (category.id) {
    'cat_groceries' => l10n.categoryGroceries,
    'cat_transport' => l10n.categoryTransport,
    'cat_home' => l10n.categoryHome,
    'cat_restaurant' => l10n.categoryRestaurant,
    'cat_entertainment' => l10n.categoryEntertainment,
    'cat_health' => l10n.categoryHealth,
    'cat_clothes' => l10n.categoryClothes,
    'cat_bills' => l10n.categoryBills,
    'cat_other_expense' => l10n.categoryOtherExpense,
    'cat_salary' => l10n.categorySalary,
    'cat_freelance' => l10n.categoryFreelance,
    'cat_gifts' => l10n.categoryGifts,
    'cat_investments' => l10n.categoryInvestments,
    'cat_other_income' => l10n.categoryOtherIncome,
    _ => category.name,
  };
}

String currencyDisplayName(BuildContext context, AppCurrency currency) {
  final l10n = context.l10n;
  return switch (currency) {
    AppCurrency.rub => l10n.currencyRub,
    AppCurrency.usd => l10n.currencyUsd,
    AppCurrency.eur => l10n.currencyEur,
    AppCurrency.uah => l10n.currencyUah,
    AppCurrency.pln => l10n.currencyPln,
    AppCurrency.byn => l10n.currencyByn,
    AppCurrency.kzt => l10n.currencyKzt,
    AppCurrency.gbp => l10n.currencyGbp,
    AppCurrency.cny => l10n.currencyCny,
    AppCurrency.tryLira => l10n.currencyTry,
  };
}
