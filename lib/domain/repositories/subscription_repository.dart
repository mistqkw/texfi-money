import '../entities/subscription_entity.dart';
import '../entities/subscription_period.dart';

abstract class SubscriptionRepository {
  /// Активные подписки. Отменённые остаются в базе, но в список не идут:
  /// «сколько я плачу за подписки» — вопрос про сейчас.
  Stream<List<SubscriptionEntity>> watchActive();

  Stream<List<SubscriptionEntity>> watchAll();

  Future<List<SubscriptionEntity>> allOnce();

  Future<String> create({
    required String name,
    required double amount,
    required SubscriptionPeriod period,
    int? customDays,
    required DateTime nextChargeAt,
    String? categoryId,
  });

  Future<void> update({
    required String id,
    required String name,
    required double amount,
    required SubscriptionPeriod period,
    int? customDays,
    required DateTime nextChargeAt,
    String? categoryId,
  });

  Future<void> setActive({required String id, required bool isActive});

  /// Двигает дату списания на период вперёд — когда списание прошло.
  Future<void> advanceCharge(String id);

  Future<void> delete(String id);
}
