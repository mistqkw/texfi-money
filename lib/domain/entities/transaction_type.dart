enum TransactionType {
  income,
  expense;

  String get storageKey => name;

  static TransactionType fromStorageKey(String key) =>
      TransactionType.values.firstWhere((e) => e.storageKey == key);
}
