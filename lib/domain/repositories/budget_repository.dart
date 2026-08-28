import '../entities/budget_entity.dart';

abstract class BudgetRepository {
  /// Бюджеты за месяц, содержащий [month], с рассчитанным `spent`.
  Stream<List<BudgetEntity>> watchAll(DateTime month);

  Future<void> setLimit({required String categoryId, required double monthlyLimit});
  Future<void> delete(String id);
}
