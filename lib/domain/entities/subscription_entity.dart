import 'category_entity.dart';
import 'subscription_period.dart';

class SubscriptionEntity {
  const SubscriptionEntity({
    required this.id,
    required this.name,
    required this.amount,
    required this.period,
    required this.nextChargeAt,
    required this.isActive,
    required this.createdAt,
    this.customDays,
    this.category,
  });

  final String id;
  final String name;
  final double amount;
  final SubscriptionPeriod period;
  final int? customDays;
  final DateTime nextChargeAt;
  final CategoryEntity? category;
  final bool isActive;
  final DateTime createdAt;

  /// Длина периода в днях.
  ///
  /// Месяц и год берутся усреднёнными, а не календарными, и это осознанно:
  /// сумма подписок в месяц — оценка нагрузки, а не платёжный календарь.
  /// Календарная точность здесь дала бы разные ответы в феврале и в марте,
  /// не сказав ничего нового.
  static const double daysInMonth = 30.44;
  static const double daysInYear = 365.25;

  double get periodDays => switch (period) {
        SubscriptionPeriod.monthly => daysInMonth,
        SubscriptionPeriod.yearly => daysInYear,
        SubscriptionPeriod.custom => (customDays ?? 30).toDouble(),
      };

  /// Сколько подписка стоит в месяц.
  ///
  /// Годовая приводится к месячной, иначе «сумма подписок в месяц»
  /// показывала бы то одно число, то другое в зависимости от того, в каком
  /// месяце списывается годовая.
  double get monthlyCost => amount * daysInMonth / periodDays;

  /// Сколько дней до следующего списания. Отрицательное — списание уже
  /// прошло, а дату ещё не сдвинули.
  int daysUntilCharge(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(
      nextChargeAt.year,
      nextChargeAt.month,
      nextChargeAt.day,
    );
    return due.difference(today).inDays;
  }
}
