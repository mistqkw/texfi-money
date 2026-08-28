import 'package:flutter/material.dart';

/// Каталог line-style иконок для категорий. Ключи хранятся в БД,
/// иконки не сериализуются напрямую, чтобы пережить смену набора шрифтов.
abstract final class CategoryIcons {
  static const Map<String, IconData> catalog = {
    'groceries': Icons.shopping_cart_outlined,
    'restaurant': Icons.restaurant_outlined,
    'transport': Icons.directions_car_outlined,
    'home': Icons.home_outlined,
    'health': Icons.local_hospital_outlined,
    'education': Icons.school_outlined,
    'entertainment': Icons.movie_outlined,
    'travel': Icons.flight_outlined,
    'pets': Icons.pets_outlined,
    'fitness': Icons.fitness_center_outlined,
    'gifts': Icons.card_giftcard_outlined,
    'bills': Icons.receipt_long_outlined,
    'clothes': Icons.checkroom_outlined,
    'salary': Icons.work_outline,
    'freelance': Icons.laptop_mac_outlined,
    'investments': Icons.trending_up_outlined,
    'savings': Icons.savings_outlined,
    'money': Icons.attach_money_outlined,
    'other': Icons.category_outlined,
  };

  static IconData resolve(String key) =>
      catalog[key] ?? Icons.category_outlined;
}
