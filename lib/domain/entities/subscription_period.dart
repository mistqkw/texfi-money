/// Как часто списывают подписку.
enum SubscriptionPeriod {
  monthly,
  yearly,

  /// Свой период в днях — для всего, что не ложится в месяц или год:
  /// квартальные списания, раз в две недели, раз в сто дней.
  custom;

  String get storageKey => name;

  static SubscriptionPeriod fromStorageKey(String? key) =>
      SubscriptionPeriod.values.firstWhere(
        (period) => period.storageKey == key,
        orElse: () => SubscriptionPeriod.monthly,
      );
}
