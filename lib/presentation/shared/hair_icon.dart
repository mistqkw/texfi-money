import 'package:flutter/material.dart';

/// Линейные иконки приложения (дизайн «hairline»): тонкий контур, без
/// заливок и без пикселей. Ключи категорий совпадают с `CategoryIcons`
/// из `core/constants/category_icons.dart`.
abstract final class HairIcons {
  // --- Навигация -------------------------------------------------------
  static const home = Icons.home_outlined;
  static const history = Icons.history_rounded;
  static const budgets = Icons.account_balance_wallet_outlined;
  static const goals = Icons.flag_outlined;
  static const statistics = Icons.bar_chart_rounded;

  // --- Категории -------------------------------------------------------
  static const groceries = Icons.shopping_basket_outlined;
  static const restaurant = Icons.restaurant_outlined;
  static const food = Icons.lunch_dining_outlined;
  static const transport = Icons.directions_bus_outlined;
  static const health = Icons.medical_services_outlined;
  static const education = Icons.school_outlined;
  static const entertainment = Icons.movie_outlined;
  static const travel = Icons.flight_outlined;
  static const pets = Icons.pets_outlined;
  static const fitness = Icons.fitness_center_outlined;
  static const gifts = Icons.card_giftcard_outlined;
  static const bills = Icons.receipt_long_outlined;
  static const clothes = Icons.checkroom_outlined;
  static const salary = Icons.payments_outlined;
  static const freelance = Icons.laptop_mac_outlined;
  static const investments = Icons.trending_up_rounded;
  static const savings = Icons.savings_outlined;
  static const money = Icons.attach_money_rounded;
  static const other = Icons.more_horiz_rounded;

  static const Map<String, IconData> categoryCatalog = {
    'food': food,
    'groceries': groceries,
    'restaurant': restaurant,
    'transport': transport,
    'home': home,
    'health': health,
    'education': education,
    'entertainment': entertainment,
    'travel': travel,
    'pets': pets,
    'fitness': fitness,
    'gifts': gifts,
    'bills': bills,
    'clothes': clothes,
    'salary': salary,
    'freelance': freelance,
    'investments': investments,
    'savings': savings,
    'money': money,
    'other': other,
  };

  static IconData forCategoryKey(String key) => categoryCatalog[key] ?? other;

  // --- Служебные / настройки -------------------------------------------
  static const add = Icons.add_rounded;
  static const check = Icons.check_rounded;
  static const chevronRight = Icons.chevron_right_rounded;
  static const chevronDown = Icons.expand_more_rounded;
  static const close = Icons.close_rounded;
  static const category = Icons.category_outlined;
  static const settings = Icons.settings_outlined;
  static const language = Icons.translate_rounded;
  static const themeDark = Icons.dark_mode_outlined;
  static const themeLight = Icons.light_mode_outlined;
  static const themeContrast = Icons.contrast_rounded;
  static const font = Icons.text_fields_rounded;
  static const wallet = budgets;
  static const profiles = Icons.people_outline_rounded;
  static const backupUp = Icons.cloud_upload_outlined;
  static const backupDown = Icons.cloud_download_outlined;
  static const danger = Icons.warning_amber_rounded;
  static const info = Icons.info_outline_rounded;
  static const delete = Icons.delete_outline_rounded;
  static const edit = Icons.edit_outlined;
  static const lock = Icons.lock_outline_rounded;
  static const calendar = Icons.calendar_today_outlined;
  static const clock = Icons.schedule_rounded;
  static const person = Icons.person_outline_rounded;
  static const globe = Icons.public_rounded;
  static const heart = Icons.favorite_border_rounded;
  static const code = Icons.code_rounded;
  static const replay = Icons.replay_rounded;
  static const terminal = Icons.terminal_rounded;
  static const license = Icons.gavel_rounded;
  static const linkOut = Icons.north_east_rounded;
  static const camera = Icons.photo_camera_outlined;
  static const netWorth = Icons.account_balance_outlined;
  static const subscriptions = Icons.autorenew_rounded;
  static const reports = Icons.assessment_outlined;
  static const cashFlow = Icons.swap_vert_rounded;
  static const advice = Icons.lightbulb_outline_rounded;
  static const risk = Icons.shield_outlined;
  static const flowIncome = Icons.south_west_rounded;
  static const flowLiability = Icons.north_east_rounded;
  static const flowNeutral = Icons.remove_rounded;
  static const creditCard = Icons.credit_card_outlined;
}

/// Линейная иконка нужного размера и цвета (вес штриха 300 — тонкий, как
/// остальные линии интерфейса).
class HairIcon extends StatelessWidget {
  const HairIcon(this.icon, {super.key, this.size = 20, this.color});

  factory HairIcon.category(
    String key, {
    Key? key2,
    double size = 20,
    Color? color,
  }) {
    return HairIcon(
      HairIcons.forCategoryKey(key),
      key: key2,
      size: size,
      color: color,
    );
  }

  final IconData icon;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: size, color: color, weight: 300);
  }
}
