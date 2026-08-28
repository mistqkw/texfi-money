import 'category_entity.dart';

class BudgetEntity {
  const BudgetEntity({
    required this.id,
    required this.category,
    required this.monthlyLimit,
    required this.spent,
  });

  final String id;
  final CategoryEntity category;
  final double monthlyLimit;

  /// Потрачено в текущем месяце по этой категории (вычисляется в репозитории).
  final double spent;

  double get progress =>
      monthlyLimit <= 0 ? 0 : (spent / monthlyLimit).clamp(0, 1);

  double get remaining => (monthlyLimit - spent).clamp(0, double.infinity);

  bool get isOverLimit => spent > monthlyLimit;

  /// Порог предупреждения — 85% лимита.
  bool get isNearLimit => !isOverLimit && progress >= 0.85;
}
